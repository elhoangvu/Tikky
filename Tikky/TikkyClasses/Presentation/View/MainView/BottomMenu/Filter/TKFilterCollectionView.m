//
//  TKFilterCollectionView.m
//  TKPresentation
//
//  Created by LeHuuNghi on 1/20/19.
//  Copyright © 2019 LeHuuNghi. All rights reserved.
//

#import "TKFilterCollectionView.h"
#import "TKFilterCollectionViewCell.h"

@interface TKFilterCollectionView() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic) TKFilterCollectionViewCell *currentCell;
@property (nonatomic) TKModelViewObject *currentCellViewModel;

@end

@implementation TKFilterCollectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataArray = [[TKSampleDataPool sharedInstance] filterModelViewList];
        self.dataSource = self;
        [self registerClass:[TKFilterCollectionViewCell class] forCellWithReuseIdentifier:@"filter_cell"];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self =  [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        [self setShowsHorizontalScrollIndicator:NO];
        self.dataArray = [[TKSampleDataPool sharedInstance] filterModelViewList];
        self.dataSource = self;
        self.delegate = self;
        [self registerClass:[TKFilterCollectionViewCell class] forCellWithReuseIdentifier:@"filter_cell"];
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self) {
        return self.dataArray.count;
    }
    return 0;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TKFilterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"filter_cell" forIndexPath:indexPath];
    if (cell) {
        TKModelViewObject *cellViewModel = self.dataArray[indexPath.row];

        cell.imageView.image = ((TKFilterModelView *)cellViewModel).thumbImageView.image;
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

#pragma UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TKFilterCollectionViewCell *cell = (TKFilterCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell) {
        TKModelViewObject *cellViewModel = self.dataArray[indexPath.row];
        if (cell.isSelected) {
            if ([cell.delegate respondsToSelector:@selector(didDeselectFilterWithIdentifier:)]) {
                [cell.delegate didDeselectFilterWithIdentifier:cellViewModel.identifier.integerValue];
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [self cellLayoutIsSelected:self.currentCell isSelected:NO];
                } completion:^(BOOL finished){
                    // if you want to do something once the animation finishes, put it here
                    [self setStateCell:cell isSelect:NO withModelView:cellViewModel];
                }];
            }
        } else {
            if ([cell.delegate respondsToSelector:@selector(didSelectFilterWithIdentifier:)]) {
                [cell.delegate didSelectFilterWithIdentifier:cellViewModel.identifier.integerValue];
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
                    if ([cell.delegate respondsToSelector:@selector(didDeselectFilterWithIdentifier:)]) {
                        [cell.delegate didDeselectFilterWithIdentifier:cellViewModel.identifier.integerValue];
                    }
                    [self setStateCell:cell isSelect:YES withModelView:cellViewModel];
                    self.currentCell = cell;
                    self.currentCellViewModel = cellViewModel;
                }];
            }
        }
    }
}

- (void)setStateCell:(TKStickerCollectionViewCellBase *)cell isSelect:(BOOL)isSelected withModelView:(TKModelViewObject *)modelView {
    cell.isSelected = isSelected;
    modelView.isSelected = isSelected;
}

- (void)cellLayoutIsSelected:(TKFilterCollectionViewCell *)cell isSelected:(BOOL)isSelected {
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
