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

- (instancetype)initWithLookupImage:(UIImage *)lookupImage;
- (void)setLookupImage:(UIImage *)lookupImage;

@end

#endif /* ZALookupFilter_h */
