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

@interface TKCameraViewController () <TKBottomItemDelegate, TKStickerPreviewerDelegate, TKStickerCollectionViewCellDelegate, TKTopItemDelegate> {
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

    _tikkyEngine = TikkyEngine.sharedInstance;
    _tikkyEngine.stickerPreviewer.delegate = self;
//    [self.view addSubview:_tikkyEngine.view];
//    [self.view addSubview:_tikkyEngine.imageFilter.view];
//    
//    NSString* url = [NSBundle.mainBundle pathForResource:@"tonystark" ofType:@"png"];
//    TKPhoto* photo = [[TKPhoto alloc] initWithImage:[UIImage imageWithContentsOfFile:url]];
//    [_tikkyEngine.imageFilter setInput:photo];
    _imageInput = _tikkyEngine.imageFilter.input;
    
//    [(TKCamera *)_imageInput swapCamera];
    
    _facialStickers = (std::vector<std::vector<TKSticker>>*)TKSampleDataPool.sharedInstance.facialStickers;
    _frameStickers = (std::vector<std::vector<TKSticker>>*)TKSampleDataPool.sharedInstance.frameStickers;
    
    [self setUpUI];
    [self.view setMultipleTouchEnabled:YES];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [((TKCamera *)_imageInput) startCameraCapture];
    
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
    if ([_imageInput isKindOfClass:TKCamera.class]) {
        [((TKCamera *)_imageInput) stopCameraCapture];
    }
}


-(void)setUpUI {

//    _tikkyEngine.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_tikkyEngine.view];
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapStickerPreviewerView:)];
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setNumberOfTouchesRequired:1];
    [_tikkyEngine.stickerPreviewer.view addGestureRecognizer:tapGesture];
//    [[_tikkyEngine.view.topAnchor constraintEqualToAnchor:self.view.topAnchor] setActive:YES];
//    [[_tikkyEngine.view.leftAnchor constraintEqualToAnchor:self.view.leftAnchor] setActive:YES];
//    [[_tikkyEngine.view.rightAnchor constraintEqualToAnchor:self.view.rightAnchor] setActive:YES];
//    [[_tikkyEngine.view.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor] setActive:YES];
    
    _guiViewController = [GUIViewController new];
    _guiViewController.view.backgroundColor = [UIColor clearColor];
//    [self addChildViewController:_viewController];
    [self.view addSubview:_guiViewController.view];
    

    _guiViewController.cameraController = self;
}

