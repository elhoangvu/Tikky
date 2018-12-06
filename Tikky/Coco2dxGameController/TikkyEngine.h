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

@interface TikkyEngine : NSObject

@property (nonatomic) UIView* view;
@property (nonatomic, readonly) TKStickerPreviewer* stickerPreviewer;
@property (nonatomic) TKImageFilter* imageFilter;

//
- (void)capture;

+ (instancetype)sharedInstance;
- (void)capturePhotoAsJPEGWithCompletionHandler:(void (^)(NSData *processedJPEG, NSError *error))block;
//- (void)capturePhotoAsJPEGAndSaveToPhotoLibraryWithAlbumName:(NSString *)albumName;

@end

