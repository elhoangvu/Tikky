//
//  CameraViewController.m
//  Tikky
//
//  Created by Le Hoang Vu on 12/3/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import "CameraViewController.h"
#import "ViewController.h"
#import "Tikky.h"
#import <Photos/Photos.h>

#import "TKUtilities.h"
#import "TKSampleDataPool.h"

#import "GPUImage.h"

#import "TKRootView.h"

#include "cocos2d.h"

@interface CameraViewController () <TKBottomItemDelegate, TKStickerPreviewerDelegate, TKStickerCollectionViewCellDelegate> {
    std::vector<std::vector<TKSticker>> facialStickers;
    std::vector<std::vector<TKSticker>> frameStickers;
}

@property (nonatomic) TikkyEngine* tikkyEngine;
@property (nonatomic) TKImageInput* imageInput;

@property (nonatomic) TKRootView* rootView;
@property (nonatomic) ViewController *viewController;

@property (nonatomic) NSMutableArray* stickers;
@property (nonatomic) NSMutableArray* filters;

@property (nonatomic) TKFilter* lastFilter;
@property (nonatomic) NSURL* movieURL;

@property (nonatomic) BOOL isTouchStickerBegan;

@end

@implementation CameraViewController

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
//    _imageInput = _tikkyEngine.imageFilter.input;
    
