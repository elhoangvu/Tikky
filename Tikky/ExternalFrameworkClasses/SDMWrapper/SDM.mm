//
//  SDM.m
//  Tikky
//
//  Created by Le Hoang Vu on 1/30/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "SDM.h"

#include "opencv+parallel_for_.h"

@interface SDM () {
    ldmarkmodel* _modelt;
    std::vector<cv::Mat>* _currentShape;
    float** landmarks;
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
    
    self.lastDetectedLandmarks = NO;
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
    landmarks = new float*[MAX_FACE_NUM];
    for (int i = 0; i < MAX_FACE_NUM; i++) {
        landmarks[i] = new float[NUMBER_OF_LANDMARKS];
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
    if (landmarks) {
        for (int i = 0; i < MAX_FACE_NUM; i++) {
            if (landmarks[i])
                delete[] landmarks[i];
        }
        delete[] landmarks;
    }
}

- (void)detectLandmarksWithImage:(cv::Mat &)image
                    newDetection:(BOOL)newDetection
                    sortFaceRect:(BOOL)sortFaceRect
                      completion:(void (^)(float** landmarks, int faceNum))completion {
    static std::vector<cv::Mat> prevShape;
    int facenum = 0;
    int ret = _modelt->track(image, *_currentShape, sortFaceRect, newDetection);
    if (newDetection) {
        prevShape = *_currentShape;
    }
    if (ret == SDM_ERROR_FACENO) {
        self.lastDetectedLandmarks = NO;
        prevShape = *_currentShape;
        if (completion) {
            completion(landmarks, facenum);
        }
        return;
    }
    self.lastDetectedLandmarks = YES;
//    cv::Vec3d eav;
//    _modelt->EstimateHeadPose((*_currentShape)[0], eav);
//    _modelt->drawPose(image, (*_currentShape)[0], 50);
    
    parallel_for_(cv::Range(0, MAX_FACE_NUM), [&](const cv::Range& range){
        for (int i = range.start; i < range.end; i++){
            if (!(*_currentShape)[i].empty()){
                int numLandmarks = (*_currentShape)[i].cols / 2;
                for (int j = 0; j < MAX_FACE_NUM; j++) {
                    if (!prevShape[j].empty()) {
                        if (abs(prevShape[j].at<float>(17) - (*_currentShape)[i].at<float>(17)) < 16
                            && abs(prevShape[j].at<float>(17 + MAX_FACE_NUM) - (*_currentShape)[i].at<float>(17 + MAX_FACE_NUM)) < 16
                            && abs(prevShape[j].at<float>(5) - (*_currentShape)[i].at<float>(5)) < 16
                            && abs(prevShape[j].at<float>(5 + MAX_FACE_NUM) - (*_currentShape)[i].at<float>(5 + MAX_FACE_NUM)) < 16
                            && abs(prevShape[j].at<float>(10) - (*_currentShape)[i].at<float>(10)) < 16
                            && abs(prevShape[j].at<float>(10 + MAX_FACE_NUM) - (*_currentShape)[i].at<float>(10 + MAX_FACE_NUM)) < 16
                            && abs(prevShape[j].at<float>(26) - (*_currentShape)[i].at<float>(26)) < 16
                            && abs(prevShape[j].at<float>(26 + MAX_FACE_NUM) - (*_currentShape)[i].at<float>(26 + MAX_FACE_NUM)) < 16
                            && abs(prevShape[j].at<float>(33) - (*_currentShape)[i].at<float>(33)) < 16
                            && abs(prevShape[j].at<float>(33 + MAX_FACE_NUM) - (*_currentShape)[i].at<float>(33 + MAX_FACE_NUM)) < 16) {
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
                                
                                landmarks[i][k] = (*_currentShape)[i].at<float>(k);
                                landmarks[i][k + numLandmarks] = (*_currentShape)[i].at<float>(k + numLandmarks);
                            }
                            break;
                        }
                    }
                    
                    if (j == MAX_FACE_NUM - 1) {
                        for (int k = 0; k < numLandmarks; k++) {
                            landmarks[i][k] = (*_currentShape)[i].at<float>(k);
                            landmarks[i][k + numLandmarks] = (*_currentShape)[i].at<float>(k + numLandmarks);
                        }
                    }
                }
                
                if (isLandmarkDebugger) {
                    for (int j = 0; j < numLandmarks; j++) {
                        int x = landmarks[i][j];
                        int y = landmarks[i][j + numLandmarks];

                        cv::circle(image, cv::Point(x, y), 2, cv::Scalar(0, 0, 255), -1);
                        NSString* lm = [NSString stringWithFormat:@"%d", j];
                        cv::putText(image, lm.UTF8String, cv::Point(x + 5, y), 4, 0.6, cv::Scalar(0, 0, 125));
                    }
                }
                
                facenum++;
            }
        }
    });
    prevShape = *_currentShape;
    if (completion) {
        completion(landmarks, facenum);
    }
}

@end
