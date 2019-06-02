//
//  TKCommonEntity.h
//  Tikky
//
//  Created by Vu Le Hoang on 6/2/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TKEntityType) {
    TKEntityTypeSticker,
    TKEntityTypeFilter
};

NS_ASSUME_NONNULL_BEGIN

@interface TKCommonEntity : NSObject

@property (nonatomic, readonly) NSUInteger cid;
@property (nonatomic, readonly) NSString* category;
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) NSString* thumbnail;
@property (nonatomic, readonly) BOOL isBundle;
@property (nonatomic, readonly) TKEntityType type;

- (instancetype)initWithID:(NSUInteger)cid
                  caterory:(NSString *)category
                      name:(NSString *)name
                 thumbnail:(NSString *)thumbnail
                  isBundle:(BOOL)isBundle
                      type:(TKEntityType)type;

@end

NS_ASSUME_NONNULL_END
