//
//  TKAssetsCollection.h
//  Tikky
//
//  Created by LeHuuNghi on 5/26/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    ready,
    progress,
    complete,
    failed
} CloudDownloadState;

typedef enum : NSUInteger {
    photo,
    video,
    livePhoto
} AssetType;

typedef enum : NSUInteger {
    png,
    jpg,
    gif,
    heic,
} ImageExtType;

@interface TKPHAsset : NSObject

@property (nonatomic) CloudDownloadState state;

@property (nonatomic) PHAsset *phAsset;

@property (nonatomic) int selectedOrder;

@property (nonatomic) AssetType type;

@property (nonatomic) UIImage *fullResolutionImage;

@property (nonatomic) NSString *originalFileName;

- (ImageExtType)extType;

- (PHImageRequestID)cloudImageDownload:(void(^)(double))progressBlock andCompletion:(void(^)(UIImage *))completionBlock;

- (void)photoSize:(PHImageRequestOptions *)options andCompletion:(void(^)(int))completion andLivePhotoVideoSize:(BOOL)livePhotoVideoSize;

- (void)videoSize:(PHVideoRequestOptions *)options andCompletion:(void(^)(int))completion;

- (NSString *)MIMEType:(NSURL *)url;

- (PHImageRequestID)tempCopyMediaFile:(PHVideoRequestOptions *)videoRequestOptions andImageRequestOptions:(PHImageRequestOptions *)imageRequestOption andExportPreset:(NSString *)exportPreset andConvertLivePhotoToJPG:(BOOL)convertLivePhotosToJPG andProgressBlock:(void(^)(double))progressBlock andCompletionBlock:(void(^)(NSURL *, NSString *))completionBlock;


@end

NS_ASSUME_NONNULL_END
