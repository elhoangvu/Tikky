//
//  TKNavigationBar.m
//  TKPresentation
//
//  Created by LeHuuNghi on 12/3/18.
//  Copyright © 2018 LeHuuNghi. All rights reserved.
//

#import "TKTopMenu.h"

@interface TKTopMenu()<TKTopItemDelegate>

@property (nonatomic, strong) TKTopSubViewMenu *subMenuView;

@end

@implementation TKTopMenu

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        _items = @[[[TKTopMenuItem alloc] initWithName:@"more"],
                   [[TKTopMenuItem alloc] initWithName:@"raito"],
                   [[TKTopMenuItem alloc] initWithName:@"time"],
                   [[TKTopMenuItem alloc] initWithName:@"flash"],
                   [[TKTopMenuItem alloc] initWithName:@"reverse"],];
        
        __weak typeof(TKTopMenuItem *)frontItem = nil;
        for (TKTopMenuItem *item in _items) {
            item.delegate = self;
            item.translatesAutoresizingMaskIntoConstraints = NO;
            item.contentMode = UIViewContentModeScaleAspectFit;
            [self addSubview:item];
            
            [[item.centerYAnchor constraintEqualToAnchor:self.centerYAnchor constant:-40] setActive:YES];
            
            [[item.widthAnchor constraintEqualToAnchor:self.heightAnchor multiplier:0.125] setActive:YES];
            
            if (!frontItem) {
                [[item.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:50] setActive:YES];
            } else {
                [[item.leadingAnchor constraintEqualToAnchor:frontItem.trailingAnchor constant:50.0] setActive:YES];
            }
            frontItem = item;
        }
    }
    return self;
}

- (void)clickItem:(NSString *)nameItem {
    

    
}

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        //draw
//        CGRect newFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height / 10);
//        [self setFrame:newFrame];
//
//        //add item
//        _subViews = [[NSMutableDictionary alloc] init];
//        [_subViews setValue:[TKTopMenuItem new] forKey:@"more_item"];
//        [_subViews setValue:[TKTopMenuItem new] forKey:@"frame"];
//        [_subViews setValue:[TKTopMenuItem new] forKey:@"timed"];
//        [_subViews setValue:[TKTopMenuItem new] forKey:@"flash"];
//        [_subViews setValue:[TKTopMenuItem new] forKey:@"reverse_camera"];
//        [self drawItem];
//    }
//    return self;
//}

@end
