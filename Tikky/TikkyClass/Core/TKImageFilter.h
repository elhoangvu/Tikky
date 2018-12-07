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
@property (nonatomic) NSData* additionalTexture;

- (instancetype)initWithInput:(TKImageInput *)input filter:(NSString *)filter;
- (EAGLSharegroup *)sharegroup;

- (BOOL)addFilter:(NSString *)filter;
- (BOOL)replaceFilter:(NSString *)filter withFilter:(NSString *)newFilter addNewFilterIfNotExist:(BOOL)isAdd;
- (BOOL)removeFilter:(NSString *)filter;
- (BOOL)setFilter:(NSString *)filter property:(NSString *)property constant:(float)constant;
- (NSDictionary *)getPropertyWithFilter:(NSString *)filter;

- (void)capturePhotoAsJPEGWithCompletionHandler:(void (^)(NSData *processedJPEG, NSError *error))block;


@end

