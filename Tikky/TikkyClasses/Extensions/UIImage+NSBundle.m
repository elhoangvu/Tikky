//
//  UIImage+NSBundle.m
//  Tikky
//
//  Created by Vu Le Hoang on 6/5/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "UIImage+NSBundle.h"

#import "TKUtilities.h"

@implementation UIImage (NSBundle)

+ (UIImage *)imageFromBundleWithName:(NSString *)name {
    return [TKUtilities imageFromBundleWithName:name];
}

@end
