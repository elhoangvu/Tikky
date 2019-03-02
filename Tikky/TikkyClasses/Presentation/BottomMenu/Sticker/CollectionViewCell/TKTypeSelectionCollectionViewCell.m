//
//  TypeSelectionCollectionViewCell.m
//  Tikky
//
//  Created by LeHuuNghi on 2/27/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "TKTypeSelectionCollectionViewCell.h"

@implementation TKTypeSelectionCollectionViewCell

- (void)setLabel:(UILabel *)label {
    if (_label) {
        [self removeFromSuperview];
    }
    _label = label;
    if (label) {
        [self addSubview:_label];
        [_label setTextColor:[UIColor whiteColor]];
        _label.translatesAutoresizingMaskIntoConstraints = NO;
        [[_label.centerXAnchor constraintEqualToAnchor:self.centerXAnchor] setActive:YES];
        [[_label.centerYAnchor constraintEqualToAnchor:self.centerYAnchor] setActive:YES];
        [[_label.bottomAnchor constraintEqualToAnchor:self.bottomAnchor] setActive:YES];
        [[_label.topAnchor constraintEqualToAnchor:self.topAnchor] setActive:YES];
        [[_label.heightAnchor constraintEqualToAnchor:self.heightAnchor] setActive:YES];


        
    }
}

@end
