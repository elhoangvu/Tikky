//
//  CameraViewController.m
//  Tikky
//
//  Created by Le Hoang Vu on 12/3/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import "CameraViewController.h"
#import "TKDirector.h"

@interface CameraViewController ()

@property (nonatomic) TKDirector* director;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _director = TKDirector.sharedInstance;
    [self.view addSubview:_director.view];
    
    CGSize size = UIScreen.mainScreen.bounds.size;
    UIButton* shootButton = [[UIButton alloc] initWithFrame:(CGRectMake(0, size.height - 80, size.width, 80))];
    [shootButton setTitle:@"Shoot" forState:(UIControlStateNormal)];
    [self.view addSubview:shootButton];
    [shootButton addTarget:self action:@selector(shoot:) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)shoot:(UIButton *)sender {
    [_director capturePhotoAsJPEGAndSaveToPhotoLibraryWithAlbumName:@"Tikky"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_director capture];
    
    NSString* path1 = [NSBundle.mainBundle pathForResource:@"HelloWorld" ofType:@"png"];
    NSString* path2 = [NSBundle.mainBundle pathForResource:@"recyclingbin" ofType:@"png"];
    NSString* path3 = [NSBundle.mainBundle pathForResource:@"lookup_amatorka" ofType:@"png"];
    NSString* path4 = [NSBundle.mainBundle pathForResource:@"close50" ofType:@"png"];
    
    [_director.stickerPreviewer newStaticStickerWithPath:path1];
    [_director.stickerPreviewer newStaticStickerWithPath:path2];
    [_director.stickerPreviewer newStaticStickerWithPath:path3];
    [_director.stickerPreviewer newStaticStickerWithPath:path4];
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
