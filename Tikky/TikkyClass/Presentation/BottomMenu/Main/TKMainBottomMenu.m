//
//  TKMainBottomMenu.m
//  TKPresentation
//
//  Created by LeHuuNghi on 1/20/19.
//  Copyright © 2019 LeHuuNghi. All rights reserved.
//

#import "TKMainBottomMenu.h"
#import "TKMainBottomMenuItem.h"

@interface TKMainBottomMenu()

@property (nonatomic, strong) NSArray<TKMainBottomMenuItem *> *items;

@end

@implementation TKMainBottomMenu

- (instancetype)init
{
    self = [super init];
    if (self) {
        _items = @[[[TKMainBottomMenuItem alloc] initWithName:@"photo"],
                   [[TKMainBottomMenuItem alloc] initWithName:@"emoji"],
                   [[TKMainBottomMenuItem alloc] initWithName:@"capture"],
                   [[TKMainBottomMenuItem alloc] initWithName:@"frame"],
                   [[TKMainBottomMenuItem alloc] initWithName:@"filter"],];
        
        UIStackView *stackView = [UIStackView new];
        stackView.axis = UILayoutConstraintAxisHorizontal;
        stackView.translatesAutoresizingMaskIntoConstraints = NO;
        stackView.distribution = UIStackViewDistributionEqualSpacing;
        stackView.alignment = UIStackViewAlignmentCenter;
        stackView.spacing = 15;
        [self addSubview:stackView];
        
        for (TKMainBottomMenuItem *item in _items) {
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
        
        [[stackView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor] setActive:YES];
    }
    return self;
}

- (void)setViewController:(id)viewController {
    [super setViewController:viewController];
    for (TKMainBottomMenuItem *item in self.items) {
        item.delegate = viewController;
    }
}

@end
