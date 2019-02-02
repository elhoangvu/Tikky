//
//  TKFilter.m
//  Tikky
//
//  Created by Le Hoang Vu on 12/7/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import "TKFilter.h"
#import "GPUImage.h"
#import "TKSampleDataPool.h"
#import "GPUImageLUTFilter.h"
#import "LFGPUImageBeautyFilter.h"

@interface TKFilter ()

@property (nonatomic) NSDictionary* filterResource;
@property (nonatomic) GPUImageFilter* filter;

@end

@implementation TKFilter

- (instancetype)init {
    if (!(self = [self initWithName:@"default"])) {
        return nil;
    }
    
    return self;
}

- (instancetype)initWithName:(NSString *)name {
    if (!(self = [super init])) {
        return nil;
    }
    
    _filterResource = TKSampleDataPool.sharedInstance.filterResources;
    _filter = [self createFilterWithString:name name:name];
    
    if (!_filter) {
        return nil;
    }
    
    _sharedObject = _filter;
    _name = name;
    
    return self;
}

- (GPUImageFilter *)createFilterWithString:(NSString *)filterString name:(NSString *)name {
    if (!filterString || [filterString isEqualToString:@""]) {
        return nil;
    }
    
    NSString* uppercaseFilter = filterString.uppercaseString;
    NSDictionary* filterDic = [_filterResource objectForKey:uppercaseFilter];
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
    
//    if (filterInstance) {
//        filterInstance.name = name;
//    }
    
    return filterInstance;
}

@end
