//
//  TKStickerCollectionView.m
//  TKPresentation
//
//  Created by LeHuuNghi on 1/28/19.
//  Copyright © 2019 LeHuuNghi. All rights reserved.
//

#import "TKStickerCollectionView.h"
#import "TKStickerCollectionViewCell.h"

@interface TKStickerCollectionView()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation TKStickerCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self =  [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.dataArray = [[TKSampleDataPool sharedInstance] stickerModelViewList];
        [self setShowsVerticalScrollIndicator:NO];
        self.dataSource = self;
        [self registerClass:[TKStickerCollectionViewCell class] forCellWithReuseIdentifier:@"sticker_cell"];
    }
    return self;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self) {
        
    }
}

#pragma UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self) {
        return self.dataArray.count;
    }
    return 0;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TKStickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sticker_cell" forIndexPath:indexPath];
    if (cell) {
        cell.imageView.image = ((TKStickerModelView *)self.dataArray[indexPath.row]).thumbImageView.image;
    }
    return cell;
}
@end
