//
//  TKEditItemView.m
//  Tikky
//
//  Created by Vu Le Hoang on 6/2/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "TKEditItemView.h"

#import "TKEditItemCollectionViewCell.h"

#import "HJCarouselViewLayout.h"

#import "TKStickerEntity.h"

#define kEditItemCellIdentifier @"tikky.edititemcell"

@interface TKEditItemView ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
UIScrollViewDelegate
>

@property (nonatomic) UICollectionView* editItemCollectionView;

@property (nonatomic) UIView* footerView;

@property (nonatomic) UIButton* closeButton;

@property (nonatomic) UIButton* doneButton;

@property (nonatomic) NSUInteger prevIndex;

@property (nonatomic) UILabel* titleLabel;

@property (nonatomic) CGFloat footerHeight;

@property (nonatomic) BOOL isEditing;

@property (nonatomic) UIView* itemPathView;

@property (nonatomic) CGSize itemSize;

@property (nonatomic) BOOL isScrolling;

@end

@implementation TKEditItemView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) {
        return nil;
    }
    
    _footerHeight = frame.size.height*0.25;
    CGRect titleFrame = CGRectMake(0, frame.size.height - _footerHeight, frame.size.width, _footerHeight);
    _titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
    [_titleLabel setTextAlignment:(NSTextAlignmentCenter)];
    [_titleLabel setTextColor:UIColor.blackColor];
    
    [_titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [self addSubview:_titleLabel];
    [self setUpCollectionView];
    [self setUpButtons];
    _isEditing = NO;
    _isScrolling = NO;
//    if (_datasource && [_datasource respondsToSelector:@selector(viewModelsForEditItemView:type:)]) {
//        _viewModels = [_datasource viewModelsForEditItemView:self type:type];
//    }
    CGRect itemPathFrame = CGRectMake(frame.size.width*0.5 - _itemSize.height*0.5+_itemSize.height*0.055, frame.size.height*0.065, _itemSize.height*0.9, _itemSize.height*0.9);
    _itemPathView = [[UIView alloc] initWithFrame:itemPathFrame];
    [self addSubview:_itemPathView];
    _itemPathView.layer.borderColor = UIColor.grayColor.CGColor;
    _itemPathView.layer.borderWidth = 8.0;
    _itemPathView.clipsToBounds = YES;
    _itemPathView.layer.cornerRadius = _itemPathView.frame.size.height*0.5;
    _itemPathView.userInteractionEnabled = NO;
    
    return self;
}

- (void)setUpButtons {
    CGFloat editViewHeight = _editItemCollectionView.frame.size.height;
    CGFloat padding = _footerHeight * 0.1;
    CGRect closeButtonFrame = CGRectMake(_footerHeight, editViewHeight + padding, _footerHeight - padding*2, _footerHeight - padding*2);
    _closeButton = [[UIButton alloc] initWithFrame:closeButtonFrame];
    
    NSString* closeImagePath = [NSBundle.mainBundle pathForResource:@"close-gray" ofType:@"png"];
    UIImage* closeImage = [UIImage imageWithContentsOfFile:closeImagePath];
    [_closeButton setImage:closeImage forState:(UIControlStateNormal)];
    [_closeButton addTarget:self action:@selector(didTapCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_closeButton];
    
    CGRect doneButtonFrame = CGRectMake(self.frame.size.width - 2*_footerHeight + padding*2, editViewHeight + padding, _footerHeight - padding*2, _footerHeight - padding*2);
    _doneButton = [[UIButton alloc] initWithFrame:doneButtonFrame];
    
    NSString* doneImagPpath = [NSBundle.mainBundle pathForResource:@"done-gray" ofType:@"png"];
    UIImage* doneImage = [UIImage imageWithContentsOfFile:doneImagPpath];
    [_doneButton setImage:doneImage forState:(UIControlStateNormal)];
    [_doneButton addTarget:self action:@selector(didTapDoneButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_doneButton];
}

- (void)setViewModels:(NSArray<TKEditItemViewModel *> *)viewModels {
    _viewModels = viewModels;
    TKEditItemViewModel* viewModel = [_viewModels objectAtIndex:1];
    [_editItemCollectionView reloadData];
    if (viewModel.entity.type == TKEntityTypeSticker) {
        TKStickerEntity* sticker = (TKStickerEntity *)viewModel.entity;
        if (sticker.stickerType == TKStickerTypeFrame) {
            _itemPathView.layer.cornerRadius = _itemPathView.frame.size.height*0.2;
            return;
        }
    }
    _itemPathView.layer.cornerRadius = _itemPathView.frame.size.height*0.5;
}

- (void)setUpCollectionView {
    HJCarouselViewLayout* collectionLayout = [[HJCarouselViewLayout alloc] initWithAnim:HJCarouselAnimCoverFlow];
//    UICollectionViewFlowLayout* collectionLayout = [[UICollectionViewFlowLayout alloc] init];
//    UICollectionViewFlowLayout* collectionLayout = layout;
    CGFloat height = self.frame.size.height;
    _itemSize = CGSizeMake(0.68*height, 0.68*height);
    collectionLayout.itemSize = _itemSize;
    collectionLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    collectionLayout.visibleCount = 20;
//    collectionLayout.minimumInteritemSpacing = 15;
//    collectionLayout.minimumLineSpacing = 15;
    
    CGRect menuFrame = CGRectMake(0, self.frame.size.height - height, self.frame.size.width, 0.75*height);
    
    _editItemCollectionView = [[UICollectionView alloc] initWithFrame:menuFrame collectionViewLayout:collectionLayout];
    _editItemCollectionView.delegate = self;
    _editItemCollectionView.dataSource = self;
    [_editItemCollectionView setShowsHorizontalScrollIndicator:NO];

    [_editItemCollectionView registerClass:TKEditItemCollectionViewCell.class forCellWithReuseIdentifier:kEditItemCellIdentifier];
    _editItemCollectionView.backgroundColor = UIColor.clearColor;
    _editItemCollectionView.alwaysBounceHorizontal = YES;
    
    [self addSubview:_editItemCollectionView];
}

- (void)didTapCloseButton:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(didCloseEditItemView:withoutEditing:)]) {
        [_delegate didCloseEditItemView:self withoutEditing:!_isEditing];
    }
    
    [self _deselectPrevCell];
}

