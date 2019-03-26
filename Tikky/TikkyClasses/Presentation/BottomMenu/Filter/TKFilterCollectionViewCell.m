//
//  TKFilterCollectionViewCell.m
//  Tikky
//
//  Created by LeHuuNghi on 3/11/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "TKFilterCollectionViewCell.h"

@implementation TKFilterCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        _imageView = [UIImageView new];
        _nameLabel = [UILabel new];
        
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _nameLabel.contentMode = UIViewContentModeScaleToFill;
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [_nameLabel setTextAlignment:NSTextAlignmentCenter];
        
        [self addSubview:_imageView];
        [self addSubview:_nameLabel];
        
        [[_imageView.topAnchor constraintEqualToAnchor:self.topAnchor constant:5] setActive:YES];
        [[_imageView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor] setActive:YES];
        [[_imageView.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:0.7] setActive:YES];
        
        [[_nameLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor] setActive:YES];
        [[_nameLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor] setActive:YES];
        [[_nameLabel.widthAnchor constraintEqualToAnchor:self.widthAnchor] setActive:YES];
        [[_nameLabel.topAnchor constraintEqualToAnchor:_imageView.bottomAnchor constant:5] setActive:YES];
    }
    return self;
}

@end
