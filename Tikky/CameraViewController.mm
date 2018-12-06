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

@interface CameraViewController ()

@property (nonatomic) TikkyEngine* tikkyEngine;
@property (nonatomic) TKCamera* camera;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tikkyEngine = TikkyEngine.sharedInstance;
    [self.view addSubview:_tikkyEngine.view];
    _camera = (TKCamera *)_tikkyEngine.imageFilter.input;
    [_camera swapCamera];

    CGSize size = UIScreen.mainScreen.bounds.size;
    UIButton* shootButton = [[UIButton alloc] initWithFrame:(CGRectMake(0, size.height - 80, size.width, 80))];
    [shootButton setTitle:@"Shoot" forState:(UIControlStateNormal)];
    [self.view addSubview:shootButton];
    [shootButton addTarget:self action:@selector(shoot:) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)shoot:(UIButton *)sender {
    [_tikkyEngine capturePhotoAsJPEGWithCompletionHandler:^(NSData *processedJPEG, NSError *error) {
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            NSMutableArray* assets = [[NSMutableArray alloc] init];
            PHAssetChangeRequest* assetRequest;
            @autoreleasepool {
                //                CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef) processedJPEG, NULL);
                //                NSMutableData* newImageData =  [[NSMutableData alloc] init];
                //
                //                CGImageDestinationRef destination = CGImageDestinationCreateWithData((CFMutableDataRef)newImageData, CGImageSourceGetType(source), 1, nil);
                //                CGImageDestinationAddImageFromSource(destination, source, 0, (__bridge CFDictionaryRef) weakSelf.camera.currentCaptureMetadata);
                //                CGImageDestinationFinalize(destination);
                //                CFRelease(source);
                //                CFRelease(destination);
                ////
                assetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:[UIImage imageWithData:processedJPEG]];
                [assets addObject:assetRequest.placeholderForCreatedAsset];
            }

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
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            //            if (block) {
            //                block(error);
            //            }
        }];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_camera startCameraCapture];
    
    NSString* path1 = [NSBundle.mainBundle pathForResource:@"HelloWorld" ofType:@"png"];
    NSString* path2 = [NSBundle.mainBundle pathForResource:@"recyclingbin" ofType:@"png"];
    NSString* path3 = [NSBundle.mainBundle pathForResource:@"lookup_amatorka" ofType:@"png"];
    NSString* path4 = [NSBundle.mainBundle pathForResource:@"close50" ofType:@"png"];
    
    [_tikkyEngine.stickerPreviewer newStaticStickerWithPath:path1];
    [_tikkyEngine.stickerPreviewer newStaticStickerWithPath:path2];
    [_tikkyEngine.stickerPreviewer newStaticStickerWithPath:path3];
    [_tikkyEngine.stickerPreviewer newStaticStickerWithPath:path4];
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
