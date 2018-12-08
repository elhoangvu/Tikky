//
//  CameraViewController.m
//  Tikky
//
//  Created by Le Hoang Vu on 12/3/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import "CameraViewController.h"
#import "TikkyEngine.h"
#import <Photos/Photos.h>

#import "TKBottomMenu.h"
#import "TKTopMenu.h"
#import "TKSampleDataPool.h"

#import "GPUImage.h"

@interface CameraViewController () <TKBottomItemDelegate>

@property (nonatomic) TikkyEngine* tikkyEngine;
@property (nonatomic) TKCamera* camera;

@property (nonatomic) TKBottomMenu *selectionBar;

@property (nonatomic) NSMutableArray* stickers;
@property (nonatomic) NSMutableArray* filters;

@property (nonatomic) TKFilter* lastFilter;
@property (nonatomic) NSURL* movieURL;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _stickers = TKSampleDataPool.sharedInstance.stickerList;
    _filters = TKSampleDataPool.sharedInstance.filterList;
    
    _tikkyEngine = TikkyEngine.sharedInstance;
    [self.view addSubview:_tikkyEngine.view];
    _camera = (TKCamera *)_tikkyEngine.imageFilter.input;
    [_camera swapCamera]; 
    
    _selectionBar = [TKBottomMenu new];
    
    TKTopMenu *navigationBar = [TKTopMenu new];
    [self.view addSubview:_selectionBar];
    _selectionBar.viewController = self;
    [self.view addSubview:navigationBar];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_camera startCameraCapture];
    
    NSString* pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/TIKKY.mp4"];
    unlink([pathToMovie UTF8String]);
    _movieURL = [NSURL fileURLWithPath:pathToMovie];
    [_camera prepareVideoWriterWithURL:_movieURL size:CGSizeMake(720, 1280)];
    [_camera setEnableAudioForVideoRecording:YES];
}

- (void)clickItem:(NSString *)nameItem {
    if ([nameItem isEqualToString:@"assert_picker"]) {

        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
            dispatch_async(dispatch_get_main_queue(), ^{

            });
        }];
    } else if ([nameItem isEqualToString:@"capture"]) {
//        [self capturePhoto];
        
        static bool isStart = NO;
        static bool isPrepare = NO;
        if (isStart == NO) {
            unlink([_movieURL.path UTF8String]);
            if (isPrepare) {
                [_camera prepareVideoWriterWithURL:_movieURL size:CGSizeMake(720, 1280)];
            } else {
                isPrepare = YES;
            }
            [_camera startVideoRecording];

            isStart = YES;
            NSLog(@">>>> HV > START RECORDING");
        } else {
            [_camera stopVideoRecording];
            isStart = NO;
            [self writeVideoToLibraryWithURL:_movieURL];
            NSLog(@">>>> HV > STOP RECORDING");
        }
    } else if ([nameItem isEqualToString:@"filter"]) {
        long rand = (long)arc4random_uniform((unsigned int)_filters.count);
        NSString* filterName = [_filters objectAtIndex:rand];
        TKFilter* filter = [[TKFilter alloc] initWithName:filterName];
        [_tikkyEngine.imageFilter replaceFilter:_lastFilter withFilter:filter addNewFilterIfNotExist:YES];
        _lastFilter = filter;
        if (!filter) {
            NSLog(@">>>> HV > filter nil");
        }
        NSLog(@">>>> HV > filter name: %@", filterName);
    } else if ([nameItem isEqualToString:@"frame"]) {
        
    } else if ([nameItem isEqualToString:@"emoji"]) {
        long rand = (long)arc4random_uniform((unsigned int)_stickers.count);
        [_tikkyEngine.stickerPreviewer newStaticStickerWithPath:[_stickers objectAtIndex:rand]];
    }
    
    
}

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
    __weak __typeof(self)weakSelf = self;
    [_tikkyEngine.imageFilter capturePhotoAsJPEGWithCompletionHandler:^(NSData *processedJPEG, NSError *error) {
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

- (BOOL) shouldAutorotate {
    return YES;
}

//fix not hide status on ios7
- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
