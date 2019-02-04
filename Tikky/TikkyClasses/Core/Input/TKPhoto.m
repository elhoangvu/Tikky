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

@property (nonatomic) UIImage* processedImage;

@end

@implementation TKPhoto

@synthesize sharedObject = sharedObject;

- (instancetype)init {
    if (!(self = [super init])) {
        return nil;
    }
    
    _processedImage = nil;
    
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
    GPUImageFilter* filter = [[GPUImageFilter alloc] init];
    [_picture addTarget:filter];
    
    if (_processedImage) {
        _photoOutputCallback ? _photoOutputCallback(_processedImage.CVPixelBufferRef, TKImageInputOrientaionDown, NO) : nil;
    } else {
        __weak __typeof(self)weakSelf = self;
        [_picture processImageUpToFilter:filter withCompletionHandler:^(UIImage *processedImage) {
            weakSelf.processedImage = processedImage;
            [weakSelf.picture removeTarget:filter];
            weakSelf.photoOutputCallback ? weakSelf.photoOutputCallback(processedImage.CVPixelBufferRef, TKImageInputOrientaionDown, NO) : nil;
        }];
    }
    return processed;
}

- (void)processImageUpToFilter:(GPUImageOutput<GPUImageInput> *)finalFilterInChain
         withCompletionHandler:(void (^)(UIImage *processedImage))block {
    [_picture processImageUpToFilter:finalFilterInChain withCompletionHandler:block];
}

- (NSObject *)sharedObject {
    return _picture;
}

- (void)trackImageDataOutput:(void (^)(CVPixelBufferRef _Nonnull, TKImageInputOrientaion, BOOL))callbackBlock {
    _photoOutputCallback = callbackBlock;
}

@end
