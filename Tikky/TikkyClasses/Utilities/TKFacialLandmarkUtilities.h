//
//  TKFacialLandmarkUtilities.hpp
//  Tikky
//
//  Created by Le Hoang Vu on 2/3/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#ifndef TKFacialLandmarkUtilities_h
#define TKFacialLandmarkUtilities_h

void flipLandmarks(float* landmarks,
                   int numLandmark,
                   bool flipHorizontal,
                   bool flipVertical,
                   float outputWidth,
                   float outputHeight,
                   float outputWidthScale,
                   float outputHeightScale);

#include <stdio.h>

#endif /* TKFacialLandmarkUtilities_h */
