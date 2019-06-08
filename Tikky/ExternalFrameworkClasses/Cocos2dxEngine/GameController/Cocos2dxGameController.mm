//
//  Cocos2dxGameController.m
//  Tikky
//
//  Created by Le Hoang Vu on 12/3/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import "Cocos2dxGameController.h"
#import "cocos2d.h"
#import "CCAppDelegate.h"
#import "platform/ios/CCEAGLView-ios.h"
#import "TKStickerPreviewer.h"

@interface Cocos2dxGameController () {
    CCEAGLView* _eaglView;
    cocos2d::GLView* _glview;
}

@end

@implementation Cocos2dxGameController

- (instancetype)initWithFrame:(CGRect)frame sharegroup:(EAGLSharegroup *)sharegroup {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appIsInBackground:) name:TKNotificationAppIsInBackground object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBackToForeground:) name:TKNotificationAppBackToForeground object:nil];

        _eaglView = [CCEAGLView viewWithFrame:frame
                                  pixelFormat:(__bridge NSString *)cocos2d::GLViewImpl::_pixelFormat
                                  depthFormat:cocos2d::GLViewImpl::_depthFormat
                           preserveBackbuffer:NO
                                   sharegroup:sharegroup
                                multiSampling:NO
                              numberOfSamples:0];
        _eaglView.backgroundColor = [UIColor clearColor];
        [_eaglView setMultipleTouchEnabled:YES];
        
        _view = _eaglView;
        
        // IMPORTANT: Setting the GLView should be done after creating the RootViewController
        _glview = cocos2d::GLViewImpl::createWithEAGLView((__bridge void *)self.view);
        cocos2d::Director::getInstance()->setOpenGLView(_glview);
        //run the cocos2d-x game scene
        cocos2d::Application::getInstance()->run();
        
        // create a scene. it's an autorelease object
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame {
    /*
     When setting a frame for cocos view, notify:
        - width and height ratio of ios-view are different from cocos view
        - setDesignResolutionSize of GLView when setting frame of glview
        - call onEnter() of running scene to re-animation to change position of stickers
     */
    
    cocos2d::Size glviewSize = _glview->getFrameSize();
    CGSize eaglViewSize = _eaglView.frame.size;
    float widthRatio = frame.size.width/eaglViewSize.width;
    float heightRatio = frame.size.height/eaglViewSize.height;
    _glview->setFrameSize(glviewSize.width*widthRatio, glviewSize.height*heightRatio);
    
    cocos2d::Size designResolutionSize = _glview->getDesignResolutionSize();
    _glview->setDesignResolutionSize(designResolutionSize.width*widthRatio, designResolutionSize.height*heightRatio, ResolutionPolicy::NO_BORDER);
    //        [eaglView setFrame:CGRectMake(0, -(frame.size.height-frame.size.width*4/3)/2, frame.size.width, frame.size.height)];
    [_eaglView setFrame:frame];
    if (cocos2d::Director::getInstance() && cocos2d::Director::getInstance()->getRunningScene()) {
        cocos2d::Director::getInstance()->getRunningScene()->onEnter();
    }
}

- (void)runWithCocos2dxScene:(void *)cocos2dxScene {
    cocos2d::Scene* scene = (cocos2d::Scene *)cocos2dxScene;
    cocos2d::Director::getInstance()->runWithScene(scene);
}
//
//- (void *)getRunningScene {
//    auto runningScene = cocos2d::Director::getInstance()->getRunningScene();
//    if (!runningScene) {
//        return (void *)_initialScene;
//    }
//    return (void *)runningScene;
//}

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
