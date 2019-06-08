//
//  TKRenderQueue.m
//  Tikky
//
//  Created by Le Hoang Vu on 2/15/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "TKRenderQueue.h"

@implementation TKRenderQueue

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static TKRenderQueue* instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[TKRenderQueue alloc] init];
    });
    
    return instance;
}

- (instancetype)init
{
    if (!(self = [super init])) {
        return nil;
    }
    
    _renderQueue = dispatch_queue_create("com.tikky.renderqueue", DISPATCH_QUEUE_SERIAL);
    
    return self;
}

@end

void runSynchronouslyOnRenderQueue(void (^block)(void))
{
    dispatch_queue_t renderQueue = TKRenderQueue.sharedInstance.renderQueue;
    
    dispatch_sync(renderQueue, block);
}

void runAsynchronouslyOnRenderQueue(void (^block)(void))
{
    dispatch_queue_t renderQueue = TKRenderQueue.sharedInstance.renderQueue;
    
    dispatch_async(renderQueue, block);
}
