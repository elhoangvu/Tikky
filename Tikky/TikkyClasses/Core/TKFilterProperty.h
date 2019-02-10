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
@property (nonatomic, readonly) CGFloat minValue;
@property (nonatomic, readonly) CGFloat maxValue;
@property (nonatomic) CGFloat value;

- (instancetype)initWithName:(NSString *)name
                    minValue:(CGFloat)minValue
                    maxValue:(CGFloat)maxValue
                       value:(CGFloat)value;

- (void)bindingRefValue:(CGFloat *)rValue;

@end

NS_ASSUME_NONNULL_END
