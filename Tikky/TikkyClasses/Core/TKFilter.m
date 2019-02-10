//
//  TKFilter.m
//  Tikky
//
//  Created by Le Hoang Vu on 12/7/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import "TKFilter.h"
#import "TKFilterCreator.h"

@interface TKFilter ()

@property (nonatomic) NSObject* filter;

@end

@implementation TKFilter

- (instancetype)initWithName:(NSString *)name {
    if (!(self = [TKFilterCreator newFilterWithName:name])) {
        return nil;
    }
    
    if (!_filter) {
        return nil;
    }
    
    _sharedObject = _filter;
    _name = name;
    
    return self;
}

- (BOOL)bindingFilterObj:(NSObject *)filterObject withPropertyList:(NSArray<TKFilterProperty *>*)propertyList {
    if (![filterObject isKindOfClass:GPUImageFilter.class]) {
        return NO;
    }
    
    _propertyList = propertyList;
    _filter = filterObject;
    _sharedObject = _filter;
    
    return YES;
}

@end
