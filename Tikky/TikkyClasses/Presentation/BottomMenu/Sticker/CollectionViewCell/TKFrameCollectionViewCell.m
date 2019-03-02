//
//  TKFrameCollectionViewCell.m
//  Tikky
//
//  Created by LeHuuNghi on 3/1/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "TKFrameCollectionViewCell.h"

@implementation TKFrameCollectionViewCell

- (void)setImageView:(UIImageView *)imageView {
    _imageView = imageView;
    [self.contentView addSubview:_imageView];
    
    _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [[_imageView.widthAnchor constraintEqualToConstant:[UIScreen mainScreen].bounds.size.width / 7] setActive:YES];
    [[_imageView.heightAnchor constraintEqualToConstant:[UIScreen mainScreen].bounds.size.height / 7] setActive:YES];
    [[_imageView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:10] setActive:YES];
    [[_imageView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor] setActive:YES];
}

@end
