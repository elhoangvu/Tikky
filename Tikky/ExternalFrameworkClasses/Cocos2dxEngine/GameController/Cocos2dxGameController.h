//
//  Cocos2dxGameController.h
//  Tikky
//
//  Created by Le Hoang Vu on 12/3/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import <Foundation/Foundation.h>


@class Cocos2dxGameController;

@protocol Cocos2dXGameControllerDelegate <NSObject>

- (void)backToAppFromGameController:(Cocos2dxGameController *)gameController;

@end

@interface Cocos2dxGameController : NSObject

@property (nonatomic, strong) UIView *view;
@property (nonatomic, weak) id<Cocos2dXGameControllerDelegate> delegate;

// Init cocos game controller
- (instancetype)initWithFrame:(CGRect)frame sharegroup:(EAGLSharegroup *)sharegroup;

// Run cocos with intial scene
- (void)runWithCocos2dxScene:(void *)cocos2dxScene;

// Set frame for cocos2d view
- (void)setFrame:(CGRect)frame;

- (void)backToApp;

@end

