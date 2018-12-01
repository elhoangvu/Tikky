//
//  TKLayerMask.m
//  Tikky
//
//  Created by Le Hoang Vu on 12/2/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import "TKLayerMask.h"
#include "StickerScene.h"
#include "cocos2d.h"

@interface TKLayerMask () {
    StickerScene* stickerScene;
}

@end

@implementation TKLayerMask

+ (instancetype)sharedInstance {
    static TKLayerMask* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TKLayerMask alloc] init];
    });
    
    return instance;
}

- (instancetype)init
{
    if (!(self = [super init])) {
        return nil;
    }
    
    cocos2d::Scene* runningScene = cocos2d::Director::getInstance()->getRunningScene();
    stickerScene = dynamic_cast<StickerScene *>(runningScene);
    if (stickerScene == nullptr) {
        return nil;
    }
    
    return self;
}

- (void)newStickerWithPath:(NSString *)path {
    if (path.length == 0 || path == nil) {
        return;
    }
    
    stickerScene->newStickerWithPath([path UTF8String]);
}

@end
