//
//  TKDataSamplePool.m
//  Tikky
//
//  Created by Le Hoang Vu on 12/7/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import "TKSampleDataPool.h"
#import "GPUImage.h"
#import "StickerScene.h"

@interface TKSampleDataPool () {
    std::vector<std::vector<TKSticker>>* _facialStickers;
    std::vector<std::vector<TKSticker>>* _frameStickers;
}

@end

@implementation TKSampleDataPool

+ (instancetype)sharedInstance {
    static TKSampleDataPool* instace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instace = [[TKSampleDataPool alloc] init];
    });
    
    return instace;
}

- (instancetype)init
{
    if (!(self = [super init])) {
        return nil;
    }
    
    [self initfilterResources];
    [self initStickerList];
    [self initFilterList];
    [self initStickerModelList];
    [self initFrameModelList];
    [self initFrameStickerList];
    [self initFacialStickerList];

    [GPUImageContrastFilter load];
    [GPUImageLevelsFilter load];
    [GPUImageSaturationFilter load];
    [GPUImageBrightnessFilter load];
    [GPUImageGammaFilter load];
    [GPUImageFilter load];
    
    return self;
}

- (void)initFilterList {
    if (_filterResources) {
        _filterList = [NSMutableArray arrayWithArray:_filterResources.allKeys];
    }
}

- (void)initStickerModelList {
    _stickerModelList = [NSMutableArray array];
    
    [_stickerModelList addObject:[[TKStickerModel alloc] initWithIdentifier:[[NSNumber alloc] initWithInt:1] andName:@"X mas" andType:@"sticker" andCategory:@"Xmas" andIsFromBundle:1 andThumbnailPath:@"sticker-xmas-hat-2-thumb" andPath:@"sticker-xmas-hat-2"]];
    [_stickerModelList addObject:[[TKStickerModel alloc] initWithIdentifier:[[NSNumber alloc] initWithInt:1] andName:@"X mas" andType:@"sticker" andCategory:@"Xmas" andIsFromBundle:1 andThumbnailPath:@"sticker-xmas-hat-3-thumb" andPath:@"sticker-xmas-hat-3"]];
    [_stickerModelList addObject:[[TKStickerModel alloc] initWithIdentifier:[[NSNumber alloc] initWithInt:1] andName:@"X mas" andType:@"sticker" andCategory:@"Xmas" andIsFromBundle:1 andThumbnailPath:@"sticker-xmas-hat-4-thumb" andPath:@"sticker-xmas-hat-4"]];
    [_stickerModelList addObject:[[TKStickerModel alloc] initWithIdentifier:[[NSNumber alloc] initWithInt:1] andName:@"X mas" andType:@"sticker" andCategory:@"Xmas" andIsFromBundle:1 andThumbnailPath:@"sticker-xmas-hat-5-thumb" andPath:@"sticker-xmas-hat-5"]];
    [_stickerModelList addObject:[[TKStickerModel alloc] initWithIdentifier:[[NSNumber alloc] initWithInt:1] andName:@"X mas" andType:@"sticker" andCategory:@"Xmas" andIsFromBundle:1 andThumbnailPath:@"sticker-xmas-hat-6-thumb" andPath:@"sticker-xmas-hat-6"]];
    [_stickerModelList addObject:[[TKStickerModel alloc] initWithIdentifier:[[NSNumber alloc] initWithInt:1] andName:@"X mas" andType:@"sticker" andCategory:@"Xmas" andIsFromBundle:1 andThumbnailPath:@"sticker-xmas-hat-7-thumb" andPath:@"sticker-xmas-hat-7"]];
    [_stickerModelList addObject:[[TKStickerModel alloc] initWithIdentifier:[[NSNumber alloc] initWithInt:1] andName:@"X mas" andType:@"sticker" andCategory:@"Xmas" andIsFromBundle:1 andThumbnailPath:@"sticker-xmas-hat-8-thumb" andPath:@"sticker-xmas-hat-8"]];
    [_stickerModelList addObject:[[TKStickerModel alloc] initWithIdentifier:[[NSNumber alloc] initWithInt:1] andName:@"X mas" andType:@"sticker" andCategory:@"Xmas" andIsFromBundle:1 andThumbnailPath:@"sticker-xmas-hat-thumb" andPath:@"sticker-xmas-hat"]];
    [_stickerModelList addObject:[[TKStickerModel alloc] initWithIdentifier:[[NSNumber alloc] initWithInt:1] andName:@"X mas" andType:@"sticker" andCategory:@"Xmas" andIsFromBundle:1 andThumbnailPath:@"sticker-xmas-pink-gift-thumb" andPath:@"sticker-xmas-pink-gift"]];
    [_stickerModelList addObject:[[TKStickerModel alloc] initWithIdentifier:[[NSNumber alloc] initWithInt:1] andName:@"X mas" andType:@"sticker" andCategory:@"Xmas" andIsFromBundle:1 andThumbnailPath:@"sticker-xmas-reindeer-thumb" andPath:@"sticker-xmas-reindeer"]];
    [_stickerModelList addObject:[[TKStickerModel alloc] initWithIdentifier:[[NSNumber alloc] initWithInt:1] andName:@"X mas" andType:@"sticker" andCategory:@"Xmas" andIsFromBundle:1 andThumbnailPath:@"sticker-xmas-santa-thumb" andPath:@"sticker-xmas-santa"]];
    [_stickerModelList addObject:[[TKStickerModel alloc] initWithIdentifier:[[NSNumber alloc] initWithInt:1] andName:@"X mas" andType:@"sticker" andCategory:@"Xmas" andIsFromBundle:1 andThumbnailPath:@"sticker-xmas-snowman-thumb" andPath:@"sticker-xmas-snowman"]];
    [_stickerModelList addObject:[[TKStickerModel alloc] initWithIdentifier:[[NSNumber alloc] initWithInt:1] andName:@"X mas" andType:@"sticker" andCategory:@"Xmas" andIsFromBundle:1 andThumbnailPath:@"sticker-xmas-violet-gift-thumb" andPath:@"sticker-xmas-violet-gift"]];
}

