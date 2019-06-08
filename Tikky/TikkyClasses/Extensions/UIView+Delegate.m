//
//  TikkyEngineView.m
//  Tikky
//
//  Created by Le Hoang Vu on 12/16/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import "UIView+Delegate.h"
#import "TKUtilities.h"

@implementation UIView (Delegate)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        swizzleInstanceMethod(class, @selector(setFrame:), @selector(delegate_setFrame:));
    });
}

- (id<UIViewDelegate>)delegate {
    return objc_getAssociatedObject(self, @selector(delegate));
}

- (void)setDelegate:(id<UIViewDelegate>)delegate {
    objc_setAssociatedObject(self, @selector(delegate), delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)delegate_setFrame:(CGRect)frame {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(view:setFrame:)]) {
            [self.delegate view:self setFrame:frame];
        }
    }
    
    [self delegate_setFrame:frame];
}

@end
