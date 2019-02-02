//
//  TKStickerPreviewer.m
//  Tikky
//
//  Created by Le Hoang Vu on 12/3/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import "TKStickerPreviewer.h"
#include "TKTextureUtilities.h"
#include "cocos2d.h"

using namespace cocos2d;

TKRectTexture convertTKCCTextureToTKRectTexture(TKCCTexture tkccTexture);

@interface TKStickerPreviewer ()

@end

@implementation TKStickerPreviewer

//- (instancetype)init
//{
//    if (!(self = [super init])) {
//        return nil;
//    }
//
//    Scene* runningScene = Director::getInstance()->getRunningScene();
//    StickerScene* stickerScene = dynamic_cast<StickerScene *>(runningScene);
//    if (!stickerScene) {
//        return nil;
//    }
//
//    _stickerScene = stickerScene;
//
//    return self;
//}

- (instancetype)initWithStickerScene:(StickerScene *)stickerScene cocos2dxGameController:(Cocos2dxGameController *)ccGameController {
    if (!(self = [super init])) {
        return nil;
    }
    
    if (!stickerScene) {
        NSAssert(NO, @"stickerScene should be not nil");
        return nil;
    }
    
    stickerScene->onEditStickerBegan = [self](){
        if (self.delegate && [self.delegate respondsToSelector:@selector(onEditStickerBegan)]) {
            [self.delegate onEditStickerBegan];
        }
    };
    
    stickerScene->onEditStickerEnded = [self](){
        if (self.delegate && [self.delegate respondsToSelector:@selector(onEditStickerEnded)]) {
            [self.delegate onEditStickerEnded];
        }
    };
    
    stickerScene->onTouchStickerBegan = [self](){
        if (self.delegate && [self.delegate respondsToSelector:@selector(onTouchStickerBegan)]) {
            [self.delegate onTouchStickerBegan];
        }
    };
    
    _view                   = ccGameController.view;
    _stickerScene           = stickerScene;
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

- (void)newStaticStickerWithSticker:(TKSticker)sticker {
    _stickerScene->newStaticStickerWithSticker(sticker);
}

- (void)newFrameStickerWithSticker:(TKSticker)sticker {
    _stickerScene->newFrameStickerWithSticker(sticker);
}

- (void)newFacialStickerWithStickers:(std::vector<TKSticker>&)sticker {
    _stickerScene->newFacialStickerWithStickers(sticker);
}

- (void)newFrameStickerWithStickers:(std::vector<TKSticker>&)stickers {
    _stickerScene->newFrameStickerWithStickers(stickers);
}

- (void)updateFacialLandmarks:(const float *)landmarks size:(int)size {
    _stickerScene->updateFacialLandmarks(landmarks, size);
}

- (void)notifyDetectNoFaces {
    _stickerScene->notifyDetectNoFaces();
}

- (BOOL)enableFacialSticker {
    return _stickerScene->enableFacialSticker();
}

- (void)removeAllStaticSticker {
    _stickerScene->removeAllStaticSticker();
}

- (void)removeFacialSticker {
    _stickerScene->removeAllFacialSticker();
}

//- (void)synchronizeStickerView {
//    cocos2d::GLView* glview = cocos2d::Director::getInstance()->getOpenGLView();
//    cocos2d::Size glviewSize = glview->getFrameSize();
//    CGSize eaglViewSize = _view.frame.size;
//    float widthRatio = frame.size.width/eaglViewSize.width;
//    float heightRatio = frame.size.height/eaglViewSize.height;
//    glview->setFrameSize(glviewSize.width*widthRatio, glviewSize.height*heightRatio);
//
//    cocos2d::Size designResolutionSize = glview->getDesignResolutionSize();
//    glview->setDesignResolutionSize(designResolutionSize.width*widthRatio, designResolutionSize.height*heightRatio, ResolutionPolicy::NO_BORDER);
//}

@end

TKRectTexture convertTKCCTextureToTKRectTexture(TKCCTexture tkccTexture) {
    TKRectTexture tkRectTexture;
    tkRectTexture.textureID = tkccTexture.textureID;
    tkRectTexture.position[3] = {
        tkccTexture.positionsInScene.bottomright.x*2.0f - 1.0f,
        (1.0f - tkccTexture.positionsInScene.bottomright.y)*2.0f - 1.0f,
        1.0f
    };
    tkRectTexture.position[2] = {
        tkccTexture.positionsInScene.bottomleft.x*2.0f - 1.0f,
        (1.0f - tkccTexture.positionsInScene.bottomleft.y)*2.0f - 1.0f,
        1.0f
    };
    tkRectTexture.position[1] = {
        tkccTexture.positionsInScene.topright.x*2.0f - 1.0f,
        (1.0f - tkccTexture.positionsInScene.topright.y)*2.0f - 1.0f,
        1.0f
    };
    tkRectTexture.position[0] = {
        tkccTexture.positionsInScene.topleft.x*2.0f - 1.0f,
        (1.0f - tkccTexture.positionsInScene.topleft.y)*2.0f - 1.0f,
        1.0f
    };
    
    return tkRectTexture;
}