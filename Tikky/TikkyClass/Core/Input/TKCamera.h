//
//  TKCamera.h
//  Tikky
//
//  Created by Le Hoang Vu on 12/11/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKImageInput.h"

//typedef NS_ENUM(NSUInteger, TKCameraCaptureSessionRatio) {
//    TKCameraCaptureSessionRatio4x3,
//    TKCameraCaptureSessionRatio16x9,
//    TKCameraCaptureSessionRatio1x1,
//    TKCameraCaptureSessionRatioUnknown
//};

@protocol TKCameraDelegate;

@interface TKCamera : TKImageInput

@property (nonatomic) int32_t frameRate;
@property (nonatomic, readonly) BOOL isRunning;
@property (nonatomic) UIInterfaceOrientation outputImageOrientation;
@property (nonatomic) id<TKCameraDelegate> delegate;
@property (nonatomic) BOOL enableAudioForVideoRecording;
@property (nonatomic, readonly) BOOL isFrontCamera;
@property (nonatomic, copy) NSString* captureSessionPreset;
//@property (nonatomic) TKCameraCaptureSessionRatio captureSessionRatio;

- (instancetype)initWithSessionPreset:(NSString *)sessionPreset cameraPosition:(AVCaptureDevicePosition)cameraPosition;

- (void)startCameraCapture;
- (void)pauseCameraCapture;
- (void)resumeCameraCapture;
- (void)stopCameraCapture;

- (void)prepareVideoWriterWithURL:(NSURL *)url size:(CGSize)size;
- (void)startVideoRecording;
- (void)pauseVideoRecording;
- (void)resumeVideoRecording;
- (void)stopVideoRecording;

- (void)swapCamera;
- (AVCaptureDevicePosition)cameraPosition;
- (void)focusAtPoint:(CGPoint)point inFrame:(CGRect)frame;

- (void)capturePhotoAsJPEGWithCompletionHandler:(void (^)(NSData *processedJPEG, NSError *error))block;
- (void)synchronizeCaptureOutputWithViewSize:(CGSize)size;

@end

@protocol TKCameraDelegate <NSObject>

- (void)camera:(TKCamera *)camera willStartRecordingWithMovieWriterObject:(NSObject *)object;
- (void)camera:(TKCamera *)camera willStopRecordingWithMovieWriterObject:(NSObject *)object;
- (void)camera:(TKCamera *)camera prepareToCapturePhotoWithCameraObject:(NSObject *)object completionHandler:(void (^)(NSData *processedJPEG, NSError *error))block;
- (void)camera:(TKCamera *)camera prepareToSynchronizeCaptureOutputWithViewSize:(CGSize)size;

@end
