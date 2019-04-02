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

- (NSInteger)numberOfSections {
    return 1;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self =  [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        [self setShowsHorizontalScrollIndicator:NO];
        self.dataArray = [[TKSampleDataPool sharedInstance] filterModelViewList];
        self.dataSource = self;
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
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height * 0.8);
}

@end
