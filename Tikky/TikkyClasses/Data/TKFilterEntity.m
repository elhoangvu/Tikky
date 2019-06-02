//
//  TKFilterEntity.m
//  Tikky
//
//  Created by Vu Le Hoang on 6/2/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "TKFilterEntity.h"

@implementation TKFilterEntity

- (instancetype)initWithID:(NSUInteger)cid caterory:(NSString *)category name:(NSString *)name thumbnail:(NSString *)thumbnail isBundle:(BOOL)isBundle type:(TKEntityType)type {
    if (!(self = [super initWithID:cid caterory:category name:name thumbnail:thumbnail isBundle:isBundle type:TKEntityTypeFilter])) {
        return nil;
    }
    
    return self;
}

@end
