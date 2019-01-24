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

- (void)clickItem:(NSString *)nameItem {
    
}

- (void)setViewController:(id)viewController {
    _viewController = viewController;
    for (TKBottomMenuItem *item in self.items) {
        item.delegate = self.viewController;
    }
}

- (void)drawItem {

}

@end
