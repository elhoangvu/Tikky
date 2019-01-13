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
        
        UIStackView *stackView = [UIStackView new];
        stackView.axis = UILayoutConstraintAxisHorizontal;
        stackView.translatesAutoresizingMaskIntoConstraints = false;
        stackView.distribution = UIStackViewDistributionEqualSpacing;
        stackView.alignment = UIStackViewAlignmentCenter;
        stackView.spacing = 30;
        [self addSubview:stackView];
        
        for (TKTopMenuItem *item in _items) {
            item.delegate = self;
            item.translatesAutoresizingMaskIntoConstraints = NO;
            item.contentMode = UIViewContentModeScaleAspectFit;
            [stackView addArrangedSubview:item];

            [[item.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:0.1] setActive:YES];
        }
        [[stackView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor] setActive:true];
//        [stackView.widthAnchor constraintEqualToAnchor:self.widthAnchor];
//        [stackView.heightAnchor constraintEqualToAnchor:self.heightAnchor];
//        [stackView.topAnchor constraintEqualToAnchor:self.topAnchor];

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
