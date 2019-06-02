//
//  TKFilterFactory.m
//  Tikky
//
//  Created by Le Hoang Vu on 2/10/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "TKFilterCreator.h"

#import "GPUImage.h"

#import "TKSampleDataPool.h"

#import <UIKit/UIKit.h>

#import "GPUImageLUTFilter.h"
#import "LFGPUImageBeautyFilter.h"
#import "TKEffectFilter.h"
#import "InstaFilters.h"

@implementation TKFilterCreator

+ (TKFilter *)newFilterWithName:(NSString *)filterName {
    TKFilter* filter = [[TKFilter alloc] init];
    GPUImageFilter* gpuimageFilter = [TKFilterCreator createFilterWithString:filterName name:filterName];
    if (!gpuimageFilter)
        return nil;
    NSArray* propertyList = [TKFilterCreator createPropertyListWithGPUImageFilter:gpuimageFilter];;
    [filter bindingFilterObj:gpuimageFilter withPropertyList:propertyList];
    return filter;
}

+ (GPUImageFilter *)createFilterWithString:(NSString *)filterString name:(NSString *)name {
    if (!filterString || [filterString isEqualToString:@""]) {
        return nil;
    }
//    NSDictionary* filterResource = TKSampleDataPool.sharedInstance.filterResources;
    
    NSString* uppercaseFilter = filterString.uppercaseString;
//    NSDictionary* filterDic = [filterResource objectForKey:uppercaseFilter];
//    NSString* filterClass = [filterDic objectForKey:@"class"];
//    if (!filterClass || [filterClass isEqualToString:@""]) {
//        return nil;
//    }
    
    GPUImageFilter* filterInstance = nil;
//    if ([filterClass isEqualToString:@"GPUImageLUTFilter"]) {
//        NSString* imagePath = [filterDic objectForKey:@"imagePath"];
//        GPUImageLUTFilter* lutFilter = (GPUImageLUTFilter *)[NSClassFromString(filterClass) alloc];
//        NSData* imageData = [NSData dataWithContentsOfFile:imagePath];
//        UIImage* image = [UIImage imageWithData:imageData];
//        if (image) {
//            filterInstance = (GPUImageFilter *)[lutFilter initWithLookupImage:image];
//        }
//    } else {
//        Class filterClass_ = NSClassFromString([NSString stringWithFormat:@"%@", filterClass]);
//        filterInstance = (GPUImageFilter *)[[filterClass_ alloc] init];
//    }
    
    return filterInstance;
}

+ (NSArray<TKFilterProperty *> *)createPropertyListWithGPUImageFilter:(GPUImageFilter *)gpuimageFilter {
    NSMutableArray* properties = [NSMutableArray array];
    
    if ([gpuimageFilter isKindOfClass:GPUImageLUTFilter.class]) {
        GPUImageLUTFilter* filter = (GPUImageLUTFilter *)gpuimageFilter;
        TKFilterProperty* property = [[TKFilterProperty alloc] initWithName:@"Intensity" minValue:0.0 maxValue:1.0 value:filter.intensity];
        [property bindingValueChangeCallback:^(CGFloat value) {
            [filter setIntensity:value];
        }];
        [properties addObject:property];
    } else if ([gpuimageFilter isKindOfClass:GPUImageBrightnessFilter.class]) {
        GPUImageBrightnessFilter* filter = (GPUImageBrightnessFilter *)gpuimageFilter;
        TKFilterProperty* property = [[TKFilterProperty alloc] initWithName:@"Brightness" minValue:-1.0 maxValue:1.0 value:filter.brightness];
        [property bindingValueChangeCallback:^(CGFloat value) {
            [filter setBrightness:value];
        }];
        [properties addObject:property];
    } else if ([gpuimageFilter isKindOfClass:GPUImageSaturationFilter.class]) {
        GPUImageSaturationFilter* filter = (GPUImageSaturationFilter *)gpuimageFilter;
        TKFilterProperty* property = [[TKFilterProperty alloc] initWithName:@"Saturation" minValue:0.0 maxValue:2.0 value:filter.saturation];
        [property bindingValueChangeCallback:^(CGFloat value) {
            [filter setSaturation:value];
        }];
        [properties addObject:property];
    } else if ([gpuimageFilter isKindOfClass:GPUImageContrastFilter.class]) {
        GPUImageContrastFilter* filter = (GPUImageContrastFilter *)gpuimageFilter;
        TKFilterProperty* property = [[TKFilterProperty alloc] initWithName:@"Contrast" minValue:0.0 maxValue:4.0 value:filter.contrast];
        [property bindingValueChangeCallback:^(CGFloat value) {
            [filter setContrast:value];
        }];
        [properties addObject:property];
    } else if ([gpuimageFilter isKindOfClass:GPUImageGammaFilter.class]) {
        GPUImageGammaFilter* filter = (GPUImageGammaFilter *)gpuimageFilter;
        TKFilterProperty* property = [[TKFilterProperty alloc] initWithName:@"Gamma" minValue:0.0 maxValue:3.0 value:filter.gamma];
        [property bindingValueChangeCallback:^(CGFloat value) {
            [filter setGamma:value];
        }];
        [properties addObject:property];
    } else if ([gpuimageFilter isKindOfClass:GPUImageRGBFilter.class]) {
        GPUImageRGBFilter* filter = (GPUImageRGBFilter *)gpuimageFilter;
        TKFilterProperty* property = [[TKFilterProperty alloc] initWithName:@"Red" minValue:0.0 maxValue:1.0 value:filter.red];
        [property bindingValueChangeCallback:^(CGFloat value) {
            [filter setRed:value];
        }];
        [properties addObject:property];
        TKFilterProperty* property2 = [[TKFilterProperty alloc] initWithName:@"Green" minValue:0.0 maxValue:1.0 value:filter.green];
        [property bindingValueChangeCallback:^(CGFloat value) {
            [filter setGreen:value];
        }];
        [properties addObject:property2];
        TKFilterProperty* property3 = [[TKFilterProperty alloc] initWithName:@"Blue" minValue:0.0 maxValue:1.0 value:filter.blue];
        [property bindingValueChangeCallback:^(CGFloat value) {
            [filter setBlue:value];
        }];
        [properties addObject:property3];
    } else if ([gpuimageFilter isKindOfClass:LFGPUImageBeautyFilter.class]) {
        LFGPUImageBeautyFilter* filter = (LFGPUImageBeautyFilter *)gpuimageFilter;
        TKFilterProperty* property = [[TKFilterProperty alloc] initWithName:@"Beauty" minValue:0.0 maxValue:1.0 value:filter.beautyLevel];
        [property bindingValueChangeCallback:^(CGFloat value) {
            [filter setBeautyLevel:value];
        }];
        [properties addObject:property];
        TKFilterProperty* property2 = [[TKFilterProperty alloc] initWithName:@"Brightness" minValue:0.0 maxValue:1.0 value:filter.brightLevel];
        [property bindingValueChangeCallback:^(CGFloat value) {
            [filter setBrightLevel:value];
        }];
        [properties addObject:property2];
        TKFilterProperty* property3 = [[TKFilterProperty alloc] initWithName:@"Tone" minValue:0.0 maxValue:1.0 value:filter.toneLevel];
        [property bindingValueChangeCallback:^(CGFloat value) {
            [filter setToneLevel:value];
        }];
        [properties addObject:property3];
    }
    
    return properties;
}

@end
