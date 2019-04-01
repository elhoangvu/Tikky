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
