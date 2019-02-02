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

//TKRectTexture convertTKCCTextureToTKRectTexture(TKCCTexture tkccTexture);

@interface TikkyEngine () <TKImageFilterDatasource, TKImageFilterDelegate, UIViewDelegate> {
    Cocos2dxGameController* _cocos2dxGameController;
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
//    rect.origin.x = 100;
//    UIImageView* imageview =  [[UIImageView alloc] initWithFrame:rect];
//    [_imageFilter.view addSubview:imageview];
//    imageview.contentMode = UIViewContentModeScaleAspectFit;
//    imageview.image = [UIImage imageNamed:@"sticker-mario.png" inBundle:NSBundle.mainBundle compatibleWithTraitCollection:nil];
    __block BOOL newDetection = YES;
    [_imageFilter.input trackImageDataOutput:^(CVPixelBufferRef _Nonnull imageBuffer, TKImageInputOrientaion orientation, BOOL flipHorizontal) {
        if (weakSelf.stickerPreviewer.enableFacialSticker) {
//            CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
            //        CVImageBufferRef imageBuffer2 = [CVPixelBufferUtils rotateBuffer:sampleBuffer withConstant:90];
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
            weakSelf.facialLandmarkDetector.isLandmarkDebugger = YES;
            float* landmarks = [weakSelf.facialLandmarkDetector detectLandmarkWithImage:result newDetection:newDetection];
            CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
//            UIImage *uiImage = MatToUIImage(result);
//            NSLog(@">>>> HV > size 4: %f %f", uiImage.size.width, uiImage.size.height);
//            dispatch_sync(dispatch_get_main_queue(), ^{
//                imageview.image = uiImage;
//            });

            if (landmarks[0] == 0 && landmarks[NUMBER_OF_LANDMARKS] == 0
                && landmarks[16] == 0 && landmarks[16+NUMBER_OF_LANDMARKS] == 0) {
                [weakSelf.stickerPreviewer notifyDetectNoFaces];
            } else {
                CGSize previewerSize = [weakSelf.stickerPreviewer getPreviewerDesignedSize];
                CGSize imgSize = CGSizeMake(result.cols, result.rows);
                float widthScale = previewerSize.width/imgSize.width;
                float heightScale = previewerSize.height/imgSize.height;
                for (int i = 0; i < NUMBER_OF_LANDMARKS; i++) {
                    if (flipHorizontal) {
                        landmarks[i] = (imgSize.width-landmarks[i])*widthScale;
                    } else {
                        landmarks[i] = landmarks[i]*widthScale;
                    }
                    landmarks[i+NUMBER_OF_LANDMARKS] = (imgSize.height-landmarks[i+NUMBER_OF_LANDMARKS])*heightScale;
                }

                dispatch_queue_t queue = dispatch_queue_create("FacialLandmarkQueue", DISPATCH_QUEUE_SERIAL);
                dispatch_async(queue, ^{
                    [weakSelf.stickerPreviewer updateFacialLandmarks:landmarks size:NUMBER_OF_LANDMARKS];
                });
            }
            
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
