//
//  ViewController.m
//  Tikky
//
//  Created by Le Hoang Vu on 11/10/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import "platform/ios/CCEAGLView-ios.h"
#import "Cocos2dxGameController.h"

#import "TikkyEngine.h"

//TKRectTexture convertTKCCTextureToTKRectTexture(TKCCTexture tkccTexture);

@interface TikkyEngine () <TKImageFilterDatasource, Cocos2dXGameControllerDelegate>

@property (nonatomic) CCEAGLView* cceaglView;

@property (nonatomic) EAGLSharegroup* sharegroup;

@end

@implementation TikkyEngine

- (instancetype)init {
    if (!(self = [super init])) {
        return nil;
    }
    
    _imageFilter = [[TKImageFilter alloc] init];
    _imageFilter.datasource = self;
    _sharegroup = _imageFilter.sharegroup;
    
    CGRect rect = CGRectMake(UIScreen.mainScreen.bounds.origin.x,
                             UIScreen.mainScreen.bounds.origin.y,
                             UIScreen.mainScreen.bounds.size.width,
                             UIScreen.mainScreen.bounds.size.height);
//    _view = [[UIView alloc] initWithFrame:rect];
    [_imageFilter.view setFrame:rect];
    
    Cocos2dxGameController* gameController = [[Cocos2dxGameController alloc] initWithFrame:rect sharegroup:_sharegroup];
//    gameController.delegate = self;
    _cceaglView = (CCEAGLView *)gameController.view;
//    [_view addSubview:_imageFilter.view];
//    [_view addSubview:gameController.view];

    StickerScene* stickerScene = (StickerScene *)StickerScene::createScene();
    [gameController setInitialScene:(void *)stickerScene];
    
    _stickerPreviewer = [[TKStickerPreviewer alloc] initWithStickerScene:stickerScene cocos2dxGameController:gameController];
    
    return self;
}

+ (instancetype)sharedInstance {
    static TikkyEngine* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TikkyEngine alloc] init];
    });
    
    return instance;
}


#pragma mark - Cocos2dXGameControllerDelegate

- (void)backToAppFromGameController:(Cocos2dxGameController *)gameController {
    [UIView animateWithDuration:0.3f animations:^{
        gameController.view.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [gameController backToApp];
//        [_cceaglView removeFromSuperview];
    }];
}

#pragma mark - TKImageFilterDatasource

- (NSData *)additionalTexturesForImageFilter:(TKImageFilter *)imageFilter {
    return [_stickerPreviewer getStickerTextures];
}

@end

