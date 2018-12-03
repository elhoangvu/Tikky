//
//  TKStickerPreviewer.m
//  Tikky
//
//  Created by Le Hoang Vu on 12/3/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import "TKStickerPreviewer.h"

using namespace cocos2d;

@interface TKStickerPreviewer ()

@end

@implementation TKStickerPreviewer

- (instancetype)init
{
    if (!(self = [super init])) {
        return nil;
    }
    
    Scene* runningScene = Director::getInstance()->getRunningScene();
    StickerScene* stickerScene = dynamic_cast<StickerScene *>(runningScene);
    if (!stickerScene) {
        return nil;
    }
    
    _stickerScene = stickerScene;
    
    return self;
}

- (instancetype)initWithStickerScene:(StickerScene *)stickerScene {
    if (!(self = [super init])) {
        return nil;
    }
    
    if (!stickerScene) {
        return nil;
    }
    
    _stickerScene = stickerScene;
    
    return self;
}

- (std::vector<TKCCTexture> *)getStickerTextures {
    return _stickerScene->getTexturesInScene();
}

- (void)newStaticStickerWithPath:(NSString *)path {
    _stickerScene->newStaticStickerWithPath([path UTF8String]);
}

- (void)newFrameStickerWithPath:(NSString *)path {
    _stickerScene->newFrameStickerWithPath([path UTF8String]);
}

- (void)newFrameStickerWith2PartTopBot:(NSString *)topFramePath bottomFramePath:(NSString *)bottomFramePath {
    _stickerScene->newFrameStickerWith2PartTopBot([topFramePath UTF8String], [bottomFramePath UTF8String]);
}

- (void)newFrameStickerWith2PartLeftRight:(NSString *)leftFramePath rightFramePath:(NSString *)rightFramePath {
    _stickerScene->newFrameStickerWith2PartLeftRight([leftFramePath UTF8String], [rightFramePath UTF8String]);
}

- (void)removeFrameSticker {
    _stickerScene->removeFrameSticker();
}

- (void)removeAllStaticSticker {
    _stickerScene->removeAllStaticSticker();
}

@end
