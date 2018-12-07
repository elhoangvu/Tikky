//
//  TKImageInput.h
//  Tikky
//
//  Created by Le Hoang Vu on 12/6/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TKCameraDelegate;

@interface TKImageInput : NSObject

@property (nonatomic, readonly, weak) NSObject* sharedObject;

@end

@interface TKCamera : TKImageInput

@property (nonatomic) int32_t frameRate;
@property (nonatomic, readonly) BOOL isRunning;
@property (nonatomic) UIInterfaceOrientation outputImageOrientation;
@property (nonatomic) id<TKCameraDelegate> delegate;

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

- (void)capturePhotoAsJPEGWithFilterObject:(NSObject *)filterObject completionHandler:(void (^)(NSData *processedJPEG, NSError *error))block;

@end

@protocol TKCameraDelegate <NSObject>

- (void)camera:(TKCamera *)camera willStartRecordingWithMovieWriterObject:(NSObject *)object;
- (void)camera:(TKCamera *)camera willStopRecordingWithMovieWriterObject:(NSObject *)object;

@end

@interface TKPhoto : TKImageInput

- (instancetype)initWithURL:(NSURL *)url;
- (instancetype)initWithImage:(UIImage *)newImageSource;
- (instancetype)initWithCGImage:(CGImageRef)newImageSource;
- (instancetype)initWithImage:(UIImage *)newImageSource smoothlyScaleOutput:(BOOL)smoothlyScaleOutput;
- (instancetype)initWithCGImage:(CGImageRef)newImageSource smoothlyScaleOutput:(BOOL)smoothlyScaleOutput;
- (instancetype)initWithImage:(UIImage *)newImageSource removePremultiplication:(BOOL)removePremultiplication;
- (instancetype)initWithCGImage:(CGImageRef)newImageSource removePremultiplication:(BOOL)removePremultiplication;
- (instancetype)initWithImage:(UIImage *)newImageSource smoothlyScaleOutput:(BOOL)smoothlyScaleOutput removePremultiplication:(BOOL)removePremultiplication;
- (instancetype)initWithCGImage:(CGImageRef)newImageSource smoothlyScaleOutput:(BOOL)smoothlyScaleOutput removePremultiplication:(BOOL)removePremultiplication;

- (void)processImageWithCompletionHandler:(void (^)(UIImage *processedImage))block;

@end

@interface TKMovie : TKImageInput

@property (readonly, nonatomic) BOOL audioEncodingIsFinished;
@property (readonly, nonatomic) BOOL videoEncodingIsFinished;

- (instancetype)initWithAsset:(AVAsset *)asset;
- (instancetype)initWithPlayerItem:(AVPlayerItem *)playerItem;
- (instancetype)initWithURL:(NSURL *)url;

- (void)startProcessing;
- (void)endProcessing;
- (void)cancelProcessing;

@end

NS_ASSUME_NONNULL_END
