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

@interface TKCamera () <GPUImageMovieWriterDelegate>

@property (nonatomic) GPUImageStillCamera* camera;
@property (nonatomic) GPUImageMovieWriter* movieWriter;

@end

@implementation TKCamera

@synthesize isRunning = isRunning;
@synthesize frameRate = frameRate;
@synthesize sharedObject = sharedObject;

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
    
    _enableAudioForVideoRecording = NO;
    isRunning = NO;
    frameRate = 0;
    sharedObject = _camera;
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

- (void)prepareVideoWriterWithURL:(NSURL *)url size:(CGSize)size {
    _movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:url size:size];
    _movieWriter.encodingLiveVideo = YES;
    _movieWriter.shouldPassthroughAudio = YES;
    
    AudioChannelLayout channelLayout;
    memset(&channelLayout, 0, sizeof(AudioChannelLayout));
    channelLayout.mChannelLayoutTag = kAudioChannelLayoutTag_Stereo;
    
    NSDictionary *audioSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [ NSNumber numberWithInt: kAudioFormatMPEG4AAC], AVFormatIDKey,
                                   [ NSNumber numberWithInt: 2 ], AVNumberOfChannelsKey,
                                   [ NSNumber numberWithFloat: 16000.0 ], AVSampleRateKey,
                                   [ NSData dataWithBytes:&channelLayout length: sizeof( AudioChannelLayout ) ], AVChannelLayoutKey,
                                   [ NSNumber numberWithInt: 32000 ], AVEncoderBitRateKey,
                                   nil];
    [_movieWriter setHasAudioTrack:TRUE audioSettings:audioSettings];
    _movieWriter.delegate = self;
}

- (void)startVideoRecording {
    
    if (!_movieWriter) {
        NSAssert(NO, @"You must call prepareVideoWriterWithURL:size: to prepare resource for video writer");
    }
    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
    if (_delegate && [_delegate respondsToSelector:@selector(camera:willStartRecordingWithMovieWriterObject:)]) {
        [_delegate camera:self willStartRecordingWithMovieWriterObject:_movieWriter];
    }

    [_movieWriter startRecording];
    NSTimeInterval end = [NSDate timeIntervalSinceReferenceDate];
    NSLog(@">>>> HV > time:%f", end - start);
}

- (void)pauseVideoRecording {
    [_movieWriter setPaused:YES];
}

- (void)resumeVideoRecording {
    [_movieWriter setPaused:NO];
}

- (void)stopVideoRecording {
//    [_camera removeTarget:_movieWriter];
    if (_delegate && [_delegate respondsToSelector:@selector(camera:willStopRecordingWithMovieWriterObject:)]) {
        [_delegate camera:self willStopRecordingWithMovieWriterObject:_movieWriter];
    }
    [_movieWriter finishRecording];
}

- (void)setEnableAudioForVideoRecording:(BOOL)enableAudioForVideoRecording {
    if (!_movieWriter || _movieWriter.isRecording) {
        return;
    }
    _enableAudioForVideoRecording = enableAudioForVideoRecording;
    if (enableAudioForVideoRecording) {
        _camera.audioEncodingTarget = _movieWriter;
    } else {
        _camera.audioEncodingTarget = nil;
    }
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
    GPUImageFilter* subFilter = (GPUImageFilter *)filterObject;
    if (!filterObject) {
        subFilter = [[GPUImageFilter alloc] init];
        [_camera addTarget:subFilter];
    }
    __weak __typeof(self)weakSelf = self;
    [_camera capturePhotoAsJPEGProcessedUpToFilter:(GPUImageOutput<GPUImageInput> *)subFilter withCompletionHandler:^(NSData *processedJPEG, NSError *error) {
        if (!filterObject) {
            [weakSelf.camera removeTarget:subFilter];
        }
        block(processedJPEG, error);
    }];
}

#pragma mark -
#pragma mark Properties's getter, setter

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

#pragma -
#pragma mark GPUImageMovieWriterDelegate

- (void)movieRecordingCompleted {
    NSLog(@">>>> HV > movieRecordingCompleted");
}

- (void)movieRecordingFailedWithError:(NSError*)error {
    NSLog(@">>>> HV > movieRecordingFailedWithError: %@", error.description);
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
