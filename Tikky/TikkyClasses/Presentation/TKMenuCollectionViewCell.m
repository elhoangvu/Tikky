//
//  TKMenuCollectionViewCell.m
//  Tikky
//
//  Created by Vu Le Hoang on 6/2/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "TKMenuCollectionViewCell.h"

@interface TKMenuCollectionViewCell ()

@property (nonatomic) UIImageView* imageView;

@property (nonatomic) UILabel* titleLabel;

@end

@implementation TKMenuCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) {
        return nil;
    }
    
    self.imageView = [[UIImageView alloc] initWithFrame:self.frame];
    [self addSubview:self.imageView];
    _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [[_imageView.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:self.frame.size.width*0.3] setActive:YES];
    [[_imageView.topAnchor constraintEqualToAnchor:self.topAnchor constant:self.frame.size.width*0.2] setActive:YES];
    [[_imageView.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:0.4] setActive:YES];
    [[_imageView.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:0.4] setActive:YES];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    _titleLabel = [[UILabel alloc] init];
    [self addSubview:_titleLabel];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [[_titleLabel.topAnchor constraintEqualToAnchor:_imageView.bottomAnchor constant:self.frame.size.width*0.05] setActive:YES];
    [[_titleLabel.leftAnchor constraintEqualToAnchor:self.leftAnchor] setActive:YES];
    [[_titleLabel.rightAnchor constraintEqualToAnchor:self.rightAnchor] setActive:YES];
    [[_titleLabel.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:0.2] setActive:YES];
    [_titleLabel setTextColor:UIColor.blackColor];
    [_titleLabel setFont:[_titleLabel.font fontWithSize:12]];
    
    self.backgroundColor = UIColor.whiteColor;
    
    return self;
}

- (void)setImageName:(NSString *)imageName {
    if ([imageName isEqualToString:_imageName]) {
        return;
    }
    _imageName = imageName;
    
    NSString* path = [NSBundle.mainBundle pathForResource:imageName ofType:nil];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    _imageView.image = image;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    [_titleLabel setText:_title];
}

@end
