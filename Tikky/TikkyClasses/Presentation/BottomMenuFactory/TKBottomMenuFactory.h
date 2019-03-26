//
//  TKBottomMenuFactory.h
//  TKPresentation
//
//  Created by LeHuuNghi on 1/20/19.
//  Copyright © 2019 LeHuuNghi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKFilterBottomMenu.h"
#import "TKMainBottomMenu.h"
#import "TKStickerBottomMenu.h"
#import "TKFacialBottomMenu.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    NoMenu,
    MainMenu,
    FilterMenu,
    StickerMenu,
    FrameMenu,
    FacialMenu
} TKBottomMenuType;

@interface TKBottomMenuFactory : NSObject

+(id)getMenuWithMenuType:(TKBottomMenuType)type;

@end

NS_ASSUME_NONNULL_END