//    [(TKCamera *)_imageInput swapCamera];
    
    [self setUpUI];
    [self.view setMultipleTouchEnabled:YES];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [((TKCamera *)_imageInput) startCameraCapture];
    
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


    std::vector<TKSticker> stickers1;

    NSString* fileName = [NSString stringWithFormat:@"sticker-dog-3.png"];
    NSString* luaName = [NSString stringWithFormat:@"sticker-dog-3.lua"];
    NSString* path = [NSBundle.mainBundle pathForResource:fileName ofType:nil];
    NSString* luaPath = [NSBundle.mainBundle pathForResource:luaName ofType:nil];
    TKSticker sticker11;
    sticker11.path = path.UTF8String;
    sticker11.luaComponentPath = luaPath.UTF8String;
    sticker11.allowChanges = NO;
    sticker11.neededLandmarks.push_back(30);
    sticker11.neededLandmarks.push_back(31);
    sticker11.neededLandmarks.push_back(33);
    sticker11.neededLandmarks.push_back(35);
    stickers1.push_back(sticker11);

    fileName = [NSString stringWithFormat:@"sticker-dog-1.png"];
    luaName = [NSString stringWithFormat:@"sticker-dog-1.lua"];
    path = [NSBundle.mainBundle pathForResource:fileName ofType:nil];
    luaPath = [NSBundle.mainBundle pathForResource:luaName ofType:nil];
    TKSticker sticker12;
    sticker12.path = path.UTF8String;
    sticker12.luaComponentPath = luaPath.UTF8String;
    sticker12.allowChanges = NO;
    sticker12.neededLandmarks.push_back(0);
    sticker12.neededLandmarks.push_back(6);
    sticker12.neededLandmarks.push_back(16);
    sticker12.neededLandmarks.push_back(19);

    stickers1.push_back(sticker12);

    fileName = [NSString stringWithFormat:@"sticker-dog-2.png"];
    luaName = [NSString stringWithFormat:@"sticker-dog-2.lua"];
    path = [NSBundle.mainBundle pathForResource:fileName ofType:nil];
    luaPath = [NSBundle.mainBundle pathForResource:luaName ofType:nil];
    TKSticker sticker13;
    sticker13.path = path.UTF8String;
    sticker13.luaComponentPath = luaPath.UTF8String;
    sticker13.allowChanges = NO;
    sticker13.neededLandmarks.push_back(0);
    sticker13.neededLandmarks.push_back(10);
    sticker13.neededLandmarks.push_back(16);
    sticker13.neededLandmarks.push_back(24);
    stickers1.push_back(sticker13);
    
    fileName = [NSString stringWithFormat:@"sticker-dog-4.png"];
    luaName = [NSString stringWithFormat:@"sticker-dog-4.lua"];
    path = [NSBundle.mainBundle pathForResource:fileName ofType:nil];
    luaPath = [NSBundle.mainBundle pathForResource:luaName ofType:nil];
    TKSticker sticker14;
    sticker14.path = path.UTF8String;
    sticker14.luaComponentPath = luaPath.UTF8String;
    sticker14.allowChanges = NO;
    sticker14.neededLandmarks.push_back(61);
    sticker14.neededLandmarks.push_back(63);
    sticker14.neededLandmarks.push_back(65);
    sticker14.neededLandmarks.push_back(67);
    stickers1.push_back(sticker14);

    std::vector<TKSticker> stickers2;

    fileName = [NSString stringWithFormat:@"sticker-fox-3.png"];
    luaName = [NSString stringWithFormat:@"sticker-fox-3.lua"];
    path = [NSBundle.mainBundle pathForResource:fileName ofType:nil];
    luaPath = [NSBundle.mainBundle pathForResource:luaName ofType:nil];
    TKSticker sticker21;
    sticker21.path = path.UTF8String;
    sticker21.luaComponentPath = luaPath.UTF8String;
    sticker21.allowChanges = NO;
    sticker21.neededLandmarks.push_back(30);
    sticker21.neededLandmarks.push_back(31);
    sticker21.neededLandmarks.push_back(33);
    sticker21.neededLandmarks.push_back(35);
    stickers2.push_back(sticker21);

    fileName = [NSString stringWithFormat:@"sticker-fox-1.png"];
    luaName = [NSString stringWithFormat:@"sticker-fox-1.lua"];
    path = [NSBundle.mainBundle pathForResource:fileName ofType:nil];
    luaPath = [NSBundle.mainBundle pathForResource:luaName ofType:nil];
    TKSticker sticker22;
    sticker22.path = path.UTF8String;
    sticker22.luaComponentPath = luaPath.UTF8String;
    sticker22.allowChanges = NO;
    sticker22.neededLandmarks.push_back(0);
    sticker22.neededLandmarks.push_back(6);
    sticker22.neededLandmarks.push_back(16);
    sticker22.neededLandmarks.push_back(19);

    stickers2.push_back(sticker22);

    fileName = [NSString stringWithFormat:@"sticker-fox-2.png"];
    luaName = [NSString stringWithFormat:@"sticker-fox-2.lua"];
    path = [NSBundle.mainBundle pathForResource:fileName ofType:nil];
    luaPath = [NSBundle.mainBundle pathForResource:luaName ofType:nil];
    TKSticker sticker23;
    sticker23.path = path.UTF8String;
    sticker23.luaComponentPath = luaPath.UTF8String;
    sticker23.allowChanges = NO;
    sticker23.neededLandmarks.push_back(0);
    sticker23.neededLandmarks.push_back(10);
    sticker23.neededLandmarks.push_back(16);
    sticker23.neededLandmarks.push_back(24);
    stickers2.push_back(sticker23);

    fileName = [NSString stringWithFormat:@"sticker-fox-4.png"];
    luaName = [NSString stringWithFormat:@"sticker-fox-4.lua"];
    path = [NSBundle.mainBundle pathForResource:fileName ofType:nil];
    luaPath = [NSBundle.mainBundle pathForResource:luaName ofType:nil];
    TKSticker sticker24;
    sticker24.path = path.UTF8String;
    sticker24.luaComponentPath = luaPath.UTF8String;
    sticker24.allowChanges = NO;
    sticker24.neededLandmarks.push_back(36);
    sticker24.neededLandmarks.push_back(39);
    sticker24.neededLandmarks.push_back(42);
    sticker24.neededLandmarks.push_back(45);
    stickers2.push_back(sticker24);
    
    std::vector<TKSticker> stickers3;
    fileName = [NSString stringWithFormat:@"sticker-nonla-hat.png"];
    luaName = [NSString stringWithFormat:@"sticker-nonla-hat.lua"];
    path = [NSBundle.mainBundle pathForResource:fileName ofType:nil];
    luaPath = [NSBundle.mainBundle pathForResource:luaName ofType:nil];
    TKSticker sticker31;
    sticker31.path = path.UTF8String;
    sticker31.luaComponentPath = luaPath.UTF8String;
    sticker31.allowChanges = NO;
    sticker31.neededLandmarks.push_back(0);
    sticker31.neededLandmarks.push_back(16);
    sticker31.neededLandmarks.push_back(27);
    sticker31.neededLandmarks.push_back(29);
    stickers3.push_back(sticker31);
    
    std::vector<TKSticker> stickers4;
    
    fileName = [NSString stringWithFormat:@"sticker-cat-1.png"];
    luaName = [NSString stringWithFormat:@"sticker-cat-1.lua"];
    path = [NSBundle.mainBundle pathForResource:fileName ofType:nil];
    luaPath = [NSBundle.mainBundle pathForResource:luaName ofType:nil];
    TKSticker sticker42;
    sticker42.path = path.UTF8String;
    sticker42.luaComponentPath = luaPath.UTF8String;
    sticker42.allowChanges = NO;
    sticker42.neededLandmarks.push_back(0);
    sticker42.neededLandmarks.push_back(6);
    sticker42.neededLandmarks.push_back(16);
    sticker42.neededLandmarks.push_back(19);
    
    stickers4.push_back(sticker42);
    
    fileName = [NSString stringWithFormat:@"sticker-cat-2.png"];
    luaName = [NSString stringWithFormat:@"sticker-cat-2.lua"];
    path = [NSBundle.mainBundle pathForResource:fileName ofType:nil];
    luaPath = [NSBundle.mainBundle pathForResource:luaName ofType:nil];
    TKSticker sticker43;
    sticker43.path = path.UTF8String;
    sticker43.luaComponentPath = luaPath.UTF8String;
    sticker43.allowChanges = NO;
    sticker43.neededLandmarks.push_back(0);
    sticker43.neededLandmarks.push_back(10);
    sticker43.neededLandmarks.push_back(16);
    sticker43.neededLandmarks.push_back(24);
    stickers4.push_back(sticker43);
    
    fileName = [NSString stringWithFormat:@"sticker-cat-3.png"];
    luaName = [NSString stringWithFormat:@"sticker-cat-3.lua"];
    path = [NSBundle.mainBundle pathForResource:fileName ofType:nil];
    luaPath = [NSBundle.mainBundle pathForResource:luaName ofType:nil];
    TKSticker sticker44;
    sticker44.path = path.UTF8String;
    sticker44.luaComponentPath = luaPath.UTF8String;
    sticker44.allowChanges = NO;
    sticker44.neededLandmarks.push_back(36);
    sticker44.neededLandmarks.push_back(39);
    sticker44.neededLandmarks.push_back(42);
    sticker44.neededLandmarks.push_back(45);
    stickers4.push_back(sticker44);
    
    facialStickers.push_back(stickers1);
    facialStickers.push_back(stickers2);
    facialStickers.push_back(stickers3);
    facialStickers.push_back(stickers4);
