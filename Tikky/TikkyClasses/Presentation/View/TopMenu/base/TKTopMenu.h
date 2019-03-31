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


@protocol TKTopItemDelegate <NSObject>

@optional

-(void)didReverseCamera;

@end

@interface TKTopMenu : UIView

@property (nonatomic, strong) id<TKTopItemDelegate> delegate;

@property (nonatomic, strong) id viewController;

@property (nonatomic, strong) NSArray *items;

@end

NS_ASSUME_NONNULL_END
