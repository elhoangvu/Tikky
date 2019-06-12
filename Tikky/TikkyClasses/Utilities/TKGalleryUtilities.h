//
//  TKGalleryUtilities.h
//  Tikky
//
//  Created by Vu Le Hoang on 5/30/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TKGalleryUtilities : NSObject

+ (void)saveImageToGalleryWithImage:(UIImage *)image;

+ (void)saveImageToGalleryWithImage:(UIImage *)image completion:(void (^ _Nullable)(BOOL success, NSError* error))completion;

+ (void)writeVideoToLibraryWithURL:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
