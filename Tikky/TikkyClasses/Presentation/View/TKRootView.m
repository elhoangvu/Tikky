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

@property (nonatomic) NSLayoutConstraint *firstConstraint;

@property (nonatomic) NSLayoutConstraint *secondConstraint;

@property (nonatomic) dispatch_queue_t serialQueue;


@end

@implementation TKRootView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _serialQueue = dispatch_queue_create("rootview_serial_queue", DISPATCH_QUEUE_SERIAL);
        
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self setBottomMenuViewWithBottomMenuType:MainMenu];
    [self.bottomMenuView setViewController:self.viewController];
}

- (void)setViewController:(id)viewController {
    _viewController = viewController;
    [self.bottomMenuView setViewController:viewController];
    [self.topMenuView setViewController:viewController];
};

-(void)setBottomMenuViewWithBottomMenuType:(TKBottomMenuType)bottomMenuType {
    if (bottomMenuType != self.typeBottom) {
        dispatch_async(self.serialQueue, ^{
            self.typeBottom = bottomMenuType;
        });
        
        TKBottomMenu *newBottomMenu = [[TKBottomMenuFactory class] getMenuWithMenuType:bottomMenuType];
        newBottomMenu.translatesAutoresizingMaskIntoConstraints = NO;
        
        
        if (bottomMenuType == MainMenu) {
            [self addSubview:newBottomMenu];
            if (self.bottomMenuView) {
                [self bringSubviewToFront:self.bottomMenuView];
            }
        } else {
            [self addSubview:newBottomMenu];
        }
        [[newBottomMenu.widthAnchor constraintEqualToAnchor:self.widthAnchor constant:0.0] setActive:YES];
        [[newBottomMenu.leftAnchor constraintEqualToAnchor:self.leftAnchor] setActive:YES];
        [[newBottomMenu.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:0.25] setActive:YES];
        
        if (self.typeBottom == MainMenu) {
            [[newBottomMenu.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:0.0] setActive:true];

            NSLayoutConstraint *temp = _firstConstraint;
            _firstConstraint = _secondConstraint;
            _secondConstraint = temp;
        } else {
            _firstConstraint = [newBottomMenu.topAnchor constraintEqualToAnchor:self.bottomAnchor constant:0.0];
            [_firstConstraint setActive:YES];
            _secondConstraint = [newBottomMenu.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:0.0];
        }
        
        [self layoutIfNeeded];

        [UIView animateWithDuration:0.3  animations:^{
            [self.firstConstraint setActive:NO];
            [self.secondConstraint setActive:YES];
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            if (finished) {
                //remove old menu
                if (self.bottomMenuView) {
                    [self.bottomMenuView removeFromSuperview];
                }
                self.bottomMenuView = newBottomMenu;
                [self layoutIfNeeded];
            }
        }];
        //transition new menu
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
