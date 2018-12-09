//
//  TKRootView.m
//  TKPresentation
//
//  Created by LeHuuNghi on 12/8/18.
//  Copyright © 2018 LeHuuNghi. All rights reserved.
//

#import "TKRootView.h"


@interface TKRootView()


@end

@implementation TKRootView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _bottomMenuView = [TKBottomMenu new];
        _topMenuView = [TKTopMenu new];
        
        _bottomMenuView.translatesAutoresizingMaskIntoConstraints = NO;
        _topMenuView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addSubview:_bottomMenuView];
        [self addSubview:_topMenuView];
        
        [[self.bottomMenuView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:0.0] setActive:YES];
        [[self.bottomMenuView.widthAnchor constraintEqualToAnchor:self.widthAnchor constant:0.0] setActive:YES];
        [[self.bottomMenuView.leadingAnchor constraintEqualToSystemSpacingAfterAnchor:self.leadingAnchor multiplier:0.0] setActive:YES];
        [[self.bottomMenuView.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:0.25] setActive:YES];
        
        [[self.topMenuView.topAnchor constraintEqualToAnchor:self.topAnchor constant:0.0] setActive:YES];
        [[self.topMenuView.widthAnchor constraintEqualToAnchor:self.widthAnchor constant:0.0] setActive:YES];
        [[self.topMenuView.leadingAnchor constraintEqualToSystemSpacingAfterAnchor:self.leadingAnchor multiplier:0.0] setActive:YES];
        [[self.topMenuView.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:0.2] setActive:YES];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
