//
//  TKImageInput.m
//  Tikky
//
//  Created by Le Hoang Vu on 12/6/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import "TKImageInput.h"
#import "GPUImage.h"

@implementation TKImageInput

@end

// ----------------------------------------------

@interface TKCamera ()

@property (nonatomic) GPUImageStillCamera* camera;

@end

@implementation TKCamera

@synthesize isRunning = isRunning;
@synthesize frameRate = frameRate;
@synthesize publicObject = publicObject;

- (instancetype)init
{
    if (!(self = [[TKCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:(AVCaptureDevicePositionFront)])) {
        return nil;
    }
    
    return self;
}

- (instancetype)initWithSessionPreset:(NSString *)sessionPreset cameraPosition:(AVCaptureDevicePosition)cameraPosition {
    if (!(self = [super init])) {
        return nil;
    }
    
    _camera = [[GPUImageStillCamera alloc] initWithSessionPreset:sessionPreset cameraPosition:cameraPosition];
    if (!_camera) {
        NSAssert(NO, @"Cannot create GPUImage camera for TKCamera");
        return nil;
    }
    
    isRunning = NO;
    frameRate = 0;
    publicObject = _camera;
    _camera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    return self;
}

- (void)startCameraCapture {
    [_camera startCameraCapture];
}

- (void)pauseCameraCapture {
    [_camera pauseCameraCapture];
}

- (void)resumeCameraCapture {
    [_camera resumeCameraCapture];
}

- (void)stopCameraCapture {
    [_camera stopCameraCapture];
}

- (void)startVideoRecording {
    
}

- (void)pauseVideoRecording {
    
}

- (void)resumeVideoRecording {
    
}

- (void)stopVideoRecording {
    
}

- (void)swapCamera {
    [_camera rotateCamera];
}

- (AVCaptureDevicePosition)cameraPosition {
    return _camera.cameraPosition;
}

- (void)capturePhotoAsJPEGWithFilterObject:(NSObject *)filterObject completionHandler:(void (^)(NSData *processedJPEG, NSError *error))block; {
    if (!block) {
        return;
    }
    [_camera capturePhotoAsJPEGProcessedUpToFilter:(GPUImageOutput<GPUImageInput> *)filterObject withCompletionHandler:^(NSData *processedJPEG, NSError *error) {
        block(processedJPEG, error);
    }];
}

#pragma mark - Properties's getter, setter

- (BOOL)isRunning {
    return _camera.isRunning;
}

- (UIInterfaceOrientation)outputImageOrientation {
    return _camera.outputImageOrientation;
}

- (void)setOutputImageOrientation:(UIInterfaceOrientation)outputImageOrientation {
    [_camera setOutputImageOrientation:outputImageOrientation];
}

- (int32_t)frameRate {
    return _camera.frameRate;
}

- (void)setFrameRate:(int32_t)frameRate {
    [_camera setFrameRate:frameRate];
}

@end

// ----------------------------------------------

@interface TKPhoto ()

@end

@implementation TKPhoto

@end

// ----------------------------------------------

@interface TKMovie ()

@end

@implementation TKMovie

@end

// ----------------------------------------------
