//
//  TKFilterBottomMenu.m
//  TKPresentation
//
//  Created by LeHuuNghi on 1/20/19.
//  Copyright © 2019 LeHuuNghi. All rights reserved.
//

#import "TKFilterBottomMenu.h"

@interface TKFilterBottomMenu()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation TKFilterBottomMenu

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
        [self setBackgroundColor:[UIColor blackColor]];
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        _filterCollectionView=[[TKFilterCollectionView alloc] initWithFrame:self.frame collectionViewLayout:layout];
        
        [self addSubview:self.filterCollectionView];
        
        _filterCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [[self.filterCollectionView.topAnchor constraintEqualToAnchor:self.topAnchor] setActive:YES];
        [[self.filterCollectionView.widthAnchor constraintEqualToAnchor:self.widthAnchor] setActive:YES];
        [[self.filterCollectionView.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:0.6] setActive:YES];
        [[self.filterCollectionView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor] setActive:YES];
        
        [self.filterCollectionView registerClass:[TKFilterCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return self;
}

#pragma UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [UICollectionViewCell new];
}

@end
