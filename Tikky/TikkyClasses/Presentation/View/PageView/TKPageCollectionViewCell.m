//
//  TKPageCollectionViewCell.m
//  Tikky
//
//  Created by Le Hoang Vu on 4/1/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "TKPageCollectionViewCell.h"

@interface TKPageCollectionViewCell ()

@property (nonatomic) UILabel* titleLabel;

@end

@implementation TKPageCollectionViewCell

- (void)setTitle:(NSString *)title {
    _title = title;
    [self updateTitleLableIfNeededWithTitle:title];
}

- (void)updateTitleLableIfNeededWithTitle:(NSString *)title {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _titleLabel.textColor = UIColor.whiteColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleLabel setNumberOfLines:0];
        [_titleLabel setContentMode:(UIViewContentModeCenter)];
        [_titleLabel setFont:[UIFont systemFontOfSize:17]];
        [self.contentView addSubview:_titleLabel];
    }
    
    [_titleLabel setText:title];
}

- (void)setIsBold:(BOOL)isBold {
    _isBold = isBold;
    
    if (isBold) {
        [_titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    } else {
        [_titleLabel setFont:[UIFont systemFontOfSize:17]];
    }
}

@end
