//
//  ViewController.m
//  Tikky
//
//  Created by Le Hoang Vu on 11/10/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import "platform/ios/CCEAGLView-ios.h"
#import "Cocos2dxGameController.h"
#import "UIView+Delegate.h"
#import "TikkyEngine.h"
#import "SDM.h"
#import "OpenCVUtilities.h"
#include <opencv2/opencv.hpp>
#include <opencv2/highgui/ios.h>
#import "TKPhoto.h"
#include "TKFacialLandmarkUtilities.h"
#import "TKDataAdapter.h"
#import "StickerScene.h"

@interface TikkyEngine () <TKImageFilterDatasource, TKImageFilterDelegate, UIViewDelegate> {
    Cocos2dxGameController* _cocos2dxGameController;
}

@property (nonatomic) CCEAGLView* cceaglView;

@property (nonatomic) EAGLSharegroup* sharegroup;

@property (nonatomic) dispatch_queue_t facialStickerRenderQueue;

@end

@implementation TikkyEngine

- (instancetype)init {
    if (!(self = [super init])) {
        return nil;
    }
    
    _imageFilter = [[TKImageFilter alloc] init];
    _imageFilter.datasource = self;
    _sharegroup = _imageFilter.sharegroup;
    
    CGRect rect = CGRectMake(UIScreen.mainScreen.bounds.origin.x,
                             UIScreen.mainScreen.bounds.origin.y,
                             UIScreen.mainScreen.bounds.size.width,
                             UIScreen.mainScreen.bounds.size.height);
    
    _view = [[UIView alloc] initWithFrame:rect];
    [_view setOpaque:NO];
    [_view setBackgroundColor:UIColor.clearColor];
    
    [_imageFilter.view setFrame:rect];
    _imageFilter.delegate = self;
    _view.delegate = self;

    _cocos2dxGameController = [[Cocos2dxGameController alloc] initWithFrame:rect sharegroup:_sharegroup];

    _cceaglView = (CCEAGLView *)_cocos2dxGameController.view;

    StickerScene* stickerScene = (StickerScene *)StickerScene::createScene();
    [_cocos2dxGameController runWithCocos2dxScene:(void *)stickerScene];
    
    _stickerPreviewer = [[TKStickerPreviewer alloc] initWithStickerScene:stickerScene cocos2dxGameController:_cocos2dxGameController];
    [_stickerPreviewer setMaxFaceNum:MAX_FACE_NUM];
    
    [_view addSubview:_imageFilter.view];
    [_view addSubview:_cocos2dxGameController.view];
    
    _facialLandmarkDetector = SDM.sharedInstance;
    _facialStickerRenderQueue = dispatch_queue_create("TKFacialLandmarkRenderQueue", nil);
    [self refeshTKImageInput];
    
    NSArray* frames = [TKDataAdapter.sharedIntance loadAllFrameStickers];
    [frames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TKFrameStickerEntity* frame = (TKFrameStickerEntity *)obj;
        std::vector<TKSticker>* frameSticker = (std::vector<TKSticker> *)frame.frameStickers;
        for (auto sticker : *frameSticker) {
            cocos2d::Director::getInstance()->getTextureCache()->addImageAsync(sticker.path, nullptr);
        }
    }];
    
//    cocos2d::Director::getInstance()->setDisplayStats(false);
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

