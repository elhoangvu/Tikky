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

@interface CameraViewController () <TKBottomItemDelegate, TKStickerPreviewerDelegate, TKStickerCollectionViewCellDelegate>

@property (nonatomic) TikkyEngine* tikkyEngine;
@property (nonatomic) TKCamera* camera;

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
    
    _camera = (TKCamera *)_tikkyEngine.imageFilter.input;
//    [_camera swapCamera];
    
    [self setUpUI];
    [self.view setMultipleTouchEnabled:YES];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_camera startCameraCapture];
    
    static BOOL isSetupAudio = false;
    if (!isSetupAudio) {
        // Record video setup
        NSString* pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/TIKKY.mp4"];
        unlink([pathToMovie UTF8String]);
        _movieURL = [NSURL fileURLWithPath:pathToMovie];
        [_camera prepareVideoWriterWithURL:_movieURL size:CGSizeMake(720, 1280)];
        [_camera setEnableAudioForVideoRecording:YES];
        isSetupAudio = YES;
    }
    
//    NSString* top = [NSBundle.mainBundle pathForResource:@"frames-xmas-5-top.png" ofType:nil];
//    NSString* bot = [NSBundle.mainBundle pathForResource:@"frames-xmas-5-bot.png" ofType:nil];
//    [_tikkyEngine.stickerPreviewer newFrameStickerWith2PartTopBot:top bottomFramePath:bot];
    
    std::vector<TKSticker> stickers;
//    for (NSInteger i = 0; i < 12; i++) {
//        NSString* fileName = [NSString stringWithFormat:@"frame-flower-shakura-%ld.png", (long)i];
//        NSString* luaName = [NSString stringWithFormat:@"frame-flower-shakura-%ld.lua", (long)i];
//        NSString* path = [NSBundle.mainBundle pathForResource:fileName ofType:nil];
//        NSString* luaPath = [NSBundle.mainBundle pathForResource:luaName ofType:nil];
//        TKSticker sticker;
//        sticker.path = path.UTF8String;
//        sticker.luaComponentPath = luaPath.UTF8String;
//        sticker.allowChanges = NO;
//        stickers.push_back(sticker);
//    }
//    [_tikkyEngine.stickerPreviewer newFrameStickerWithStickers:stickers];
    
    NSString* fileName = [NSString stringWithFormat:@"sticker-dog-3.png"];
    NSString* luaName = [NSString stringWithFormat:@"sticker-dog-3.lua"];
    NSString* path = [NSBundle.mainBundle pathForResource:fileName ofType:nil];
    NSString* luaPath = [NSBundle.mainBundle pathForResource:luaName ofType:nil];
    TKSticker sticker;
    sticker.path = path.UTF8String;
    sticker.luaComponentPath = luaPath.UTF8String;
    sticker.allowChanges = NO;
    sticker.neededLandmarks.push_back(30);
    sticker.neededLandmarks.push_back(31);
    sticker.neededLandmarks.push_back(33);
    sticker.neededLandmarks.push_back(35);
    stickers.push_back(sticker);
    
    fileName = [NSString stringWithFormat:@"sticker-dog-1.png"];
    luaName = [NSString stringWithFormat:@"sticker-dog-1.lua"];
    path = [NSBundle.mainBundle pathForResource:fileName ofType:nil];
    luaPath = [NSBundle.mainBundle pathForResource:luaName ofType:nil];
    TKSticker sticker2;
    sticker2.path = path.UTF8String;
    sticker2.luaComponentPath = luaPath.UTF8String;
    sticker2.allowChanges = NO;
    sticker2.neededLandmarks.push_back(0);
    sticker2.neededLandmarks.push_back(10);
    sticker2.neededLandmarks.push_back(16);
    sticker2.neededLandmarks.push_back(24);
    stickers.push_back(sticker2);
    
    fileName = [NSString stringWithFormat:@"sticker-dog-2.png"];
    luaName = [NSString stringWithFormat:@"sticker-dog-2.lua"];
    path = [NSBundle.mainBundle pathForResource:fileName ofType:nil];
    luaPath = [NSBundle.mainBundle pathForResource:luaName ofType:nil];
    TKSticker sticker3;
    sticker3.path = path.UTF8String;
    sticker3.luaComponentPath = luaPath.UTF8String;
    sticker3.allowChanges = NO;
    sticker3.neededLandmarks.push_back(0);
    sticker3.neededLandmarks.push_back(6);
    sticker3.neededLandmarks.push_back(16);
    sticker3.neededLandmarks.push_back(19);
    stickers.push_back(sticker3);
    [_tikkyEngine.stickerPreviewer newFacialStickerWithStickers:stickers];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_camera stopCameraCapture];
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
    [_camera capturePhotoAsJPEGWithCompletionHandler:^(NSData *processedJPEG, NSError *error) {
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
            [_camera focusAtPoint:tapPoint inFrame:_tikkyEngine.imageFilter.view.bounds];
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
