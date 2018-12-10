//
//  TKCamera.h
//  Tikky
//
//  Created by Le Hoang Vu on 12/11/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKImageInput.h"

@protocol TKCameraDelegate;

@interface TKCamera : TKImageInput

@property (nonatomic) int32_t frameRate;
@property (nonatomic, readonly) BOOL isRunning;
@property (nonatomic) UIInterfaceOrientation outputImageOrientation;
@property (nonatomic) id<TKCameraDelegate> delegate;
@property (nonatomic) BOOL enableAudioForVideoRecording;
@property (nonatomic) BOOL isFrontCamera;

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


- (void)capturePhotoAsJPEGWithFilterObject:(NSObject *)filterObject completionHandler:(void (^)(NSData *processedJPEG, NSError *error))block;

@end

@protocol TKCameraDelegate <NSObject>

- (void)camera:(TKCamera *)camera willStartRecordingWithMovieWriterObject:(NSObject *)object;
- (void)camera:(TKCamera *)camera willStopRecordingWithMovieWriterObject:(NSObject *)object;

@end
