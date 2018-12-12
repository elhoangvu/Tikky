//
//  TKStickerPreviewer.h
//  Tikky
//
//  Created by Le Hoang Vu on 12/3/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "StickerScene.h"
#import "Cocos2dxGameController.h"
#import "UIKit/UIKit.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TKStickerPreviewerDelegate;

@interface TKStickerPreviewer : NSObject

@property (nonatomic, readonly) UIView* view;
@property (nonatomic, readonly) StickerScene* stickerScene;
@property (nonatomic, weak) id<TKStickerPreviewerDelegate> delegate;

- (instancetype)initWithStickerScene:(StickerScene * _Nonnull)stickerScene
              cocos2dxGameController:(Cocos2dxGameController *)ccGameController;

- (NSData *)getStickerTextures;

- (void)newStaticStickerWithPath:(NSString *)path;
- (void)newStaticStickerWithSticker:(TKSticker)sticker;
- (void)newFrameStickerWithSticker:(TKSticker)sticker;
- (void)newFrameStickerWithStickers:(std::vector<TKSticker>&)stickers;
//- (void)newFrameStickerWith2PartTopBot:(NSString *)topFramePath bottomFramePath:(NSString *)bottomFramePath;
//- (void)newFrameStickerWith2PartLeftRight:(NSString *)leftFramePath rightFramePath:(NSString *)rightFramePath;
- (void)removeFrameSticker;
- (void)removeAllStaticSticker;

@end

@protocol TKStickerPreviewerDelegate <NSObject>

- (void)onTouchStickerBegan;
- (void)onEditStickerBegan;
- (void)onEditStickerEnded;

@end

NS_ASSUME_NONNULL_END