- (void)clickBottomMenuItem:(NSString *)nameItem {
//    static int etouches = 0;
//    static int ftouches = 0;
//    if ([nameItem isEqualToString:@"emoji"]) {
//        etouches++;
//        [_tikkyEngine.stickerPreviewer newFacialStickerWithStickers:facialStickers[etouches%facialStickers.size()]];
//        if ([_imageInput isKindOfClass:TKPhoto.class]) {
//            [((TKPhoto*)_imageInput) processImageWithCompletionHandler:nil];
//        }
//    } else if ([nameItem isEqualToString:@"frame"]) {
//        ftouches++;
//        [_tikkyEngine.stickerPreviewer removeAllFrameStickers];
//        [_tikkyEngine.stickerPreviewer newFrameStickerWithStickers:frameStickers[ftouches%frameStickers.size()]];
//    } else if ([nameItem isEqualToString:@"photo"]) {
//        NSString* url = [NSBundle.mainBundle pathForResource:@"aquaman" ofType:@"png"];
//        TKPhoto* photo = [[TKPhoto alloc] initWithImage:[UIImage imageWithContentsOfFile:url]];
//        [_tikkyEngine.imageFilter setInput:photo];
//        _imageInput = _tikkyEngine.imageFilter.input;
//        [photo processImageWithCompletionHandler:nil];
//    } else if ([nameItem isEqualToString:@"filter"]) {
//        TKCamera* camera = [[TKCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionFront];
//        [_tikkyEngine.imageFilter setInput:camera];
//        _imageInput = _tikkyEngine.imageFilter.input;
//        [((TKCamera *)_imageInput) startCameraCapture];
//    } else if ([nameItem isEqualToString:@"capture"]) {
//        [self capturePhoto];
//    }
//    return;
    
    
//    [_tikkyEngine.stickerPreviewer removeAllFacialStickers];
    
//    [((TKPhoto*)_imageInput) processImageWithCompletionHandler:nil];
    
    if ([nameItem isEqualToString:@"photo"]) {
        CGSize screenSize = UIScreen.mainScreen.bounds.size;
        static BOOL is3x4 = NO;
        
        if (is3x4) {
            [_tikkyEngine.view setFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
            is3x4 = NO;
        } else {
            [_tikkyEngine.view setFrame:CGRectMake(0,
                                                   (screenSize.height - screenSize.width*4.0f/3.0f)/2.0f,
                                                   screenSize.width,
                                                   screenSize.width*4.0f/3.0f)];
            is3x4 = YES;
        }
    } else if ([nameItem isEqualToString:@"capture"]) {
        // capture photo
        [self capturePhoto];
    } else if ([nameItem isEqualToString:@"filter"]) {
        [self.rootView setBottomMenuViewWithBottomMenuType:FilterMenu];

//        long rand = (long)arc4random_uniform((unsigned int)_filters.count);
//        NSString* filterName = [_filters objectAtIndex:rand];
//        TKFilter* filter = [[TKFilter alloc] initWithName:filterName];
//        [_tikkyEngine.imageFilter replaceFilter:_lastFilter withFilter:filter addNewFilterIfNotExist:YES];
//        _lastFilter = filter;
//        if (!filter) {
//            NSLog(@">>>> HV > filter nil");
//        }
//        NSLog(@">>>> HV > filter name: %@", filterName);
    } else if ([nameItem isEqualToString:@"frame"]) {
        [self.rootView setBottomMenuViewWithBottomMenuType:FrameMenu];

//        long rand = (long)arc4random_uniform((unsigned int)_stickers.count);
//        [_tikkyEngine.stickerPreviewer newStaticStickerWithPath:[_stickers objectAtIndex:rand]];
    } else if ([nameItem isEqualToString:@"emoji"]) {
        [self.rootView setBottomMenuViewWithBottomMenuType:StickerMenu];
//        ((TKStickerBottomMenu *)self.rootView.bottomMenuView).stickers = [NSMutableArray new];
//        [((TKStickerBottomMenu *)self.rootView.bottomMenuView).stickers addObject:[[TKStickerModel alloc] initWithIdentifier:[[NSNumber alloc] initWithInt:1] andName:@"X mas" andType:@"sticker" andCategory:@"Xmas" andIsFromBundle:1 andThumbnailPath:@"frame-xmas-2-thumb" andPath:@"frame-xmas-2"]];
////        dispatch_async(dispatch_get_main_queue(), ^{
//            [((TKStickerBottomMenu *)self.rootView.bottomMenuView).stickerCollectionView reloadData];
//        });
 
        // Record video
//<<<<<<< ui
//        static bool isStart = NO;
//        static bool isPrepare = NO;
//        if (isStart == NO) {
//            unlink([_movieURL.path UTF8String]);
//            if (isPrepare) {
//                [_camera prepareVideoWriterWithURL:_movieURL size:CGSizeMake(720, 1280)];
//            } else {
//                isPrepare = YES;
//            }
//            double delayToStartRecording = 0.5f;
//            __weak __typeof(self)weakSelf = self;
//            dispatch_time_t startTime = dispatch_time(DISPATCH_TIME_NOW, delayToStartRecording * NSEC_PER_SEC);
//            dispatch_after(startTime, dispatch_get_main_queue(), ^(void){
//                NSLog(@">>>> HV > START RECORDING");
//
//                [weakSelf.camera startVideoRecording];
//                isStart = YES;
//            });
//        } else {
//            [_camera stopVideoRecording];
////            [_camera setEnableAudioForVideoRecording:NO];
//            isStart = NO;
//            [self writeVideoToLibraryWithURL:_movieURL];
//            NSLog(@">>>> HV > STOP RECORDING");
//        }
// =======
//         static bool isStart = NO;
//         static bool isPrepare = NO;
//         if (isStart == NO) {
//             unlink([_movieURL.path UTF8String]);
//             if (isPrepare) {
//                 [_camera prepareVideoWriterWithURL:_movieURL size:CGSizeMake(720, 1280)];
//             } else {
//                 isPrepare = YES;
//             }
//             double delayToStartRecording = 0.5f;
//             __weak __typeof(self)weakSelf = self;
//             dispatch_time_t startTime = dispatch_time(DISPATCH_TIME_NOW, delayToStartRecording * NSEC_PER_SEC);
//             dispatch_after(startTime, dispatch_get_main_queue(), ^(void){
//                 NSLog(@">>>> HV > START RECORDING");

//                 [weakSelf.camera startVideoRecording];
//                 isStart = YES;
//             });
//         } else {
//             [_camera stopVideoRecording];
// //            [_camera setEnableAudioForVideoRecording:NO];
//             isStart = NO;
//             [self writeVideoToLibraryWithURL:_movieURL];
//             NSLog(@">>>> HV > STOP RECORDING");
//         }

    }
}
//
//- (void)clickItem:(NSString *)nameItem {
//    if ([nameItem isEqualToString:@"assert_picker"]) {
//
//        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
//            dispatch_async(dispatch_get_main_queue(), ^{
//
//            });
//        }];
//    } else if ([nameItem isEqualToString:@"capture"]) {
//
//    } else if ([nameItem isEqualToString:@"filter"]) {
//
//    } else if ([nameItem isEqualToString:@"frame"]) {
//
//    } else if ([nameItem isEqualToString:@"emoji"]) {
//
//    }
//
//
//}

- (void)writeVideoToLibraryWithURL:(NSURL *)url {
    if (![url isFileURL]) {
        NSLog(@">>>> HV > URL is not the file url");
        return;
    }

    unsigned long long fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:url.path error:nil] fileSize];
    NSLog(@">>>> HV > URL is the file url with size: %llu", fileSize);
    __weak __typeof(self)weakSelf = self;
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        NSMutableArray* assets = [[NSMutableArray alloc] init];
        PHAssetChangeRequest* assetRequest;
        @autoreleasepool {
            assetRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:url];
            [assets addObject:assetRequest.placeholderForCreatedAsset];
        }
        
        [weakSelf writeAssetsToAlbum:assets];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (error) {
            NSLog(@">>>> HV > Save video failed with code: %@", error.description);
        }
    }];
}

