//
//  TKFilterProperty.m
//  Tikky
//
//  Created by Le Hoang Vu on 12/7/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import "TKFilterProperty.h"

@implementation TKFilterProperty

- (instancetype)initWithName:(NSString *)name
                    minValue:(NSInteger)minValue
                    maxValue:(NSInteger)maxValue
                defaultValue:(NSInteger)defaultValue {
    if (!(self = [super init])) {
        return nil;
    }
    
    _name = name;
    _minValue = minValue;
    _maxValue = maxValue;
    _defaultValue = defaultValue;
    
    return self;
}

@end
