//
//  ZALookupFilter.h
//  GPUImageDemo
//
//  Created by CPU11680 on 8/17/18.
//  Copyright © 2018 CPU11680. All rights reserved.
//

#ifndef ZALookupFilter_h
#define ZALookupFilter_h

#import <Foundation/Foundation.h>

#import "GPUImage.h"

@interface GPUImageLUTFilter : GPUImageFilterGroup

@property (nonatomic) CGFloat intensity;

/**
 Init LUT filter with lookup image

 @param lookupImage Lookup image to define filter color
 @return Instancetype
 */
- (instancetype)initWithLookupImage:(UIImage *)lookupImage;

/**
 Set lookup image for current LUT filter

 @param lookupImage New lookup image to define filter color
 */
- (void)setLookupImage:(UIImage *)lookupImage;

@end

#endif /* ZALookupFilter_h */
