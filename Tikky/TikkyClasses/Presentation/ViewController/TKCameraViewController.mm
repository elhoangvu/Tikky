//
//  CameraViewController.m
//  Tikky
//
//  Created by Le Hoang Vu on 12/3/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import "TKCameraViewController.h"
#import "GUIViewController.h"
#import "Tikky.h"
#import <Photos/Photos.h>

#import "TKUtilities.h"
#import "TKSampleDataPool.h"

#import "GPUImage.h"

#import "TKRootView.h"

#include "cocos2d.h"

#import "TKSNFacebookSDK.h"

#import "FeatureDefinition.h"

#import "TKDefinition.h"

#import "TKNotification.h"

#import "TKGalleryUtilities.h"

@interface TKCameraViewController ()
<
TKBottomItemDelegate,
TKStickerPreviewerDelegate,
TKStickerCollectionViewCellDelegate,
TKTopItemDelegate,
TKFacialItemDelegate,
TKButtonCaptureVideoDelegate,
TKFilterItemDelegate,
TKStickerItemDelegate,
TKFrameItemDelegate
> {
    std::vector<std::vector<TKSticker>>* _facialStickers;
    std::vector<std::vector<TKSticker>>* _frameStickers;
}

@property (nonatomic) TikkyEngine* tikkyEngine;
@property (nonatomic) TKImageInput* imageInput;

@property (nonatomic) TKRootView* rootView;
@property (nonatomic) GUIViewController *guiViewController;

@property (nonatomic) NSMutableArray* stickers;
@property (nonatomic) NSMutableArray* filters;

@property (nonatomic) TKFilter* lastFilter;
@property (nonatomic) NSURL* movieURL;

@property (nonatomic) BOOL isTouchStickerBegan;

@end

@implementation TKCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isTouchStickerBegan = NO;
    _stickers = TKSampleDataPool.sharedInstance.stickerList;
    _filters = TKSampleDataPool.sharedInstance.filterList;

#if ENDABLE_CAMERA
    _tikkyEngine = TikkyEngine.sharedInstance;
    _tikkyEngine.stickerPreviewer.delegate = self;
    _imageInput = _tikkyEngine.imageFilter.input;
#endif
    
//    [(TKCamera *)_imageInput swapCamera];
    
    _facialStickers = (std::vector<std::vector<TKSticker>>*)TKSampleDataPool.sharedInstance.facialStickers;
    _frameStickers = (std::vector<std::vector<TKSticker>>*)TKSampleDataPool.sharedInstance.frameStickers;
    
    [self setUpUI];
    [self.view setMultipleTouchEnabled:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(editViewControllerWillDismiss:)
                                                 name:kEditViewControllerWillDismiss
                                               object:nil];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
#if ENDABLE_CAMERA
    [((TKCamera *)_imageInput) startCameraCapture];
#endif
    
    // <!-- Test FB SDK
#if ENDABLE_FB_SHARE_TEST
    NSString* url = [NSBundle.mainBundle pathForResource:@"tonystark" ofType:@"png"];

    UIImage* img = [UIImage imageWithContentsOfFile:url];

    [TKSNFacebookSDK.sharedInstance sharePhotoWithPhoto:@[img]
                                              caption:@"Test caption"
                                        userGenerated:YES
                                        hashtagString:@"Tikky"
                                 showedViewController:self
                                             delegate:nil];
#endif
    // Test FB SDK -->
    
#if ENDABLE_CAMERA
    static BOOL isSetupAudio = true;
    if (!isSetupAudio) {
        // Record video setup
        NSString* pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/TIKKY.mp4"];
        unlink([pathToMovie UTF8String]);
        _movieURL = [NSURL fileURLWithPath:pathToMovie];
        [((TKCamera *)_imageInput) prepareVideoWriterWithURL:_movieURL size:CGSizeMake(720, 1280)];
        [((TKCamera *)_imageInput) setEnableAudioForVideoRecording:YES];
        isSetupAudio = YES;
    }
    
    TKFilter* filter = [[TKFilter alloc] initWithName:@"BEAUTY"];
    [_tikkyEngine.imageFilter replaceFilter:nil withFilter:filter addNewFilterIfNotExist:YES];
#endif
    
    // <!-- Test capture
#if ENDABLE_STICKER_TEST
    long rand1 = (long)arc4random_uniform((unsigned int)_frameStickers->size());
    long rand2 = (long)arc4random_uniform((unsigned int)_facialStickers->size());
    [_tikkyEngine.stickerPreviewer newFrameStickerWithStickers:_frameStickers->at(rand1)];
    [_tikkyEngine.stickerPreviewer newFacialStickerWithStickers:_facialStickers->at(rand2)];
#endif
//    Delay 4 seconds
//    __weak __typeof(self)weakSelf = self;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [weakSelf capturePhoto];
//    });
    // Test capture -->
    
    // Delay 2 seconds
//    __weak __typeof(self)weakSelf = self;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [((TKPhoto*)weakSelf.imageInput) processImageWithCompletionHandler:nil];
//    });
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
#if ENDABLE_CAMERA
    if ([_imageInput isKindOfClass:TKCamera.class]) {
        [((TKCamera *)_imageInput) stopCameraCapture];
    }
#endif
}

