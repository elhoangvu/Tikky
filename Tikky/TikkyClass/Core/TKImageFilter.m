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

@interface TKImageFilter ()

@property (nonatomic) GPUImageFilterPipeline* filterPipeline;
@property (nonatomic) GPUImageView* gpuimageView;
@property (nonatomic) GPUImageStickerFilter* gpuimageStickerFilter;
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
    if (camera && [_input isKindOfClass:TKCamera.class]) {
        __weak __typeof(self)weakSelf = self;
        if (_additionalTexture) {
            __block BOOL isEmpty = NO;
            [_gpuimageStickerFilter setTextureStickers:_additionalTexture];
            if (_filterPipeline.filters.count == 0) {
                [_filterPipeline addFilter:_gpuimageStickerFilter];
                isEmpty = YES;
            } else {
                [_filterPipeline.filters.lastObject addTarget:_gpuimageStickerFilter];
            }

            [camera capturePhotoAsJPEGWithFilterObject:_gpuimageStickerFilter completionHandler:^(NSData * _Nonnull processedJPEG, NSError * _Nonnull error) {
                if (isEmpty) {
                    [weakSelf.filterPipeline removeAllFilters];
                } else {
                    [weakSelf.filterPipeline.filters.lastObject removeTarget:weakSelf.gpuimageStickerFilter];
                }
                
                block(processedJPEG, error);
            }];
        } else {
            [camera capturePhotoAsJPEGWithFilterObject:_filterPipeline completionHandler:^(NSData * _Nonnull processedJPEG, NSError * _Nonnull error) {
                block(processedJPEG, error);
            }];
        }

    }
}

#pragma mark - Properties's getter, setter

- (EAGLSharegroup *)sharegroup {
    return [[[GPUImageContext sharedImageProcessingContext] context] sharegroup];
}

- (void)setInput:(TKImageInput *)input {
    if (!(input
          || [input isKindOfClass:TKCamera.class]
          || [input isKindOfClass:TKMovie.class]
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

@end