//    [_tikkyEngine.stickerPreviewer newFacialStickerWithStickers:stickers[1]];
//    NSString* filterName = [_filters lastObject];
    
    std::vector<TKSticker> fstickers1;
    for (NSInteger i = 0; i < 12; i++) {
        NSString* fileName = [NSString stringWithFormat:@"frame-flower-shakura-%ld.png", (long)i];
        NSString* luaName = [NSString stringWithFormat:@"frame-flower-shakura-%ld.lua", (long)i];
        NSString* path = [NSBundle.mainBundle pathForResource:fileName ofType:nil];
        NSString* luaPath = [NSBundle.mainBundle pathForResource:luaName ofType:nil];
        TKSticker fsticker;
        fsticker.path = path.UTF8String;
        fsticker.luaComponentPath = luaPath.UTF8String;
        fsticker.allowChanges = NO;
        fstickers1.push_back(fsticker);
    }
    
    std::vector<TKSticker> fstickers2;
    for (NSInteger i = 0; i < 3; i++) {
        NSString* fileName = [NSString stringWithFormat:@"frame-lotus-%ld.png", (long)i];
        NSString* luaName = [NSString stringWithFormat:@"frame-lotus-%ld.lua", (long)i];
        NSString* path = [NSBundle.mainBundle pathForResource:fileName ofType:nil];
        NSString* luaPath = [NSBundle.mainBundle pathForResource:luaName ofType:nil];
        TKSticker fsticker;
        fsticker.path = path.UTF8String;
        fsticker.luaComponentPath = luaPath.UTF8String;
        fsticker.allowChanges = NO;
        fstickers2.push_back(fsticker);
    }
    
    std::vector<TKSticker> fstickers3;
    for (NSInteger i = 0; i < 2; i++) {
        NSString* fileName = [NSString stringWithFormat:@"frame-leaves-%ld.png", (long)i];
        NSString* luaName = [NSString stringWithFormat:@"frame-leaves-%ld.lua", (long)i];
        NSString* path = [NSBundle.mainBundle pathForResource:fileName ofType:nil];
        NSString* luaPath = [NSBundle.mainBundle pathForResource:luaName ofType:nil];
        TKSticker fsticker;
        fsticker.path = path.UTF8String;
        fsticker.luaComponentPath = luaPath.UTF8String;
        fsticker.allowChanges = NO;
        fstickers3.push_back(fsticker);
    }
    frameStickers.push_back(fstickers1);
    frameStickers.push_back(fstickers2);
    frameStickers.push_back(fstickers3);
    
    TKFilter* filter = [[TKFilter alloc] initWithName:@"BEAUTY"];
    [_tikkyEngine.imageFilter replaceFilter:nil withFilter:filter addNewFilterIfNotExist:YES];
    
    // Delay 2 seconds
    __weak __typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [((TKPhoto*)weakSelf.imageInput) processImageWithCompletionHandler:nil];
    });
    
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
    
    _viewController = [ViewController new];
    _viewController.view.backgroundColor = [UIColor clearColor];
    [self addChildViewController:_viewController];
    [self.view addSubview:_viewController.view];
}

