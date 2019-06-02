//
//  TKStickerEntity.h
//  Tikky
//
//  Created by Vu Le Hoang on 5/28/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TKCommonEntity.h"

typedef NS_ENUM(NSUInteger, TKStickerType) {
    TKStickerTypeFace,
    TKStickerTypeFrame,
    TKStickerTypeCommmon,
    TKStickerTypeUnknown
};

NS_ASSUME_NONNULL_BEGIN

@interface TKStickerEntity : TKCommonEntity

@property (nonatomic, readonly) TKStickerType stickerType;
@property (nonatomic, readonly) NSUInteger count;

- (instancetype)initWithID:(NSUInteger)sid
                  category:(NSString *)category
                      name:(NSString*)name
                 thumbnail:(NSString *)thumbnail
                  isBundle:(BOOL)isBundle
                     count:(NSUInteger)count
                      type:(TKStickerType)type;

- (instancetype)initWithID:(NSUInteger)sid
                  category:(NSString *)category
                      name:(NSString*)name
                 thumbnail:(NSString *)thumbnail
                  isBundle:(BOOL)isBundle
                     count:(NSUInteger)count;

@end

@interface TKFaceStickerEntity: TKStickerEntity

@property (nonatomic, readonly) NSDictionary* landmarks;

- (instancetype)initWithID:(NSUInteger)sid
                  category:(NSString *)category
                      name:(NSString *)name
                 thumbnail:(NSString *)thumbnail
                  isBundle:(BOOL)isBundle
                     count:(NSUInteger)count
                 landmarks:(NSDictionary *)landmarks;

- (void *)facialSticker;

@end

@interface TKFrameStickerEntity: TKStickerEntity

- (void *)frameStickers;

@end

@interface TKCommonStickerEntity : TKStickerEntity

@end

NS_ASSUME_NONNULL_END
