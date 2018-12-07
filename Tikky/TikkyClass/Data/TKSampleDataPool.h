//
//  TKSampleDataPool.h
//  Tikky
//
//  Created by Le Hoang Vu on 12/7/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TKSampleDataPool : NSObject

@property (nonatomic, readonly) NSMutableArray* stickerList;
@property (nonatomic, readonly) NSMutableArray* filterList;

@property (nonatomic, readonly) NSMutableDictionary* filterResources;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
