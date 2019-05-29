//
//  TKFrameCollectionView.m
//  Tikky
//
//  Created by LeHuuNghi on 3/1/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "TKFrameCollectionView.h"

@interface TKFrameCollectionView()<UICollectionViewDataSource>

@property (nonatomic) TKFrameCollectionViewCell *currentCell;
@property (nonatomic) TKModelViewObject *currentCellViewModel;

@end

@implementation TKFrameCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self =  [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.dataArray = [[TKSampleDataPool sharedInstance] frameModelViewList];
        [self setShowsVerticalScrollIndicator:NO];
        self.backgroundColor = [UIColor whiteColor];
        self.dataSource = self;
        self.delegate = self;
        [self registerClass:[TKFrameCollectionViewCell class] forCellWithReuseIdentifier:@"frame_cell"];
    }
    return self;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TKFrameCollectionViewCell *cell = (TKFrameCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell) {
        TKModelViewObject *cellViewModel = self.dataArray[indexPath.row];
        if (cell.isSelected) {
            if ([cell.delegate respondsToSelector:@selector(didDeselectFrameWithIdentifier:)]) {
                [cell.delegate didDeselectFrameWithIdentifier:cellViewModel.identifier.integerValue];
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [self cellLayoutIsSelected:self.currentCell isSelected:NO];
                } completion:^(BOOL finished){
                    // if you want to do something once the animation finishes, put it here
                    [self setStateCell:cell isSelect:NO withModelView:cellViewModel];
                }];
            }
        } else {
            if ([cell.delegate respondsToSelector:@selector(didSelectFrameWithIdentifier:)]) {
                [cell.delegate didSelectFrameWithIdentifier:cellViewModel.identifier.integerValue];
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    if (self.currentCell != cell) {
                        [self cellLayoutIsSelected:self.currentCell isSelected:NO];
                    }
                    // animate it to the identity transform (100% scale)
                    [self cellLayoutIsSelected:cell isSelected:YES];
                    
                } completion:^(BOOL finished){
                    // if you want to do something once the animation finishes, put it here
                    if (self.currentCell != cell) {
                        [self setStateCell:self.currentCell isSelect:NO withModelView:self.currentCellViewModel];
                    }
                    if ([cell.delegate respondsToSelector:@selector(didDeselectFrameWithIdentifier:)]) {
                        [cell.delegate didDeselectFrameWithIdentifier:cellViewModel.identifier.integerValue];
                    }
                    [self setStateCell:cell isSelect:YES withModelView:cellViewModel];
                    self.currentCell = cell;
                    self.currentCellViewModel = cellViewModel;
                }];
            }
        }
    }
}

#pragma UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TKFrameCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"frame_cell" forIndexPath:indexPath];
    if (cell) {
        TKModelViewObject *cellViewModel = self.dataArray[indexPath.row];

        cell.imageView.image = ((TKFrameModelView *)cellViewModel).thumbImageView.image;
        cell.delegate = self.cameraViewController;
        
        if (cellViewModel.isSelected) {
            [self cellLayoutIsSelected:cell isSelected:YES];
            cell.isSelected = YES;
            self.currentCell = cell;
            self.currentCellViewModel = cellViewModel;
        }
    }
    return cell;
}

- (void)setStateCell:(TKStickerCollectionViewCellBase *)cell isSelect:(BOOL)isSelected withModelView:(TKModelViewObject *)modelView {
    cell.isSelected = isSelected;
    modelView.isSelected = isSelected;
}

- (void)cellLayoutIsSelected:(TKFrameCollectionViewCell *)cell isSelected:(BOOL)isSelected {
    if (isSelected) {
        cell.imageView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        cell.layer.borderWidth = 3.0f;
        cell.layer.borderColor = [UIColor purpleColor].CGColor;
    } else {
        cell.imageView.transform = CGAffineTransformIdentity;
        cell.layer.borderWidth = 0;
    }
}

@end
