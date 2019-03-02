//
//  ViewController.m
//  Tikky
//
//  Created by LeHuuNghi on 2/25/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "ViewController.h"
#import "TKRootView.h"
#import "TKSampleDataPool.h"

@interface ViewController ()<TKBottomItemDelegate>

@property (nonatomic) TKRootView* rootView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor clearColor]];
    // Do any additional setup after loading the view.
    _rootView = [TKRootView new];
    [self.view setOpaque:NO];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    [self.rootView setOpaque:NO];
    [_rootView setBackgroundColor:[UIColor clearColor]];
    _rootView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_rootView];
    
    [self.rootView setBackgroundColor:[UIColor clearColor]];
    [[self.rootView.topAnchor constraintEqualToAnchor:self.view.topAnchor] setActive:YES];
    [[self.rootView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:0.0] setActive:YES];
    [[self.rootView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:1.0] setActive:YES];
    [[self.rootView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:1.0] setActive:YES];
    
    [self.rootView.bottomMenuView setViewController:self];
    [self.rootView.topMenuView setViewController:self];
    
    [_rootView bringSubviewToFront:_rootView];
    [_rootView bringSubviewToFront:_rootView.topMenuView];
    [_rootView bringSubviewToFront:_rootView.bottomMenuView];
}

- (void)clickBottomMenuItem:(NSString *)nameItem {
    if ([nameItem isEqualToString:@"photo"]) {
        
    } else if ([nameItem isEqualToString:@"capture"]) {
        
    } else if ([nameItem isEqualToString:@"filter"]) {
        [self.rootView setBottomMenuViewWithBottomMenuType:FilterMenu];
        
    } else if ([nameItem isEqualToString:@"frame"]) {
        [self.rootView setBottomMenuViewWithBottomMenuType:StickerMenu];


    } else if ([nameItem isEqualToString:@"emoji"]) {
        [self.rootView setBottomMenuViewWithBottomMenuType:StickerMenu];
        
    }
}

@end
