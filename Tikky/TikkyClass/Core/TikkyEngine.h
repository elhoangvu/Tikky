//
//  ViewController.h
//  Tikky
//
//  Created by Le Hoang Vu on 11/10/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKStickerPreviewer.h"
#import "TKImageFilter.h"

/**
 The main class of project. Include:
 - TKStickerPreviewer: a sticker previewer in the front of view
 - TKImageFilter: a filter view (including camera view) in background view.
 */
@interface TikkyEngine : NSObject

@property (nonatomic) UIView* view;
@property (nonatomic, readonly) TKStickerPreviewer* stickerPreviewer;
@property (nonatomic) TKImageFilter* imageFilter;

+ (instancetype)sharedInstance;

@end

