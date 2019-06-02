//
//  TKEditItemViewModel.h
//  Tikky
//
//  Created by Vu Le Hoang on 6/2/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#import "TKCommonEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface TKEditItemViewModel : NSObject

@property (nonatomic) UIImage* thumbnail;

@property (nonatomic) TKCommonEntity* entity;

- (instancetype)initWithCommonEntity:(TKCommonEntity *)entity;

@end

NS_ASSUME_NONNULL_END
