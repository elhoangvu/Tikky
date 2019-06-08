//
//  UIImage+NSBundle.h
//  Tikky
//
//  Created by Vu Le Hoang on 6/5/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (NSBundle)

+ (UIImage *)imageFromBundleWithName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
