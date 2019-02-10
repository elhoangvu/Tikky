//
//  TKFilterFactory.h
//  Tikky
//
//  Created by Le Hoang Vu on 2/10/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TKFilter.h"

NS_ASSUME_NONNULL_BEGIN

@interface TKFilterCreator : NSObject

+ (TKFilter *)newFilterWithName:(NSString *)filterName;

@end

NS_ASSUME_NONNULL_END
