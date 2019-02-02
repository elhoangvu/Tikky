//
//  SDM.m
//  Tikky
//
//  Created by Le Hoang Vu on 1/30/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "SDM.h"

#include "ldmarkmodel.h"

#include "opencv+parallel_for_.h"

@interface SDM () {
    ldmarkmodel* _modelt;
    std::vector<cv::Mat>* _currentShape;
    float landmarks[NUMBER_OF_LANDMARKS*2];
}

@end

static SDM* instace = nil;

@implementation SDM

@synthesize isLandmarkDebugger = isLandmarkDebugger;

- (instancetype)init
{
    if (!(self = [super init])) {
        return nil;
    }
    
    NSString* haarPath = [NSBundle.mainBundle pathForResource:@"haar_facedetection" ofType:@"xml"];
    NSString* modelPath = [NSBundle.mainBundle pathForResource:@"landmark-model" ofType:@"bin"];
    _modelt = new ldmarkmodel([haarPath UTF8String]);
    bool isLoadLmkModelt = load_ldmarkmodel([modelPath UTF8String], *_modelt);
    _currentShape = new std::vector<cv::Mat>(MAX_FACE_NUM);
    isLandmarkDebugger = NO;
    
    if (!_modelt || !isLoadLmkModelt) {
        if (_modelt)
            delete _modelt;
        if (_currentShape)
            delete _currentShape;
        NSAssert(NO, @"Could not load face detection modelt or landmark modelt");
        return nil;
    }
    
    return self;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instace = [[SDM alloc] init];
    });
    
    return instace;
}

+ (void)freeInstance {
    instace = nil;
}

- (void)dealloc {
    if (_modelt)
        delete _modelt;
    if (_currentShape)
        delete[] _currentShape;
}

- (float *)detectLandmarkWithImage:(cv::Mat &)image newDetection:(BOOL)newDetection {
    static std::vector<cv::Mat> prevShape;
    int ret = _modelt->track(image, *_currentShape, newDetection);
    if (newDetection) {
        prevShape = *_currentShape;
    }
    if (ret == SDM_ERROR_FACENO) {
        landmarks[0] = 0;
        landmarks[NUMBER_OF_LANDMARKS] = 0;
        landmarks[16] = 0;
        landmarks[16 + NUMBER_OF_LANDMARKS] = 0;
        prevShape = *_currentShape;
        return landmarks;
    }
    
//    cv::Vec3d eav;
//    _modelt->EstimateHeadPose((*_currentShape)[0], eav);
//    _modelt->drawPose(image, (*_currentShape)[0], 50);
    parallel_for_(cv::Range(0, MAX_FACE_NUM), [&](const cv::Range& range){
        for (int i = range.start; i < range.end; i++){
            if (!(*_currentShape)[i].empty()){
                int numLandmarks = (*_currentShape)[i].cols / 2;
                for (int j = 0; j < MAX_FACE_NUM; j++) {
                    if (!prevShape[j].empty()) {
                        for (int k = 0; k < numLandmarks; k++) {
                            int preX = prevShape[j].at<float>(k);
                            int preY = prevShape[j].at<float>(k + numLandmarks);
                            
                            int x = (*_currentShape)[i].at<float>(k);
                            int y = (*_currentShape)[i].at<float>(k + numLandmarks);
                            
                            if (abs(preX-x) <= 8) {
                                (*_currentShape)[i].at<float>(k) = preX;
                            } else if (abs(preX-x) <= 16) {
                                (*_currentShape)[i].at<float>(k) = (preX + x)/2.0f;
                            }
                            if (abs(preY-y) <= 8) {
                                (*_currentShape)[i].at<float>(k + numLandmarks) = preY;
                            } else if (abs(preY-y) <= 16) {
                                (*_currentShape)[i].at<float>(k + numLandmarks) = (preY + y)/2.0f;
                            }
                            
                            landmarks[k] = (*_currentShape)[i].at<float>(k);
                            landmarks[k + numLandmarks] = (*_currentShape)[i].at<float>(k + numLandmarks);
                        }
                    }
                }
                
                if (isLandmarkDebugger) {
                    for (int j = 0; j < numLandmarks; j++) {
                        int x = landmarks[j];
                        int y = landmarks[j + numLandmarks];

                        cv::circle(image, cv::Point(x, y), 2, cv::Scalar(0, 0, 255), -1);
                        NSString* lm = [NSString stringWithFormat:@"%d", j];
                        cv::putText(image, lm.UTF8String, cv::Point(x + 5, y), 4, 0.6, cv::Scalar(0, 0, 125));
                    }
                }
            }
        }
    });
//    NSTimeInterval end = [NSDate timeIntervalSinceReferenceDate];
//    NSString* fps = [NSString stringWithFormat:@"FPS: %f", 1.0f/(end - start)];
//    NSLog(@">>>> FPS: %f", 1.0f/(end - start));
    
    prevShape = *_currentShape;
    
    return landmarks;
}

@end
