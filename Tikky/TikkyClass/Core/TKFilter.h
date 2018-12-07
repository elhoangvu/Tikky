//
//  TKFilter.h
//  Tikky
//
//  Created by Le Hoang Vu on 12/7/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKFilter : NSObject

@property (nonatomic, readonly, weak) NSObject* sharedObject;
@property (nonatomic, readonly) NSString* name;

- (instancetype)initWithName:(NSString *)name;

@end
