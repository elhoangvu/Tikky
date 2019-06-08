//
//  TKEditorViewController.h
//  Tikky
//
//  Created by Vu Le Hoang on 6/2/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TKEditorViewController;

@protocol TKEditorViewControllerDelegate <NSObject>

- (void)didTapCloseButtonAtEditorViewController:(TKEditorViewController *)editorVC;

- (void)didTapShareButtonAtEditorViewController:(TKEditorViewController *)editorVC;

@end

@interface TKEditorViewController : UIViewController

@property (nonatomic, weak) id<TKEditorViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
