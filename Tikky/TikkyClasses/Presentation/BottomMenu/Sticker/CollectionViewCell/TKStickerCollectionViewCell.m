//
//  TKStickerCollectionViewCell.m
//  TKPresentation
//
//  Created by LeHuuNghi on 1/29/19.
//  Copyright © 2019 LeHuuNghi. All rights reserved.
//

#import "TKStickerCollectionViewCell.h"
#import "TKSampleDataPool.h"
@interface TKStickerCollectionViewCell()

@end

@implementation TKStickerCollectionViewCell

//-(void)setImageView:(UIImageView *)imageView {
//    if (!_imageView) {
//        _imageView = imageView;
//
//    }
//}

- (instancetype)init
{
    self = [super init];
    if (self) {


    }
    return self;
}

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
