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

//TKRectTexture convertTKCCTextureToTKRectTexture(TKCCTexture tkccTexture);

@interface TikkyEngine () <TKImageFilterDatasource, TKImageFilterDelegate, UIViewDelegate> {
    Cocos2dxGameController* _cocos2dxGameController;
    dispatch_queue_t _facialStickerRenderQueue;
}

@property (nonatomic) CCEAGLView* cceaglView;

@property (nonatomic) EAGLSharegroup* sharegroup;

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
    
    [_imageFilter.view setFrame:rect];
    _imageFilter.delegate = self;
    _view.delegate = self;
//    [_imageFilter.view setFrame:(CGRectMake(0, 0, rect.size.width, rect.size.width*4/3))];
    
    /*
     This method to create an instance of Cocos2dxGameController in the class,
     this instance will push to an external class which is shared item.
     */
    _cocos2dxGameController = [[Cocos2dxGameController alloc] initWithFrame:rect sharegroup:_sharegroup];
    
//    gameController.delegate = self;
    _cceaglView = (CCEAGLView *)_cocos2dxGameController.view;

    StickerScene* stickerScene = (StickerScene *)StickerScene::createScene();
    [_cocos2dxGameController runWithCocos2dxScene:(void *)stickerScene];
    
    _stickerPreviewer = [[TKStickerPreviewer alloc] initWithStickerScene:stickerScene cocos2dxGameController:_cocos2dxGameController];
