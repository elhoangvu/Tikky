//
//  Cocos2dXGameController.m
//  iOSCoco2dXApp
//
//  Created by Ngoc Tuan Le on 10/10/17.
//  Copyright © 2017 LifeOfCoder. All rights reserved.
//

#import "Cocos2dxGameController.h"
#import "cocos2d.h"
#import "CCAppDelegate.h"
#import "platform/ios/CCEAGLView-ios.h"
#import "base/CCDirector.h"
#import "TKStickerPreviewer.h"

@interface Cocos2dxGameController () {
    cocos2d::Scene* _firstScene;
}

@end

@implementation Cocos2dxGameController

- (instancetype)initWithFrame:(CGRect)frame sharegroup:(EAGLSharegroup *)sharegroup {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appIsInBackground:) name:TKNotificationAppIsInBackground object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBackToForeground:) name:TKNotificationAppBackToForeground object:nil];


        CCEAGLView *eaglView = [CCEAGLView viewWithFrame:frame
                                             pixelFormat:(__bridge NSString *)cocos2d::GLViewImpl::_pixelFormat
                                             depthFormat:cocos2d::GLViewImpl::_depthFormat
                                      preserveBackbuffer:NO
                                              sharegroup:sharegroup
                                           multiSampling:NO
                                         numberOfSamples:0];
        eaglView.backgroundColor = [UIColor clearColor];
        [eaglView setMultipleTouchEnabled:YES];
        
        self.view = eaglView;        
        
        // IMPORTANT: Setting the GLView should be done after creating the RootViewController
        cocos2d::GLView *glview = cocos2d::GLViewImpl::createWithEAGLView((__bridge void *)self.view);
        cocos2d::Director::getInstance()->setOpenGLView(glview);
        //run the cocos2d-x game scene
        cocos2d::Application::getInstance()->run();
        
        // create a scene. it's an autorelease object
        _firstScene = StickerScene::createScene();
        
        cocos2d::Director::getInstance()->runWithScene(_firstScene);
    }
    
    return self;
}

- (void *)getFirstScene {
    return (void *)_firstScene;
}

- (void)appIsInBackground:(NSNotification *)notification {
    cocos2d::Application::getInstance()->applicationDidEnterBackground();
}

- (void)appBackToForeground:(NSNotification *)notification {
    cocos2d::Application::getInstance()->applicationWillEnterForeground();
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Receiver Methods

- (void)backToApp {
    if (self.delegate && [self.delegate respondsToSelector:@selector(backToAppFromGameController:)]) {
        [self.delegate backToAppFromGameController:self];
    }
}

@end
