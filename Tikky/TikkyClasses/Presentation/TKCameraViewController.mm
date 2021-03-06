//
//  CameraViewController.m
//  Tikky
//
//  Created by Le Hoang Vu on 12/3/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import "TKCameraViewController.h"

#import "Tikky.h"

#import <Photos/Photos.h>

#import "TKUtilities.h"

#import "TKSampleDataPool.h"

#import "GPUImage.h"

#include "cocos2d.h"

#import "TKSNFacebookSDK.h"

#import "FeatureDefinition.h"

#import "TKDefinition.h"

#import "TKNotification.h"

#import "TKGalleryUtilities.h"

#import "TKCameraGUIView.h"

#import "TKEditorViewController.h"

#import "TKStickerEntity.h"

#import "TKNotificationViewController.h"

@interface TKCameraViewController ()
<
TKStickerPreviewerDelegate,
TKCameraGUIViewDelegate,
TKEditorViewControllerDelegate,
TKNotificationViewControllerDelegate
> {
    std::vector<std::vector<TKSticker>>* _facialStickers;
    std::vector<std::vector<TKSticker>>* _frameStickers;
}

@property (nonatomic) TikkyEngine* tikkyEngine;
@property (nonatomic) TKImageInput* imageInput;

@property (nonatomic) NSMutableArray* stickers;
@property (nonatomic) NSMutableArray* filters;

@property (nonatomic) TKFilter* lastFilter;
@property (nonatomic) NSURL* movieURL;

@property (nonatomic) BOOL isTouchStickerBegan;

@property (nonatomic) TKCameraGUIView* cameraGUIView;

@property (nonatomic) TKEditorViewController* editorVC;

@property (nonatomic) dispatch_group_t cameraPermissionGroup;

@property (nonatomic) TKNotificationViewController* notificationVC;

@property (nonatomic) BOOL isEditing;

@property (nonatomic) CGAffineTransform lastCameraTransform;

@property (nonatomic) UIDeviceOrientation lastCameraOrientation;

@end

@implementation TKCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;

    _isEditing = NO;
    _isTouchStickerBegan = NO;
    _cameraPermissionGroup = dispatch_group_create();
    
#if ENABLE_CAMERA
    _tikkyEngine = TikkyEngine.sharedInstance;
    _tikkyEngine.stickerPreviewer.delegate = self;
    _imageInput = _tikkyEngine.imageFilter.input;
#endif
    
//    [(TKCamera *)_imageInput swapCamera];
    
//    _facialStickers = (std::vector<std::vector<TKSticker>>*)TKSampleDataPool.sharedInstance.facialStickers;
//    _frameStickers = (std::vector<std::vector<TKSticker>>*)TKSampleDataPool.sharedInstance.frameStickers;
    
    [self setUpUI];
    TKFilter* filter = [[TKFilter alloc] initWithName:@"BEAUTY"];
    [_tikkyEngine.imageFilter replaceFilter:nil withFilter:filter addNewFilterIfNotExist:YES];
    [self.view setMultipleTouchEnabled:YES];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    __weak __typeof(self)weakSelf = self;
    
//    dispatch_group_enter(_cameraPermissionGroup);
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                if (weakSelf.notificationVC) {
                    [weakSelf.notificationVC dismissViewControllerAnimated:YES completion:nil];
                }
                //            dispatch_group_leave(weakSelf.cameraPermissionGroup);
            } else {
                weakSelf.notificationVC = [[TKNotificationViewController alloc] init];
                weakSelf.notificationVC.topTitle = @"Active your phone's camera";
                weakSelf.notificationVC.type = TKNotificationTypeFailture;
                weakSelf.notificationVC.leftButtonName = @"Setting";
                weakSelf.notificationVC.subTitle = @"Go to Setting\nto enable camera permission.";
                weakSelf.notificationVC.contentSize = CGSizeMake(self.view.frame.size.width*0.6, self.view.frame.size.height*0.45);
                
                weakSelf.notificationVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                weakSelf.notificationVC.delegate = self;
                [weakSelf presentViewController:weakSelf.notificationVC animated:NO completion:nil];
            }
        });
        
    }];
//    dispatch_group_wait(_cameraPermissionGroup, DISPATCH_TIME_FOREVER);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

#if ENABLE_CAMERA
    if ([_imageInput isKindOfClass:TKCamera.class]) {
        [((TKCamera *)_imageInput) startCameraCapture];
    }
#endif
    
#if ENABLE_FACIAL_STICKER_TEST
    NSArray* faces = [TKDataAdapter.sharedIntance loadAllFacialStickers];
    TKFaceStickerEntity* entity = [faces objectAtIndex:0];
    
    std::vector<TKSticker>* facialStickers = (std::vector<TKSticker> *)entity.facialSticker;
    [TikkyEngine.sharedInstance.stickerPreviewer newFacialStickerWithStickers:*facialStickers];
