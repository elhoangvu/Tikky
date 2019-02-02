//
//  TKImageFilter.h
//  Tikky
//
//  Created by Le Hoang Vu on 12/4/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKImageInput.h"
#import "TKFilter.h"

@protocol TKImageFilterDatasource;
@protocol TKImageFilterDelegate;

@interface TKImageFilter : NSObject

@property (nonatomic, readonly) UIView* view;
@property (nonatomic) TKImageInput* input;
@property (nonatomic) NSData* additionalTexture;
@property (nonatomic, weak) id<TKImageFilterDatasource> datasource;
@property (nonatomic, weak) id<TKImageFilterDelegate> delegate;

- (instancetype)initWithInput:(TKImageInput *)input filter:(NSString *)filter;
- (EAGLSharegroup *)sharegroup;

- (BOOL)addFilter:(TKFilter *)filter;
- (BOOL)replaceFilter:(TKFilter *)filter withFilter:(TKFilter *)newFilter addNewFilterIfNotExist:(BOOL)isAdd;
- (BOOL)removeFilter:(TKFilter *)filter;
- (void)removeAllFilter;

@end

@protocol TKImageFilterDatasource <NSObject>

@required

- (NSData *)additionalTexturesForImageFilter:(TKImageFilter *)imageFilter;

@end

@protocol TKImageFilterDelegate <NSObject>

@optional

- (void)imageFilter:(TKImageFilter *)imageFilter didChangeInput:(TKImageInput *)input;

@end

