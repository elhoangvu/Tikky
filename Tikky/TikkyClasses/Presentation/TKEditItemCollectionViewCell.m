//
//  TKEditItemCollectionViewCell.m
//  Tikky
//
//  Created by Vu Le Hoang on 6/2/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "TKEditItemCollectionViewCell.h"

@interface TKEditItemCollectionViewCell ()

@property (nonatomic) UIImageView* imageView;

@end

@implementation TKEditItemCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) {
        return nil;
    }

    _imageView = [[UIImageView alloc] initWithFrame:frame];
    _imageView.clipsToBounds = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_imageView];

    _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [[_imageView.leftAnchor constraintEqualToAnchor:self.leftAnchor] setActive:YES];
    [[_imageView.topAnchor constraintEqualToAnchor:self.topAnchor] setActive:YES];
    [[_imageView.rightAnchor constraintEqualToAnchor:self.rightAnchor] setActive:YES];
    [[_imageView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor] setActive:YES];

    return self;
}

- (void)setViewModel:(TKEditItemViewModel *)viewModel {
    _viewModel = viewModel;
    _imageView.image = viewModel.thumbnail;
    [self bringSubviewToFront:_imageView];
    
    if (viewModel.entity.type == TKEntityTypeSticker) {
        _imageView.layer.cornerRadius = self.frame.size.height*0.2;
    } else if (viewModel.entity.type == TKEntityTypeSticker) {
        _imageView.layer.cornerRadius = 0;
    }
}

@end