#endif
    
    // <!-- Test FB SDK
#if ENABLE_FB_SHARE_TEST
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
    
#if ENABLE_CAMERA
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
    
#endif
    
    // <!-- Test capture
#if ENABLE_STICKER_TEST
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

- (void)didTapLeftButtonWithNotificationViewController:(TKNotificationViewController *)notificationVC {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

- (void)didTapRightButtonWithNotificationViewController:(TKNotificationViewController *)notificationVC {
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
#if ENABLE_CAMERA
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
#if ENABLE_CAMERA
        [((TKCamera *)_imageInput) startCameraCapture];
#endif
    } else if ([_imageInput isKindOfClass:TKPhoto.class]) {
        [(TKPhoto *)_imageInput processImageWithCompletionHandler:nil];
    }
}

-(void)setUpUI {
    [self.view addSubview:_tikkyEngine.view];
    [_tikkyEngine.view setFrame:UIScreen.mainScreen.bounds];
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapStickerPreviewerView:)];
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setNumberOfTouchesRequired:1];
#if ENABLE_CAMERA
    [_tikkyEngine.stickerPreviewer.view addGestureRecognizer:tapGesture];
#endif
    
    _cameraGUIView = [[TKCameraGUIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    _cameraGUIView.delegate = self;
    [self.view addSubview:_cameraGUIView];
}

- (void)capturePhoto {
    [_tikkyEngine.stickerPreviewer pause];
 
    __weak __typeof(self)weakSelf = self;
    [((TKCamera *)_imageInput) capturePhotoAsJPEGWithCompletionHandler:^(NSData *processedJPEG, NSError *error) {
        [weakSelf.tikkyEngine.stickerPreviewer resume];
        [TKGalleryUtilities saveImageToGalleryWithImage:[UIImage imageWithData:processedJPEG]];
    }];
}
- (BOOL)shouldAutorotate {
    return YES;
}

//fix not hide status on ios7
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    if (_isEditing) {
        return;
    }
    [_tikkyEngine.view setHidden:NO];
    UIInterfaceOrientation orientation = UIInterfaceOrientationPortrait;
    CGSize currentSize = self.view.bounds.size;
    if (currentSize.width < size.width)
        orientation = UIInterfaceOrientationLandscapeLeft;
    
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wdeprecated-declarations"
//    [self willRotateToInterfaceOrientation:orientation duration:coordinator.transitionDuration];
//#pragma clang diagnostic pop
    __weak typeof(self) weakSelf = self;
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        CGAffineTransform deltaTransform = coordinator.targetTransform;
        CGFloat deltaAngle = atan2f(deltaTransform.b, deltaTransform.a);
        
        CGFloat currentRotation = [[weakSelf.tikkyEngine.view.layer valueForKeyPath:@"transform.rotation.z"] floatValue];
        
        
        // Adding a small value to the rotation angle forces the animation to occur in a the desired direction, preventing an issue where the view would appear to rotate 2PI radians during a rotation from LandscapeRight -> LandscapeLeft.
        currentRotation += -1 * deltaAngle + 0.0001;
        
        [weakSelf.tikkyEngine.view.layer setValue:@(currentRotation) forKeyPath:@"transform.rotation.z"];
//        [weakSelf.cameraGUIView.layer setValue:@(currentRotation) forKey:@"transform.rotation.z"];
        
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wdeprecated-declarations"
//        [self willAnimateRotationToInterfaceOrientation:orientation duration:coordinator.transitionDuration];
//#pragma clang diagnostic pop
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        // Integralize the transform to undo the extra 0.0001 added to the rotation angle.
        CGAffineTransform currentTransform = weakSelf.tikkyEngine.view.transform;
        
        currentTransform.a = round(currentTransform.a);
        currentTransform.b = round(currentTransform.b);
        currentTransform.c = round(currentTransform.c);
        currentTransform.d = round(currentTransform.d);
        weakSelf.tikkyEngine.view.transform = currentTransform;
        weakSelf.cameraGUIView.transform = currentTransform;
        weakSelf.lastCameraTransform = currentTransform;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [self didRotateFromInterfaceOrientation:orientation];
#pragma clang diagnostic pop
        
    }];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    if (_isEditing) {
        return;
    }
    
    static BOOL isFirstLayout = YES;

    self.tikkyEngine.view.center = CGPointMake(CGRectGetMidX(UIScreen.mainScreen.bounds), CGRectGetMidY(UIScreen.mainScreen.bounds));
    self.cameraGUIView.center = CGPointMake(CGRectGetMidX(UIScreen.mainScreen.bounds), CGRectGetMidY(UIScreen.mainScreen.bounds));
    if (isFirstLayout) {
        CGFloat rotation = 0;
        if (UIDevice.currentDevice.orientation == UIDeviceOrientationLandscapeLeft) {
            rotation = -1.5706963705062866;
        } else if (UIDevice.currentDevice.orientation == UIDeviceOrientationLandscapeRight) {
            rotation = 1.5706963705062866;
        } else {
            isFirstLayout = NO;
            return;
        }

        [self.tikkyEngine.view.layer setValue:@(rotation) forKeyPath:@"transform.rotation.z"];
        [self.cameraGUIView.layer setValue:@(rotation) forKey:@"transform.rotation.z"];
        CGAffineTransform currentTransform = self.tikkyEngine.view.transform;

        currentTransform.a = round(currentTransform.a);
        currentTransform.b = round(currentTransform.b);
        currentTransform.c = round(currentTransform.c);
        currentTransform.d = round(currentTransform.d);
        self.tikkyEngine.view.transform = currentTransform;
        self.cameraGUIView.transform = currentTransform;
    }
    isFirstLayout = NO;
}


