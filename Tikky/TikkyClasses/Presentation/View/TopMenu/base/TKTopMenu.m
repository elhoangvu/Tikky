//
//  TKNavigationBar.m
//  TKPresentation
//
//  Created by LeHuuNghi on 12/3/18.
//  Copyright © 2018 LeHuuNghi. All rights reserved.
//

#import "TKTopMenu.h"
#import "RCEasyTipView.h"

@interface TKTopMenu()<TKTopItemViewDelegate>

@property (nonatomic, strong) TKTopSubViewMenu *subMenuView;

@property (nonatomic) RCEasyTipView *tipView;

@end

@implementation TKTopMenu

-(void)aloha:(id)obj {
    NSLog(@"abc");
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _items = @[[[TKTopMenuItem alloc] initWithName:@"more"],
                   [[TKTopMenuItem alloc] initWithName:@"raito"],
                   [[TKTopMenuItem alloc] initWithName:@"time"],
                   [[TKTopMenuItem alloc] initWithName:@"flash"],
                   [[TKTopMenuItem alloc] initWithName:@"reverse"],];
        
        UIStackView *stackView = [UIStackView new];
        stackView.axis = UILayoutConstraintAxisHorizontal;
        stackView.translatesAutoresizingMaskIntoConstraints = NO;
        stackView.distribution = UIStackViewDistributionEqualSpacing;
        stackView.alignment = UIStackViewAlignmentCenter;
        
        [self addSubview:stackView];
        
        [[stackView.topAnchor constraintEqualToAnchor:self.topAnchor constant:20] setActive:true];
        [[stackView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor] setActive:true];
        [[stackView.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:0.9] setActive:YES];
        [[stackView.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:0.25] setActive:YES];
        
        for (TKTopMenuItem *item in _items) {
            item.delegate = self;
            item.translatesAutoresizingMaskIntoConstraints = NO;
            item.contentMode = UIViewContentModeScaleAspectFit;
            
            [stackView addArrangedSubview:item];

            [[item.heightAnchor constraintEqualToAnchor:stackView.heightAnchor] setActive:YES];
            [[item.centerYAnchor constraintEqualToAnchor:stackView.centerYAnchor] setActive:true];
            
            RCEasyTipPreferences *preferences = [[RCEasyTipPreferences alloc] initWithDefaultPreferences];
            preferences.drawing.backgroundColor = [UIColor purpleColor];
            preferences.drawing.arrowPostion = Top;
            preferences.animating.showDuration = 0.4;
            preferences.animating.dismissDuration = 0.4;
            preferences.animating.dismissTransform = CGAffineTransformMakeTranslation(0, -100);
            preferences.animating.showInitialTransform = CGAffineTransformMakeTranslation(0, -100);
            
            _tipView = [[RCEasyTipView alloc] initWithPreferences:preferences];
            _tipView.text = @"Lorem Ipsum is simply dummy text of the printing and typesetting industry.";
        }
        
    }
    return self;
}



- (void)tapTopItem:(NSString *)nameItem {
    if ([nameItem isEqualToString:@"reverse"]) {
        if([self.delegate respondsToSelector:@selector(didReverseCamera)]) {
            [self.delegate didReverseCamera];
        }
    } else {
        if ([nameItem isEqualToString:@"more"]) {
            if ([self.tipView isHidden]) {
                [self.tipView showAnimated:YES forView:self.items[0] withinSuperView:nil];
                [self.tipView setHidden:NO];
            } else {
                [self.tipView dismissWithCompletion:nil];
                [self.tipView setHidden:YES];
            }
        } else if ([nameItem isEqualToString:@"more"]) {
            
        } else if ([nameItem isEqualToString:@"raito"]) {
            
        } else if ([nameItem isEqualToString:@"flash"]) {
            
        }
    }
    
    
}

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        //draw
//        CGRect newFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height / 10);
//        [self setFrame:newFrame];
//
//        //add item
//        _subViews = [[NSMutableDictionary alloc] init];
//        [_subViews setValue:[TKTopMenuItem new] forKey:@"more_item"];
//        [_subViews setValue:[TKTopMenuItem new] forKey:@"frame"];
//        [_subViews setValue:[TKTopMenuItem new] forKey:@"timed"];
//        [_subViews setValue:[TKTopMenuItem new] forKey:@"flash"];
//        [_subViews setValue:[TKTopMenuItem new] forKey:@"reverse_camera"];
//        [self drawItem];
//    }
//    return self;
//}

@end
