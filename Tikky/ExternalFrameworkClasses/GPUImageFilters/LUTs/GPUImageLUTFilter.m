//
//  ZALookupFilter.m
//  GPUImageDemo
//
//  Created by CPU11680 on 8/17/18.
//  Copyright © 2018 CPU11680. All rights reserved.
//

#import "GPUImageLUTFilter.h"

@interface GPUImageLUTFilter ()

@property (nonatomic) UIImage* lookupImage;
@property (nonatomic) GPUImagePicture* sourcePicture;
@property (nonatomic) GPUImageLookupFilter* lookupFilter;

@end

@implementation GPUImageLUTFilter

- (instancetype)init {
    if (self = [super init]) {
        _lookupFilter = [[GPUImageLookupFilter alloc] init];
    }
    return self;
}

- (instancetype)initWithLookupImage:(UIImage *)lookupImage {
    if (self = [self init]) {
        NSAssert(lookupImage != nil, @"Look up image should be not null.");
        if (lookupImage == nil) {
            return self;
        }
        
        self.lookupImage = lookupImage;
        
    }
    return self;
}

- (void)setLookupImage:(UIImage *)lookupImage {
    NSAssert(lookupImage != nil, @"Look up image should be not null.");
    if (lookupImage == nil) {
        return;
    }
    _lookupImage = lookupImage;
    _sourcePicture = [[GPUImagePicture alloc] initWithImage:lookupImage];
    _lookupFilter = [[GPUImageLookupFilter alloc] init];
    _intensity = _lookupFilter.intensity;
    [_sourcePicture addTarget:_lookupFilter atTextureLocation:1];
    [_sourcePicture useNextFrameForImageCapture];
    [_sourcePicture processImage];
    [_sourcePicture forceProcessingAtSize:_sourcePicture.outputImageSize];
    
    [self removeAllTargets];
    NSLog(@">>>> %lu", (unsigned long)self.filterCount);
    [self addFilter:_lookupFilter];
    [self setInitialFilters:[NSArray arrayWithObjects:_lookupFilter, nil]];
    [self setTerminalFilter:_lookupFilter];
}

- (void)newFrameReadyAtTime:(CMTime)frameTime atIndex:(NSInteger)textureIndex {
    [_sourcePicture processImage];
    [super newFrameReadyAtTime:frameTime atIndex:textureIndex];
}

- (void)setIntensity:(CGFloat)intensity {
    _lookupFilter.intensity = intensity;
}

@end
