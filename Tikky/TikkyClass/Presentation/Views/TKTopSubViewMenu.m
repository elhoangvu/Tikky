//
//  TKTopSubViewMenu.m
//  TKPresentation
//
//  Created by LeHuuNghi on 12/9/18.
//  Copyright © 2018 LeHuuNghi. All rights reserved.
//

#import "TKTopSubViewMenu.h"
#import "TKTopMenuItem.h"

@implementation TKTopSubViewMenu

- (instancetype)init
{
    self = [super init];
    if (self) {
        _items = @[[[TKTopMenuItem alloc] initWithName:@"3s"],
                      [[TKTopMenuItem alloc] initWithName:@"5s"],
                      [[TKTopMenuItem alloc] initWithName:@"10s"],
                      [[TKTopMenuItem alloc] initWithName:@"15s"],];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
