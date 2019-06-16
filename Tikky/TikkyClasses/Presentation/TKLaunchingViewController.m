//
//  TKLaunchingViewController.m
//  Tikky
//
//  Created by Vu Le Hoang on 6/13/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "TKLaunchingViewController.h"

#import "TKCameraViewController.h"

@interface TKLaunchingViewController ()

@property (nonatomic) UIImageView *lauchingImage;

@end

@implementation TKLaunchingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _lauchingImage = [[UIImageView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    [self.view addSubview:_lauchingImage];
    _lauchingImage.image = [UIImage imageNamed:@"launchimage"];
    _lauchingImage.translatesAutoresizingMaskIntoConstraints = NO;
    [[_lauchingImage.leftAnchor constraintEqualToAnchor:self.view.leftAnchor] setActive:YES];
    [[_lauchingImage.rightAnchor constraintEqualToAnchor:self.view.rightAnchor] setActive:YES];
    [[_lauchingImage.topAnchor constraintEqualToAnchor:self.view.topAnchor] setActive:YES];
    [[_lauchingImage.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor] setActive:YES];
    self.view.backgroundColor = UIColor.whiteColor;
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.5 delay:1.0 options:(UIViewAnimationOptionCurveLinear) animations:^{
        [weakSelf.view setAlpha:0];
    } completion:^(BOOL finished) {
        TKCameraViewController* cameraVC = [[TKCameraViewController alloc] init];
        [self presentViewController:cameraVC animated:NO completion:nil];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
