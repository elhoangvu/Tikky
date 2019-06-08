//
//  TKPhoto.m
//  Tikky
//
//  Created by Le Hoang Vu on 12/11/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import "TKPhoto.h"
#import "GPUImage.h"
#import "UIImage+CVPixelBufferRefConverter.h"

@interface TKPhoto ()

@property (nonatomic) GPUImagePicture* picture;

@property (nonatomic) void (^photoOutputCallback)(CVPixelBufferRef, TKImageInputOrientaion, BOOL);

@property (nonatomic) UIImage* defaultImage;

@end

@implementation TKPhoto

@synthesize sharedObject = sharedObject;

- (instancetype)init {
    if (!(self = [super init])) {
        return nil;
    }
    
    return self;
}

- (instancetype)initWithURL:(NSURL *)url {
    if (!(self = [self init])) {
        return nil;
    }
    
    _picture = [[GPUImagePicture alloc] initWithURL:url];
    
    return self;
}

- (instancetype)initWithImage:(UIImage *)newImageSource {
    if (!(self = [self init])) {
        return nil;
    }
    
    _defaultImage = newImageSource;
    _picture = [[GPUImagePicture alloc] initWithImage:newImageSource];
    
    return self;
}

- (instancetype)initWithCGImage:(CGImageRef)newImageSource {
    if (!(self = [self init])) {
        return nil;
    }
    
    _picture = [[GPUImagePicture alloc] initWithCGImage:newImageSource];
    
    return self;
}

- (instancetype)initWithImage:(UIImage *)newImageSource smoothlyScaleOutput:(BOOL)smoothlyScaleOutput {
    if (!(self = [self init])) {
        return nil;
    }
    
    _defaultImage = newImageSource;
    _picture = [[GPUImagePicture alloc] initWithImage:newImageSource smoothlyScaleOutput:smoothlyScaleOutput];
    
    return self;
}

- (instancetype)initWithCGImage:(CGImageRef)newImageSource smoothlyScaleOutput:(BOOL)smoothlyScaleOutput {
    if (!(self = [self init])) {
        return nil;
    }
    
    _picture = [[GPUImagePicture alloc] initWithCGImage:newImageSource smoothlyScaleOutput:smoothlyScaleOutput];
    
    return self;
}

- (instancetype)initWithImage:(UIImage *)newImageSource removePremultiplication:(BOOL)removePremultiplication {
    if (!(self = [self init])) {
        return nil;
    }
    
    _defaultImage =  newImageSource;
    _picture = [[GPUImagePicture alloc] initWithImage:newImageSource removePremultiplication:removePremultiplication];
    
    return self;
}

- (instancetype)initWithCGImage:(CGImageRef)newImageSource removePremultiplication:(BOOL)removePremultiplication {
    if (!(self = [self init])) {
        return nil;
    }
    
    _picture = [[GPUImagePicture alloc] initWithCGImage:newImageSource removePremultiplication:removePremultiplication];
    
    return self;
}

- (instancetype)initWithImage:(UIImage *)newImageSource smoothlyScaleOutput:(BOOL)smoothlyScaleOutput removePremultiplication:(BOOL)removePremultiplication {
    if (!(self = [self init])) {
        return nil;
    }
    
    _defaultImage = newImageSource;
    _picture = [[GPUImagePicture alloc] initWithImage:newImageSource smoothlyScaleOutput:smoothlyScaleOutput removePremultiplication:removePremultiplication];
    
    return self;
}

- (instancetype)initWithCGImage:(CGImageRef)newImageSource smoothlyScaleOutput:(BOOL)smoothlyScaleOutput removePremultiplication:(BOOL)removePremultiplication {
    if (!(self = [self init])) {
        return nil;
    }
    
    _picture = [[GPUImagePicture alloc] initWithCGImage:newImageSource smoothlyScaleOutput:smoothlyScaleOutput removePremultiplication:removePremultiplication];
    
    return self;
}

- (BOOL)processImageWithCompletionHandler:(void (^)(void))completion {
    BOOL processed = [_picture processImageWithCompletionHandler:completion];
    
    if (_defaultImage) {
        _photoOutputCallback ? _photoOutputCallback(_defaultImage.CVPixelBufferRef, TKImageInputOrientaionDown, NO) : nil;
    } else {
        GPUImageFilter* filter = [[GPUImageFilter alloc] init];
        [_picture addTarget:filter];
        __weak __typeof(self)weakSelf = self;
        [_picture processImageUpToFilter:filter withCompletionHandler:^(UIImage *processedImage) {
            weakSelf.defaultImage = processedImage;
            [weakSelf.picture removeTarget:filter];
            weakSelf.photoOutputCallback ? weakSelf.photoOutputCallback(processedImage.CVPixelBufferRef, TKImageInputOrientaionDown, NO) : nil;
        }];
    }
    return processed;
}

- (void)processImageUpToFilter:(TKFilter *)finalFilterInChain
         withCompletionHandler:(void (^)(UIImage *processedImage))block {
    GPUImageOutput<GPUImageInput>* finalFilter = (GPUImageFilterGroup *)finalFilterInChain.sharedObject;

    [_picture processImageUpToFilter:finalFilter withCompletionHandler:^(UIImage *processedImage) {
        if (block) {
            block(processedImage);
        }
    }];
}

- (void)processImage {
    [_picture processImage];
}

- (UIImage *)defaultImage {
    return _defaultImage;
}

- (NSObject *)sharedObject {
    return _picture;
}

- (void)trackImageDataOutput:(void (^)(CVPixelBufferRef _Nonnull, TKImageInputOrientaion, BOOL))callbackBlock {
    _photoOutputCallback = callbackBlock;
}

@end
