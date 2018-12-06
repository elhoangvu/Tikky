//
//  TKStickerPreviewer.m
//  Tikky
//
//  Created by Le Hoang Vu on 12/3/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import "TKStickerPreviewer.h"

using namespace cocos2d;

TKRectTexture convertTKCCTextureToTKRectTexture(TKCCTexture tkccTexture);

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

- (NSData *)getStickerTextures {
    std::vector<TKCCTexture>* textureList = _stickerScene->getTexturesInScene();
    TKRectTexture* rectTexture = (TKRectTexture *)malloc(sizeof(TKRectTexture)*textureList->size());
    int i = 0;
    for (TKCCTexture& ccTexture : *textureList) {
        rectTexture[i] = convertTKCCTextureToTKRectTexture(ccTexture);
        i += 1;
    }
    NSData* textureListData = [NSData dataWithBytesNoCopy:rectTexture length:textureList->size() freeWhenDone:YES];
    return textureListData;
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

TKRectTexture convertTKCCTextureToTKRectTexture(TKCCTexture tkccTexture) {
    TKRectTexture tkRectTexture;
    tkRectTexture.textureID = tkccTexture.textureID;
    tkRectTexture.position[3] = {
        tkccTexture.positionsInScene.bottomleft.x*2.0f - 1.0f,
        (1.0f - tkccTexture.positionsInScene.bottomleft.y)*2.0f - 1.0f,
        1.0f
    };
    tkRectTexture.position[2] = {
        tkccTexture.positionsInScene.bottomright.x*2.0f - 1.0f,
        (1.0f - tkccTexture.positionsInScene.bottomright.y)*2.0f - 1.0f,
        1.0f
    };
    tkRectTexture.position[1] = {
        tkccTexture.positionsInScene.topleft.x*2.0f - 1.0f,
        (1.0f - tkccTexture.positionsInScene.topleft.y)*2.0f - 1.0f,
        1.0f
    };
    tkRectTexture.position[0] = {
        tkccTexture.positionsInScene.topright.x*2.0f - 1.0f,
        (1.0f - tkccTexture.positionsInScene.topright.y)*2.0f - 1.0f,
        1.0f
    };
    
    return tkRectTexture;
}
