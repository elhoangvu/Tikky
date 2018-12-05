//
//  CameraViewController.m
//  Tikky
//
//  Created by Le Hoang Vu on 12/3/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import "CameraViewController.h"
#import "TikkyEngine.h"

@interface CameraViewController ()

@property (nonatomic) TikkyEngine* tikkyEngine;
@property (nonatomic) TKCamera* camera;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tikkyEngine = TikkyEngine.sharedInstance;
    [self.view addSubview:_tikkyEngine.view];
    _camera = (TKCamera *)_tikkyEngine.imageFilter.input;
    [_camera swapCamera];
    
    CGSize size = UIScreen.mainScreen.bounds.size;
    UIButton* shootButton = [[UIButton alloc] initWithFrame:(CGRectMake(0, size.height - 80, size.width, 80))];
    [shootButton setTitle:@"Shoot" forState:(UIControlStateNormal)];
    [self.view addSubview:shootButton];
    [shootButton addTarget:self action:@selector(shoot:) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)shoot:(UIButton *)sender {
//    [_tikkyEngine capturePhotoAsJPEGAndSaveToPhotoLibraryWithAlbumName:@"Tikky"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_camera startCameraCapture];
    
    NSString* path1 = [NSBundle.mainBundle pathForResource:@"HelloWorld" ofType:@"png"];
    NSString* path2 = [NSBundle.mainBundle pathForResource:@"recyclingbin" ofType:@"png"];
    NSString* path3 = [NSBundle.mainBundle pathForResource:@"lookup_amatorka" ofType:@"png"];
    NSString* path4 = [NSBundle.mainBundle pathForResource:@"close50" ofType:@"png"];
    
    [_tikkyEngine.stickerPreviewer newStaticStickerWithPath:path1];
    [_tikkyEngine.stickerPreviewer newStaticStickerWithPath:path2];
    [_tikkyEngine.stickerPreviewer newStaticStickerWithPath:path3];
    [_tikkyEngine.stickerPreviewer newStaticStickerWithPath:path4];
}

// For ios6, use supportedInterfaceOrientations & shouldAutorotate instead
#ifdef __IPHONE_6_0
- (NSUInteger) supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
#endif

- (BOOL) shouldAutorotate {
    return YES;
}

//fix not hide status on ios7
- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
