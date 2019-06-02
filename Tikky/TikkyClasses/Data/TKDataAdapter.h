//
//  TKDataLoader.h
//  Tikky
//
//  Created by Vu Le Hoang on 6/2/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TKFilterEntity.h"

#import "TKStickerEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface TKDataAdapter : NSObject

+ (instancetype)sharedIntance;

- (NSArray *)loadAllFilters;

- (NSArray *)loadAllEffects;

- (NSArray *)loadAllFacialStickers;

- (NSArray *)loadAllFrameStickers;

- (NSArray *)loadAllCommonStickers;

- (NSArray *)loadAllStickers;

+ (NSString *)stickerDirectoryForResource;

+ (NSString *)filterDirectoryForResource;

+ (NSString *)stickerThumbnailDirectoryForResource;

+ (NSString *)filterThumbnailDirectoryForResource;

@end

NS_ASSUME_NONNULL_END
