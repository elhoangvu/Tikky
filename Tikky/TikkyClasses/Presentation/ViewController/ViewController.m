//
//  ViewController.m
//  Tikky
//
//  Created by LeHuuNghi on 2/25/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "ViewController.h"
#import "TKRootView.h"
#import "TKSampleDataPool.h"
#import <Photos/Photos.h>
#import "EditViewController.h"

@interface ViewController ()<TKBottomItemDelegate>

@property (nonatomic) TKRootView* rootView;

@end

@implementation ViewController

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
    [self.view addSubview:_rootView];
    
    [self.rootView setBackgroundColor:[UIColor blueColor]];
    [[self.rootView.topAnchor constraintEqualToAnchor:self.view.topAnchor] setActive:YES];
    [[self.rootView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:0.0] setActive:YES];
    [[self.rootView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:1.0] setActive:YES];
    [[self.rootView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:1.0] setActive:YES];
    
    [_rootView setViewController:self];
    [_rootView bringSubviewToFront:_rootView];
    [_rootView bringSubviewToFront:_rootView.topMenuView];
    [_rootView bringSubviewToFront:_rootView.bottomMenuView];
}

- (void)clickBottomMenuItem:(NSString *)nameItem {
    if ([nameItem isEqualToString:@"photo"]) {
        
        PHFetchOptions *userAlbumsOptions = [PHFetchOptions new];
        userAlbumsOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        userAlbumsOptions.fetchLimit = 1;
        
        PHFetchResult *userAlbums = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:userAlbumsOptions];
        
//        PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:userAlbumsOptions];
        
        PHAsset *asset = [userAlbums objectAtIndex:0];
        PHImageRequestOptions *option = [PHImageRequestOptions new];
        option.resizeMode   = PHImageRequestOptionsResizeModeExact;
        option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        option.networkAccessAllowed = YES;
        option.synchronous = NO;

        
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:self.view.frame.size contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                EditViewController *editViewController = [EditViewController new];
                editViewController.imageView = [[UIImageView alloc] initWithImage:result];
                [self presentViewController:editViewController animated:YES completion:nil];
            });
        }];

    } else if ([nameItem isEqualToString:@"capture"]) {
        
    } else if ([nameItem isEqualToString:@"filter"]) {
        [self.rootView setBottomMenuViewWithBottomMenuType:FilterMenu];
        
    } else if ([nameItem isEqualToString:@"emoji"]) {


    } else if ([nameItem isEqualToString:@"frame"]) {
        [self.rootView setBottomMenuViewWithBottomMenuType:StickerMenu];
    }
}

@end
