//
//  TKTopEditView.m
//  Tikky
//
//  Created by LeHuuNghi on 5/4/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "TKTopEditView.h"
@interface TKTopEditView()

@property (nonatomic) UIStackView *stackView;

@end

@implementation TKTopEditView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _stackView.axis = UILayoutConstraintAxisHorizontal;
        _stackView.translatesAutoresizingMaskIntoConstraints = NO;
        _stackView.distribution = UIStackViewDistributionEqualSpacing;
        _stackView.spacing = 30;
        _stackView.alignment = UIStackViewAlignmentCenter;
        [self addSubview:_stackView];
        
        [[_stackView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor] setActive:YES];
        [[_stackView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor] setActive:YES];
        [[_stackView.heightAnchor constraintEqualToAnchor:self.heightAnchor] setActive:YES];
        
        
    }
    return self;
}

@end
