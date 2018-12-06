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
//#import <CTAssetsPickerController.h>

@interface CameraViewController () <TKBottomItemDelegate>
//@interface CameraViewController () <TKBottomItemDelegate, CTAssetsPickerControllerDelegate>

@property (nonatomic) TikkyEngine* tikkyEngine;
@property (nonatomic) TKCamera* camera;

@property (nonatomic, strong) TKBottomMenu *selectionBar;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tikkyEngine = TikkyEngine.sharedInstance;
    [self.view addSubview:_tikkyEngine.view];
    _camera = (TKCamera *)_tikkyEngine.imageFilter.input;
    [_camera swapCamera];
    
    //    CGSize size = UIScreen.mainScreen.bounds.size;
    //    UIButton* shootButton = [[UIButton alloc] initWithFrame:(CGRectMake(0, size.height - 80, size.width, 80))];
    //    [shootButton setTitle:@"Shoot" forState:(UIControlStateNormal)];
    //    [self.view addSubview:shootButton];
    //    [shootButton addTarget:self action:@selector(shoot:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    _selectionBar = [TKBottomMenu new];
    
    TKTopMenu *navigationBar = [TKTopMenu new];
    [self.view addSubview:_selectionBar];
    _selectionBar.viewController = self;
    [self.view addSubview:navigationBar];
    
}


- (void)clickItem:(NSString *)nameItem {
    if ([nameItem isEqualToString:@"assert_picker"]) {
        __weak typeof(self)weakSelf = self;
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //                // init picker
                //                CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
                //
                //                // set delegate
                //                picker.delegate = weakSelf;
                //
                //                // Optionally present picker as a form sheet on iPad
                //                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                //                    picker.modalPresentationStyle = UIModalPresentationFullScreen;
                //                else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                //                    picker.modalPresentationStyle = UIModalPresentationFullScreen;
                //                }
                //
                //                // present picker
                //                [self presentViewController:picker animated:YES completion:nil];
            });
        }];
    } else if ([nameItem isEqualToString:@"capture"]) {
        [self shoot:nil];
    } else if ([nameItem isEqualToString:@"filter"]) {
        
    } else if ([nameItem isEqualToString:@"frame"]) {
        
    } else if ([nameItem isEqualToString:@"emoji"]) {
        
    }
    
    
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
