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
                           @"LEVELS"     : @{ @"class" : @"GPUImageLevelsFilter"     },
                           @"SATURATION" : @{ @"class" : @"GPUImageSaturationFilter" },
                           @"CONTRAST"   : @{ @"class" : @"GPUImageContrastFilter"   },
                           @"GAMMA"      : @{ @"class" : @"GPUImageGammaFilter"      },
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
                           @"BEAUTY"     : @{ @"class" : @"LFGPUImageBeautyFilter" },
                           @"BEAUTY2"     : @{ @"class" : @"YUGPUImageHighPassSkinSmoothingFilter" }
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
