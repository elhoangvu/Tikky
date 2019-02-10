//
//  TKFilter.h
//  Tikky
//
//  Created by Le Hoang Vu on 12/7/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKFilterProperty.h"

@interface TKFilter : NSObject

@property (nonatomic, readonly) NSObject* sharedObject;
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) NSArray<TKFilterProperty *>* propertyList;

- (instancetype)initWithName:(NSString *)name;

- (BOOL)bindingFilterObj:(NSObject *)filterObject withPropertyList:(NSArray<TKFilterProperty *>*)propertyList;

@end