- (void)editViewControllerWillDismiss:(NSNotification *)notification {
    if (self.view != _tikkyEngine.view.superview) {
        [self.view addSubview:_tikkyEngine.view];
        [_tikkyEngine.imageFilter setInput:_imageInput];
        [_tikkyEngine.imageFilter.view setFrame:self.view.frame];
    }
    
    if ([_imageInput isKindOfClass:TKCamera.class]) {
#if ENDABLE_CAMERA
        [((TKCamera *)_imageInput) startCameraCapture];
#endif
    } else if ([_imageInput isKindOfClass:TKPhoto.class]) {
        [(TKPhoto *)_imageInput processImageWithCompletionHandler:nil];
    }
}

-(void)setUpUI {
    [self.view addSubview:_tikkyEngine.view];
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapStickerPreviewerView:)];
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setNumberOfTouchesRequired:1];
#if ENDABLE_CAMERA
    [_tikkyEngine.stickerPreviewer.view addGestureRecognizer:tapGesture];
#endif
    
    _guiViewController =[[GUIViewController alloc] init];
    _guiViewController.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_guiViewController.view];
    _guiViewController.cameraController = self;
}

- (void)capturePhoto {
    cocos2d::Director::getInstance()->pause();
    __weak __typeof(self)weakSelf = self;
    [((TKCamera *)_imageInput) capturePhotoAsJPEGWithCompletionHandler:^(NSData *processedJPEG, NSError *error) {
        cocos2d::Director::getInstance()->resume();
        [TKGalleryUtilities saveImageToGalleryWithImage:[UIImage imageWithData:processedJPEG]];
    }];
}


// For ios6, use supportedInterfaceOrientations & shouldAutorotate instead
#ifdef __IPHONE_6_0
- (NSUInteger) supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
#endif

- (BOOL)shouldAutorotate {
    return YES;
}

//fix not hide status on ios7
- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark -
#pragma mark TKStickerPreviewerDelegate

- (void)onEditStickerBegan {
    [_rootView.bottomMenuView setHidden:YES];
    [_rootView.topMenuView setHidden:YES];
}

- (void)onEditStickerEnded {
    [_rootView.bottomMenuView setHidden:NO];
    [_rootView.topMenuView setHidden:NO];
}

- (void)onTouchStickerBegan {
    _isTouchStickerBegan = YES;
}

#if ENDABLE_CAMERA
- (void)didTapStickerPreviewerView:(UITapGestureRecognizer *)tapGesture {
    if (tapGesture.state == UIGestureRecognizerStateEnded) {
        if (!_isTouchStickerBegan) {
            CGPoint tapPoint = [tapGesture locationInView:_tikkyEngine.imageFilter.view];
            [((TKCamera *)_imageInput) focusAtPoint:tapPoint inFrame:_tikkyEngine.imageFilter.view.bounds];
        }
        _isTouchStickerBegan = NO;
    }
}
#endif

#pragma UIStickerCollectionViewCellDelegate
- (void)cellClickWith:(NSNumber *)identifier andType:(NSString *)type {
    
}

- (void)didReverseCamera {
    [((TKCamera *)_imageInput) swapCamera];
}

#pragma TKFacialItemDelegate
-(void)didSelectFacialWithIdentifier:(NSInteger)identifier {
    NSLog(@"tap facial item! %ld", (long)identifier);
    if (identifier < 0 && identifier >= _facialStickers->size()) {
        NSLog(@"vulh > Facial stickers' identifier is out of range!!!");
        return;
    }
    [_tikkyEngine.stickerPreviewer newFacialStickerWithStickers:_facialStickers->at(identifier-1)];
}

#pragma getMenuWithMenuType


-(void)didCapturePhoto {
    NSLog(@"capture!");
    [self capturePhoto];
}

-(void)didActionVideoWithType:(CaptureButtonType)type {
    if (type == startvideo) {
        NSLog(@"start video");
    } else if (type == stopvideo) {
        NSLog(@"stop video");
    }
    
}

#pragma TKFilterItemDelegate

-(void)didSelectFilterWithIdentifier:(NSInteger)identifier {
    NSLog(@"tap filter item %ld", (long)identifier);
    if (identifier < 0 && identifier >= TKSampleDataPool.sharedInstance.orderedIndexFilterArray.count) {
        NSLog(@"vulh > Filters' identifier is out of range!!!");
        return;
    }
    NSString* filterName = [TKSampleDataPool.sharedInstance.orderedIndexFilterArray objectAtIndex:identifier-1];
    TKFilter* filter = [[TKFilter alloc] initWithName:filterName];
    [_tikkyEngine.imageFilter replaceFilter:_lastFilter withFilter:filter addNewFilterIfNotExist:YES];
    _lastFilter = filter;
}

#pragma TKStickerItemDelegate

-(void)didSelectStickerWithIdentifier:(NSInteger)identifier {
    NSLog(@"tap sticker item %ld", (long)identifier);
    if (identifier < 0 && identifier >= _frameStickers->size()) {
        NSLog(@"vulh > Static stickers' identifier is out of range!!!");
        return;
    }
    [_tikkyEngine.stickerPreviewer newStaticStickerWithPath:[_stickers objectAtIndex:identifier-1]];
}


#pragma TKFrameItemDelegate

-(void)didSelectFrameWithIdentifier:(NSInteger)identifier {
    NSLog(@"tap frame item %ld", (long)identifier);
    if (identifier < 0 && identifier >= _frameStickers->size()) {
        NSLog(@"vulh > Frame stickers' identifier is out of range!!!");
        return;
    }
    [_tikkyEngine.stickerPreviewer removeAllFrameStickers];
   [_tikkyEngine.stickerPreviewer newFrameStickerWithStickers:_frameStickers->at(identifier-1)];
}

@end
