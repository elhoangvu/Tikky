//
//  TKEffectFilter.m
//  Tikky
//
//  Created by Vu Le Hoang on 6/5/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "TKEffectFilter.h"

#import "GPUImageEffectFilterProtocol.h"

@implementation TKEffectFilter

- (instancetype)initWithName:(NSString *)name {
    if (!(self = [super initWithName:name])) {
        return nil;
    }
    
    return self;
}

- (void)randomTime {
    id<GPUImageEffectFilterProtocol> effectFilter = (id<GPUImageEffectFilterProtocol>)self.sharedObject;
    if (effectFilter) {
        [effectFilter randomTime];
    }
}

@end