- (void)initFrameModelList {
    _frameModelList = [NSMutableArray array];
    
    [_frameModelList addObject:[[TKFrameModel alloc] initWithIdentifier:[[NSNumber alloc] initWithInt:1] andName:@"X mas" andType:@"frame" andCategory:@"Flower" andIsFromBundle:1 andThumbnailPath:@"frame-flower-2-thumb" andPath:@"frame-flower-2"]];
    [_frameModelList addObject:[[TKFrameModel alloc] initWithIdentifier:[[NSNumber alloc] initWithInt:1] andName:@"X mas" andType:@"frame" andCategory:@"Flower" andIsFromBundle:1 andThumbnailPath:@"frame-flower-3-thumb" andPath:@"frame-flower-3"]];
    [_frameModelList addObject:[[TKFrameModel alloc] initWithIdentifier:[[NSNumber alloc] initWithInt:1] andName:@"X mas" andType:@"frame" andCategory:@"Flower" andIsFromBundle:1 andThumbnailPath:@"frame-flower-4-thumb" andPath:@"frame-flower-4"]];
    [_frameModelList addObject:[[TKFrameModel alloc] initWithIdentifier:[[NSNumber alloc] initWithInt:1] andName:@"X mas" andType:@"frame" andCategory:@"Xmas" andIsFromBundle:1 andThumbnailPath:@"frame-xmas-2-thumb" andPath:@"frame-xmas-2"]];
    [_frameModelList addObject:[[TKFrameModel alloc] initWithIdentifier:[[NSNumber alloc] initWithInt:1] andName:@"X mas" andType:@"frame" andCategory:@"Xmas" andIsFromBundle:1 andThumbnailPath:@"frame-xmas-3-thumb" andPath:@"frame-xmas-3-toponly"]];
    [_frameModelList addObject:[[TKFrameModel alloc] initWithIdentifier:[[NSNumber alloc] initWithInt:1] andName:@"X mas" andType:@"frame" andCategory:@"Xmas" andIsFromBundle:1 andThumbnailPath:@"frame-xmas-4-thumb" andPath:@"frame-xmas-4-toponly"]];
}

