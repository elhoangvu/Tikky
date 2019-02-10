//
//  TKFilterProperty.m
//  Tikky
//
//  Created by Le Hoang Vu on 12/7/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import "TKFilterProperty.h"

@interface TKFilterProperty ()

@property (nonatomic) void (^valueSetter)(CGFloat);

@end

@implementation TKFilterProperty

- (instancetype)initWithName:(NSString *)name
                    minValue:(CGFloat)minValue
                    maxValue:(CGFloat)maxValue
                       value:(CGFloat)value {
    if (!(self = [self init])) {
        return nil;
    }
    
    _name = name;
    _minValue = minValue;
    _maxValue = maxValue;
    _value = value;

    return self;
}

- (instancetype)init {
    if (!(self = [super init])) {
        return nil;
    }
    
    _valueSetter = NULL;
    
    return self;
}

- (void)bindingValueChangeCallback:(void (^)(CGFloat value))callback {
    _valueSetter = callback;
}

- (void)setValue:(CGFloat)value {
    _value = value;
    
    if (_valueSetter) {
        _valueSetter(value);
    }
}

@end
