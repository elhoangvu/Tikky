//
//  TKSampleDataPool.h
//  Tikky
//
//  Created by Le Hoang Vu on 12/7/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKStickerModel.h"
#import "TKFrameModel.h"
#import "TKFilterModel.h"
#import "TKFacialModel.h"

#import "TKStickerModelView.h"
#import "TKFrameModelView.h"
#import "TKFilterModelView.h"
#import "TKFacialModelView.h"

NS_ASSUME_NONNULL_BEGIN

/**
 The Sample data for unit test in project
 */
@interface TKSampleDataPool : NSObject

@property (nonatomic, readonly) NSMutableArray* stickerModelList;
@property (nonatomic, readonly) NSMutableArray* frameModelList;
@property (nonatomic, readonly) NSMutableArray* filterModelList;
@property (nonatomic, readonly) NSMutableArray* facialModelList;

@property (nonatomic, readonly) NSMutableArray* stickerModelViewList;
@property (nonatomic, readonly) NSMutableArray* frameModelViewList;
@property (nonatomic, readonly) NSMutableArray* filterModelViewList;
@property (nonatomic, readonly) NSMutableArray* facialModelViewList;

@property (nonatomic, readonly) NSMutableArray* stickerList;
@property (nonatomic, readonly) NSMutableArray* filterList;

@property (nonatomic, readonly) NSMutableDictionary* filterResources;

+ (instancetype)sharedInstance;

- (void *)facialStickers;
- (void *)frameStickers;

@end

NS_ASSUME_NONNULL_END
