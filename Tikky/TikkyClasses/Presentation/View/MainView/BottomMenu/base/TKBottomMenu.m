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

- (void)clickItem:(NSString *)nameItem {
    
}

- (void)setViewController:(id)viewController {
    _viewController = viewController;
    for (TKBottomMenuItem *item in self.items) {
        item.delegate = self.viewController;
    }
}

@end
