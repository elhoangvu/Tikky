//
//  TKCamera.m
//  Tikky
//
//  Created by Le Hoang Vu on 12/11/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import "TKCamera.h"


@interface TKCamera ()

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
    
    if ([sessionPreset containsString:@"Front"]) {
        _isFrontCamera = YES;
    } else {
        _isFrontCamera = NO;
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
    _movieWriter.shouldPassthroughAudio = NO;
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
    [_movieWriter setHasAudioTrack:enableAudioForVideoRecording];
    if (enableAudioForVideoRecording) {

        
//        AudioChannelLayout channelLayout;
//        memset(&channelLayout, 0, sizeof(AudioChannelLayout));
//        channelLayout.mChannelLayoutTag = kAudioChannelLayoutTag_Stereo;
//
//        NSDictionary *audioSettings = [NSDictionary dictionaryWithObjectsAndKeys:
//                                       [ NSNumber numberWithInt: kAudioFormatMPEG4AAC], AVFormatIDKey,
//                                       [ NSNumber numberWithInt: 2 ], AVNumberOfChannelsKey,
//                                       [ NSNumber numberWithFloat: 16000.0 ], AVSampleRateKey,
//                                       [ NSData dataWithBytes:&channelLayout length: sizeof( AudioChannelLayout ) ], AVChannelLayoutKey,
//                                       [ NSNumber numberWithInt: 32000 ], AVEncoderBitRateKey,
//                                       nil];
//        [_movieWriter setHasAudioTrack:TRUE audioSettings:audioSettings];
        _enableAudioForVideoRecording = enableAudioForVideoRecording;
        _camera.audioEncodingTarget = _movieWriter;
    } else {
        _camera.audioEncodingTarget = nil;
    }
}

- (void)swapCamera {
    [_camera rotateCamera];
    _isFrontCamera = !_isFrontCamera;
}

- (AVCaptureDevicePosition)cameraPosition {
    return _camera.cameraPosition;
}

- (void)focusAtPoint:(CGPoint)point inFrame:(CGRect)frame {
    AVCaptureDevice* device = _camera.inputCamera;
    CGPoint pointOfInterest = [TKCamera convertToPointOfInterestFromViewCoordinates:point
                                                                            inFrame:frame
                                                                    withOrientation:(UIDeviceOrientation)_camera.outputImageOrientation
                                                                        andFillMode:1
                                                                           mirrored:_isFrontCamera];
    
    if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:AVCaptureFocusModeAutoFocus])
    {
        NSError *error;
        if ([device lockForConfiguration:&error])
        {
            [device setFocusPointOfInterest:pointOfInterest];
            [device setFocusMode:AVCaptureFocusModeAutoFocus];
            [device unlockForConfiguration];
        }
    }
    
    if ([device isExposurePointOfInterestSupported] && [device isExposureModeSupported:AVCaptureExposureModeAutoExpose])
    {
        NSError *error;
        if ([device lockForConfiguration:&error])
        {
            [device setExposurePointOfInterest:pointOfInterest];
            [device setExposureMode:AVCaptureExposureModeAutoExpose];
            [device unlockForConfiguration];
        }
    }
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

//#pragma -
//#pragma mark GPUImageMovieWriterDelegate
//
//- (void)movieRecordingCompleted {
//    NSLog(@">>>> HV > movieRecordingCompleted");
//}
//
//- (void)movieRecordingFailedWithError:(NSError*)error {
//    NSLog(@">>>> HV > movieRecordingFailedWithError: %@", error.description);
//}

#pragma mark -
#pragma mark Static Func

+ (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates
                                               inFrame:(CGRect)frame
                                       withOrientation:(UIDeviceOrientation)orientation
                                           andFillMode:(GPUImageFillModeType)fillMode
                                              mirrored:(BOOL)mirrored;
{
    CGSize frameSize = frame.size;
    CGPoint pointOfInterest = CGPointMake(0.5, 0.5);
    
    if (mirrored)
    {
        viewCoordinates.x = frameSize.width - viewCoordinates.x;
    }
    
    if (fillMode == kGPUImageFillModeStretch) {
        pointOfInterest = CGPointMake(viewCoordinates.y / frameSize.height, 1.f - (viewCoordinates.x / frameSize.width));
    } else {
        CGSize apertureSize = CGSizeMake(CGRectGetHeight(frame), CGRectGetWidth(frame));
        if (!CGSizeEqualToSize(apertureSize, CGSizeZero)) {
            CGPoint point = viewCoordinates;
            CGFloat apertureRatio = apertureSize.height / apertureSize.width;
            CGFloat viewRatio = frameSize.width / frameSize.height;
            CGFloat xc = .5f;
            CGFloat yc = .5f;
            
            if (fillMode == kGPUImageFillModePreserveAspectRatio) {
                if (viewRatio > apertureRatio) {
                    CGFloat y2 = frameSize.height;
                    CGFloat x2 = frameSize.height * apertureRatio;
                    CGFloat x1 = frameSize.width;
                    CGFloat blackBar = (x1 - x2) / 2;
                    if (point.x >= blackBar && point.x <= blackBar + x2) {
                        xc = point.y / y2;
                        yc = 1.f - ((point.x - blackBar) / x2);
                    }
                } else {
                    CGFloat y2 = frameSize.width / apertureRatio;
                    CGFloat y1 = frameSize.height;
                    CGFloat x2 = frameSize.width;
                    CGFloat blackBar = (y1 - y2) / 2;
                    if (point.y >= blackBar && point.y <= blackBar + y2) {
                        xc = ((point.y - blackBar) / y2);
                        yc = 1.f - (point.x / x2);
                    }
                }
            } else if (fillMode == kGPUImageFillModePreserveAspectRatioAndFill) {
                if (viewRatio > apertureRatio) {
                    CGFloat y2 = apertureSize.width * (frameSize.width / apertureSize.height);
                    xc = (point.y + ((y2 - frameSize.height) / 2.f)) / y2;
                    yc = (frameSize.width - point.x) / frameSize.width;
                } else {
                    CGFloat x2 = apertureSize.height * (frameSize.height / apertureSize.width);
                    yc = 1.f - ((point.x + ((x2 - frameSize.width) / 2)) / x2);
                    xc = point.y / frameSize.height;
                }
            }
            
            pointOfInterest = CGPointMake(xc, yc);
        }
    }
    
    return pointOfInterest;
}

@end
