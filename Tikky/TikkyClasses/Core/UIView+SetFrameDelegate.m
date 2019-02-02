//
//  TikkyEngineView.m
//  Tikky
//
//  Created by Le Hoang Vu on 12/16/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import "UIView+SetFrameDelegate.h"

@implementation TikkyEngineView

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    if (_delegate && [_delegate respondsToSelector:@selector(tikkyEngineView:setFrame:)]) {
        [_delegate tikkyEngineView:self setFrame:frame];
    }
}

@end
