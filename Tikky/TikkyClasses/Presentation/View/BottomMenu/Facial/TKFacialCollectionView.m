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
        self.dataSource = self;
        [self registerClass:[TKFacialCollectionViewCell class] forCellWithReuseIdentifier:@"filter_cell"];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self =  [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.dataArray = [[TKSampleDataPool sharedInstance] facialModelViewList];
        self.dataSource = self;
        [self registerClass:[TKFacialCollectionViewCell class] forCellWithReuseIdentifier:@"facial_cell"];
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
    TKFacialCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"facial_cell" forIndexPath:indexPath];
    if (cell) {
        cell.imageView.image = ((TKFacialModelView *)[self.dataArray objectAtIndex:indexPath.row]).thumbImageView.image;
    }
    return cell;
}

@end
