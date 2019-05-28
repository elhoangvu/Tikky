//
//  TKStickerEntity.m
//  Tikky
//
//  Created by Vu Le Hoang on 5/28/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "TKStickerEntity.h"
#import "StickerScene.h"

@implementation TKStickerEntity

- (instancetype)initWithID:(NSUInteger)sid
                  category:(NSString *)category
                      name:(NSString*)name
                 thumbnail:(NSString *)thumbnail
                  isBundle:(BOOL)isBundle
                     count:(NSUInteger)count
                      type:(TKStickerType)type {
    if (!(self = [super init])) {
        return nil;
    }
    
    _sid = sid;
    _category = category;
    _name = name;
    _thumbnail = thumbnail;
    _isBundle = isBundle;
    _count = count;
    _type = type;
    
    return self;
}

@end

@interface TKFaceStickerEntity () {
    std::vector<TKSticker> _facialStickers;
}

@end

@implementation TKFaceStickerEntity

- (instancetype)initWithID:(NSUInteger)sid
                  category:(NSString *)category
                      name:(NSString *)name
                 thumbnail:(NSString *)thumbnail
                  isBundle:(BOOL)isBundle
                     count:(NSUInteger)count
                      type:(TKStickerType)type
                 landmarks:(NSDictionary *)landmarks {
    if (!(self = [super initWithID:sid category:category name:name thumbnail:thumbnail isBundle:isBundle count:count type:type])) {
        return nil;
    }
    
    _landmarks = landmarks;
    
    for (NSUInteger i = 1; i <= count; i++) {
        NSString* fileName = [NSString stringWithFormat:@"%@-%lu.png", name, (unsigned long)i];
        NSString* luaName = [NSString stringWithFormat:@"%@-%lu.lua", name, (unsigned long)i];
        NSString* path;
        NSString* luaPath;
        if (isBundle) {
            path = [NSBundle.mainBundle pathForResource:fileName ofType:nil];
            luaPath = [NSBundle.mainBundle pathForResource:luaName ofType:nil];
        } else {
            NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString* documentsDirectory = [paths objectAtIndex:0];
            NSString* facialStickerDir = [documentsDirectory stringByAppendingPathComponent:@"/FacialSticker/"];
            path = [facialStickerDir stringByAppendingPathComponent:fileName];
            luaPath = [facialStickerDir stringByAppendingPathComponent:luaName];
        }
        
        if (!path || !luaPath) {
            continue;
        }
        
        TKSticker sticker;
        sticker.path = path.UTF8String;
        sticker.luaComponentPath = luaPath.UTF8String;
        sticker.allowChanges = NO;
        
        NSArray* landmarkArr = (NSArray *)[landmarks objectForKey:@(i)];
        for (NSNumber* lmk in landmarkArr) {
            sticker.neededLandmarks.push_back(lmk.intValue);
        }

        _facialStickers.push_back(sticker);
    }

    return self;
}

- (void *)facialSticker {
    return &_facialStickers;
}

@end

@interface TKFrameStickerEntity () {
    std::vector<TKSticker> _frameStickers;
}

@end

@implementation TKFrameStickerEntity

- (instancetype)initWithID:(NSUInteger)sid category:(NSString *)category name:(NSString *)name thumbnail:(NSString *)thumbnail isBundle:(BOOL)isBundle count:(NSUInteger)count type:(TKStickerType)type {
    if (!(self = [super initWithID:sid category:category name:name thumbnail:thumbnail isBundle:isBundle count:count type:type])) {
        return nil;
    }
    
    for (NSInteger i = 1; i <= count; i++) {
        NSString* fileName = [NSString stringWithFormat:@"%@-%ld.png", name, (long)i];
        NSString* luaName = [NSString stringWithFormat:@"%@-%ld.lua", name, (long)i];
        NSString* path;
        NSString* luaPath;
        
        if (isBundle) {
            path = [NSBundle.mainBundle pathForResource:fileName ofType:nil];
            luaPath = [NSBundle.mainBundle pathForResource:luaName ofType:nil];
        } else {
            NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString* documentsDirectory = [paths objectAtIndex:0];
            NSString* facialStickerDir = [documentsDirectory stringByAppendingPathComponent:@"/FrameSticker/"];
            path = [facialStickerDir stringByAppendingPathComponent:fileName];
            luaPath = [facialStickerDir stringByAppendingPathComponent:luaName];
        }
        
        TKSticker fsticker;
        fsticker.path = path.UTF8String;
        fsticker.luaComponentPath = luaPath.UTF8String;
        fsticker.allowChanges = NO;
        _frameStickers.push_back(fsticker);
    }
    
    return self;
}

- (void *)frameStickers {
    return &_frameStickers;
}

@end

@implementation TKCommonStickerEntity


@end
