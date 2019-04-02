//
//  TKSelectionBar.h
//  TKPresentation
//
//  Created by LeHuuNghi on 12/4/18.
//  Copyright © 2018 LeHuuNghi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKBottomMenuItem.h"

NS_ASSUME_NONNULL_BEGIN

//@protocol TKBottomMenuDelegate <NSObject>
//
//
//@end

@interface TKBottomMenu : UIView

@property (nonatomic, weak) id cameraViewController;

@property (nonatomic, weak) id viewController;

@property (nonatomic, strong) NSMutableDictionary *subViews;

@end

NS_ASSUME_NONNULL_END
