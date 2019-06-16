//
//  TKNotificationViewController.h
//  Tikky
//
//  Created by Vu Le Hoang on 6/12/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TKNotificationType) {
    TKNotificationTypeSuccess,
    TKNotificationTypeFailture
};

@class TKNotificationViewController;

@protocol TKNotificationViewControllerDelegate <NSObject>

- (void)didTapLeftButtonWithNotificationViewController:(TKNotificationViewController *)notificationVC;

- (void)didTapRightButtonWithNotificationViewController:(TKNotificationViewController *)notificationVC;

@end

NS_ASSUME_NONNULL_BEGIN

@interface TKNotificationViewController : UIViewController

@property (nonatomic) NSString* topTitle;

@property (nonatomic) NSString* leftButtonName;

@property (nonatomic) NSString* rightButtonName;

@property (nonatomic) NSString* subTitle;

@property (nonatomic) CGSize contentSize;

@property (nonatomic) TKNotificationType type;

@property (nonatomic, weak) id<TKNotificationViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
