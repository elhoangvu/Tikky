//
//  TKEffectFilter.h
//  Tikky
//
//  Created by Vu Le Hoang on 6/5/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "TKFilter.h"

NS_ASSUME_NONNULL_BEGIN

@interface TKEffectFilter : TKFilter

- (instancetype)initWithName:(NSString *)name;

- (void)randomTime;

@end

NS_ASSUME_NONNULL_END
