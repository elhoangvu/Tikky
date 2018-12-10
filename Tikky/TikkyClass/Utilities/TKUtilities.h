//
//  TKUtilities.h
//  Tikky
//
//  Created by Le Hoang Vu on 12/11/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TKFocusUtilities : NSObject

+ (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates
                                               inFrame:(CGRect)frame
                                       withOrientation:(UIDeviceOrientation)orientation
                                           andFillMode:(GPUImageFillModeType)fillMode
                                              mirrored:(BOOL)mirrored;
+ (void)setFocus:(CGPoint)focus forDevice:(AVCaptureDevice *)device;

@end
