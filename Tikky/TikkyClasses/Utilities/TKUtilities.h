//
//  TKUtilities.h
//  Tikky
//
//  Created by Le Hoang Vu on 12/11/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

void swizzleInstanceMethod(Class swizzledClass, SEL originalSelector, SEL swizzledSelector);

@interface TKUtilities : NSObject

+ (UIImage *)imageFromBundleWithName:(NSString *)name;

@end
