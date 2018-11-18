//
//  ViewController.m
//  Tikky
//
//  Created by Le Hoang Vu on 11/10/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import "ViewController.h"

#import "Prefix.pch"
//#import "cocos2d.h"
#import "platform/ios/CCEAGLView-ios.h"
#import "Coco2dXGameController/Cocos2dXGameController.h"
#import "GPUImage.h"
#import <Photos/Photos.h>
#import "TKGLRectTextureCommand.h"
//#import <Photos/PHAsset.h>
//#import <AssetsLibrary/AssetsLibrary.h>

@interface ViewController () <Cocos2dXGameControllerDelegate>

@property (nonatomic) GPUImageStillCamera* camera;
@property (nonatomic) GPUImageView* cameraView;
@property (nonatomic) CCEAGLView* cceaglView;
@property (nonatomic) GPUImageOutput<GPUImageInput>* filter;

@property (nonatomic) EAGLSharegroup* sharegroup;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    _sharegroup = [[EAGLSharegroup alloc] init];
//    [[GPUImageContext sharedImageProcessingContext] useSharegroup:_sharegroup];
    _sharegroup = [[[GPUImageContext sharedImageProcessingContext] context] sharegroup];
    
    _camera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionBack];
    _camera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    _filter = [[GPUImageAmatorkaFilter alloc] init];
    CGRect rect = CGRectMake(UIScreen.mainScreen.bounds.origin.x,
                             UIScreen.mainScreen.bounds.origin.y,
                             UIScreen.mainScreen.bounds.size.width,
                             UIScreen.mainScreen.bounds.size.height);
    _cameraView = [[GPUImageView alloc] initWithFrame:rect];
    [_camera addTarget:_filter];
    [_filter addTarget:_cameraView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    CGRect rect = CGRectMake(UIScreen.mainScreen.bounds.origin.x,
//                             UIScreen.mainScreen.bounds.origin.y + UIScreen.mainScreen.bounds.size.height/2.0f,
//                             UIScreen.mainScreen.bounds.size.width/2.0f,
//                             UIScreen.mainScreen.bounds.size.height/2.0f);
    CGRect rect = CGRectMake(UIScreen.mainScreen.bounds.origin.x,
                             UIScreen.mainScreen.bounds.origin.y,
                             UIScreen.mainScreen.bounds.size.width,
                             UIScreen.mainScreen.bounds.size.height);
    Cocos2dXGameController *gameController = [[Cocos2dXGameController alloc] initWithFrame:rect sharegroup:_sharegroup];
    gameController.delegate = self;
    _cceaglView = (CCEAGLView *)gameController.view;
    
    [self.view addSubview:_cameraView];
    [self.view addSubview:gameController.view];
    
    UIButton* shootButton = [[UIButton alloc] initWithFrame:(CGRectMake(200, 300, 100, 50))];
    [shootButton setTitle:@"Shoot" forState:(UIControlStateNormal)];
    [self.view addSubview:shootButton];
    [shootButton addTarget:self action:@selector(shoot:) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)shoot:(UIButton *)sender {
    std::vector<TKCCTexture>* texturesInScene = cocos2d::Director::getInstance()->getTKTexturesInRunningScene();
    for (int i = 0; i < texturesInScene->size(); i++) {
        TKRectTexture rectTexture = convertTKCCTextureToTKRectTexture(texturesInScene[0][i]);
        TKGLRectTextureCommand* glRectTextureCommand = [[TKGLRectTextureCommand alloc] initWithGLProgram:nil rectTexture:rectTexture];
    }
    
    
//    __weak __typeof(self)weakSelf = self;
//    [_camera capturePhotoAsJPEGProcessedUpToFilter:_filter withCompletionHandler:^(NSData *processedJPEG, NSError *error){
//        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
//            NSMutableArray* assets = [[NSMutableArray alloc] init];
//            PHAssetChangeRequest* assetRequest;
//            @autoreleasepool {
////                CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef) processedJPEG, NULL);
////                NSMutableData* newImageData =  [[NSMutableData alloc] init];
////
////                CGImageDestinationRef destination = CGImageDestinationCreateWithData((CFMutableDataRef)newImageData, CGImageSourceGetType(source), 1, nil);
////                CGImageDestinationAddImageFromSource(destination, source, 0, (__bridge CFDictionaryRef) weakSelf.camera.currentCaptureMetadata);
////                CGImageDestinationFinalize(destination);
////                CFRelease(source);
////                CFRelease(destination);
//////
//                assetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:[UIImage imageWithData:processedJPEG]];
//                [assets addObject:assetRequest.placeholderForCreatedAsset];
//            }
//
//            __block PHAssetCollectionChangeRequest* assetCollectionRequest = nil;
//            PHFetchResult* result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
//            [result enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                PHAssetCollection* collection = (PHAssetCollection*)obj;
//                if ([collection isKindOfClass:[PHAssetCollection class]]) {
//                    if ([[collection localizedTitle] isEqualToString:@"Test"]) {
//                        assetCollectionRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection];
//                        [assetCollectionRequest addAssets:assets];
//                        *stop = YES;
//                    }
//                }
//            }];
//            if (assetCollectionRequest == nil) {
//                assetCollectionRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:@"Test"];
//                [assetCollectionRequest addAssets:assets];
//            }
//        } completionHandler:^(BOOL success, NSError * _Nullable error) {
////            if (block) {
////                block(error);
////            }
//        }];
//    }];
}

- (NSArray *)generateRenderCommandQueue:(std::vector<TKCCTexture> *)tkTextures {
    NSMutableArray* renderCmdQueue = [[NSMutableArray alloc] init];
    return renderCmdQueue;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_camera startCameraCapture];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
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

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    auto glview = cocos2d::Director::getInstance()->getOpenGLView();
    
    if (glview)
    {
        CCEAGLView *eaglview = (__bridge CCEAGLView *)glview->getEAGLView();
        
        if (eaglview)
        {
            CGSize s = CGSizeMake([eaglview getWidth], [eaglview getHeight]);
            cocos2d::Application::getInstance()->applicationScreenSizeChanged((int) s.width, (int) s.height);
        }
    }
}

//fix not hide status on ios7
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Cocos2dXGameControllerDelegate

- (void)backToAppFromGameController:(Cocos2dXGameController *)gameController {
    [UIView animateWithDuration:0.3f animations:^{
        gameController.view.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [gameController backToApp];
        [self.view removeFromSuperview];
    }];
}

@end

TKRectTexture convertTKCCTextureToTKRectTexture(TKCCTexture tkccTexture) {
    TKRectTexture tkRectTexture;
    tkRectTexture.textureID = tkccTexture.textureID;
    tkRectTexture.ptVertex[0] = { .position = { 1, 1, 1 }, .texCoord = { 1, 1 } };
    tkRectTexture.ptVertex[1] = { .position = { 1, 1, 1 }, .texCoord = { 1, 1 } };
    tkRectTexture.ptVertex[2] = { .position = { 1, 1, 1 }, .texCoord = { 1, 1 } };
    tkRectTexture.ptVertex[3] = { .position = { 1, 1, 1 }, .texCoord = { 1, 1 } };
    
    return tkRectTexture;
}

//- (TKRectTexture)convertTKCCTextureToTKRectTexture:(TKCCTexture)tkccTexture {
//    TKRectTexture tkRectTexture;
//    tkRectTexture.textureID = tkccTexture.textureID;
//    tkRectTexture.ptVertex[0] = TKPTVertexMake(TKPositionMake(1, 1, 1), TKTexCoordMake(1, 1));
//    tkRectTexture.ptVertex[1] = TKPTVertexMake(TKPositionMake(1, 1, 1), TKTexCoordMake(1, 1));
//    tkRectTexture.ptVertex[2] = TKPTVertexMake(TKPositionMake(1, 1, 1), TKTexCoordMake(1, 1));
//    tkRectTexture.ptVertex[3] = TKPTVertexMake(TKPositionMake(1, 1, 1), TKTexCoordMake(1, 1));
//
//    return tkRectTexture;
//}
