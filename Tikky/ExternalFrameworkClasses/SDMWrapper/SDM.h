//
//  SDM.h
//  Tikky
//
//  Created by Le Hoang Vu on 1/30/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <opencv2/opencv.hpp>

#import "TKFacialLandmarkDetector.h"

#include "ldmarkmodel.h"

#define NUMBER_OF_LANDMARKS 68

NS_ASSUME_NONNULL_BEGIN

@interface SDM : TKFacialLandmarkDetector

+ (instancetype)sharedInstance;

+ (void)freeInstance;

@end

NS_ASSUME_NONNULL_END
