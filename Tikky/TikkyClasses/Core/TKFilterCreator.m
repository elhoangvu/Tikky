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
    NSDictionary* filterResource = TKSampleDataPool.sharedInstance.filterResources;
    
    NSString* uppercaseFilter = filterString.uppercaseString;
    NSDictionary* filterDic = [filterResource objectForKey:uppercaseFilter];
    NSString* filterClass = [filterDic objectForKey:@"class"];
    if (!filterClass || [filterClass isEqualToString:@""]) {
        return nil;
    }
    
    GPUImageFilter* filterInstance = nil;
    if ([filterClass isEqualToString:@"GPUImageLUTFilter"]) {
        NSString* imagePath = [filterDic objectForKey:@"imagePath"];
        GPUImageLUTFilter* lutFilter = (GPUImageLUTFilter *)[NSClassFromString(filterClass) alloc];
        NSData* imageData = [NSData dataWithContentsOfFile:imagePath];
        UIImage* image = [UIImage imageWithData:imageData];
        if (image) {
            filterInstance = (GPUImageFilter *)[lutFilter initWithLookupImage:image];
        }
    } else {
        Class filterClass_ = NSClassFromString([NSString stringWithFormat:@"%@", filterClass]);
        filterInstance = (GPUImageFilter *)[[filterClass_ alloc] init];
    }
    
    return filterInstance;
}

+ (NSArray<TKFilterProperty *> *)createPropertyListWithGPUImageFilter:(GPUImageFilter *)gpuimageFilter {
    NSMutableArray* properties = [NSMutableArray array];
    
    if ([gpuimageFilter isKindOfClass:GPUImageLUTFilter.class]) {
        GPUImageLUTFilter* filter = (GPUImageLUTFilter *)gpuimageFilter;
        TKFilterProperty* property = [[TKFilterProperty alloc] initWithName:@"Intensity" minValue:0.0 maxValue:1.0 value:filter.intensity];
        [properties addObject:property];
    } else if ([gpuimageFilter isKindOfClass:GPUImageBrightnessFilter.class]) {
        GPUImageBrightnessFilter* filter = (GPUImageBrightnessFilter *)gpuimageFilter;
        TKFilterProperty* property = [[TKFilterProperty alloc] initWithName:@"Brightness" minValue:-1.0 maxValue:1.0 value:filter.brightness];
        [properties addObject:property];
    } else if ([gpuimageFilter isKindOfClass:GPUImageSaturationFilter.class]) {
        GPUImageSaturationFilter* filter = (GPUImageSaturationFilter *)gpuimageFilter;
        TKFilterProperty* property = [[TKFilterProperty alloc] initWithName:@"Saturation" minValue:0.0 maxValue:2.0 value:filter.saturation];
        [properties addObject:property];
    } else if ([gpuimageFilter isKindOfClass:GPUImageContrastFilter.class]) {
        GPUImageContrastFilter* filter = (GPUImageContrastFilter *)gpuimageFilter;
        TKFilterProperty* property = [[TKFilterProperty alloc] initWithName:@"Contrast" minValue:0.0 maxValue:4.0 value:filter.contrast];
        [properties addObject:property];
    } else if ([gpuimageFilter isKindOfClass:GPUImageGammaFilter.class]) {
        GPUImageGammaFilter* filter = (GPUImageGammaFilter *)gpuimageFilter;
        TKFilterProperty* property = [[TKFilterProperty alloc] initWithName:@"Gamma" minValue:0.0 maxValue:3.0 value:filter.gamma];
        [properties addObject:property];
    } else if ([gpuimageFilter isKindOfClass:LFGPUImageBeautyFilter.class]) {
        LFGPUImageBeautyFilter* filter = (LFGPUImageBeautyFilter *)gpuimageFilter;
        TKFilterProperty* property = [[TKFilterProperty alloc] initWithName:@"Beauty" minValue:0.0 maxValue:1.0 value:filter.beautyLevel];
        [properties addObject:property];
        TKFilterProperty* property2 = [[TKFilterProperty alloc] initWithName:@"Brightness" minValue:0.0 maxValue:1.0 value:filter.brightLevel];
        [properties addObject:property2];
        TKFilterProperty* property3 = [[TKFilterProperty alloc] initWithName:@"Tone" minValue:0.0 maxValue:1.0 value:filter.toneLevel];
        [properties addObject:property3];
    }
    
    return properties;
}

@end
