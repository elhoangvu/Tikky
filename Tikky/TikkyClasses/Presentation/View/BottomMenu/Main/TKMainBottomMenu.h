//
//  TKMainBottomMenu.h
//  TKPresentation
//
//  Created by LeHuuNghi on 1/20/19.
//  Copyright © 2019 LeHuuNghi. All rights reserved.
//

#import "TKBottomMenu.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    capture,
    startvideo,
    stopvideo,
} CaptureButtonType;

@protocol TKButtonCaptureVideoDelegate <NSObject>

@optional

-(void)didCapturePhoto;

-(void)didActionVideoWithType:(CaptureButtonType)type;

@end

@interface TKMainBottomMenu : TKBottomMenu

@property (nonatomic) CaptureButtonType captureType;

@property (nonatomic) id<TKButtonCaptureVideoDelegate> delegate;

-(void)setIsCapturePhotoType:(BOOL)isCapturePhotoType;



@end

NS_ASSUME_NONNULL_END
