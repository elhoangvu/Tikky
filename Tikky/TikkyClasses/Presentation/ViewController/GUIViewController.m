//
//  ViewController.m
//  Tikky
//
//  Created by LeHuuNghi on 2/25/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "GUIViewController.h"
#import "TKRootView.h"
#import "TKSampleDataPool.h"
#import <Photos/Photos.h>
#import "EditViewController.h"
#import "FeatureDefinition.h"

@interface GUIViewController ()<TKBottomItemDelegate>

@property (nonatomic) TKRootView* rootView;

@end

@implementation GUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.view setBackgroundColor:[UIColor blueColor]];
    // Do any additional setup after loading the view.
    _rootView = [TKRootView new];
//    [self.view setOpaque:NO];
//    [self.view setBackgroundColor:[UIColor clearColor]];
    
    [self.rootView setOpaque:NO];
    [_rootView setBackgroundColor:[UIColor clearColor]];
    _rootView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.rootView.viewController = self;
    self.rootView.cameraViewController = self.cameraController;

    [self.view addSubview:_rootView];
    
#if ENDABLE_BACKGROUND_VIEW_FOR_UI_TESTING
    [self.rootView setBackgroundColor:[UIColor blueColor]];
#endif
    [[self.rootView.topAnchor constraintEqualToAnchor:self.view.topAnchor] setActive:YES];
    [[self.rootView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:0.0] setActive:YES];
    [[self.rootView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:1.0] setActive:YES];
    [[self.rootView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:1.0] setActive:YES];
    
    [_rootView bringSubviewToFront:_rootView];
    [_rootView bringSubviewToFront:_rootView.topMenuView];
    [_rootView bringSubviewToFront:_rootView.bottomMenuView];
}

- (void)setCameraController:(id)cameraController {
    _cameraController = cameraController;
    self.rootView.cameraViewController = self.cameraController;
}

#pragma TKBottomItemDelegate

- (void)clickBottomMenuItem:(NSString *)nameItem {
    if ([nameItem isEqualToString:@"photo"]) {
        
        PHFetchOptions *userAlbumsOptions = [PHFetchOptions new];
        userAlbumsOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        userAlbumsOptions.fetchLimit = 1;
        
        PHFetchResult *userAlbums = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:userAlbumsOptions];
        
        if (userAlbums.count > 0) {
            PHAsset *asset = [userAlbums objectAtIndex:0];
            PHImageRequestOptions *option = [PHImageRequestOptions new];
            option.resizeMode   = PHImageRequestOptionsResizeModeExact;
            option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
            option.synchronous = YES;
            option.networkAccessAllowed = YES;
            
            [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    EditViewController *editViewController = [[EditViewController alloc] initWithImage:result];
                    [self presentViewController:editViewController animated:YES completion:nil];
                });
            }];
        }
    } else if ([nameItem isEqualToString:@"capture"]) {
        if ([self.rootView.bottomMenuView class] == [TKMainBottomMenu class]) {
            TKMainBottomMenu *mainMenu = (TKMainBottomMenu *)self.rootView.bottomMenuView;
            mainMenu.delegate = self.cameraController;
            if (mainMenu.captureType == capture) {
                if ([mainMenu.delegate respondsToSelector:@selector(didCapturePhoto)]) {
                    [mainMenu.delegate didCapturePhoto];
                }
            } else if (mainMenu.captureType == startvideo) {
                if ([mainMenu.delegate respondsToSelector:@selector(didActionVideoWithType:)]) {
                    [mainMenu.delegate didActionVideoWithType:startvideo];
                    [mainMenu setCaptureType:stopvideo];
                }
            } else if (mainMenu.captureType == stopvideo) {
                if ([mainMenu.delegate respondsToSelector:@selector(didActionVideoWithType:)]) {
                    [mainMenu.delegate didActionVideoWithType:stopvideo];
                    [mainMenu setCaptureType:startvideo];
                }
            }
        }
        
        
    } else if ([nameItem isEqualToString:@"filter"]) {
        [self.rootView setBottomMenuViewWithBottomMenuType:FilterMenu];
        
    } else if ([nameItem isEqualToString:@"emoji"]) {
        [self.rootView setBottomMenuViewWithBottomMenuType:FacialMenu];

    } else if ([nameItem isEqualToString:@"frame"]) {
        [self.rootView setBottomMenuViewWithBottomMenuType:StickerMenu];
    }
}

@end
