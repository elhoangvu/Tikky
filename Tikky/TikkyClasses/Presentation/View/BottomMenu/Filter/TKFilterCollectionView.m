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
        cell.imageView.image = ((TKFilterModelView *)[self.dataArray objectAtIndex:indexPath.row]).thumbImageView.image;
        cell.delegate = self.cameraViewController;
    }
    return cell;
}

#pragma UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TKFilterCollectionViewCell *cell = (TKFilterCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if ([cell.delegate respondsToSelector:@selector(didSelectFilterWithIdentifier:)]) {
        [cell.delegate didSelectFilterWithIdentifier:self.dataArray[indexPath.row].identifier];
    }
}

@end
