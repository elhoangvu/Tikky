//
//  TKStickerPreviewer.h
//  Tikky
//
//  Created by Le Hoang Vu on 12/3/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "StickerScene.h"

NS_ASSUME_NONNULL_BEGIN

@interface TKStickerPreviewer : NSObject

@property (nonatomic, readonly) StickerScene* stickerScene;

- (instancetype)initWithStickerScene:(StickerScene * _Nonnull)stickerScene;

- (NSData *)getStickerTextures;

- (void)newStaticStickerWithPath:(NSString *)path;
- (void)newFrameStickerWithPath:(NSString *)path;
- (void)newFrameStickerWith2PartTopBot:(NSString *)topFramePath bottomFramePath:(NSString *)bottomFramePath;
- (void)newFrameStickerWith2PartLeftRight:(NSString *)leftFramePath rightFramePath:(NSString *)rightFramePath;
- (void)removeFrameSticker;
- (void)removeAllStaticSticker;

@end

NS_ASSUME_NONNULL_END
