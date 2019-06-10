//
//  TKImageFilter.m
//  Tikky
//
//  Created by Le Hoang Vu on 12/4/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import "TKImageFilter.h"
#import "GPUImage.h"
#import "GPUImageStickerFilter.h"
#import "TKSampleDataPool.h"
#import "TKCamera.h"
#import "TKVideo.h"
#import "TKPhoto.h"
#import "UIView+Delegate.h"
#import "IFImageFilter.h"

@interface TKImageFilter () <
TKCameraDelegate,
UIViewDelegate,
TKPhotoDelegate
>

@property (nonatomic) GPUImageFilterPipeline* filterPipeline;
@property (nonatomic) GPUImageView* gpuimageView;
@property (nonatomic) GPUImageStickerFilter* gpuimageStickerFilter;
@property (nonatomic) GPUImageCropFilter* gpuimageCropFilter;
@property (nonatomic) GPUImageMovieWriter* gpuimageMovieWriter;
@property (nonatomic) NSDictionary* filterList;

@end

@implementation TKImageFilter

@synthesize view = view;

- (instancetype)init
{
//    if (!(self = [self initWithInput:[[TKPhoto alloc] init] filter:@"default"])) {
    if (!(self = [self initWithInput:[[TKCamera alloc] init] filter:@"default"])) {
        return nil;
    }
    
    return self;
}