- (void)capturePhoto {
    cocos2d::Director::getInstance()->pause();
    __weak __typeof(self)weakSelf = self;
    [((TKCamera *)_imageInput) capturePhotoAsJPEGWithCompletionHandler:^(NSData *processedJPEG, NSError *error) {
        cocos2d::Director::getInstance()->resume();
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            NSMutableArray* assets = [[NSMutableArray alloc] init];
            PHAssetChangeRequest* assetRequest;
            @autoreleasepool {
                assetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:[UIImage imageWithData:processedJPEG]];
                [assets addObject:assetRequest.placeholderForCreatedAsset];
            }
            
            [weakSelf writeAssetsToAlbum:assets];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            //            if (block) {
            //                block(error);
            //            }
            
        }];
    }];
}

- (void)writeAssetsToAlbum:(NSMutableArray *)assets {
    __block PHAssetCollectionChangeRequest* assetCollectionRequest = nil;
    PHFetchResult* result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    [result enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PHAssetCollection* collection = (PHAssetCollection*)obj;
        if ([collection isKindOfClass:[PHAssetCollection class]]) {
            if ([[collection localizedTitle] isEqualToString:@"Tikky"]) {
                assetCollectionRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection];
                [assetCollectionRequest addAssets:assets];
                *stop = YES;
            }
        }
    }];
    if (assetCollectionRequest == nil) {
        assetCollectionRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:@"Tikky"];
        [assetCollectionRequest addAssets:assets];
    }
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

#pragma mark -
#pragma mark
//<<<<<<< ui

- (void)didTapStickerPreviewerView:(UITapGestureRecognizer *)tapGesture {
    if (tapGesture.state == UIGestureRecognizerStateEnded) {
        if (!_isTouchStickerBegan) {
            CGPoint tapPoint = [tapGesture locationInView:_tikkyEngine.imageFilter.view];
            [((TKCamera *)_imageInput) focusAtPoint:tapPoint inFrame:_tikkyEngine.imageFilter.view.bounds];
        }
        _isTouchStickerBegan = NO;
    }
}

#pragma UIStickerCollectionViewCellDelegate
-(void)cellClickWith:(NSNumber *)identifier andType:(NSString *)type {
    NSLog(@"sticker!!!");
// =======

// - (void)didTapStickerPreviewerView:(UITapGestureRecognizer *)tapGesture {
//     if (tapGesture.state == UIGestureRecognizerStateEnded) {
//         if (!_isTouchStickerBegan) {
//             CGPoint tapPoint = [tapGesture locationInView:_tikkyEngine.imageFilter.view];
//             [_camera focusAtPoint:tapPoint inFrame:_tikkyEngine.imageFilter.view.bounds];
//         }
//         _isTouchStickerBegan = NO;
//     }
// >>>>>>> master
}

#pragma TKTopItemDelegate

-(void)didReverseCamera {
    NSLog(@"Change camera");
}

@end