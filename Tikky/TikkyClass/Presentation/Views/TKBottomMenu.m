//
//  TKSelectionBar.m
//  TKPresentation
//
//  Created by LeHuuNghi on 12/4/18.
//  Copyright © 2018 LeHuuNghi. All rights reserved.
//

#import "TKBottomMenu.h"
#import "TKBottomMenuItem.h"

@interface TKBottomMenu()

@property (nonatomic, strong) NSArray<TKBottomMenuItem *> *items;

@end

@implementation TKBottomMenu

- (instancetype)init
{
    self = [super init];
    if (self) {
        _items = @[[[TKBottomMenuItem alloc] initWithName:@"photo"],
                   [[TKBottomMenuItem alloc] initWithName:@"emoji"],
                   [[TKBottomMenuItem alloc] initWithName:@"capture"],
                   [[TKBottomMenuItem alloc] initWithName:@"frame"],
                   [[TKBottomMenuItem alloc] initWithName:@"filter"],];
        
        UIStackView *stackView = [UIStackView new];
        stackView.axis = UILayoutConstraintAxisHorizontal;
        stackView.translatesAutoresizingMaskIntoConstraints = false;
        stackView.distribution = UIStackViewDistributionEqualSpacing;
        stackView.alignment = UIStackViewAlignmentCenter;
        stackView.spacing = 15;
        [self addSubview:stackView];
        
        for (TKBottomMenuItem *item in _items) {
//            item.delegate = self;
            item.translatesAutoresizingMaskIntoConstraints = NO;
            item.contentMode = UIViewContentModeScaleAspectFit;
            [stackView addArrangedSubview:item];
            
            if ([item.name isEqualToString:@"capture"]) {
                [[item.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:0.5] setActive:YES];
                [[item.widthAnchor constraintEqualToAnchor:self.heightAnchor multiplier:0.5] setActive:YES];
                [[item.centerXAnchor constraintEqualToAnchor:self.centerXAnchor] setActive:YES];
            } else {
                [[item.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:0.12] setActive:YES];
            }
        }
        
        
        
//        __weak typeof(TKBottomMenuItem *)frontItem = nil;
//        float distance = 0;
//        for (TKBottomMenuItem *item in _items) {
//            item.translatesAutoresizingMaskIntoConstraints = NO;
//            item.contentMode = UIViewContentModeScaleAspectFit;
//            [self addSubview:item];
//
//            [[item.centerYAnchor constraintEqualToAnchor:self.centerYAnchor] setActive:YES];
//
//            if ([item.name isEqualToString:@"capture"]) {
//                [[item.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:0.5] setActive:YES];
//                [[item.centerXAnchor constraintEqualToAnchor:self.centerXAnchor] setActive:YES];
//            } else {
//                [[item.widthAnchor constraintEqualToAnchor:self.heightAnchor multiplier:0.25] setActive:YES];
//                [[item.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:distance] setActive:YES];
//            }
//        }
    }
    return self;
}

- (void)clickItem:(NSString *)nameItem {
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//
//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        
//
////        _subViews = [[NSMutableDictionary alloc] init];
////        
////        [_subViews setValue:[[TKBottomMenuItem alloc] initWithName:@"assert_picker"] forKey:@"assert_picker"];
////        [_subViews setValue:[[TKBottomMenuItem alloc] initWithName:@"emoji"] forKey:@"emoji"];
////        [_subViews setValue:[[TKBottomMenuItem alloc] initWithName:@"capture"] forKey:@"capture"];
////        [_subViews setValue:[[TKBottomMenuItem alloc] initWithName:@"frame"] forKey:@"frame"];
////        [_subViews setValue:[[TKBottomMenuItem alloc] initWithName:@"filter"] forKey:@"filter"];
////        
////        [self drawItem];
////        
////        [[self.subViews objectForKey:@"assert_picker"] setPathImage:[[NSBundle mainBundle] pathForResource:@"assert_picker" ofType:@"png"]];
////        [[self.subViews objectForKey:@"emoji"] setPathImage:[[NSBundle mainBundle] pathForResource:@"emoji" ofType:@"png"]];
////        [[self.subViews objectForKey:@"capture"] setPathImage:[[NSBundle mainBundle] pathForResource:@"capture_button" ofType:@"png"]];
////        [[self.subViews objectForKey:@"frame"] setPathImage:[[NSBundle mainBundle] pathForResource:@"frame" ofType:@"png"]];
////        [[self.subViews objectForKey:@"filter"] setPathImage:[[NSBundle mainBundle] pathForResource:@"filter" ofType:@"png"]];
//        
//    }
//    return self;
//}

- (void)setViewController:(id)viewController {
    _viewController = viewController;
    for (TKBottomMenuItem *item in self.items) {
        item.delegate = self.viewController;
    }
}

- (void)drawItem {
//    int count = 0;
//    float widthItem = (float)(self.bounds.size.width - (float)self.bounds.size.height / 2) / (self.subViews.count - 1);
//    float xItem = 0;
//    [[self.subViews objectForKey:@"assert_picker"] setFrame:CGRectMake( 0, (float)self.bounds.size.height * 17 / 40 , widthItem, (float)self.bounds.size.height / 4)];
//    [[self.subViews objectForKey:@"emoji"] setFrame:CGRectMake( widthItem, (float)self.bounds.size.height * 17 / 40 , widthItem, (float)self.bounds.size.height / 4)];
//    [[self.subViews objectForKey:@"capture"] setFrame:CGRectMake( widthItem * 2, (float)self.bounds.size.height / 4 , (float)self.bounds.size.height / 2, (float)self.bounds.size.height / 2)];
//    [[self.subViews objectForKey:@"frame"] setFrame:CGRectMake( widthItem * 2 + (float)self.bounds.size.height / 2, (float)self.bounds.size.height * 17 / 40 , widthItem, (float)self.bounds.size.height / 4)];
//    [[self.subViews objectForKey:@"filter"] setFrame:CGRectMake( widthItem * 3 + (float)self.bounds.size.height / 2, (float)self.bounds.size.height * 17 / 40 , widthItem, (float)self.bounds.size.height / 4)];
    
//   for (TKBottomMenuItem *item in self.subViews.allValues) {
//       [item.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:self.subViews.count/(self.subViews.count + 1)];
//       [[item.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:0.1] setActive:NO];
//       [self addSubview:item];
//   }
    
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
