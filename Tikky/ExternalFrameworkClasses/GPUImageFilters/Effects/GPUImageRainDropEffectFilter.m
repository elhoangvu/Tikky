//
//  GPUImageRainDropEffectFilter.m
//  GPUImageDemo
//
//  Created by Vu. Le Hoang (3) on 4/7/19.
//  Copyright © 2019 CPU11750. All rights reserved.
//

#import "GPUImageRainDropEffectFilter.h"
#import "GPUImageGaussianBlurFilter.h"
#import "GPUImageiOSBlurFilter.h"
#import "GPUImageRainDropFilter.h"

@interface GPUImageRainDropEffectFilter ()

@property (nonatomic) GPUImageRainDropFilter* rainDropFilter;
@property (nonatomic) GPUImageGaussianBlurFilter* blurFilter;

@end

@implementation GPUImageRainDropEffectFilter

- (instancetype)init {
    if (!(self = [super init])) {
        return nil;
    }
    
    _rainDropFilter = [[GPUImageRainDropFilter alloc] init];
    _blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
    _blurFilter.blurRadiusInPixels = 5.0;
    
    [_blurFilter addTarget:_rainDropFilter];
    [self setInitialFilters:@[_blurFilter]];
    [self setTerminalFilter:_rainDropFilter];
    
    return self;
}

- (void)randomTime {
    [_rainDropFilter randomTime];
}

@end
