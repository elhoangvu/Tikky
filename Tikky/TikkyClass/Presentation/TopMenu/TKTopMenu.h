//
//  TKNavigationBar.h
//  TKPresentation
//
//  Created by LeHuuNghi on 12/3/18.
//  Copyright © 2018 LeHuuNghi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKTopMenuItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface TKTopMenu : UIView

@property (nonatomic, strong) id viewController;

@property (nonatomic, strong) NSArray *items;

@end

NS_ASSUME_NONNULL_END
