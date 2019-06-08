//
//  GPUImageRainDropEffectFilter.h
//  GPUImageDemo
//
//  Created by Vu. Le Hoang (3) on 4/7/19.
//  Copyright © 2019 CPU11750. All rights reserved.
//

#import "GPUImageFilterGroup.h"

#import "GPUImageEffectFilterProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface GPUImageRainDropEffectFilter : GPUImageFilterGroup <GPUImageEffectFilterProtocol>

- (void)randomTime;

@end

NS_ASSUME_NONNULL_END