- (void)clickBottomMenuItem:(NSString *)nameItem {
    static int etouches = 0;
    static int ftouches = 0;
    if ([nameItem isEqualToString:@"emoji"]) {
        etouches++;
        [_tikkyEngine.stickerPreviewer newFacialStickerWithStickers:facialStickers[etouches%facialStickers.size()]];
        if ([_imageInput isKindOfClass:TKPhoto.class]) {
            [((TKPhoto*)_imageInput) processImageWithCompletionHandler:nil];
        }
    } else if ([nameItem isEqualToString:@"frame"]) {
        ftouches++;
        [_tikkyEngine.stickerPreviewer removeAllFrameStickers];
        [_tikkyEngine.stickerPreviewer newFrameStickerWithStickers:frameStickers[ftouches%frameStickers.size()]];
    } else if ([nameItem isEqualToString:@"photo"]) {
        NSString* url = [NSBundle.mainBundle pathForResource:@"aquaman" ofType:@"png"];
        TKPhoto* photo = [[TKPhoto alloc] initWithImage:[UIImage imageWithContentsOfFile:url]];
        [_tikkyEngine.imageFilter setInput:photo];
        _imageInput = _tikkyEngine.imageFilter.input;
        [photo processImageWithCompletionHandler:nil];
    } else if ([nameItem isEqualToString:@"filter"]) {
        TKCamera* camera = [[TKCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionFront];
        [_tikkyEngine.imageFilter setInput:camera];
        _imageInput = _tikkyEngine.imageFilter.input;
        [((TKCamera *)_imageInput) startCameraCapture];
    }
    return;
    
    
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

@end
