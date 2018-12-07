//
//  TKSelectionBar.m
//  TKPresentation
//
//  Created by LeHuuNghi on 12/4/18.
//  Copyright © 2018 LeHuuNghi. All rights reserved.
//

#import "TKBottomMenu.h"

@interface TKBottomMenu()<TKBottomItemDelegate>

@end

@implementation TKBottomMenu

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
        CGRect newFrame = CGRectMake( 0, [UIScreen mainScreen].bounds.size.height * 3 /4, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height / 4);
        [self setFrame:newFrame];
        
        //add item
        _subViews = [[NSMutableDictionary alloc] init];
        
        [_subViews setValue:[[TKBottomMenuItem alloc] initWithName:@"assert_picker"] forKey:@"assert_picker"];
        [_subViews setValue:[[TKBottomMenuItem alloc] initWithName:@"emoji"] forKey:@"emoji"];
        [_subViews setValue:[[TKBottomMenuItem alloc] initWithName:@"capture"] forKey:@"capture"];
        [_subViews setValue:[[TKBottomMenuItem alloc] initWithName:@"frame"] forKey:@"frame"];
        [_subViews setValue:[[TKBottomMenuItem alloc] initWithName:@"filter"] forKey:@"filter"];
        
        [self drawItem];
        
        [[self.subViews objectForKey:@"assert_picker"] setPathImage:[[NSBundle mainBundle] pathForResource:@"assert_picker" ofType:@"png"]];
        [[self.subViews objectForKey:@"emoji"] setPathImage:[[NSBundle mainBundle] pathForResource:@"emoji" ofType:@"png"]];
        [[self.subViews objectForKey:@"capture"] setPathImage:[[NSBundle mainBundle] pathForResource:@"capture_button" ofType:@"png"]];
        [[self.subViews objectForKey:@"frame"] setPathImage:[[NSBundle mainBundle] pathForResource:@"frame" ofType:@"png"]];
        [[self.subViews objectForKey:@"filter"] setPathImage:[[NSBundle mainBundle] pathForResource:@"filter" ofType:@"png"]];
    }
    return self;
}

- (void)clickItem:(NSString *)nameItem {
    
}

- (void)setViewController:(id)viewController {
    _viewController = viewController;
    for (TKBottomMenuItem *item in self.subViews.allValues) {
        item.delegate = self.viewController;
    }
}

- (void)drawItem {
//    int count = 0;
    float widthItem = (float)( self.bounds.size.width - (float)self.bounds.size.height / 2) / (self.subViews.count - 1);
//    float xItem = 0;
    [[self.subViews objectForKey:@"assert_picker"] setFrame:CGRectMake( 0, (float)self.bounds.size.height * 17 / 40 , widthItem, (float)self.bounds.size.height / 4)];
    [[self.subViews objectForKey:@"emoji"] setFrame:CGRectMake( widthItem, (float)self.bounds.size.height * 17 / 40 , widthItem, (float)self.bounds.size.height / 4)];
    [[self.subViews objectForKey:@"capture"] setFrame:CGRectMake( widthItem * 2, (float)self.bounds.size.height / 4 , (float)self.bounds.size.height / 2, (float)self.bounds.size.height / 2)];
    [[self.subViews objectForKey:@"frame"] setFrame:CGRectMake( widthItem * 2 + (float)self.bounds.size.height / 2, (float)self.bounds.size.height * 17 / 40 , widthItem, (float)self.bounds.size.height / 4)];
    [[self.subViews objectForKey:@"filter"] setFrame:CGRectMake( widthItem * 3 + (float)self.bounds.size.height / 2, (float)self.bounds.size.height * 17 / 40 , widthItem, (float)self.bounds.size.height / 4)];
    
   for (TKBottomMenuItem *item in self.subViews.allValues) {
       [self addSubview:item];
   }
    
//    for (TKBottomMenuItem *item in self.subViews.allKeys) {
//        [item setFrame:CGRectMake( xItem, (float)self.bounds.size.height * 17 / 40 , widthItem, (float)self.bounds.size.height / 4)];
//        if (count == 3) {
//            [item setFrame:CGRectMake( 2 * widthItem, (float)self.bounds.size.height / 4 , (float)self.bounds.size.height / 2, (float)self.bounds.size.height / 2)];
//            xItem += (float)self.bounds.size.height / 2;
//        } else {
//            if (count < 2) xItem = count * widthItem;
//            else xItem
//        }
//        count++;
//        [self addSubview:item];
//    }
}

@end
