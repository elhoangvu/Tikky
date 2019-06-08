//
//  TKEditItemView.m
//  Tikky
//
//  Created by Vu Le Hoang on 6/2/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "TKEditItemView.h"

#import "TKEditItemCollectionViewCell.h"

#define kEditItemCellIdentifier @"tikky.edititemcell"

@interface TKEditItemView ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>

@property (nonatomic) UICollectionView* editItemCollectionView;

@property (nonatomic) UIView* footerView;

@property (nonatomic) UIButton* closeButton;

@property (nonatomic) UIButton* doneButton;

@property (nonatomic) NSUInteger prevIndex;

@property (nonatomic) UILabel* titleLabel;

@property (nonatomic) CGFloat footerHeight;

@property (nonatomic) BOOL isEditing;

@end

@implementation TKEditItemView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) {
        return nil;
    }
    
    _footerHeight = frame.size.height*0.3;
    CGRect titleFrame = CGRectMake(0, frame.size.height - _footerHeight, frame.size.width, _footerHeight);
    _titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
    [_titleLabel setTextAlignment:(NSTextAlignmentCenter)];
    [_titleLabel setTextColor:UIColor.blackColor];
    
    [_titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [self addSubview:_titleLabel];
    [self setUpCollectionView];
    [self setUpButtons];
    _isEditing = NO;
//    if (_datasource && [_datasource respondsToSelector:@selector(viewModelsForEditItemView:type:)]) {
//        _viewModels = [_datasource viewModelsForEditItemView:self type:type];
//    }
    
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
    [_editItemCollectionView reloadData];
}

- (void)setUpCollectionView {
    UICollectionViewFlowLayout* collectionLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat height = self.frame.size.height;
    collectionLayout.itemSize = CGSizeMake(0.465*height, 0.62*height);
    collectionLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    collectionLayout.minimumInteritemSpacing = 10;
    collectionLayout.minimumLineSpacing = 10;
    
    CGRect menuFrame = CGRectMake(0, self.frame.size.height - height, self.frame.size.width, 0.7*height);
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
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TKEditItemCollectionViewCell* cell = (TKEditItemCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];

    TKEditItemViewModel* currentModel = [_viewModels objectAtIndex:indexPath.row];
    if (currentModel.isSelected) {
        if (_delegate && [_delegate respondsToSelector:@selector(editItemView:didDeselectItem:atIndex:)]) {
            [_delegate editItemView:self didDeselectItem:[self.viewModels objectAtIndex:indexPath.row] atIndex:indexPath.row];
        }
        
        [cell didDeselectCell];
    } else {
        if (_delegate && [_delegate respondsToSelector:@selector(editItemView:didSelectItem:atIndex:)]) {
            [_delegate editItemView:self didSelectItem:[self.viewModels objectAtIndex:indexPath.row] atIndex:indexPath.row];
        }
        
        [cell didSelectCell];
        _isEditing = YES;
        if (indexPath && _prevIndex != indexPath.row) {
            [self _deselectPrevCell];
        }
    }
    
    _prevIndex = indexPath.row;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

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
