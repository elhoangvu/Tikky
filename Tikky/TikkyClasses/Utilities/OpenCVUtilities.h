//
//  OpenCVUtilities.h
//  Tikky
//
//  Created by Le Hoang Vu on 1/31/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <opencv2/opencv.hpp>

NS_ASSUME_NONNULL_BEGIN

@interface OpenCVUtilities : NSObject

+ (cv::Mat)matFromSampleBuffer:(CMSampleBufferRef)sampleBuffer;

+ (void)rotateImage:(cv::Mat &)src angle:(float)angle dst:(cv::Mat &)dst;

@end

NS_ASSUME_NONNULL_END
