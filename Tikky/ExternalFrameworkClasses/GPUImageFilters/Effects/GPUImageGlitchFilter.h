//
//  GPUImageGlitchFilter.h
//  GlitchFilter
//
//  Created by Le Hoang Vu on 3/4/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "GPUImageFilter+GPUVector2.h"

#import "GPUImageEffectFilterProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface GPUImageGlitchFilter : GPUImageFilter <GPUImageEffectFilterProtocol>

@property (nonatomic) NSInteger fps;

@property (nonatomic) BOOL stillImage;

- (void)randomTime;

@end

NS_ASSUME_NONNULL_END
