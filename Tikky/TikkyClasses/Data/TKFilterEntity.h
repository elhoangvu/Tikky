//
//  TKFilterEntity.h
//  Tikky
//
//  Created by Vu Le Hoang on 6/2/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TKCommonEntity.h"

typedef NS_ENUM(NSUInteger, TKFilterType) {
    TKFilterTypeEffect = 0,
    TKFilterTypeColorFilter,
    TKFilterTypeFaceFilter,
    TKFilterTypeUnknown
};

NS_ASSUME_NONNULL_BEGIN

@interface TKFilterEntity : TKCommonEntity

@property (nonatomic) TKFilterType filterType;

@property (nonatomic) NSString* filterID;

- (instancetype)initWithID:(NSUInteger)cid
                  filterID:(NSString *)filterID
                  caterory:(NSString *)category
                      name:(NSString *)name
                 thumbnail:(NSString *)thumbnail
                  isBundle:(BOOL)isBundle
                      type:(TKFilterType)type;

@end

NS_ASSUME_NONNULL_END
