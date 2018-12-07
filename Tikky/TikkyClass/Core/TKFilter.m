//
//  TKFilter.m
//  Tikky
//
//  Created by Le Hoang Vu on 12/7/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import "TKFilter.h"

@implementation TKFilter

- (instancetype)init {
    if (!(self = [self initWithName:@"default"])) {
        return nil;
    }
    
    return self;
}

- (instancetype)initWithName:(NSString *)name {
    if (!(self = [super init])) {
        return nil;
    }
    
    _name = name;
    
    return self;
}

@end
