//
//  TKNotificationViewController.m
//  Tikky
//
//  Created by Vu Le Hoang on 6/12/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "TKNotificationViewController.h"

#import "UIImage+NSBundle.h"

@interface TKNotificationViewController ()

@property (nonatomic) UIView* containerView;

@property (nonatomic) UILabel* topTitleLabel;

@property (nonatomic) UILabel* bottomTitleLabel;

@property (nonatomic) UIImageView* contentImageView;

@property (nonatomic) UIButton* rightButton;

@property (nonatomic) UIButton* leftButton;

@property (nonatomic) UIView* bottomView;

@end

@implementation TKNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view.layer setOpaque:NO];
    [self.view setOpaque:NO];
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.15];
    
    // container
    CGSize mainSize = UIScreen.mainScreen.bounds.size;
    CGSize containerSize = _contentSize;
    CGRect containerFrame = CGRectMake((mainSize.width - containerSize.width)*0.5, (mainSize.height - containerSize.height)*0.5, containerSize.width, containerSize.height);
    _containerView = [[UIView alloc] initWithFrame:containerFrame];
    _containerView.layer.cornerRadius = 20.0f;
    _containerView.clipsToBounds = YES;
    _containerView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:_containerView];
    
    // top title
    CGRect topFrame = CGRectMake(0, containerSize.height*0.05, containerSize.width, containerSize.height*0.2);
    _topTitleLabel = [[UILabel alloc] initWithFrame:topFrame];
    [_topTitleLabel setText:_topTitle];
    _topTitleLabel.font = [UIFont systemFontOfSize:18];
    [_topTitleLabel setTextColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.9]];
    [_topTitleLabel setTextAlignment:(NSTextAlignmentCenter)];
    [_containerView addSubview:_topTitleLabel];
    
    // image
    if (_type == TKNotificationTypeSuccess) {
        UIImage* image = [UIImage imageFromBundleWithName:@"img-success.png"];
        _contentImageView = [[UIImageView alloc] initWithImage:image];
    } else {
        UIImage* image = [UIImage imageFromBundleWithName:@"img-failure.png"];
        _contentImageView = [[UIImageView alloc] initWithImage:image];
    }
    
    CGSize imageSize = CGSizeMake(containerSize.width*0.35, containerSize.width*0.35);
    CGRect imageFrame = CGRectMake((containerSize.width - imageSize.width)*0.5, topFrame.origin.y + topFrame.size.height, imageSize.width, imageSize.height);
    [_contentImageView setFrame:imageFrame];
    _contentImageView.contentMode = UIViewContentModeScaleToFill;
    [_containerView addSubview:_contentImageView];
    
    // bottom title
    CGRect bottomFrame = CGRectMake(0, imageFrame.origin.y + imageFrame.size.height, containerSize.width, topFrame.size.height);
    _bottomTitleLabel = [[UILabel alloc] initWithFrame:bottomFrame];
    if (_type == TKNotificationTypeSuccess) {
        [_bottomTitleLabel setText:@"Successful"];
    } else {
        [_bottomTitleLabel setText:@"Failed"];
    }
    _bottomTitleLabel.font = [UIFont boldSystemFontOfSize:20];

    [_bottomTitleLabel setTextColor:[UIColor colorWithRed:66.0/255.0 green:176.0/255.0 blue:109.0/255.0 alpha:1.0]];
    [_bottomTitleLabel setTextAlignment:(NSTextAlignmentCenter)];
    [_containerView addSubview:_bottomTitleLabel];
    
    // bottom
    CGFloat bottomHeight = containerSize.height*0.2;
    CGRect bottomViewFrame = CGRectMake(0, containerSize.height-bottomHeight, containerSize.width, bottomHeight);
    _bottomView = [[UIView alloc] initWithFrame:bottomViewFrame];
    _bottomView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.02];
    [_containerView addSubview:_bottomView];
    
    UIColor* buttonColor = [UIColor colorWithRed:29.0/255.0 green:161.0/255.0 blue:242.0/255.0 alpha:1.0];
    // left button
    CGRect leftFrame = CGRectMake(0, 0, bottomViewFrame.size.width*0.5, bottomViewFrame.size.height);
    _leftButton = [[UIButton alloc] initWithFrame:leftFrame];
    [_leftButton.titleLabel setTextAlignment:(NSTextAlignmentCenter)];
    _leftButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_leftButton setTitle:_leftButtonName forState:(UIControlStateNormal)];
    [_leftButton setTitleColor:buttonColor forState:(UIControlStateNormal)];
    [_leftButton addTarget:self action:@selector(didTapLeftButton:) forControlEvents:(UIControlEventTouchUpOutside)];
    [_bottomView addSubview:_leftButton];
    
    //right button
    CGRect rigthFrame = CGRectMake(bottomViewFrame.size.width*0.5, 0, bottomViewFrame.size.width*0.5, bottomViewFrame.size.height);
    _rightButton = [[UIButton alloc] initWithFrame:rigthFrame];
    [_rightButton.titleLabel setTextAlignment:(NSTextAlignmentCenter)];
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_rightButton setTitle:_rightButtonName forState:(UIControlStateNormal)];
    [_rightButton setTitleColor:buttonColor forState:(UIControlStateNormal)];
    [_rightButton addTarget:self action:@selector(didTapRightButton:) forControlEvents:(UIControlEventTouchUpOutside)];
    [_bottomView addSubview:_rightButton];
    
    // section line
    CGSize lineSize = CGSizeMake(2.0, bottomViewFrame.size.height*0.8);
    CGRect lineFrame = CGRectMake((bottomViewFrame.size.width - lineSize.width)*0.5, (bottomViewFrame.size.height-lineSize.height)*0.5, lineSize.width, lineSize.height);
    UIView* sectionLine = [[UIView alloc] initWithFrame:lineFrame];
    sectionLine.backgroundColor = UIColor.whiteColor;
    [_bottomView addSubview:sectionLine];
}

- (void)didTapLeftButton:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(didTapLeftButtonWithNotificationViewController:)]) {
        [_delegate didTapLeftButtonWithNotificationViewController:self];
    }
}

- (void)didTapRightButton:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(didTapRightButtonWithNotificationViewController:)]) {
        [_delegate didTapRightButtonWithNotificationViewController:self];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
