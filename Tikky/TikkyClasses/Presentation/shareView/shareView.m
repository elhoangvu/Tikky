//
//  shareView.m
//  Tikky
//
//  Created by LeHuuNghi on 3/13/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "shareView.h"

@implementation shareView

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
        stackView.alignment = UIStackViewAlignmentCenter;
        [self addSubview:stackView];
        
        stackView.translatesAutoresizingMaskIntoConstraints = NO;
        stackView.center = self.center;
        [[stackView.heightAnchor constraintEqualToAnchor:self.heightAnchor] setActive:YES];
        [[stackView.widthAnchor constraintEqualToAnchor:self.widthAnchor] setActive:YES];

        [stackView addArrangedSubview:_facebook];
        [stackView addArrangedSubview:_twitter];
        
        _facebook.translatesAutoresizingMaskIntoConstraints = NO;
        _twitter.translatesAutoresizingMaskIntoConstraints = NO;
        
        
        
    }
    return self;
}

@end
