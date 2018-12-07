//
//  TKNavigationBar.m
//  TKPresentation
//
//  Created by LeHuuNghi on 12/3/18.
//  Copyright © 2018 LeHuuNghi. All rights reserved.
//

#import "TKTopMenu.h"
#import "TKTopMenuItem.h"

@interface TKTopMenu()

@end

@implementation TKTopMenu

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //draw
        CGRect newFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height / 10);
        [self setFrame:newFrame];
        
        //add item
        _subViews = [[NSMutableDictionary alloc] init];
        [_subViews setValue:[TKTopMenuItem new] forKey:@"more_item"];
        [_subViews setValue:[TKTopMenuItem new] forKey:@"frame"];
        [_subViews setValue:[TKTopMenuItem new] forKey:@"timed"];
        [_subViews setValue:[TKTopMenuItem new] forKey:@"flash"];
        [_subViews setValue:[TKTopMenuItem new] forKey:@"reverse_camera"];
        [self drawItem];
    }
    return self;
}

- (void)drawItem {
    int count = 0;
    float widthItem = (float)self.bounds.size.width / self.subViews.count;
    for (TKTopMenuItem *item in self.subViews.allValues) {
        float xItem = count * widthItem;
        [item setFrame:CGRectMake( xItem, 0, widthItem, (float)self.bounds.size.height)];
        count++;
        
        [self addSubview:item];
    }
}

@end