#pragma mark -
#pragma mark TKStickerPreviewerDelegate

- (void)onEditStickerBegan {

}

- (void)onEditStickerEnded {

}

- (void)onTouchStickerBegan {
    _isTouchStickerBegan = YES;
}

#if ENABLE_CAMERA
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
    if (identifier < 0 && identifier >= _facialStickers->size()) {
        NSLog(@"vulh > Facial stickers' identifier is out of range!!!");
        return;
    }
    [_tikkyEngine.stickerPreviewer newFacialStickerWithStickers:_facialStickers->at(identifier-1)];
}

-(void)didDeselectFacialWithIdentifier:(NSInteger)identifier {
    NSLog(@"deselect facial");

}

#pragma getMenuWithMenuType


-(void)didCapturePhoto {
    NSLog(@"capture!");
    [self capturePhoto];
}

#pragma TKFilterItemDelegate

-(void)didSelectFilterWithIdentifier:(NSInteger)identifier {
//    if (identifier < 0 && identifier >= TKSampleDataPool.sharedInstance.orderedIndexFilterArray.count) {
//        NSLog(@"vulh > Filters' identifier is out of range!!!");
//        return;
//    }
//    NSString* filterName = [TKSampleDataPool.sharedInstance.orderedIndexFilterArray objectAtIndex:identifier-1];
//    TKFilter* filter = [[TKFilter alloc] initWithName:filterName];
//    [_tikkyEngine.imageFilter replaceFilter:_lastFilter withFilter:filter addNewFilterIfNotExist:YES];
//    _lastFilter = filter;
}

-(void)didDeselectFilterWithIdentifier:(NSInteger)identifier {
    NSLog(@"deselect filter");

}

#pragma TKStickerItemDelegate

-(void)didSelectStickerWithIdentifier:(NSInteger)identifier {
    if (identifier < 0 && identifier >= _frameStickers->size()) {
        NSLog(@"vulh > Static stickers' identifier is out of range!!!");
        return;
    }
    [_tikkyEngine.stickerPreviewer newStaticStickerWithPath:[_stickers objectAtIndex:identifier-1]];
}

-(void)didDeselectStickerWithIdentifier:(NSInteger)identifier {
    
}


#pragma TKFrameItemDelegate

-(void)didSelectFrameWithIdentifier:(NSInteger)identifier {
    if (identifier < 0 && identifier >= _frameStickers->size()) {
        NSLog(@"vulh > Frame stickers' identifier is out of range!!!");
        return;
    }
    [_tikkyEngine.stickerPreviewer removeAllFrameStickers];
   [_tikkyEngine.stickerPreviewer newFrameStickerWithStickers:_frameStickers->at(identifier-1)];
}

-(void)didDeselectFrameWithIdentifier:(NSInteger)identifier {
    NSLog(@"deselect frame");

}

#pragma mark - TKCameraGUIViewDelegate

