//
//  TKLaunchingViewController.m
//  Tikky
//
//  Created by Vu Le Hoang on 6/13/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "TKLaunchingViewController.h"

@interface TKLaunchingViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *lauchingImage;

@end

@implementation TKLaunchingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _lauchingImage.translatesAutoresizingMaskIntoConstraints = NO;
    [[_lauchingImage.leftAnchor constraintEqualToAnchor:self.view.leftAnchor] setActive:YES];
    [[_lauchingImage.rightAnchor constraintEqualToAnchor:self.view.rightAnchor] setActive:YES];
    [[_lauchingImage.topAnchor constraintEqualToAnchor:self.view.topAnchor] setActive:YES];
    [[_lauchingImage.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor] setActive:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.4 animations:^{
        [weakSelf.view setAlpha:0];
    } completion:^(BOOL finished) {
        dispatch_group_leave(group);
    }];
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
