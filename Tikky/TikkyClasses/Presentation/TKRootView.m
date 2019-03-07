//
//  TKRootView.m
//  TKPresentation
//
//  Created by LeHuuNghi on 12/8/18.
//  Copyright © 2018 LeHuuNghi. All rights reserved.
//

#import "TKRootView.h"

@interface TKRootView()

@property (strong, nonatomic) TKBottomMenuFactory *bottomMenuFactory;

@property (nonatomic) TKBottomMenuType typeBottom;

@end

@implementation TKRootView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _topMenuView = [TKTopMenu new];
        
        _topMenuView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addSubview:_topMenuView];
        [self setBottomMenuViewWithBottomMenuType:MainMenu];
        
        [[self.topMenuView.topAnchor constraintEqualToAnchor:self.topAnchor constant:0.0] setActive:YES];
        [[self.topMenuView.widthAnchor constraintEqualToAnchor:self.widthAnchor constant:0.0] setActive:YES];
        [[self.topMenuView.leftAnchor constraintEqualToAnchor:self.leftAnchor] setActive:YES];
        [[self.topMenuView.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:0.2] setActive:YES];
    }
    return self;
}

- (void)setViewController:(id)viewController {
    _viewController = viewController;
    [self.bottomMenuView setViewController:viewController];
    [self.topMenuView setViewController:viewController];
}

-(void)setBottomMenuViewWithBottomMenuType:(TKBottomMenuType)bottomMenuType {
    if (bottomMenuType != self.typeBottom) {
        _typeBottom = bottomMenuType;
        if (self.bottomMenuView) {
            [self.bottomMenuView removeFromSuperview];
        }
        _bottomMenuView = [[TKBottomMenuFactory class] getMenuWithMenuType:bottomMenuType];
        _bottomMenuView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addSubview:_bottomMenuView];
        
        [[self.bottomMenuView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:0.0] setActive:YES];
        [[self.bottomMenuView.widthAnchor constraintEqualToAnchor:self.widthAnchor constant:0.0] setActive:YES];
        [[self.bottomMenuView.leftAnchor constraintEqualToAnchor:self.leftAnchor] setActive:YES];
        [[self.bottomMenuView.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:0.25] setActive:YES];
    }
    

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
