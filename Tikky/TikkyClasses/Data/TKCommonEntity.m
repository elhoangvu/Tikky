//
//  TKCommonEntity.m
//  Tikky
//
//  Created by Vu Le Hoang on 6/2/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "TKCommonEntity.h"

@implementation TKCommonEntity

- (instancetype)initWithID:(NSUInteger)cid
                  caterory:(NSString *)category
                      name:(NSString *)name
                 thumbnail:(NSString *)thumbnail
                  isBundle:(BOOL)isBundle
                      type:(TKEntityType)type; {
    if (!(self = [super init])) {
        return nil;
    }
    
    _cid = cid;
    _category = category;
    _name = name;
    _thumbnail = thumbnail;
    _isBundle = isBundle;
    _type = type;
    
    return self;
}

@end
