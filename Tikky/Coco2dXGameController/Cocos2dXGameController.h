//
//  Cocos2dXGameController.h
//  iOSCoco2dXApp
//
//  Created by Ngoc Tuan Le on 10/10/17.
//  Copyright © 2017 LifeOfCoder. All rights reserved.
//

#import <Foundation/Foundation.h>


@class Cocos2dXGameController;

@protocol Cocos2dXGameControllerDelegate <NSObject>

- (void)backToAppFromGameController:(Cocos2dXGameController *)gameController;

@end

@interface Cocos2dXGameController : NSObject

@property (nonatomic, strong) UIView *view;
@property (nonatomic, weak) id<Cocos2dXGameControllerDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame sharegroup:(EAGLSharegroup *)sharegroup;

- (void)backToApp;

@end