- (void)initFacialStickerList {
    _facialStickers = new std::vector<std::vector<TKSticker>>();
    std::vector<TKSticker> stickers1;
    
    NSString* fileName = [NSString stringWithFormat:@"sticker-dog-3.png"];
    NSString* luaName = [NSString stringWithFormat:@"sticker-dog-3.lua"];
    NSString* path = [NSBundle.mainBundle pathForResource:fileName ofType:nil];
    NSString* luaPath = [NSBundle.mainBundle pathForResource:luaName ofType:nil];
    TKSticker sticker11;
    sticker11.path = path.UTF8String;
    sticker11.luaComponentPath = luaPath.UTF8String;
    sticker11.allowChanges = NO;
    sticker11.neededLandmarks.push_back(30);
    sticker11.neededLandmarks.push_back(31);
    sticker11.neededLandmarks.push_back(33);
    sticker11.neededLandmarks.push_back(35);
    stickers1.push_back(sticker11);
    
    fileName = [NSString stringWithFormat:@"sticker-dog-1.png"];
    luaName = [NSString stringWithFormat:@"sticker-dog-1.lua"];
    path = [NSBundle.mainBundle pathForResource:fileName ofType:nil];
    luaPath = [NSBundle.mainBundle pathForResource:luaName ofType:nil];
    TKSticker sticker12;
    sticker12.path = path.UTF8String;
    sticker12.luaComponentPath = luaPath.UTF8String;
    sticker12.allowChanges = NO;
    sticker12.neededLandmarks.push_back(0);
    sticker12.neededLandmarks.push_back(6);
    sticker12.neededLandmarks.push_back(16);
    sticker12.neededLandmarks.push_back(19);
    
    stickers1.push_back(sticker12);
    
    fileName = [NSString stringWithFormat:@"sticker-dog-2.png"];
    luaName = [NSString stringWithFormat:@"sticker-dog-2.lua"];
    path = [NSBundle.mainBundle pathForResource:fileName ofType:nil];
    luaPath = [NSBundle.mainBundle pathForResource:luaName ofType:nil];
    TKSticker sticker13;
    sticker13.path = path.UTF8String;
    sticker13.luaComponentPath = luaPath.UTF8String;
    sticker13.allowChanges = NO;
    sticker13.neededLandmarks.push_back(0);
    sticker13.neededLandmarks.push_back(10);
    sticker13.neededLandmarks.push_back(16);
    sticker13.neededLandmarks.push_back(24);
    stickers1.push_back(sticker13);
    
    fileName = [NSString stringWithFormat:@"sticker-dog-4.png"];
    luaName = [NSString stringWithFormat:@"sticker-dog-4.lua"];
    path = [NSBundle.mainBundle pathForResource:fileName ofType:nil];
    luaPath = [NSBundle.mainBundle pathForResource:luaName ofType:nil];
    TKSticker sticker14;
    sticker14.path = path.UTF8String;
    sticker14.luaComponentPath = luaPath.UTF8String;
    sticker14.allowChanges = NO;
    sticker14.neededLandmarks.push_back(61);
    sticker14.neededLandmarks.push_back(63);
    sticker14.neededLandmarks.push_back(65);
    sticker14.neededLandmarks.push_back(67);
    stickers1.push_back(sticker14);
    
    std::vector<TKSticker> stickers2;
    
    fileName = [NSString stringWithFormat:@"sticker-fox-3.png"];
    luaName = [NSString stringWithFormat:@"sticker-fox-3.lua"];
    path = [NSBundle.mainBundle pathForResource:fileName ofType:nil];
    luaPath = [NSBundle.mainBundle pathForResource:luaName ofType:nil];
    TKSticker sticker21;
    sticker21.path = path.UTF8String;
    sticker21.luaComponentPath = luaPath.UTF8String;
    sticker21.allowChanges = NO;
    sticker21.neededLandmarks.push_back(30);
    sticker21.neededLandmarks.push_back(31);
    sticker21.neededLandmarks.push_back(33);
    sticker21.neededLandmarks.push_back(35);
    stickers2.push_back(sticker21);
    
    fileName = [NSString stringWithFormat:@"sticker-fox-1.png"];
    luaName = [NSString stringWithFormat:@"sticker-fox-1.lua"];
    path = [NSBundle.mainBundle pathForResource:fileName ofType:nil];
    luaPath = [NSBundle.mainBundle pathForResource:luaName ofType:nil];
    TKSticker sticker22;
    sticker22.path = path.UTF8String;
    sticker22.luaComponentPath = luaPath.UTF8String;
    sticker22.allowChanges = NO;
    sticker22.neededLandmarks.push_back(0);
    sticker22.neededLandmarks.push_back(6);
    sticker22.neededLandmarks.push_back(16);
    sticker22.neededLandmarks.push_back(19);
    
    stickers2.push_back(sticker22);
    
    fileName = [NSString stringWithFormat:@"sticker-fox-2.png"];
    luaName = [NSString stringWithFormat:@"sticker-fox-2.lua"];
    path = [NSBundle.mainBundle pathForResource:fileName ofType:nil];
    luaPath = [NSBundle.mainBundle pathForResource:luaName ofType:nil];
    TKSticker sticker23;
    sticker23.path = path.UTF8String;
    sticker23.luaComponentPath = luaPath.UTF8String;
    sticker23.allowChanges = NO;
    sticker23.neededLandmarks.push_back(0);
    sticker23.neededLandmarks.push_back(10);
    sticker23.neededLandmarks.push_back(16);
    sticker23.neededLandmarks.push_back(24);
    stickers2.push_back(sticker23);
    
    fileName = [NSString stringWithFormat:@"sticker-fox-4.png"];
    luaName = [NSString stringWithFormat:@"sticker-fox-4.lua"];
    path = [NSBundle.mainBundle pathForResource:fileName ofType:nil];
    luaPath = [NSBundle.mainBundle pathForResource:luaName ofType:nil];
    TKSticker sticker24;
    sticker24.path = path.UTF8String;
    sticker24.luaComponentPath = luaPath.UTF8String;
    sticker24.allowChanges = NO;
    sticker24.neededLandmarks.push_back(36);
    sticker24.neededLandmarks.push_back(39);
    sticker24.neededLandmarks.push_back(42);
    sticker24.neededLandmarks.push_back(45);
    stickers2.push_back(sticker24);
    
    std::vector<TKSticker> stickers3;
    fileName = [NSString stringWithFormat:@"sticker-nonla-hat.png"];
    luaName = [NSString stringWithFormat:@"sticker-nonla-hat.lua"];
    path = [NSBundle.mainBundle pathForResource:fileName ofType:nil];
    luaPath = [NSBundle.mainBundle pathForResource:luaName ofType:nil];
    TKSticker sticker31;
    sticker31.path = path.UTF8String;
    sticker31.luaComponentPath = luaPath.UTF8String;
    sticker31.allowChanges = NO;
    sticker31.neededLandmarks.push_back(0);
    sticker31.neededLandmarks.push_back(16);
    sticker31.neededLandmarks.push_back(27);
    sticker31.neededLandmarks.push_back(29);
    stickers3.push_back(sticker31);
    
    std::vector<TKSticker> stickers4;
    
    fileName = [NSString stringWithFormat:@"sticker-cat-1.png"];
    luaName = [NSString stringWithFormat:@"sticker-cat-1.lua"];
    path = [NSBundle.mainBundle pathForResource:fileName ofType:nil];
    luaPath = [NSBundle.mainBundle pathForResource:luaName ofType:nil];
    TKSticker sticker42;
    sticker42.path = path.UTF8String;
    sticker42.luaComponentPath = luaPath.UTF8String;
    sticker42.allowChanges = NO;
    sticker42.neededLandmarks.push_back(0);
    sticker42.neededLandmarks.push_back(6);
    sticker42.neededLandmarks.push_back(16);
    sticker42.neededLandmarks.push_back(19);
    
    stickers4.push_back(sticker42);
    
    fileName = [NSString stringWithFormat:@"sticker-cat-2.png"];
    luaName = [NSString stringWithFormat:@"sticker-cat-2.lua"];
    path = [NSBundle.mainBundle pathForResource:fileName ofType:nil];
    luaPath = [NSBundle.mainBundle pathForResource:luaName ofType:nil];
    TKSticker sticker43;
    sticker43.path = path.UTF8String;
    sticker43.luaComponentPath = luaPath.UTF8String;
    sticker43.allowChanges = NO;
    sticker43.neededLandmarks.push_back(0);
    sticker43.neededLandmarks.push_back(10);
    sticker43.neededLandmarks.push_back(16);
    sticker43.neededLandmarks.push_back(24);
    stickers4.push_back(sticker43);
    
    fileName = [NSString stringWithFormat:@"sticker-cat-3.png"];
    luaName = [NSString stringWithFormat:@"sticker-cat-3.lua"];
    path = [NSBundle.mainBundle pathForResource:fileName ofType:nil];
    luaPath = [NSBundle.mainBundle pathForResource:luaName ofType:nil];
    TKSticker sticker44;
    sticker44.path = path.UTF8String;
    sticker44.luaComponentPath = luaPath.UTF8String;
    sticker44.allowChanges = NO;
    sticker44.neededLandmarks.push_back(36);
    sticker44.neededLandmarks.push_back(39);
    sticker44.neededLandmarks.push_back(42);
    sticker44.neededLandmarks.push_back(45);
    stickers4.push_back(sticker44);
    
    std::vector<TKSticker> stickers5;
    
    fileName = [NSString stringWithFormat:@"sticker-flag-vn-0.png"];
    luaName = [NSString stringWithFormat:@"sticker-flag-vn-0.lua"];
    path = [NSBundle.mainBundle pathForResource:fileName ofType:nil];
    luaPath = [NSBundle.mainBundle pathForResource:luaName ofType:nil];
    TKSticker sticker51;
    sticker51.path = path.UTF8String;
    sticker51.luaComponentPath = luaPath.UTF8String;
    sticker51.allowChanges = NO;
    sticker51.neededLandmarks.push_back(1);
    sticker51.neededLandmarks.push_back(15);
    sticker51.neededLandmarks.push_back(30);
    sticker51.neededLandmarks.push_back(39);
    sticker51.neededLandmarks.push_back(42);
    
    stickers5.push_back(sticker51);
    
    fileName = [NSString stringWithFormat:@"sticker-flag-vn-1.png"];
    luaName = [NSString stringWithFormat:@"sticker-flag-vn-1.lua"];
    path = [NSBundle.mainBundle pathForResource:fileName ofType:nil];
    luaPath = [NSBundle.mainBundle pathForResource:luaName ofType:nil];
    TKSticker sticker52;
    sticker52.path = path.UTF8String;
    sticker52.luaComponentPath = luaPath.UTF8String;
    sticker52.allowChanges = NO;
    sticker52.neededLandmarks.push_back(1);
    sticker52.neededLandmarks.push_back(15);
    sticker52.neededLandmarks.push_back(30);
    sticker52.neededLandmarks.push_back(39);
    sticker52.neededLandmarks.push_back(42);
    stickers5.push_back(sticker52);
    
    _facialStickers->push_back(stickers1);
    _facialStickers->push_back(stickers2);
    _facialStickers->push_back(stickers3);
    _facialStickers->push_back(stickers4);
    _facialStickers->push_back(stickers5);
}