- (void)didTapDoneButton:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(didDoneEditItemView:withoutEditing:)]) {
        [_delegate didDoneEditItemView:self withoutEditing:!_isEditing];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _viewModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TKEditItemCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kEditItemCellIdentifier forIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    cell.backgroundColor = UIColor.clearColor;
    TKEditItemViewModel* viewModel = [_viewModels objectAtIndex:indexPath.row];
    [cell setViewModel:viewModel];
    
    [self updateTittle];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    TKEditItemCollectionViewCell* cell = (TKEditItemCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//
//    TKEditItemViewModel* currentModel = [_viewModels objectAtIndex:indexPath.row];
    _isEditing = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(editItemView:didSelectItem:atIndex:)]) {
        [_delegate editItemView:self didSelectItem:[self.viewModels objectAtIndex:indexPath.row] atIndex:indexPath.row];
    }
    [self updateTittle];
//    if (currentModel.isSelected) {
//        if (_delegate && [_delegate respondsToSelector:@selector(editItemView:didDeselectItem:atIndex:)]) {
//            [_delegate editItemView:self didDeselectItem:[self.viewModels objectAtIndex:indexPath.row] atIndex:indexPath.row];
//        }
//
//        [cell didDeselectCell];
//    } else {
//        if (_delegate && [_delegate respondsToSelector:@selector(editItemView:didSelectItem:atIndex:)]) {
//            [_delegate editItemView:self didSelectItem:[self.viewModels objectAtIndex:indexPath.row] atIndex:indexPath.row];
//        }
//
//        [cell didSelectCell];
//        _isEditing = YES;
//        if (indexPath && _prevIndex != indexPath.row) {
//            [self _deselectPrevCell];
//        }
//    }
    
    _prevIndex = indexPath.row;
}

- (void)updateTittle {
    TKEditItemViewModel* viewModel = [_viewModels objectAtIndex:1];
    if (viewModel.entity.type != TKEntityTypeSticker) {
        NSIndexPath* curIndexPath = [self curIndexPath];
        TKEditItemViewModel* curViewModel = [_viewModels objectAtIndex:curIndexPath.row];
        [_titleLabel setText:curViewModel.entity.name];
//        NSLog(@"vulh3 +++++++> %@", curViewModel.entity.name);
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSLog(@"vulh3 --------------> end scroll1");
    [self updateTittle];
//    _isScrolling = NO;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    NSLog(@"vulh3 --------------> end scroll2");
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"vulh3 --------------> end scroll77777");
}

- (void)scrollViewDidChangeAdjustedContentInset:(UIScrollView *)scrollView {
    NSLog(@"vulh3 --------------> end scroll3");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"vulh3 --------------> end scroll4");
    NSIndexPath* indexPath = [self curIndexPath];
    [self collectionView:_editItemCollectionView didSelectItemAtIndexPath:indexPath];
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    NSLog(@"vulh3 --------------> end 999999999");
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSIndexPath *)curIndexPath {
    NSArray *indexPaths = [self.editItemCollectionView indexPathsForVisibleItems];
    NSIndexPath *curIndexPath = nil;
    NSInteger curzIndex = 0;
    for (NSIndexPath *path in indexPaths.objectEnumerator) {
        UICollectionViewLayoutAttributes *attributes = [self.editItemCollectionView layoutAttributesForItemAtIndexPath:path];
        if (!curIndexPath) {
            curIndexPath = path;
            curzIndex = attributes.zIndex;
            continue;
        }
        if (attributes.zIndex > curzIndex) {
            curIndexPath = path;
            curzIndex = attributes.zIndex;
        }
    }
    return curIndexPath;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSIndexPath *curIndexPath = [self curIndexPath];
//    if (indexPath.row == curIndexPath.row) {
//        return YES;
//    }
//
//    if (_isScrolling) {
//        return NO;
//    }
//    _isScrolling = YES;

    NSLog(@"vulh3 +++++>");
    NSIndexPath* curIndexPath = [self curIndexPath];
    TKEditItemViewModel* curViewModel = [_viewModels objectAtIndex:curIndexPath.row];
    [_titleLabel setText:curViewModel.entity.name];
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
//    [self collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    
    return YES;
}


//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    return 20;
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    return 20;
//}

- (void)_deselectPrevCell {
    NSIndexPath* prevIndexPath = [NSIndexPath indexPathForItem:_prevIndex inSection:0];
    if (prevIndexPath) {
        TKEditItemCollectionViewCell* prevCell = (TKEditItemCollectionViewCell *)[_editItemCollectionView cellForItemAtIndexPath:prevIndexPath];
        [prevCell didDeselectCell];
    }
}

- (void)reset {
    NSIndexPath* topIndexpath = [NSIndexPath indexPathForItem:0 inSection:0];
    if (_viewModels.count > 0) {
        [_editItemCollectionView scrollToItemAtIndexPath:topIndexpath atScrollPosition:0 animated:NO];
        [self _deselectPrevCell];
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    [_titleLabel setText:title];
//    [_titleLabel sizeToFit];
}

@end
