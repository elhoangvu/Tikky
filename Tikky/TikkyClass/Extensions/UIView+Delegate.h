//
//  TikkyEngineView.h
//  Tikky
//
//  Created by Le Hoang Vu on 12/16/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIViewDelegate;

@interface UIView (Delegate)

@property (nonatomic, weak) id<UIViewDelegate> delegate;

@end

@protocol UIViewDelegate <NSObject>

- (void)view:(UIView *)view setFrame:(CGRect)frame;

@end

