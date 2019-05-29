//
//  TKFacialCollectionView.m
//  TKPresentation
//
//  Created by LeHuuNghi on 1/20/19.
//  Copyright © 2019 LeHuuNghi. All rights reserved.
//

#import "TKFacialCollectionView.h"
#import "TKFacialCollectionViewCell.h"

@interface TKFacialCollectionView() <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic) TKFacialCollectionViewCell *currentCell;
@property (nonatomic) TKModelViewObject *currentCellViewModel;

@end

@implementation TKFacialCollectionView

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
        self.dataArray = [[TKSampleDataPool sharedInstance] facialModelList];
        [self registerClass:[TKFacialCollectionViewCell class] forCellWithReuseIdentifier:@"filter_cell"];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self =  [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self setShowsVerticalScrollIndicator:NO];
        self.dataArray = [[TKSampleDataPool sharedInstance] facialModelViewList];
        self.dataSource = self;
        self.delegate = self;
        [self registerClass:[TKFacialCollectionViewCell class] forCellWithReuseIdentifier:@"facial_cell"];
    }
    return self;
}

- (void)setCameraViewController:(id)cameraViewController {
    _cameraViewController = cameraViewController;
    [self reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self) {
        return self.dataArray.count;
    }
    return 0;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TKFacialCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"facial_cell" forIndexPath:indexPath];
    TKModelViewObject *cellViewModel = self.dataArray[indexPath.row];
    if (cell) {
        cell.imageView.image = ((TKFacialModelView *)cellViewModel).thumbImageView.image;
            [cell setClipsToBounds:YES];
        if (self.cameraViewController) {
            cell.delegate = self.cameraViewController;
        }
        
        if (cellViewModel.isSelected) {
            [self cellLayoutIsSelected:cell isSelected:YES];
            cell.isSelected = YES;
            self.currentCell = cell;
            self.currentCellViewModel = cellViewModel;
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TKFacialCollectionViewCell *cell = (TKFacialCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell) {
        TKModelViewObject *cellViewModel = self.dataArray[indexPath.row];
        if (cell.isSelected) {
            if ([cell.delegate respondsToSelector:@selector(didDeselectFacialWithIdentifier:)]) {
                [cell.delegate didDeselectFacialWithIdentifier:cellViewModel.identifier.integerValue];
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [self cellLayoutIsSelected:self.currentCell isSelected:NO];
                } completion:^(BOOL finished){
                    // if you want to do something once the animation finishes, put it here
                    [self setStateCell:cell isSelect:NO withModelView:cellViewModel];
                }];
            }
        } else {
            if ([cell.delegate respondsToSelector:@selector(didSelectFacialWithIdentifier:)]) {
                [cell.delegate didSelectFacialWithIdentifier:cellViewModel.identifier.integerValue];
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
                    if ([self.currentCell.delegate respondsToSelector:@selector(didDeselectFacialWithIdentifier:)]) {
                        [self.currentCell.delegate didDeselectFacialWithIdentifier:self.currentCellViewModel.identifier.integerValue];
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

- (void)cellLayoutIsSelected:(TKFacialCollectionViewCell *)cell isSelected:(BOOL)isSelected {
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