- (void)refeshTKImageInput {
    __weak __typeof(self)weakSelf = self;
    __block BOOL newDetection = YES;
    [_imageFilter.input trackImageDataOutput:^(CVPixelBufferRef _Nonnull imageBuffer, TKImageInputOrientaion orientation, BOOL flipHorizontal) {
        if (weakSelf.stickerPreviewer.enableFacialSticker || weakSelf.stickerPreviewer.enableFacialStickerForTestingDetector) {
            dispatch_sync(weakSelf.facialStickerRenderQueue, ^{
                newDetection = NO;
                CVPixelBufferLockBaseAddress(imageBuffer, 0);
                
                void* bufferAddress;
                size_t width;
                size_t height;
                size_t bytesPerRow = 0;

                int format_opencv = 0;
                
                OSType format = CVPixelBufferGetPixelFormatType(imageBuffer);
                if (format == kCVPixelFormatType_420YpCbCr8BiPlanarFullRange) {
                    format_opencv = CV_8UC1;
                    width = CVPixelBufferGetWidthOfPlane(imageBuffer, 0);
                    height = CVPixelBufferGetHeightOfPlane(imageBuffer, 0);
                    
                    bufferAddress = CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0);
                    bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer, 0);
                    
                } else { // expect kCVPixelFormatType_32BGRA
                    
                    format_opencv = CV_8UC4;
                    
                    bufferAddress = CVPixelBufferGetBaseAddress(imageBuffer);
                    width = CVPixelBufferGetWidth(imageBuffer);
                    height = CVPixelBufferGetHeight(imageBuffer);
                    bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
                    
                }
                
                // delegate image processing to the delegate
                cv::Mat img((int)height, (int)width, format_opencv, bufferAddress, bytesPerRow);
                
                float rotation = 0;
                if (orientation == TKImageInputOrientaionRight) {
                    rotation = -90;
                } else if (orientation == TKImageInputOrientaionLeft) {
                    rotation = 90;
                } else if (orientation == TKImageInputOrientaionUp) {
                    rotation = 180;
                }
                
                cv::Mat rotatedImage;
                [OpenCVUtilities rotateImage:img angle:rotation dst:rotatedImage];
                /////////

                BOOL isPhoto = NO;
                if ([weakSelf.imageFilter.input isKindOfClass:TKPhoto.class]) {
                    newDetection = YES;
                    isPhoto = YES;
                }
                weakSelf.facialLandmarkDetector.isLandmarkDebugger = YES;
//                [weakSelf.facialLandmarkDetector detectLandmarksWithImage:rotatedImage newDetection:newDetection];
                [weakSelf.facialLandmarkDetector detectLandmarksWithImage:rotatedImage
                                                             newDetection:newDetection
                                                             sortFaceRect:YES
                                                               completion:^(float ** _Nullable landmarks, int faceNum) {
                    if (weakSelf.stickerPreviewer.enableFacialSticker) {
                        CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    //                    UIImage* image = MatToUIImage(rotatedImage);
                        if (faceNum == 0) {
                            [weakSelf.stickerPreviewer notifyNoFaceDetected];
                        } else {
                            CGSize previewerSize;
                            if (isPhoto) {
                                previewerSize = weakSelf.stickerPreviewer.view.frame.size;
                            } else {
                                previewerSize = [weakSelf.stickerPreviewer getPreviewerDesignedSize];
                            }
                            CGSize imgSize = CGSizeMake(rotatedImage.cols, rotatedImage.rows);
                            float widthScale = previewerSize.width/imgSize.width * cocos2d::Director::getInstance()->getOpenGLView()->getScaleX();
                            float heightScale = previewerSize.height/imgSize.height * cocos2d::Director::getInstance()->getOpenGLView()->getScaleY();
                            NSLog(@">>>> HV > face: %d", faceNum);
                            
                            flipLandmarks(landmarks, NUMBER_OF_LANDMARKS, faceNum, flipHorizontal, true, imgSize.width, imgSize.height, widthScale, heightScale);
                            [weakSelf.stickerPreviewer updateFacialLandmarks:landmarks landmarkNum:NUMBER_OF_LANDMARKS faceNum:faceNum];
                        }
                    }
                }];
                
            });
        }
    }];
}

#pragma mark -
#pragma mark TKImageFilterDatasource

- (NSData *)additionalTexturesForImageFilter:(TKImageFilter *)imageFilter {
    return [_stickerPreviewer getStickerTextures];
}

#pragma mark -
#pragma mark UIViewDelegate

- (void)view:(UIView *)view setFrame:(CGRect)frame {
    CGRect newframe = CGRectMake(0, 0, frame.size.width, frame.size.height);
    [_imageFilter.view setFrame:newframe];
    [_cocos2dxGameController setFrame:newframe];
}

#pragma mark -
#pragma mark TKImageFilterDelegate

- (void)imageFilter:(TKImageFilter *)imageFilter didChangeInput:(TKImageInput *)input {
    [self refeshTKImageInput];
}

@end
