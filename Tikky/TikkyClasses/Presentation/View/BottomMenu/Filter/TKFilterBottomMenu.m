//
//  TKFilterBottomMenu.m
//  TKPresentation
//
//  Created by LeHuuNghi on 1/20/19.
//  Copyright © 2019 LeHuuNghi. All rights reserved.
//

#import "TKFilterBottomMenu.h"

@interface TKFilterBottomMenu()

@property (nonatomic) UIImageView *captureButton;
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
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _filterCollectionView=[[TKFilterCollectionView alloc] initWithFrame:self.frame collectionViewLayout:layout];
        [self addSubview:self.filterCollectionView];
        
        _filterCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [[self.filterCollectionView.topAnchor constraintEqualToAnchor:self.topAnchor] setActive:YES];
        [[self.filterCollectionView.widthAnchor constraintEqualToAnchor:self.widthAnchor] setActive:YES];
        [[self.filterCollectionView.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:0.6] setActive:YES];
        [[self.filterCollectionView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor] setActive:YES];
        [self layoutIfNeeded];
        
        _captureButton = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"capture" ofType:@"png"]]];
        _captureButton.contentMode = UIViewContentModeScaleAspectFit;
        _captureButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_captureButton];
        
        [[_captureButton.centerXAnchor constraintEqualToAnchor:self.centerXAnchor] setActive:YES];
        [[_captureButton.topAnchor constraintEqualToAnchor:self.filterCollectionView.bottomAnchor] setActive:YES];
        [[_captureButton.bottomAnchor constraintEqualToAnchor:self.bottomAnchor] setActive:YES];
    }
    return self;
}

@end
