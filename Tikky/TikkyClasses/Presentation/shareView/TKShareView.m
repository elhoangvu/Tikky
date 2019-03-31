//
//  shareView.m
//  Tikky
//
//  Created by LeHuuNghi on 3/13/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "TKShareView.h"

@implementation TKShareView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _facebook = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"facebook" ofType:@"png"]]];
        _twitter = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"twitter" ofType:@"png"]]];
        
        UIStackView *stackView = [UIStackView new];
        stackView.axis = UILayoutConstraintAxisHorizontal;
        stackView.translatesAutoresizingMaskIntoConstraints = NO;
        stackView.distribution = UIStackViewDistributionEqualSpacing;
        stackView.spacing = 30;
        stackView.alignment = UIStackViewAlignmentCenter;
        [self addSubview:stackView];
        
        [[stackView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor] setActive:YES];
        [[stackView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor] setActive:YES];
        [[stackView.heightAnchor constraintEqualToAnchor:self.heightAnchor] setActive:YES];

        [stackView addArrangedSubview:_facebook];
        [stackView addArrangedSubview:_twitter];
        
        _facebook.translatesAutoresizingMaskIntoConstraints = NO;
        _twitter.translatesAutoresizingMaskIntoConstraints = NO;
        
        _facebook.contentMode = UIViewContentModeScaleAspectFit;
        _twitter.contentMode = UIViewContentModeScaleAspectFit;
        
        [[_facebook.heightAnchor constraintEqualToAnchor:stackView.heightAnchor] setActive:YES];
        [[_twitter.heightAnchor constraintEqualToAnchor:stackView.heightAnchor] setActive:YES];
        
    }
    return self;
}

@end
