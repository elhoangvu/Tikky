//
//  TKRenderQueue.h
//  Tikky
//
//  Created by Le Hoang Vu on 2/15/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TKRenderQueue : NSObject

@property (nonatomic, readonly) dispatch_queue_t renderQueue;

+ (instancetype)sharedInstance;

@end

void runSynchronouslyOnRenderQueue(void (^block)(void));

void runAsynchronouslyOnRenderQueue(void (^block)(void));

NS_ASSUME_NONNULL_END
