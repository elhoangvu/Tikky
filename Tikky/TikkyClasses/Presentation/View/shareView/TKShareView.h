//
//  shareView.h
//  Tikky
//
//  Created by LeHuuNghi on 3/13/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TKShareViewDataSource;

@interface TKShareView : UIView

@property (nonatomic) UIImageView *facebook;

@property (nonatomic) UIImageView *twitter;

@property (nonatomic, weak) id<TKShareViewDataSource> dataSource;

@end

@protocol TKShareViewDataSource <NSObject>

@required
- (UIImage *)sharedImage;

- (UIViewController *)myViewController;

@end

NS_ASSUME_NONNULL_END
