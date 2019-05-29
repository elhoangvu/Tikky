//
//  EditViewController.h
//  Tikky
//
//  Created by LeHuuNghi on 3/6/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EditViewController : UIViewController

@property (nonatomic) UIImageView *imageView;

@property (nonatomic) UIView* editView;

@property (nonatomic) UIImageView *shareButton;

@property (nonatomic) UIImageView *editButton;

@property (nonatomic) UIImageView *deleteButton;

- (instancetype)initWithImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
