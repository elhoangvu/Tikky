//
//  ViewController.m
//  Tikky
//
//  Created by Le Hoang Vu on 11/10/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import "platform/ios/CCEAGLView-ios.h"
#import "Cocos2dxGameController.h"

#import "TikkyEngine.h"

//TKRectTexture convertTKCCTextureToTKRectTexture(TKCCTexture tkccTexture);

@interface TikkyEngine () <Cocos2dXGameControllerDelegate>

@property (nonatomic) CCEAGLView* cceaglView;

@property (nonatomic) EAGLSharegroup* sharegroup;

@end

@implementation TikkyEngine

- (instancetype)init {
    if (!(self = [super init])) {
        return nil;
    }
    
    _imageFilter = [[TKImageFilter alloc] init];
    _sharegroup = _imageFilter.sharegroup;
    
    CGRect rect = CGRectMake(UIScreen.mainScreen.bounds.origin.x,
                             UIScreen.mainScreen.bounds.origin.y,
                             UIScreen.mainScreen.bounds.size.width,
                             UIScreen.mainScreen.bounds.size.height);
    _view = [[UIView alloc] initWithFrame:rect];
    [_imageFilter.view setFrame:rect];
    

    Cocos2dxGameController* gameController = [[Cocos2dxGameController alloc] initWithFrame:rect sharegroup:_sharegroup];
    gameController.delegate = self;
    _cceaglView = (CCEAGLView *)gameController.view;
    [_view addSubview:_imageFilter.view];
    [_view addSubview:gameController.view];
    StickerScene* stickerScene = (StickerScene *)StickerScene::createScene();
    [gameController setInitialScene:(void *)stickerScene];
    
    _stickerPreviewer = [[TKStickerPreviewer alloc] initWithStickerScene:stickerScene];

    return self;
}

+ (instancetype)sharedInstance {
    static TikkyEngine* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TikkyEngine alloc] init];
    });
    
    return instance;
}

- (void)capturePhotoAsJPEGWithCompletionHandler:(void (^)(NSData *processedJPEG, NSError *error))block {
    if (!block) {
        return;
    }
    NSData* textures = [_stickerPreviewer getStickerTextures];
    
    if (_stickerPreviewer) {
        [_imageFilter setAdditionalTexture:textures];
    }

    [_imageFilter capturePhotoAsJPEGWithCompletionHandler:^(NSData *processedJPEG, NSError *error) {
        block(processedJPEG, error);
    }];
}
//
//- (void)capturePhotoAsJPEGAndSaveToPhotoLibraryWithAlbumName:(NSString *)albumName {
//    __weak __typeof(self)weakSelf = self;
//    [self capturePhotoAsJPEGWithCompletionHandler:^(NSData *processedJPEG, NSError *error) {
//        [weakSelf.filter removeTarget:weakSelf.stickerFilter];
//        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
//            NSMutableArray* assets = [[NSMutableArray alloc] init];
//            PHAssetChangeRequest* assetRequest;
//            @autoreleasepool {
//                //                CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef) processedJPEG, NULL);
//                //                NSMutableData* newImageData =  [[NSMutableData alloc] init];
//                //
//                //                CGImageDestinationRef destination = CGImageDestinationCreateWithData((CFMutableDataRef)newImageData, CGImageSourceGetType(source), 1, nil);
//                //                CGImageDestinationAddImageFromSource(destination, source, 0, (__bridge CFDictionaryRef) weakSelf.camera.currentCaptureMetadata);
//                //                CGImageDestinationFinalize(destination);
//                //                CFRelease(source);
//                //                CFRelease(destination);
//                ////
//                assetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:[UIImage imageWithData:processedJPEG]];
//                [assets addObject:assetRequest.placeholderForCreatedAsset];
//            }
//
//            __block PHAssetCollectionChangeRequest* assetCollectionRequest = nil;
//            PHFetchResult* result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
//            [result enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                PHAssetCollection* collection = (PHAssetCollection*)obj;
//                if ([collection isKindOfClass:[PHAssetCollection class]]) {
//                    if ([[collection localizedTitle] isEqualToString:albumName]) {
//                        assetCollectionRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection];
//                        [assetCollectionRequest addAssets:assets];
//                        *stop = YES;
//                    }
//                }
//            }];
//            if (assetCollectionRequest == nil) {
//                assetCollectionRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:albumName];
//                [assetCollectionRequest addAssets:assets];
//            }
//        } completionHandler:^(BOOL success, NSError * _Nullable error) {
//            //            if (block) {
//            //                block(error);
//            //            }
//        }];
//    }];
//}
//
//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    [_camera startCameraCapture];
//
//    NSString* path = [NSBundle.mainBundle pathForResource:@"HelloWorld" ofType:@"png"];
//    NSLog(@">>>> HV: %@", path);
//    [TKLayerMask.sharedInstance newStickerWithPath:path];
//    [TKLayerMask.sharedInstance newStickerWithPath:path];
//    [TKLayerMask.sharedInstance newStickerWithPath:path];
//}

//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//}


//- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
//    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
//
//    auto glview = cocos2d::Director::getInstance()->getOpenGLView();
//
//    if (glview)
//    {
//        CCEAGLView *eaglview = (__bridge CCEAGLView *)glview->getEAGLView();
//
//        if (eaglview)
//        {
//            CGSize s = CGSizeMake([eaglview getWidth], [eaglview getHeight]);
//            cocos2d::Application::getInstance()->applicationScreenSizeChanged((int) s.width, (int) s.height);
//        }
//    }
//}



//- (void)didReceiveMemoryWarning {
//    // Releases the view if it doesn't have a superview.
//    [super didReceiveMemoryWarning];
//    
//    // Release any cached data, images, etc that aren't in use.
//}

#pragma mark - Cocos2dXGameControllerDelegate

- (void)backToAppFromGameController:(Cocos2dxGameController *)gameController {
    [UIView animateWithDuration:0.3f animations:^{
        gameController.view.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [gameController backToApp];
        [self.view removeFromSuperview];
    }];
}

@end


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
