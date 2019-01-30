//
//  TKUtilities.h
//  Tikky
//
//  Created by Le Hoang Vu on 12/11/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

void swizzleInstanceMethod(Class swizzledClass, SEL originalSelector, SEL swizzledSelector);

