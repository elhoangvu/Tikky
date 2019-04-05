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
        if ([cell.delegate respondsToSelector:@selector(didSelectFrameWithIdentifier:)]) {
            [cell.delegate didSelectFrameWithIdentifier:self.dataArray[indexPath.row].identifier.integerValue];
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                if (self.currentCell) {
                    self.currentCell.imageView.transform = CGAffineTransformIdentity;
                    self.currentCell.layer.borderWidth = 0;
                    if (self.currentCell == cell) return;
                }
                // animate it to the identity transform (100% scale)
                cell.imageView.transform = CGAffineTransformMakeScale(0.8, 0.8);
                cell.layer.borderWidth = 3.0f;
                cell.layer.borderColor = [UIColor purpleColor].CGColor;
            } completion:^(BOOL finished){
                // if you want to do something once the animation finishes, put it here
                self.currentCell = cell;
            }];
            
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
        cell.imageView.image = ((TKFrameModelView *)[self.dataArray objectAtIndex:indexPath.row]).thumbImageView.image;
        cell.delegate = self.cameraViewController;
    }
    return cell;
}

@end
