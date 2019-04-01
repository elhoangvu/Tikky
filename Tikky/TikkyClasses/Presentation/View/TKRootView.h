//
//  TKRootView.h
//  TKPresentation
//
//  Created by LeHuuNghi on 12/8/18.
//  Copyright © 2018 LeHuuNghi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKBottomMenu.h"
#import "TKTopMenu.h"
#import "TKBottomMenuFactory.h"
#import "TKHorizontalPageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TKRootView : UIView

@property (nonatomic, weak) id viewController;

@property (nonatomic, strong) TKBottomMenu *bottomMenuView;

@property (nonatomic, strong) TKTopMenu *topMenuView;

-(instancetype)initWithView:(UIView *)view;

-(void)setBottomMenuViewWithBottomMenuType:(TKBottomMenuType)bottomMenuType;

@end

NS_ASSUME_NONNULL_END
