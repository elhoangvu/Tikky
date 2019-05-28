//
//  TKSelectionBottomMenuCollectionViewCell.m
//  Tikky
//
//  Created by LeHuuNghi on 5/28/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "TKSelectionBottomMenuCollectionViewCell.h"

@implementation TKSelectionBottomMenuCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [[_imageView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor] setActive:YES];
        [[_imageView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor] setActive:YES];
        [[_imageView.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:0.5] setActive:YES];

    }
    return self;
}

@end
