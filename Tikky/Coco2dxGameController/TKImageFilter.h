//
//  TKImageFilter.h
//  Tikky
//
//  Created by Le Hoang Vu on 12/4/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKImageInput.h"

@interface TKImageFilter : NSObject

@property (nonatomic, readonly) UIView* view;
@property (nonatomic) TKImageInput* input;
@property (nonatomic) NSString* filter;

- (instancetype)initWithInput:(TKImageInput *)input filter:(NSString *)filter;
- (EAGLSharegroup *)sharegroup;
- (void)capturePhotoAsJPEGWithCompletionHandler:(void (^)(NSData *processedJPEG, NSError *error))block;
//- (void)capturePhotoAsJPEGAndSaveToPhotoLibraryWithAlbumName:(NSString *)albumName;

@end

