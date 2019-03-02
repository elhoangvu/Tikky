//
//  TKDataSamplePool.m
//  Tikky
//
//  Created by Le Hoang Vu on 12/7/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import "TKSampleDataPool.h"
#import "GPUImage.h"

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

    NSDictionary* dic = @{ @"BRIGHTNESS" : @{ @"class" : @"GPUImageBrightnessFilter" },
                           @"SATURATION" : @{ @"class" : @"GPUImageSaturationFilter" },
                           @"CONTRAST"   : @{ @"class" : @"GPUImageContrastFilter"   },
                           @"GAMMA"      : @{ @"class" : @"GPUImageGammaFilter"      },
                           @"RGB"        : @{ @"class" : @"GPUImageRGBFilter"           },
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

@end
