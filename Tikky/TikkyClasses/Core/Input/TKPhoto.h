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

@protocol TKPhotoDelegate;

@interface TKPhoto : TKImageInput

@property (nonatomic, weak) id<TKPhotoDelegate> delegate;

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
- (BOOL)processImageForFacialFeatureWithCompletionHandler:(void (^)(void))completion;
- (void)processImageUpToFilter:(TKFilter *)finalFilterInChain withCompletionHandler:(void (^)(UIImage *processedImage))block;
- (UIImage *)defaultImage;

@end

@protocol TKPhotoDelegate <NSObject>

- (void)photo:(TKPhoto *)photo prepareToProcessPhotoWithPhotoObject:(NSObject *)object completionHandler:(void (^)(UIImage* image))block;

@end
