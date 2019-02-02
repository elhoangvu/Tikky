//
//  UIImage+CVPixelBufferRefConverter.h
//  Tikky
//
//  Created by Le Hoang Vu on 2/2/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (CVPixelBufferRefConverter)

- (CVPixelBufferRef)CVPixelBufferRef ;

@end

NS_ASSUME_NONNULL_END