- (void)initFrameStickerList {
    _frameStickers = new std::vector<std::vector<TKSticker>>();
    
    std::vector<TKSticker> fstickers1;
    for (NSInteger i = 0; i < 12; i++) {
        NSString* fileName = [NSString stringWithFormat:@"frame-flower-shakura-%ld.png", (long)i];
        NSString* luaName = [NSString stringWithFormat:@"frame-flower-shakura-%ld.lua", (long)i];
        NSString* path = [NSBundle.mainBundle pathForResource:fileName ofType:nil];
        NSString* luaPath = [NSBundle.mainBundle pathForResource:luaName ofType:nil];
        TKSticker fsticker;
        fsticker.path = path.UTF8String;
        fsticker.luaComponentPath = luaPath.UTF8String;
        fsticker.allowChanges = NO;
        fstickers1.push_back(fsticker);
    }
    
    std::vector<TKSticker> fstickers2;
    for (NSInteger i = 0; i < 3; i++) {
        NSString* fileName = [NSString stringWithFormat:@"frame-lotus-%ld.png", (long)i];
        NSString* luaName = [NSString stringWithFormat:@"frame-lotus-%ld.lua", (long)i];
        NSString* path = [NSBundle.mainBundle pathForResource:fileName ofType:nil];
        NSString* luaPath = [NSBundle.mainBundle pathForResource:luaName ofType:nil];
        TKSticker fsticker;
        fsticker.path = path.UTF8String;
        fsticker.luaComponentPath = luaPath.UTF8String;
        fsticker.allowChanges = NO;
        fstickers2.push_back(fsticker);
    }
    
    std::vector<TKSticker> fstickers3;
    for (NSInteger i = 0; i < 2; i++) {
        NSString* fileName = [NSString stringWithFormat:@"frame-leaves-%ld.png", (long)i];
        NSString* luaName = [NSString stringWithFormat:@"frame-leaves-%ld.lua", (long)i];
        NSString* path = [NSBundle.mainBundle pathForResource:fileName ofType:nil];
        NSString* luaPath = [NSBundle.mainBundle pathForResource:luaName ofType:nil];
        TKSticker fsticker;
        fsticker.path = path.UTF8String;
        fsticker.luaComponentPath = luaPath.UTF8String;
        fsticker.allowChanges = NO;
        fstickers3.push_back(fsticker);
    }
    
    std::vector<TKSticker> fstickers4;
    for (NSInteger i = 0; i < 9; i++) {
        NSString* fileName = [NSString stringWithFormat:@"frame-flower-peony-%ld.png", (long)i];
        NSString* luaName = [NSString stringWithFormat:@"frame-flower-peony-%ld.lua", (long)i];
        NSString* path = [NSBundle.mainBundle pathForResource:fileName ofType:nil];
        NSString* luaPath = [NSBundle.mainBundle pathForResource:luaName ofType:nil];
        TKSticker fsticker;
        fsticker.path = path.UTF8String;
        fsticker.luaComponentPath = luaPath.UTF8String;
        fsticker.allowChanges = NO;
        fstickers4.push_back(fsticker);
    }
    
    _frameStickers->push_back(fstickers1);
    _frameStickers->push_back(fstickers2);
    _frameStickers->push_back(fstickers3);
    _frameStickers->push_back(fstickers4);
}


