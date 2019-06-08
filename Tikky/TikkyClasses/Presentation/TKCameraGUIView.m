//
//  TKCameraGUIView.m
//  Tikky
//
//  Created by Vu Le Hoang on 6/5/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "TKCameraGUIView.h"

#import "UIImage+NSBundle.h"

@interface TKCameraGUIView ()

@property (nonatomic) UIButton* captureButton;

@property (nonatomic) UIButton* swapCameraButton;

@end

@implementation TKCameraGUIView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) {
        return nil;
    }
    
    [self setUpButtons];
    
    return self;
}

- (void)setUpButtons {
    CGSize mainSize = UIScreen.mainScreen.bounds.size;
    CGFloat captureHeight = mainSize.height*0.12;
    CGRect captureFrame = CGRectMake(mainSize.width*0.5 - captureHeight*0.5, mainSize.height*0.85, captureHeight, captureHeight);
    _captureButton = [[UIButton alloc] initWithFrame:captureFrame];
    UIImage* captureImage = [UIImage imageFromBundleWithName:@"capture-white.png"];
    [_captureButton setImage:captureImage forState:(UIControlStateNormal)];
    [_captureButton addTarget:self action:@selector(didTapCaptureButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:_captureButton];
    
    CGFloat swapHeight = captureHeight*0.35;
    CGRect swapFrame = CGRectMake(mainSize.width - swapHeight*1.5, swapHeight*0.5, swapHeight, swapHeight);
    _swapCameraButton = [[UIButton alloc] initWithFrame:swapFrame];
    UIImage* swapImage = [UIImage imageFromBundleWithName:@"swap.png"];
    [_swapCameraButton setImage:swapImage forState:(UIControlStateNormal)];
    [_swapCameraButton addTarget:self action:@selector(didTapSwapButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:_swapCameraButton];
}

- (void)didTapCaptureButton:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(didTapCaptureButtonAtCameraGUIView:)]) {
        [_delegate didTapCaptureButtonAtCameraGUIView:self];
    }
}

- (void)didTapSwapButton:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(didTapSwapButtonAtCameraGUIView:)]) {
        [_delegate didTapSwapButtonAtCameraGUIView:self];
    }
}

@end
