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

void rotate(cv::Mat& src, double angle, cv::Mat& dst);

@interface OpenCVUtilities : NSObject

+ (cv::Mat)matFromSampleBuffer:(CMSampleBufferRef)sampleBuffer;

@end

NS_ASSUME_NONNULL_END
