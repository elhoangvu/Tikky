//
//  TKFrameCollectionViewCell.m
//  Tikky
//
//  Created by LeHuuNghi on 3/1/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "TKFrameCollectionViewCell.h"

@implementation TKFrameCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addSubview:_imageView];
        
        [[_imageView.topAnchor constraintEqualToAnchor:self.topAnchor constant:5] setActive:YES];
        [[_imageView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor] setActive:YES];
        [[_imageView.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:0.7] setActive:YES];
    }
    return self;
}

@end
