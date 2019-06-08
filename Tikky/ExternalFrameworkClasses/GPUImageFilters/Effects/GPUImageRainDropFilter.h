//
//  GPUImageRainDropFilter.h
//  GlitchFilter
//
//  Created by Le Hoang Vu on 3/26/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "GPUImageFilter.h"

NS_ASSUME_NONNULL_BEGIN

@interface GPUImageRainDropFilter : GPUImageFilter

@property (nonatomic) NSInteger speed;

@property (nonatomic) BOOL stillImage;

- (void)randomTime;

@end

NS_ASSUME_NONNULL_END
