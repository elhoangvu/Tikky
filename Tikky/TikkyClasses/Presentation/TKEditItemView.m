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

@end

@implementation TKEditItemView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) {
        return nil;
    }
    
    [self setUpCollectionView];
    [self setUpButtons];
//    if (_datasource && [_datasource respondsToSelector:@selector(viewModelsForEditItemView:type:)]) {
//        _viewModels = [_datasource viewModelsForEditItemView:self type:type];
//    }
    
    return self;
}

- (void)setUpButtons {
    CGFloat editViewHeight = _editItemCollectionView.frame.size.height;
    CGFloat height = self.frame.size.height*0.3;
    CGFloat padding = height * 0.2;
    CGRect closeButtonFrame = CGRectMake(height, editViewHeight + padding, height - padding*2, height - padding*2);
    _closeButton = [[UIButton alloc] initWithFrame:closeButtonFrame];
    
    NSString* closeImagePath = [NSBundle.mainBundle pathForResource:@"cross" ofType:@"png"];
    UIImage* closeImage = [UIImage imageWithContentsOfFile:closeImagePath];
    [_closeButton setImage:closeImage forState:(UIControlStateNormal)];
    [_closeButton addTarget:self action:@selector(didTapCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_closeButton];
    
    CGRect doneButtonFrame = CGRectMake(self.frame.size.width - 2*height + padding*2, editViewHeight + padding, height - padding*2, height - padding*2);
    _doneButton = [[UIButton alloc] initWithFrame:doneButtonFrame];
    
    NSString* doneImagPpath = [NSBundle.mainBundle pathForResource:@"done" ofType:@"png"];
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
    collectionLayout.itemSize = CGSizeMake(0.62*height, 0.62*height);
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
    if (_delegate && [_delegate respondsToSelector:@selector(didCloseEditItemView:)]) {
        [_delegate didCloseEditItemView:self];
    }
}

- (void)didTapDoneButton:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(didDoneEditItemView:)]) {
        [_delegate didDoneEditItemView:self];
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
    if (_delegate && [_delegate respondsToSelector:@selector(editItemView:didSelectItem:atIndex:)]) {
        [_delegate editItemView:self didSelectItem:[self.viewModels objectAtIndex:indexPath.row] atIndex:indexPath.row];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

@end
