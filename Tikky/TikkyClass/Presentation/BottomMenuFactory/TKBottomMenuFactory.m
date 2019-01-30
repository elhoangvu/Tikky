//
//  TKBottomMenuFactory.m
//  TKPresentation
//
//  Created by LeHuuNghi on 1/20/19.
//  Copyright © 2019 LeHuuNghi. All rights reserved.
//

#import "TKBottomMenuFactory.h"


@implementation TKBottomMenuFactory

+(id)getMenuWithMenuType:(TKBottomMenuType)type {
    if (type == FilterMenu) {
        return [TKFilterBottomMenu new];
    } if (type == StickerMenu) {
        return [TKStickerBottomMenu new];
    } else if (type == MainMenu) {
        return [TKMainBottomMenu new];
    }
    return nil;
}

@end