//
    [_view addSubview:_imageFilter.view];
    [_view addSubview:_cocos2dxGameController.view];
    
    _facialLandmarkDetector = SDM.sharedInstance;
    _facialStickerRenderQueue = dispatch_queue_create("TKFacialLandmarkRenderQueue", nil);
    [self refeshTKImageInput];
    
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
//    CGRect rect = UIScreen.mainScreen.bounds;
//    UIImageView* imageview =  [[UIImageView alloc] initWithFrame:rect];
//    [_imageFilter.view addSubview:imageview];
//    imageview.contentMode = UIViewContentModeScaleAspectFit;
//    imageview.image = [UIImage imageNamed:@"sticker-mario.png" inBundle:NSBundle.mainBundle compatibleWithTraitCollection:nil];
    __block BOOL newDetection = YES;
    [_imageFilter.input trackImageDataOutput:^(CVPixelBufferRef _Nonnull imageBuffer, TKImageInputOrientaion orientation, BOOL flipHorizontal) {
        if (weakSelf.stickerPreviewer.enableFacialSticker) {
            dispatch_sync(_facialStickerRenderQueue, ^{
                newDetection = NO;
                CVPixelBufferLockBaseAddress(imageBuffer, 0);
                
                void* bufferAddress;
                size_t width;
                size_t height;
                size_t bytesPerRow = 0;
                //
                //    CGColorSpaceRef colorSpace;
                //    CGContextRef context;
                
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
                
                cv::Mat result;
                if (rotation == 0) {
                    result = img.clone();
                } else {
                    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
                    
                    // Make larger image
                    int rows = img.rows;
                    int cols = img.cols;
                    int largest = 0;
                    if ( rows > cols ){
                        largest = rows;
                    }else{
                        largest = cols;
                    }
                    cv::Mat temp = cv::Mat::zeros(largest, largest, format_opencv);
                    
                    // Copy your original image
                    // First define the roi in the large image --> draw this on a paper to make it clear
                    // There are two possible cases
                    cv::Rect roi;
                    if (img.rows > img.cols){
                        roi = cv::Rect((temp.cols - img.cols)/2, 0, img.cols, img.rows);
                    }
                    if (img.cols > img.rows){
                        roi = cv::Rect(0, (temp.rows - img.rows)/2, img.cols, img.rows);
                    }
                    
                    // Copy the original to the black large temp image
                    img.copyTo(temp(roi));
                    
                    // Rotate the image
                    cv::Mat rotated = temp.clone();
                    rotate(temp, -90, rotated);
                    
                    //            imshow("rotated", rotated);
                    
                    // Now cut it out again
                    result = rotated(cv::Rect(roi.y, roi.x, roi.height, roi.width)).clone();
                    if (flipHorizontal) {
                        cv::flip(result, result, 1);
                    }
                    NSTimeInterval end = [NSDate timeIntervalSinceReferenceDate];
                    NSLog(@">>>> HV > time 2: %f", end - start);
                    NSLog(@">>>> HV > size: %d %d", result.cols, result.rows);
                    NSLog(@">>>> HV > size: %d %d", result.cols, result.rows);
                    NSLog(@">>>> HV > size 3: %d %d", result.size().width, result.size().height);
                }
                /////////
                
                
                /////////
                //        cv::Mat img = [OpenCVUtilities matFromSampleBuffer:image];
                //            cv::Mat img;
                //            UIImageToMat(imageBuffer, img);
                
                if ([weakSelf.imageFilter.input isKindOfClass:TKPhoto.class]) {
                    newDetection = YES;
                }
                weakSelf.facialLandmarkDetector.isLandmarkDebugger = NO;
                float* landmarks = [weakSelf.facialLandmarkDetector detectLandmarkWithImage:result newDetection:newDetection];
                CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
                
                
                if (landmarks[0] == 0 && landmarks[NUMBER_OF_LANDMARKS] == 0
                    && landmarks[16] == 0 && landmarks[16+NUMBER_OF_LANDMARKS] == 0) {
                    [weakSelf.stickerPreviewer notifyDetectNoFaces];
                } else {
                    CGSize previewerSize = [weakSelf.stickerPreviewer getPreviewerDesignedSize];
                    static const int hflippingConverter[68] = {
                        //  0     1     2     3     4     5     6     7     8     9
                        16,  15,   14,   13,   12,   11,   10,    9,    8,   -1,
                        //  10   11    12    13    14    15    16    17    18    19
                        -1,  -1,   -1,   -1,   -1,   -1,   -1,   26,   25,   24,
                        //  20   21    22    23    24    25    26    27    28    29
                        23,  22,   -1,   -1,   -1,   -1,   -1,   27,   28,   29,
                        //  30   31    32    33    34    35    36    37    38    39
                        30,  35,   34,   33,   -1,   -1,   45,   44,   43,   42,
                        //  40   41    42    43    44    45    46    47    48    49
                        47,  46,   -1,   -1,   -1,   -1,   -1,   -1,   54,   53,
                        //  50   51    52    53    54    55    56    57    58    59
                        52,  51,   -1,   -1,   -1,   59,   58,   57,   -1,   -1,
                        //  60   61    62    63    64    65    66    67    68    69
                        64,  63,   62,   -1,   -1,   67,   66,   -1
                    };
                    CGSize imgSize = CGSizeMake(result.cols, result.rows);
                    float widthScale = previewerSize.width/imgSize.width;
                    float heightScale = previewerSize.height/imgSize.height;
                    
                    for (int i = 0; i < NUMBER_OF_LANDMARKS; i++) {
                        //                    int j = hflippingConverter[i];
                        //                    if (flipHorizontal) {
                        //                        if (j >= 0 && j != i) {
                        //                            std::swap(landmarks[i], landmarks[j]);
                        //                        }
                        //                    }
                        //                    landmarks[i] = (imgSize.width-landmarks[i])*widthScale;
                        landmarks[i] = landmarks[i]*widthScale;
                        landmarks[i+NUMBER_OF_LANDMARKS] = (imgSize.height-landmarks[i+NUMBER_OF_LANDMARKS])*heightScale;
                    }
                    
                    //                for (int j = 0; j < NUMBER_OF_LANDMARKS; j++) {
                    //                    int x = landmarks[j]/widthScale;
                    ////                    int y = landmarks[j + NUMBER_OF_LANDMARKS];
                    //                    int y = (imgSize.height-landmarks[j + NUMBER_OF_LANDMARKS]/heightScale);
                    //                    cv::circle(result, cv::Point(x, y), 2, cv::Scalar(0, 0, 255), -1);
                    //                    NSString* lm = [NSString stringWithFormat:@"%d", j];
                    //                    cv::putText(result, lm.UTF8String, cv::Point(x + 5, y), 4, 0.6, cv::Scalar(0, 0, 125));
                    //                }
                    //
                    //                UIImage *uiImage = MatToUIImage(result);
                    //                NSLog(@">>>> HV > size 4: %f %f", uiImage.size.width, uiImage.size.height);
                    //                dispatch_sync(dispatch_get_main_queue(), ^{
                    //                    imageview.image = uiImage;
                    //                });
                    ////
                    
                    //                dispatch_queue_t queue = dispatch_queue_create("FacialLandmarkQueue", DISPATCH_QUEUE_SERIAL);
                    //                dispatch_async(queue, ^{
                    //                    [weakSelf.stickerPreviewer updateFacialLandmarks:landmarks size:NUMBER_OF_LANDMARKS];
                    //                });
                    [weakSelf.stickerPreviewer updateFacialLandmarks:landmarks size:NUMBER_OF_LANDMARKS];
                }
            });
//            CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
            //        CVImageBufferRef imageBuffer2 = [CVPixelBufferUtils rotateBuffer:sampleBuffer withConstant:90];
            
            
            //            NSLog(@">>>> HV > %f %f %f %f", landmarks[0], landmarks[1], landmarks[2], landmarks[3]);
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
    [_imageFilter.view setFrame:frame];
    [_cocos2dxGameController setFrame:newframe];
}

#pragma mark -
#pragma mark TKImageFilterDelegate

- (void)imageFilter:(TKImageFilter *)imageFilter didChangeInput:(TKImageInput *)input {
    [self refeshTKImageInput];
}

@end
