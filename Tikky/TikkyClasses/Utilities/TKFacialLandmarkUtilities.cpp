//
//  TKFacialLandmarkUtilities.cpp
//  Tikky
//
//  Created by Le Hoang Vu on 2/3/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#include "TKFacialLandmarkUtilities.h"
#include "opencv+parallel_for_.h"

void flipLandmarks(float** landmarks,
                   int numLandmarks,
                   int numFaces,
                   bool flipHorizontal,
                   bool flipVertical,
                   float outputWidth,
                   float outputHeight,
                   float outputWidthScale,
                   float outputHeightScale) {
    static const int hflippingConverter[68] = {
    //  0     1     2     3     4     5     6     7     8     9
        16,  15,   14,   13,   12,   11,   10,    9,    8,   -1,
    //  10   11    12    13    14    15    16    17    18    19
        -1,  -1,   -1,   -1,   -1,   -1,   -1,   26,   25,   24,
    //  20   21    22    23    24    25    26    27    28    29
        23,  22,   -1,   -1,   -1,   -1,   -1,   27,   28,   29,
    //  30   31    32    33    34    35    36    37    38    39
        30,  35,   34,   33,   -1,   -1,   45,   44,   43,   42,
    //  40   41    42    43    44    45    46    47    48    49
        47,  46,   -1,   -1,   -1,   -1,   -1,   -1,   54,   53,
    //  50   51    52    53    54    55    56    57    58    59
        52,  51,   -1,   -1,   -1,   59,   58,   57,   -1,   -1,
    //  60   61    62    63    64    65    66    67    68    69
        64,  63,   62,   -1,   -1,   67,   66,   -1
    };
    if (numLandmarks != 68) {
        printf("Flip horizotal landmarks support 68 landmark points only.");
    }
    parallel_for_(cv::Range(0, numFaces), [&](const cv::Range& range) {
        for (int i = range.start; i < range.end; i++) {
            for (int j = 0; j < numLandmarks; j++) {
                int k = hflippingConverter[j];
                if (flipHorizontal) {
                    if (k >= 0 && k != j) {
                        std::swap(landmarks[i][j], landmarks[i][k]);
                        std::swap(landmarks[i][j+numLandmarks], landmarks[i][k+numLandmarks]);
                    }
                    landmarks[i][j] = (outputWidth-landmarks[i][j])*outputWidthScale;
                } else {
                    landmarks[i][j] = landmarks[i][j]*outputWidthScale;
                }
                if (flipVertical) {
                    landmarks[i][j+numLandmarks] = (outputHeight-landmarks[i][j+numLandmarks])*outputHeightScale;
                } else {
                    landmarks[i][j+numLandmarks] = landmarks[i][j+numLandmarks]*outputHeightScale;
                }
            }
        }
    });
}
