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

@property (nonatomic) UIButton* flashButton;

@property (nonatomic) UIButton* beautyButton;

@property (nonatomic) AVCaptureFlashMode flashMode;

@property (nonatomic) BOOL isOnMode;

@property (nonatomic) UIView* focusView;

@end

@implementation TKCameraGUIView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) {
        return nil;
    }
    
    [self setUpButtons];
    _flashMode = AVCaptureFlashModeOff;
    _isOnMode = YES;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapMyself:)];
    [self addGestureRecognizer:tap];
    
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
    
    CGFloat flashHeight = captureHeight*0.4;
    CGRect flashFrame = CGRectMake(mainSize.width - flashHeight*2.0, flashHeight*0.5, flashHeight, flashHeight);
    _flashButton = [[UIButton alloc] initWithFrame:flashFrame];
    UIImage* flashImage = [UIImage imageFromBundleWithName:@"flash-off.png"];
    [_flashButton setImage:flashImage forState:(UIControlStateNormal)];
    [_flashButton addTarget:self action:@selector(didTapFlashButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:_flashButton];
    
    CGFloat swapHeight = captureHeight*0.35;
    CGRect swapFrame = CGRectMake(mainSize.width*0.2 - swapHeight*0.5, captureFrame.origin.y+captureFrame.size.height*0.5-swapHeight*0.5, swapHeight, swapHeight);
    _swapCameraButton = [[UIButton alloc] initWithFrame:swapFrame];
    UIImage* swapImage = [UIImage imageFromBundleWithName:@"swap.png"];
    [_swapCameraButton setImage:swapImage forState:(UIControlStateNormal)];
    [_swapCameraButton addTarget:self action:@selector(didTapSwapButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:_swapCameraButton];
    
    CGFloat beautyHeight = captureHeight*0.4;
    CGRect beautyFrame = CGRectMake(mainSize.width*0.8 - beautyHeight*0.5, captureFrame.origin.y+captureFrame.size.height*0.5-beautyHeight*0.5, beautyHeight, beautyHeight);
    _beautyButton = [[UIButton alloc] initWithFrame:beautyFrame];
    UIImage* beautyImage = [UIImage imageFromBundleWithName:@"beauty-on.png"];
    [_beautyButton setImage:beautyImage forState:(UIControlStateNormal)];
    [_beautyButton addTarget:self action:@selector(didTapBeautyButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:_beautyButton];
    
    CGFloat focusHeight = mainSize.width*0.15;
    _focusView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, focusHeight, focusHeight))];
    _focusView.backgroundColor = UIColor.clearColor;
    _focusView.layer.cornerRadius = focusHeight*0.5;
    _focusView.layer.borderColor = UIColor.whiteColor.CGColor;
    _focusView.layer.borderWidth = 1.0;
    _focusView.clipsToBounds = YES;
    [self addSubview:_focusView];
    [_focusView setHidden:YES];
}

- (void)didTapCaptureButton:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(didTapCaptureButtonInCameraGUIView:)]) {
        [_delegate didTapCaptureButtonInCameraGUIView:self];
    }
}

- (void)didTapSwapButton:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(didTapSwapButtonInCameraGUIView:)]) {
        [_delegate didTapSwapButtonInCameraGUIView:self];
    }
}

- (void)didTapFlashButton:(UIButton *)button {
    if (_flashMode == AVCaptureFlashModeOff) {
        _flashMode = AVCaptureFlashModeOn;
        UIImage* onImg = [UIImage imageFromBundleWithName:@"flash-on.png"];
        [_flashButton setImage:onImg forState:(UIControlStateNormal)];
    } else if (_flashMode == AVCaptureFlashModeOn) {
        _flashMode = AVCaptureFlashModeAuto;
        UIImage* autoImg = [UIImage imageFromBundleWithName:@"flash-auto.png"];
        [_flashButton setImage:autoImg forState:(UIControlStateNormal)];
    } else {
        _flashMode = AVCaptureFlashModeOff;
        UIImage* offImg = [UIImage imageFromBundleWithName:@"flash-off.png"];
        [_flashButton setImage:offImg forState:(UIControlStateNormal)];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(didTapFlashButtonInCameraGUIView:withMode:)]) {
        [_delegate didTapFlashButtonInCameraGUIView:self withMode:_flashMode];
    }
}

- (void)didTapBeautyButton:(UIButton *)button {
    if (_isOnMode) {
        _isOnMode = NO;
        UIImage* beautyImg = [UIImage imageFromBundleWithName:@"beauty-off.png"];
        [_beautyButton setImage:beautyImg forState:(UIControlStateNormal)];
    } else {
        _isOnMode = YES;
        UIImage* beautyImg = [UIImage imageFromBundleWithName:@"beauty-on.png"];
        [_beautyButton setImage:beautyImg forState:(UIControlStateNormal)];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(didTapBeautyButtonInCameraGUIView:isOnMode:)]) {
        [_delegate didTapBeautyButtonInCameraGUIView:self isOnMode:_isOnMode];
    }
}

- (void)didTapMyself:(UITapGestureRecognizer *)tapGesture {
    [_focusView setHidden:NO];
    CGRect frame = _focusView.frame;
    __block CGRect newFrame = frame;
    frame.size.width *= 2.0;
    frame.size.height *= 2.0;
    CGPoint tapPoint = [tapGesture locationInView:self];
    frame = [self focusViewFrame:frame atPoint:tapPoint];
    [_focusView setFrame:frame];
    _focusView.layer.cornerRadius = frame.size.height*0.5;
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        newFrame = [weakSelf focusViewFrame:newFrame atPoint:tapPoint];
        weakSelf.focusView.layer.cornerRadius = newFrame.size.height*0.5;
        [weakSelf.focusView setFrame:newFrame];
    } completion:^(BOOL finished) {
        [weakSelf.focusView setHidden:YES];
    }];
    
    if (_delegate && [_delegate respondsToSelector:@selector(didTapInCameraGUIView:atPoint:)]) {
        [_delegate didTapInCameraGUIView:self atPoint:tapPoint];
    }
}

- (CGRect)focusViewFrame:(CGRect)frame atPoint:(CGPoint)point {
    frame.origin.x = point.x - frame.size.width*0.5;
    frame.origin.y = point.y - frame.size.height*0.5;
    return frame;
}

@end
