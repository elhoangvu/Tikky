//
//  TKCameraGUIView.h
//  Tikky
//
//  Created by Vu Le Hoang on 6/5/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TKCameraGUIView;

@protocol TKCameraGUIViewDelegate <NSObject>

- (void)didTapCaptureButtonAtCameraGUIView:(TKCameraGUIView *)cameraGUIView;

- (void)didTapSwapButtonAtCameraGUIView:(TKCameraGUIView *)cameraGUIView;

@end

@interface TKCameraGUIView : UIView

@property (nonatomic, weak) id<TKCameraGUIViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END