- (instancetype)initWithInput:(TKImageInput *)input filter:(NSString *)filter {
    if (!(self = [super init])) {
        return nil;
    }
    
//    _filterList = TKSampleDataPool.sharedInstance.filterResources;
    
    self.input = input;
    
    _gpuimageView = [[GPUImageView alloc] init];
    [_gpuimageView setBackgroundColorRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    _gpuimageView.delegate = self;
    [_gpuimageView setFillMode:(kGPUImageFillModePreserveAspectRatio)];
    view = _gpuimageView;
    
    _gpuimageStickerFilter = [[GPUImageStickerFilter alloc] init];
    _gpuimageCropFilter = [[GPUImageCropFilter alloc] init];
    _filterPipeline = [[GPUImageFilterPipeline alloc] initWithOrderedFilters:[NSArray array] input:(GPUImageOutput *)input.sharedObject output:_gpuimageView];
    return self;
}

- (void)photo:(TKPhoto *)photo prepareToProcessPhotoWithPhotoObject:(NSObject *)object completionHandler:(void (^)(UIImage *))block {
    if (!_datasource || ![_datasource respondsToSelector:@selector(additionalTexturesForImageFilter:)]) {
        return;
    }
    
    _additionalTexture = [_datasource additionalTexturesForImageFilter:self];
    GPUImagePicture* picture = (GPUImagePicture *)object;
    if (photo && [_input isKindOfClass:TKPhoto.class]) {
//        __weak __typeof(self)weakSelf = self;
        if (_additionalTexture && _additionalTexture.length > 0) {
            __block BOOL isEmpty = NO;
            GPUImageOutput<GPUImageInput>* filter;
            if (_filterPipeline.filters.count == 0) {
                UIImage* image = photo.defaultImage;
                GPUImagePicture* picture2 = [[GPUImagePicture alloc] initWithImage:image];
//                GPUImageFilter* defFilter = [[GPUImageFilter alloc] init];
                
                [picture2 useNextFrameForImageCapture];
                [picture2 processImage];
                GPUImageStickerFilter* sticker = [[GPUImageStickerFilter alloc] init];
                [sticker setTextureStickers:_additionalTexture];
                [picture2 addTarget:sticker];
                GPUImageRGBFilter* rgb = [[GPUImageRGBFilter alloc] init];
                [sticker addTarget:rgb];
                [picture2 processImageUpToFilter:rgb withCompletionHandler:^(UIImage *processedImage) {
                    if (block) {
                        block(processedImage);
                    }
                }];

//                filter = defFilter;
                isEmpty = YES;
            } else {
                [_gpuimageStickerFilter setTextureStickers:_additionalTexture];
                [_filterPipeline.filters.lastObject addTarget:_gpuimageStickerFilter];
                filter = _gpuimageStickerFilter;
            }
        
//            [picture useNextFrameForImageCapture];
//            [picture processImageUpToFilter:filter withCompletionHandler:^(UIImage *processedImage) {
//                if (isEmpty) {
//                    [weakSelf.filterPipeline removeAllFilters];
//                    [picture removeTarget:filter];
//                } else {
//                    [weakSelf.filterPipeline.filters.lastObject removeTarget:weakSelf.gpuimageStickerFilter];
//                }
//
//                if (block) {
//                    block(processedImage);
//                }
//            }];
        } else {
            GPUImageFilter* subFilter = (GPUImageFilter *)_filterPipeline.filters.lastObject;
            if (!subFilter) {
                subFilter = [[GPUImageRGBFilter alloc] init];
                [picture addTarget:subFilter];
            }
            __weak __typeof(self)weakSelf = self;
            [picture useNextFrameForImageCapture];
            [picture processImageUpToFilter:subFilter withCompletionHandler:^(UIImage *processedImage) {
                if (!weakSelf.filterPipeline.filters.lastObject) {
                    [picture removeTarget:subFilter];
                }
                
                if (block) {
                    block(processedImage);
                }
            }];
        }
    }
}

- (void)camera:(TKCamera *)camera prepareToCapturePhotoWithCameraObject:(NSObject *)object completionHandler:(void (^)(NSData *, NSError *))block {
    if (!_datasource || ![_datasource respondsToSelector:@selector(additionalTexturesForImageFilter:)]) {
        return;
    }
    
    _additionalTexture = [_datasource additionalTexturesForImageFilter:self];
    GPUImageStillCamera* gpuimageCamera = (GPUImageStillCamera *)object;
    if (camera && [_input isKindOfClass:TKCamera.class]) {
        __weak __typeof(self)weakSelf = self;
        if (_additionalTexture && _additionalTexture.length > 0) {
            __block BOOL isEmpty = NO;
            [_gpuimageStickerFilter setTextureStickers:_additionalTexture];
            
            if (_filterPipeline.filters.count == 0) {
                GPUImageFilter* filter = [[GPUImageFilter alloc] init];
                [_filterPipeline addFilter:filter];
                [gpuimageCamera addTarget:_gpuimageStickerFilter];
                isEmpty = YES;
            } else {
                [_filterPipeline.filters.lastObject addTarget:_gpuimageStickerFilter];
            }
            
            [gpuimageCamera capturePhotoAsJPEGProcessedUpToFilter:_gpuimageStickerFilter withCompletionHandler:^(NSData *processedJPEG, NSError *error) {
                if (isEmpty) {
                    [weakSelf.filterPipeline removeAllFilters];
                    [gpuimageCamera removeTarget:weakSelf.gpuimageStickerFilter];
                } else {
                    [weakSelf.filterPipeline.filters.lastObject removeTarget:weakSelf.gpuimageStickerFilter];
                }
                
                block(processedJPEG, error);
            }];
        } else {
            GPUImageFilter* subFilter = (GPUImageFilter *)_filterPipeline.filters.lastObject;
            if (!subFilter) {
                subFilter = [[GPUImageFilter alloc] init];
                [gpuimageCamera addTarget:subFilter];
            }
            __weak __typeof(self)weakSelf = self;
            [gpuimageCamera capturePhotoAsJPEGProcessedUpToFilter:subFilter withCompletionHandler:^(NSData *processedJPEG, NSError *error) {
                if (!weakSelf.filterPipeline.filters.lastObject) {
                    [gpuimageCamera removeTarget:subFilter];
                }
                block(processedJPEG, error);
            }];
        }
    }
}

- (void)camera:(TKCamera *)camera prepareToSynchronizeCaptureOutputWithViewSize:(CGSize)size {
    if (camera.isFrontCamera) {
        [camera setCaptureSessionPreset:AVCaptureSessionPreset1280x720];
    } else {
        [camera setCaptureSessionPreset:AVCaptureSessionPreset1920x1080];
    }
    if (size.width / size.height - 9.0f/16.0f < 0.00001) {
        if ([_filterPipeline.filters.firstObject isKindOfClass:GPUImageCropFilter.class]) {
            [_filterPipeline removeFilterAtIndex:0];
        }
    } else {
        CGFloat height = 9.0f*size.height/(16.0f*size.width);
        CGFloat y = (1.0f - height)/2.0f;
        CGFloat x = 0;
        CGFloat width = 1.0f;
        [_gpuimageCropFilter setCropRegion:CGRectMake(x, y, width, height)];
        if (![_filterPipeline.filters.firstObject isKindOfClass:GPUImageCropFilter.class]) {
            [_filterPipeline addFilter:_gpuimageCropFilter atIndex:0];
        }
    }
}

#pragma mark -
#pragma mark Properties's getter, setter

- (EAGLSharegroup *)sharegroup {
    return [[[GPUImageContext sharedImageProcessingContext] context] sharegroup];
}

- (void)setInput:(TKImageInput *)input {
    if (!(input
          || [input isKindOfClass:TKCamera.class]
          || [input isKindOfClass:TKVideo.class]
          || [input isKindOfClass:TKPhoto.class]
          || input.sharedObject)
          || input == _input) {
        return;
    }
    if ([_filterPipeline.input isKindOfClass:GPUImageVideoCamera.class]) {
        GPUImageVideoCamera* videoCamera = (GPUImageVideoCamera *)_filterPipeline.input;
        [videoCamera stopCameraCapture];
    }

    GPUImageOutput* input_ = (GPUImageOutput *)input.sharedObject;
    _filterPipeline.input = input_;
    _input = input;
    if ([_input isKindOfClass:TKCamera.class]) {
        TKCamera* camera = (TKCamera *)_input;
        camera.delegate = self;
    } else if ([_input isKindOfClass:TKPhoto.class]) {
        TKPhoto* photo = (TKPhoto *)_input;
        photo.delegate = self;
    }
    [_filterPipeline refreshFilters];
    if (_delegate || [_delegate respondsToSelector:@selector(imageFilter:didChangeInput:)]) {
        [_delegate imageFilter:self didChangeInput:_input];
    }
}

- (BOOL)addFilter:(TKFilter *)filter {
    GPUImageFilter* gpuiamgeFilter = (GPUImageFilter *)filter.sharedObject;
    if (!gpuiamgeFilter) {
        return NO;
    }
    [_filterPipeline addFilter:gpuiamgeFilter];
    return YES;
}

- (BOOL)replaceFilter:(TKFilter *)filter withFilter:(TKFilter *)newFilter addNewFilterIfNotExist:(BOOL)isAdd {
    if (!newFilter) {
        return NO;
    }
    GPUImageFilter* newFilter_ = (GPUImageFilter *)newFilter.sharedObject;
    if (!newFilter_) {
        return NO;
    }
    
    __block BOOL isReplace = NO;
    if (filter && filter.sharedObject) {
        __weak __typeof(self)weakSelf = self;
        for (NSUInteger i = 0; i < _filterPipeline.filters.count; i += 1) {
            GPUImageFilter* filter_ = (GPUImageFilter *)[_filterPipeline.filters objectAtIndex:i];
            if (filter_ == filter.sharedObject) {
                [weakSelf.filterPipeline replaceFilterAtIndex:i withFilter:newFilter_];
                isReplace = YES;
            }
        }
    }

    if (!isReplace && isAdd) {
        [_filterPipeline addFilter:newFilter_];
        isReplace = YES;
    }
    
//    if (_filterPipeline.filters.count > 1) {
//        NSLog(@">>>> HV > BUG");
//    }
    return isReplace;
}

- (BOOL)removeFilter:(TKFilter *)filter {
    __block BOOL isRemove = NO;
    __weak __typeof(self)weakSelf = self;
    for (NSUInteger i = 0; i < _filterPipeline.filters.count; i += 1) {
        GPUImageFilter* filter_ = (GPUImageFilter *)[_filterPipeline.filters objectAtIndex:i];
        if (filter_ == filter.sharedObject) {
            [weakSelf.filterPipeline removeFilter:filter_];
            isRemove = YES;
        }
    }

    return isRemove;
}

- (void)removeAllFilter {
    [_filterPipeline removeAllFilters];
}

#pragma mark -
#pragma mark TKCameraDelegate

- (void)camera:(TKCamera *)camera willStartRecordingWithMovieWriterObject:(NSObject *)object {
    GPUImageMovieWriter* movieWriter = (GPUImageMovieWriter *)object;
    
    if (!_datasource || ![_datasource respondsToSelector:@selector(additionalTexturesForImageFilter:)]) {
        return;
    }
    _additionalTexture = [_datasource additionalTexturesForImageFilter:self];
    
    if (camera && [_input isKindOfClass:TKCamera.class]) {
        GPUImageStillCamera* stillCamera = (GPUImageStillCamera *)camera.sharedObject;
        if (_additionalTexture && _additionalTexture.length > 0) {
            [_gpuimageStickerFilter setTextureStickers:_additionalTexture];
            if (_filterPipeline.filters.count == 0) {
                [stillCamera addTarget:_gpuimageStickerFilter];
            } else {
                [_filterPipeline.filters.lastObject addTarget:_gpuimageStickerFilter];
            }
            [_gpuimageStickerFilter addTarget:movieWriter];
        } else {
            if (_filterPipeline.filters.count == 0) {
                GPUImageStillCamera* camera_ = (GPUImageStillCamera *)camera.sharedObject;
                if (camera_) {
                    [camera_ addTarget:movieWriter];
                }
            } else {
                [_filterPipeline.filters.lastObject addTarget:movieWriter];
            }
        }
    }
}

- (void)camera:(TKCamera *)camera willStopRecordingWithMovieWriterObject:(NSObject *)object {
    GPUImageMovieWriter* movieWriter = (GPUImageMovieWriter *)object;
    GPUImageStillCamera* stillCamera = (GPUImageStillCamera *)camera.sharedObject;
    if (_additionalTexture && _additionalTexture.length > 0) {
        if (_filterPipeline.filters.count == 1) {
            [stillCamera removeTarget:_gpuimageStickerFilter];
        } else {
            [_filterPipeline.filters.lastObject removeTarget:_gpuimageStickerFilter];
        }
        [_gpuimageStickerFilter removeTarget:movieWriter];
    } else {
        if (_filterPipeline.filters.count == 1) {
            GPUImageStillCamera* camera_ = (GPUImageStillCamera *)camera.sharedObject;
            if (camera_) {
                [camera_ removeTarget:movieWriter];
            }
        } else {
            [_filterPipeline.filters.lastObject removeTarget:movieWriter];
        }
    }
}

#pragma -
#pragma mark GPUImageViewDelegate

- (void)view:(GPUImageView *)view setFrame:(CGRect)frame {
    if ([_input isKindOfClass:TKCamera.class]) {
        TKCamera* camera = (TKCamera *)_input;
        [camera synchronizeCaptureOutputWithViewSize:frame.size];
    }
}

@end
