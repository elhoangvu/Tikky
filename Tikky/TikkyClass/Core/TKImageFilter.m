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

@interface TKImageFilter () <TKCameraDelegate>

@property (nonatomic) GPUImageFilterPipeline* filterPipeline;
@property (nonatomic) GPUImageView* gpuimageView;
@property (nonatomic) GPUImageStickerFilter* gpuimageStickerFilter;
@property (nonatomic) GPUImageMovieWriter* gpuimageMovieWriter;
@property (nonatomic) NSDictionary* filterList;

@end

@implementation TKImageFilter

@synthesize view = view;

- (instancetype)init
{
    if (!(self = [self initWithInput:[[TKCamera alloc] init] filter:@"default"])) {
        return nil;
    }
    
    return self;
}

- (instancetype)initWithInput:(TKImageInput *)input filter:(NSString *)filter {
    if (!(self = [super init])) {
        return nil;
    }
    
    _filterList = TKSampleDataPool.sharedInstance.filterResources;
    
    self.input = input;
    
    _gpuimageView = [[GPUImageView alloc] init];
    view = _gpuimageView;
    
    _gpuimageStickerFilter = [[GPUImageStickerFilter alloc] init];
    _filterPipeline = [[GPUImageFilterPipeline alloc] initWithOrderedFilters:[NSArray array] input:(GPUImageOutput *) input.sharedObject output:_gpuimageView];

    return self;
}

- (void)capturePhotoAsJPEGWithCompletionHandler:(void (^)(NSData *, NSError *))block {
    if (!block) {
        return;
    }

    if (!_datasource || ![_datasource respondsToSelector:@selector(additionalTexturesForImageFilter:)]) {
        return;
    }
    
    _additionalTexture = [_datasource additionalTexturesForImageFilter:self];
    TKCamera* camera = (TKCamera *)_input;
    GPUImageStillCamera* gpuimageCamera = (GPUImageStillCamera *)camera.sharedObject;
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

            [camera capturePhotoAsJPEGWithFilterObject:_gpuimageStickerFilter completionHandler:^(NSData * _Nonnull processedJPEG, NSError * _Nonnull error) {
                if (isEmpty) {
                    [weakSelf.filterPipeline removeAllFilters];
                    [gpuimageCamera removeTarget:weakSelf.gpuimageStickerFilter];
                } else {
                    [weakSelf.filterPipeline.filters.lastObject removeTarget:weakSelf.gpuimageStickerFilter];
                }
                
                block(processedJPEG, error);
            }];
        } else {
            [camera capturePhotoAsJPEGWithFilterObject:_filterPipeline.filters.lastObject completionHandler:^(NSData * _Nonnull processedJPEG, NSError * _Nonnull error) {
                block(processedJPEG, error);
            }];
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
          || input.sharedObject)) {
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
        TKCamera* camera = (TKCamera *)input;
        camera.delegate = self;
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

@end
