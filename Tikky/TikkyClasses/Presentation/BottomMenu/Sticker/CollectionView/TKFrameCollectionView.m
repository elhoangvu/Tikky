//
//  TKFrameCollectionView.m
//  Tikky
//
//  Created by LeHuuNghi on 3/1/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "TKFrameCollectionView.h"
#import "TKFrameCollectionViewCell.h"

@implementation TKFrameCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self =  [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.dataArray = [[TKSampleDataPool sharedInstance] frameModelList];
        self.dataSource = self;
        [self registerClass:[TKFrameCollectionViewCell class] forCellWithReuseIdentifier:@"frame_cell"];
    }
    return self;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self) {
        NSLog(@"%d", indexPath.row);
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
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:((TKStickerModel *)[self.dataArray objectAtIndex:indexPath.row]).thumbnailPath ofType:@"png"]];
        cell.imageView = [[UIImageView alloc] initWithImage:image];
    }
    return cell;
}

@end