- (void)didTapCaptureButtonInCameraGUIView:(TKCameraGUIView *)cameraGUIView {
    static BOOL shouldCapture = YES;
    if (shouldCapture) {
        shouldCapture = NO;
        [_tikkyEngine.stickerPreviewer pause];
        
        __weak __typeof(self)weakSelf = self;
        [((TKCamera *)_imageInput) capturePhotoAsJPEGWithCompletionHandler:^(NSData *processedJPEG, NSError *error) {
            [((TKCamera *)weakSelf.imageInput) stopCameraCapture];
//            [weakSelf.tikkyEngine.stickerPreviewer resume];
            [weakSelf.tikkyEngine.imageFilter removeAllFilter];
            if (processedJPEG) {
                UIImage* image = [UIImage imageWithData:processedJPEG];
                TKPhoto* photo = [[TKPhoto alloc] initWithImage:image smoothlyScaleOutput:YES];
                [weakSelf.tikkyEngine.imageFilter removeAllFilter];
                [weakSelf.tikkyEngine.imageFilter setInput:photo];
                weakSelf.editorVC = [[TKEditorViewController alloc] init];
                weakSelf.isEditing = YES;
                weakSelf.lastCameraOrientation = UIDevice.currentDevice.orientation;
                [weakSelf presentViewController:weakSelf.editorVC animated:YES completion:nil];
                weakSelf.editorVC.delegate = self;
            }
            shouldCapture = YES;
    //        [TKGalleryUtilities saveImageToGalleryWithImage:[UIImage imageWithData:processedJPEG]];
        }];
    }
}

- (void)didTapSwapButtonInCameraGUIView:(TKCameraGUIView *)cameraGUIView {
    [((TKCamera *)_imageInput) swapCamera];
}

- (void)didTapCloseButtonAtEditorViewController:(TKEditorViewController *)editorVC {
     _isEditing = NO;
    [TikkyEngine.sharedInstance.stickerPreviewer pause];

    [self.view addSubview:_tikkyEngine.view];
    [self.view sendSubviewToBack:_tikkyEngine.view];
    
    CGRect cameraFrame = UIScreen.mainScreen.bounds;
//    if (orientation != _lastCameraOrientation
//        && ((orientation != UIDeviceOrientationLandscapeRight && _lastCameraOrientation != UIDeviceOrientationLandscapeLeft)
//            || (orientation != UIDeviceOrientationLandscapeLeft && _lastCameraOrientation != UIDeviceOrientationLandscapeRight))) {
//
//        CGFloat cWidth = cameraFrame.size.width;
//        cameraFrame.size.width = cameraFrame.size.height;
//        cameraFrame.size.height = cWidth;
//    }
    
    [_tikkyEngine.view setFrame:cameraFrame];
    
    _editorVC = nil;
    [_tikkyEngine.imageFilter setInput:_imageInput];
    [_tikkyEngine.imageFilter removeAllFilter];
    [_tikkyEngine.stickerPreviewer removeAllFrameStickers];
    [_tikkyEngine.stickerPreviewer removeAllFacialStickers];
    [_tikkyEngine.stickerPreviewer removeAllStaticStickers];
    if ([_imageInput isKindOfClass:TKCamera.class]) {
        [(TKCamera *)_imageInput startCameraCapture];
    }
    TKFilter* filter = [[TKFilter alloc] initWithName:@"BEAUTY"];
    [_tikkyEngine.imageFilter replaceFilter:nil withFilter:filter addNewFilterIfNotExist:YES];
    CGAffineTransform zeroTransform = CGAffineTransformMake(0, 0, 0, 0, 0, 0);
    if (!CGAffineTransformEqualToTransform(zeroTransform, _lastCameraTransform)) {
        _tikkyEngine.view.transform = _lastCameraTransform;
    }
    
    UIDeviceOrientation orientation = UIDevice.currentDevice.orientation;
    if ((_lastCameraOrientation == UIDeviceOrientationLandscapeRight || _lastCameraOrientation == UIDeviceOrientationLandscapeLeft)
        && (orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown)) {
        [_tikkyEngine.view setHidden:YES];
    }
//    [TikkyEngine.sharedInstance.stickerPreviewer resume];
}

- (void)didTapBeautyButtonInCameraGUIView:(TKCameraGUIView *)cameraGUIView isOnMode:(BOOL)isOnMode {
    if (isOnMode) {
        TKFilter* filter = [[TKFilter alloc] initWithName:@"BEAUTY"];
        [_tikkyEngine.imageFilter replaceFilter:nil withFilter:filter addNewFilterIfNotExist:YES];
    } else {
        [_tikkyEngine.imageFilter removeAllFilter];
    }
}

- (void)didTapFlashButtonInCameraGUIView:(TKCameraGUIView *)cameraGUIView withMode:(AVCaptureFlashMode)mode {
    if ([_imageInput isKindOfClass:TKCamera.class]) {
        TKCamera* camera = (TKCamera *)_imageInput;
        [camera setFlashMode:mode];
    }
}

- (void)didTapInCameraGUIView:(TKCameraGUIView *)cameraGUIView atPoint:(CGPoint)point {
    if ([_imageInput isKindOfClass:TKCamera.class]) {
        TKCamera* camera = (TKCamera *)_imageInput;
        [camera focusAtPoint:point inFrame:cameraGUIView.frame];
    }
}

@end
