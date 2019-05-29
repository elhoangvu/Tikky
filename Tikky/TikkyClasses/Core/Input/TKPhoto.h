//
//  TKPhoto.h
//  Tikky
//
//  Created by Le Hoang Vu on 12/11/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKImageInput.h"
#import "TKFilter.h"

@interface TKPhoto : TKImageInput

- (instancetype)initWithURL:(NSURL *)url;
- (instancetype)initWithImage:(UIImage *)newImageSource;
- (instancetype)initWithCGImage:(CGImageRef)newImageSource;
- (instancetype)initWithImage:(UIImage *)newImageSource smoothlyScaleOutput:(BOOL)smoothlyScaleOutput;
- (instancetype)initWithCGImage:(CGImageRef)newImageSource smoothlyScaleOutput:(BOOL)smoothlyScaleOutput;
- (instancetype)initWithImage:(UIImage *)newImageSource removePremultiplication:(BOOL)removePremultiplication;
- (instancetype)initWithCGImage:(CGImageRef)newImageSource removePremultiplication:(BOOL)removePremultiplication;
- (instancetype)initWithImage:(UIImage *)newImageSource smoothlyScaleOutput:(BOOL)smoothlyScaleOutput removePremultiplication:(BOOL)removePremultiplication;
- (instancetype)initWithCGImage:(CGImageRef)newImageSource smoothlyScaleOutput:(BOOL)smoothlyScaleOutput removePremultiplication:(BOOL)removePremultiplication;

- (void)processImage;
- (BOOL)processImageWithCompletionHandler:(void (^)(void))completion;
- (void)processImageUpToFilter:(TKFilter *)finalFilterInChain withCompletionHandler:(void (^)(UIImage *processedImage))block;
- (UIImage *)processedImage;

@end
