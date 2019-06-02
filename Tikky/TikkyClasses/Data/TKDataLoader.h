//
//  TKDataLoader.h
//  Tikky
//
//  Created by Vu Le Hoang on 6/2/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TKFilterEntity.h"

#import "TKStickerEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface TKDataAdapter : NSObject

- (NSArray<TKFilterEntity *> *)loadAllFilters;

- (NSArray<TKFilterEntity *> *)loadAllFilters;

@end

NS_ASSUME_NONNULL_END
