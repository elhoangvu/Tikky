//
//  TLAssertCollection.h
//  Tikky
//
//  Created by LeHuuNghi on 3/4/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface TLAssertCollection : NSObject

@property (nonatomic) PHAssetCollection *phAssetCollection;

@property (nonatomic) PHFetchResult<PHAsset *> *fetchResult;

@property (nonatomic) Boolean useCameraButton;

@property (nonatomic) NSString *title;

@property (nonatomic) NSString *localIdentifier;

@property (nonatomic) NSArray *section;

@property (nonatomic) int count;

@end

NS_ASSUME_NONNULL_END
