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

@interface TKImageFilter ()

@property (nonatomic) GPUImageFilterPipeline* filterPipeline;
@property (nonatomic) GPUImageView* gpuimageView;
@property (nonatomic) GPUImageStickerFilter* gpuimageStickerFilter;
@property (nonatomic) NSMutableDictionary* filterList;
@property (nonatomic) NSMutableDictionary* lookupFilterList;

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
    
    _filterList = [NSMutableDictionary dictionary];
    _lookupFilterList = [NSMutableDictionary dictionary];
    
    [_filterList setObject:@"GPUImageBrightnessFilter" forKey:@"BRIGHTNESS"];
    [_filterList setObject:@"GPUImageLevelsFilter" forKey:@"LEVELS"];
    [_filterList setObject:@"GPUImageSaturationFilter" forKey:@"SATURATION"];
    [_filterList setObject:@"GPUImageContrastFilter" forKey:@"CONTRAST"];
    [_filterList setObject:@"GPUImageGammaFilter" forKey:@"GAMMA"];
    [_filterList setObject:@"GPUImageFilter" forKey:@"DEFAULT"];
    
    [_lookupFilterList setObject:@"" forKey:@""];
    [_lookupFilterList setObject:@"" forKey:@""];
    [_lookupFilterList setObject:@"" forKey:@""];
    [_lookupFilterList setObject:@"" forKey:@""];
    [_lookupFilterList setObject:@"" forKey:@""];
    
    self.input = input;
    
    _gpuimageView = [[GPUImageView alloc] init];
    view = _gpuimageView;
    
    _gpuimageStickerFilter = [[GPUImageStickerFilter alloc] init];
    _filterPipeline = [[GPUImageFilterPipeline alloc] initWithOrderedFilters:[NSArray array] input:(GPUImageOutput *) input.publicObject output:_gpuimageView];

    return self;
}

- (void)capturePhotoAsJPEGWithCompletionHandler:(void (^)(NSData *, NSError *))block {
    if (!block) {
        return;
    }
    
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
          || input.publicObject)) {
        return;
    }
    if ([_filterPipeline.input isKindOfClass:GPUImageVideoCamera.class]) {
        GPUImageVideoCamera* videoCamera = (GPUImageVideoCamera *)_filterPipeline.input;
        [videoCamera stopCameraCapture];
    }

    GPUImageOutput* input_ = (GPUImageOutput *)input.publicObject;
    _filterPipeline.input = input_;
    _input = input;
}

- (BOOL)addFilter:(NSString *)filter {
    GPUImageFilter* newFilter = [self createFilterWithString:filter name:filter];
    if (!filter) {
        return NO;
    }
    [_filterPipeline addFilter:newFilter];
    return YES;
}

- (BOOL)replaceFilter:(NSString *)filter withFilter:(NSString *)newFilter addNewFilterIfNotExist:(BOOL)isAdd {
    GPUImageFilter* newFilter_ = [self createFilterWithString:newFilter name:newFilter];
    if (!newFilter_) {
        return NO;
    }
    
    __block BOOL isReplace = NO;
    if (filter) {
        __weak __typeof(self)weakSelf = self;
        for (NSUInteger i = 0; i < _filterPipeline.filters.count; i += 1) {
            GPUImageFilter* filter_ = (GPUImageFilter *)[_filterPipeline.filters objectAtIndex:i];
            if ([filter_.name isEqualToString:filter]) {
                [weakSelf.filterPipeline replaceFilterAtIndex:i withFilter:newFilter_];
                isReplace = YES;
            }
        }
    }

    if (!isReplace && isAdd) {
        [_filterPipeline addFilter:newFilter_];
        isReplace = YES;
    }
    return isReplace;
}

- (GPUImageFilter *)createFilterWithString:(NSString *)filterString name:(NSString *)name {
    if (!filterString || [filterString isEqualToString:@""]) {
        return nil;
    }
    NSString* uppercaseFilter = filterString.uppercaseString;
    NSString* filterClass = [_filterList objectForKey:uppercaseFilter];
    if (!filterClass || [filterClass isEqualToString:@""]) {
        return nil;
    }
    
    GPUImageFilter* filterInstance = (GPUImageFilter *)[[NSClassFromString(filterClass) alloc] init];
    filterInstance.name = name;
    if ([name isEqualToString:@"GAMMA"]) {
        GPUImageGammaFilter* gamma = (GPUImageGammaFilter *)filterInstance;
        gamma.gamma = 2.0f;
    }
    return filterInstance;
}

- (BOOL)removeFilter:(NSString *)filter {
    __block BOOL isRemove = NO;
    __weak __typeof(self)weakSelf = self;
    for (NSUInteger i = 0; i < _filterPipeline.filters.count; i += 1) {
        GPUImageFilter* filter_ = (GPUImageFilter *)[_filterPipeline.filters objectAtIndex:i];
        if ([filter_.name isEqualToString:filter]) {
            [weakSelf.filterPipeline removeFilter:filter_];
            isRemove = YES;
        }
    }

    return isRemove;
}
//
//- (BOOL)setFilter:(NSString *)filter property:(NSString *)property constant:(float)constant {
//    
//}
//
//- (NSDictionary *)getPropertyWithFilter:(NSString *)filter {
//    
//}

@end
