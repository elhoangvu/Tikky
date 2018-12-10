//
//  TKUtilities.m
//  Tikky
//
//  Created by Le Hoang Vu on 12/11/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import "TKUtilities.h"

@implementation TKFocusUtilities


+ (void)setFocus:(CGPoint)focus forDevice:(AVCaptureDevice *)device {
    if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:AVCaptureFocusModeAutoFocus])
    {
        NSError *error;
        if ([device lockForConfiguration:&error])
        {
            [device setFocusPointOfInterest:focus];
            [device setFocusMode:AVCaptureFocusModeAutoFocus];
            [device unlockForConfiguration];
        }
    }
    
    if ([device isExposurePointOfInterestSupported] && [device isExposureModeSupported:AVCaptureExposureModeAutoExpose])
    {
        NSError *error;
        if ([device lockForConfiguration:&error])
        {
            [device setExposurePointOfInterest:focus];
            [device setExposureMode:AVCaptureExposureModeAutoExpose];
            [device unlockForConfiguration];
        }
    }
}

@end
