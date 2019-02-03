//
//  CameraViewController.m
//  Tikky
//
//  Created by Le Hoang Vu on 12/3/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import "CameraViewController.h"
#import "Tikky.h"
#import <Photos/Photos.h>

#import "TKUtilities.h"
#import "TKSampleDataPool.h"

#import "GPUImage.h"

#import "TKRootView.h"

#include "cocos2d.h"

@interface CameraViewController () <TKBottomItemDelegate, TKStickerPreviewerDelegate, TKStickerCollectionViewCellDelegate> {
    std::vector<std::vector<TKSticker>> stickers;
}

@property (nonatomic) TikkyEngine* tikkyEngine;
@property (nonatomic) TKImageInput* imageInput;

@property (nonatomic) TKRootView* rootView;

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
    [self.view addSubview:_tikkyEngine.imageFilter.view];
    
//    NSString* url = [NSBundle.mainBundle pathForResource:@"tonystark" ofType:@"png"];
//    TKPhoto* photo = [[TKPhoto alloc] initWithImage:[UIImage imageWithContentsOfFile:url]];
//    [_tikkyEngine.imageFilter setInput:photo];
    _imageInput = _tikkyEngine.imageFilter.input;
    
//    [_camera swapCamera];
    
    [self setUpUI];
    [self.view setMultipleTouchEnabled:YES];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [((TKCamera *)_imageInput) startCameraCapture];
    
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
    
    stickers.push_back(stickers1);
    stickers.push_back(stickers2);
    [_tikkyEngine.stickerPreviewer newFacialStickerWithStickers:stickers[1]];
//    NSString* filterName = [_filters lastObject];
    TKFilter* filter = [[TKFilter alloc] initWithName:@"BEAUTY"];
    [_tikkyEngine.imageFilter replaceFilter:nil withFilter:filter addNewFilterIfNotExist:YES];
//    [((TKPhoto*)_imageInput) processImageWithCompletionHandler:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [((TKCamera *)_imageInput) stopCameraCapture];
}


-(void)setUpUI {
    _rootView = [TKRootView new];
    _rootView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_rootView];
    
    [self.rootView setBackgroundColor:[UIColor clearColor]];
    [[self.rootView.topAnchor constraintEqualToAnchor:self.view.topAnchor] setActive:YES];
    [[self.rootView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:0.0] setActive:YES];
    [[self.rootView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:1.0] setActive:YES];
    [[self.rootView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:1.0] setActive:YES];
    [self.rootView.bottomMenuView setViewController:self];
    [self.rootView.topMenuView setViewController:self];
    
//    _tikkyEngine.view.translatesAutoresizingMaskIntoConstraints = NO;
    [_rootView addSubview:_tikkyEngine.view];
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapStickerPreviewerView:)];
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setNumberOfTouchesRequired:1];
    [_tikkyEngine.stickerPreviewer.view addGestureRecognizer:tapGesture];
//    [[_tikkyEngine.view.topAnchor constraintEqualToAnchor:self.view.topAnchor] setActive:YES];
//    [[_tikkyEngine.view.leftAnchor constraintEqualToAnchor:self.view.leftAnchor] setActive:YES];
//    [[_tikkyEngine.view.rightAnchor constraintEqualToAnchor:self.view.rightAnchor] setActive:YES];
//    [[_tikkyEngine.view.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor] setActive:YES];

    [_rootView bringSubviewToFront:_rootView];
    [_rootView bringSubviewToFront:_rootView.topMenuView];
    [_rootView bringSubviewToFront:_rootView.bottomMenuView];
}

- (void)clickBottomMenuItem:(NSString *)nameItem {
    static int touches = 0;
    touches++;
    [_tikkyEngine.stickerPreviewer newFacialStickerWithStickers:stickers[touches%2]];
    return;
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
        ((TKStickerBottomMenu *)self.rootView.bottomMenuView).stickers = [NSMutableArray new];
        [((TKStickerBottomMenu *)self.rootView.bottomMenuView).stickers addObject:[[TKStickerModel alloc] initWithIdentifier:[[NSNumber alloc] initWithInt:1] andName:@"X mas" andType:@"sticker" andCategory:@"Xmas" andIsFromBundle:1 andThumbnailPath:@"frame-xmas-2-thumb" andPath:@"frame-xmas-2"]];
//        dispatch_async(dispatch_get_main_queue(), ^{
            [((TKStickerBottomMenu *)self.rootView.bottomMenuView).stickerCollectionView reloadData];
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
