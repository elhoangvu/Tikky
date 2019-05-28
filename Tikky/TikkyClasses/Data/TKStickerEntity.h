//
//  TKStickerEntity.h
//  Tikky
//
//  Created by Vu Le Hoang on 5/28/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TKStickerType) {
    TKStickerTypeFace,
    TKStickerTypeFrame,
    TKStickerTypeCommmon
};

NS_ASSUME_NONNULL_BEGIN

@interface TKStickerEntity : NSObject

@property (nonatomic, readonly) NSUInteger sid;
@property (nonatomic, readonly) NSString* category;
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) NSString* thumbnail;
@property (nonatomic, readonly) BOOL isBundle;
@property (nonatomic, readonly) TKStickerType type;
@property (nonatomic, readonly) NSUInteger count;

- (instancetype)initWithID:(NSUInteger)sid
                  category:(NSString *)category
                      name:(NSString*)name
                 thumbnail:(NSString *)thumbnail
                  isBundle:(BOOL)isBundle
                     count:(NSUInteger)count
                      type:(TKStickerType)type;

@end

@interface TKFaceStickerEntity: TKStickerEntity

@property (nonatomic, readonly) NSDictionary* landmarks;

- (instancetype)initWithID:(NSUInteger)sid
                  category:(NSString *)category
                      name:(NSString *)name
                 thumbnail:(NSString *)thumbnail
                  isBundle:(BOOL)isBundle
                     count:(NSUInteger)count
                      type:(TKStickerType)type
                 landmarks:(NSDictionary *)landmarks;

- (void *)facialSticker;

@end

@interface TKFrameStickerEntity: TKStickerEntity

- (void *)frameStickers;

@end

@interface TKCommonStickerEntity : TKStickerEntity

@end

NS_ASSUME_NONNULL_END
