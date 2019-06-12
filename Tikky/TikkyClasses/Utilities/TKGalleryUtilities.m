//
//  TKGalleryUtilities.m
//  Tikky
//
//  Created by Vu Le Hoang on 5/30/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "TKGalleryUtilities.h"
#import <Photos/Photos.h>

@implementation TKGalleryUtilities

+ (void)saveImageToGalleryWithImage:(UIImage *)image {
    [self.class saveImageToGalleryWithImage:image completion:nil];
}

+ (void)saveImageToGalleryWithImage:(UIImage *)image completion:(void (^)(BOOL success, NSError* error))completion {
    if (!image) {
        if (completion) {
            completion(NO, [NSError errorWithDomain:@"TIKK.GALLERY" code:-1 userInfo:nil]);
        }
        return;
    }
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        NSMutableArray* assets = [[NSMutableArray alloc] init];
        PHAssetChangeRequest* assetRequest;
        @autoreleasepool {
            assetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
            [assets addObject:assetRequest.placeholderForCreatedAsset];
        }
        
        [self.class writeAssetsToAlbum:assets];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (completion) {
            completion(success, error);
        }
    }];
}

+ (void)writeAssetsToAlbum:(NSMutableArray *)assets {
    __block PHAssetCollectionChangeRequest* assetCollectionRequest = nil;
    PHFetchResult* result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    [result enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PHAssetCollection* collection = (PHAssetCollection*)obj;
        if ([collection isKindOfClass:[PHAssetCollection class]]) {
            if ([[collection localizedTitle] isEqualToString:@"Tikky"]) {
                assetCollectionRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection];
                [assetCollectionRequest addAssets:assets];
                *stop = YES;
            }
        }
    }];
    if (assetCollectionRequest == nil) {
        assetCollectionRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:@"Tikky"];
        [assetCollectionRequest addAssets:assets];
    }
}

+ (void)writeVideoToLibraryWithURL:(NSURL *)url {
    if (![url isFileURL]) {
        NSLog(@">>>> HV > URL is not the file url");
        return;
    }
    
    unsigned long long fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:url.path error:nil] fileSize];
    NSLog(@">>>> HV > URL is the file url with size: %llu", fileSize);
    __weak __typeof(self)weakSelf = self;
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        NSMutableArray* assets = [[NSMutableArray alloc] init];
        PHAssetChangeRequest* assetRequest;
        @autoreleasepool {
            assetRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:url];
            [assets addObject:assetRequest.placeholderForCreatedAsset];
        }
        
        [weakSelf writeAssetsToAlbum:assets];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (error) {
            NSLog(@">>>> HV > Save video failed with code: %@", error.description);
        }
    }];
}

@end
