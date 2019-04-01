//
//  TKHorizontalPageView.h
//  Tikky
//
//  Created by Le Hoang Vu on 4/1/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TKPageSelectedType) {
    TKPageSelectedTypePhoto = 0,
    TKPageSelectedTypeVideo = 1
};

NS_ASSUME_NONNULL_BEGIN

@protocol TKHorizontalPageViewDelegate;

@interface TKHorizontalPageView : UIView

@property (nonatomic, weak) id<TKHorizontalPageViewDelegate> delegate;

- (instancetype)init NS_UNAVAILABLE;

@end

@protocol TKHorizontalPageViewDelegate <NSObject>

- (void)horizontalPageView:(TKHorizontalPageView *)horizontalPageView didSelectPageType:(TKPageSelectedType)pageType;

@end

NS_ASSUME_NONNULL_END
