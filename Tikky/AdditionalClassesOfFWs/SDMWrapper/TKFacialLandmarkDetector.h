//
//  TKFacialLandmarkDetector.h
//  Tikky
//
//  Created by Le Hoang Vu on 1/30/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <opencv2/opencv.hpp>

NS_ASSUME_NONNULL_BEGIN

@interface TKFacialLandmarkDetector : NSObject

@property (nonatomic) BOOL isLandmarkDebugger;

- (void)detectLandmarksWithImage:(cv::Mat &)image
                    newDetection:(BOOL)newDetection
                      completion:(void (^)(float** _Nullable landmarks, int faceNum))completion;

@end

NS_ASSUME_NONNULL_END
