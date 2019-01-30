//
//  TKImageInput.h
//  Tikky
//
//  Created by Le Hoang Vu on 12/6/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TKImageInput : NSObject

// A internal object which is TKImageInput want to sharing
@property (nonatomic, readonly, weak) NSObject* sharedObject;

@end

NS_ASSUME_NONNULL_END
