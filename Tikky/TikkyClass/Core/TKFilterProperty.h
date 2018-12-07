//
//  TKFilterProperty.h
//  Tikky
//
//  Created by Le Hoang Vu on 12/7/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TKFilterProperty : NSObject

@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) NSInteger minValue;
@property (nonatomic, readonly) NSInteger maxValue;
@property (nonatomic, readonly) NSInteger defaultValue;

- (instancetype)initWithName:(NSString *)name
                    minValue:(NSInteger)minValue
                    maxValue:(NSInteger)maxValue
                defaultValue:(NSInteger)defaultValue;

@end

NS_ASSUME_NONNULL_END
