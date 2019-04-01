//
//  TKFacialBottomMenu.m
//  TKPresentation
//
//  Created by LeHuuNghi on 1/20/19.
//  Copyright © 2019 LeHuuNghi. All rights reserved.
//

#import "TKFacialBottomMenu.h"

@interface TKFacialBottomMenu()
@end

@implementation TKFacialBottomMenu

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
        [self setBackgroundColor:[UIColor whiteColor]];
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _filterCollectionView=[[TKFacialCollectionView alloc] initWithFrame:self.frame collectionViewLayout:layout];
        [self addSubview:self.filterCollectionView];
        
        _filterCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [[self.filterCollectionView.topAnchor constraintEqualToAnchor:self.topAnchor] setActive:YES];
        [[self.filterCollectionView.widthAnchor constraintEqualToAnchor:self.widthAnchor] setActive:YES];
        [[self.filterCollectionView.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:0.6] setActive:YES];
        [[self.filterCollectionView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor] setActive:YES];
    
    }
    return self;
}

@end