- (void)initStickerList {
    _stickerList = [NSMutableArray array];
    
    NSMutableArray* stickerName = [NSMutableArray array];
    [stickerName addObject:@"sticker-panda"];
    [stickerName addObject:@"sticker-funny-king"];
    [stickerName addObject:@"sticker-mario"];
    [stickerName addObject:@"sticker-astronaut"];
    
    for (NSString* name in stickerName) {
        NSString* path = [NSBundle.mainBundle pathForResource:name ofType:@"png"];
        if (path) {
            [_stickerList addObject:path];
        }
    }
}

- (void)initfilterResources {

    NSDictionary* dic = @{ @"GLITCH"     : @{ @"class" : @"GPUImageGlitchFilter"     },
                           @"BRIGHTNESS" : @{ @"class" : @"GPUImageBrightnessFilter" },
                           @"SATURATION" : @{ @"class" : @"GPUImageSaturationFilter" },
                           @"CONTRAST"   : @{ @"class" : @"GPUImageContrastFilter"   },
                           @"GAMMA"      : @{ @"class" : @"GPUImageGammaFilter"      },
                           @"RGB"        : @{ @"class" : @"GPUImageRGBFilter"        },
                           @"DEFAULT"    : @{ @"class" : @"GPUImageFilter"           },
                          
                           @"MENTAL"     : @{ @"class" : @"GPUImageLUTFilter" },
                           @"MONO COOL"  : @{ @"class" : @"GPUImageLUTFilter" },
                           @"POLAROID"   : @{ @"class" : @"GPUImageLUTFilter" },
                           @"ROBINSON"   : @{ @"class" : @"GPUImageLUTFilter" },
                           @"SAHA"       : @{ @"class" : @"GPUImageLUTFilter" },
                           @"RUN"        : @{ @"class" : @"GPUImageLUTFilter" },
                           @"SELENA"     : @{ @"class" : @"GPUImageLUTFilter" },
                           @"SEVEN"      : @{ @"class" : @"GPUImageLUTFilter" },
                           @"SOLAR"      : @{ @"class" : @"GPUImageLUTFilter" },
                           @"SUMMER"     : @{ @"class" : @"GPUImageLUTFilter" },
                           @"VINTAGE"    : @{ @"class" : @"GPUImageLUTFilter" },
                           @"WESTERN"    : @{ @"class" : @"GPUImageLUTFilter" },
                           @"ELIZABETH"  : @{ @"class" : @"GPUImageLUTFilter" },
                           @"FASHION"    : @{ @"class" : @"GPUImageLUTFilter" },
                           @"FLOYD"      : @{ @"class" : @"GPUImageLUTFilter" },
                           @"GOTHAM"     : @{ @"class" : @"GPUImageLUTFilter" },
                           @"GRAY"       : @{ @"class" : @"GPUImageLUTFilter" },
                           @"GUARDIAN"   : @{ @"class" : @"GPUImageLUTFilter" },
                           @"GYPSY"      : @{ @"class" : @"GPUImageLUTFilter" },
                           @"HIPSTER"    : @{ @"class" : @"GPUImageLUTFilter" },
                           @"INDIGO"     : @{ @"class" : @"GPUImageLUTFilter" },
                           @"LINDA"      : @{ @"class" : @"GPUImageLUTFilter" },
                           @"BROOKLYN"   : @{ @"class" : @"GPUImageLUTFilter" },
                           @"1971"       : @{ @"class" : @"GPUImageLUTFilter" },
                           @"B & W"      : @{ @"class" : @"GPUImageLUTFilter" },
                           @"CHARCOAL"   : @{ @"class" : @"GPUImageLUTFilter" },
                           @"CLARITY"    : @{ @"class" : @"GPUImageLUTFilter" },
                           @"AMATORKA"   : @{ @"class" : @"GPUImageLUTFilter" },
                           @"BEAUTY"     : @{ @"class" : @"LFGPUImageBeautyFilter" }
                           };
    
    _filterResources = [NSMutableDictionary dictionaryWithCapacity:dic.allKeys.count];
    __weak __typeof(self)weakSelf = self;
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString* _Nonnull key, NSDictionary*  _Nonnull value, BOOL * _Nonnull stop) {
        NSMutableDictionary* value_ = [NSMutableDictionary dictionaryWithDictionary:value];
        NSString* className = [value_ objectForKey:@"class"];
        if ([className isEqualToString:@"GPUImageLUTFilter"]) {
            NSString* imageName = [NSString stringWithFormat:@"lookup-%@", key.lowercaseString];
            NSString* imagePath = [NSBundle.mainBundle pathForResource:imageName ofType:@"png"];
            if (!imagePath) {
                NSLog(@">>>> HV > image path nil: %@", key);
            }
            [value_ setValue:imagePath forKey:@"imagePath"];
        }
        [weakSelf.filterResources setObject:value_ forKey:key];
    }];
}

- (void *)facialStickers {
    return (void *)_facialStickers;
}

- (void *)frameStickers {
    return (void *)_frameStickers;
}

- (void)dealloc {
    if (_facialStickers)
        delete _facialStickers;
    
    if (_frameStickers)
        delete _frameStickers;
}

@end
