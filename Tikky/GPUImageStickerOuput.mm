//
//  GPUImageStickerFilter.m
//  Tikky
//
//  Created by Le Hoang Vu on 11/17/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import "GPUImageStickerOutput.h"

@interface GPUImageStickerOutput ()

@end

@implementation GPUImageStickerOutput

- (instancetype)initWithQueuedBatchesRectTextureCommands:(std::vector<TKGLRectTextureCommand *> * __nullable)queuedRectTextureCommands {
    if (!(self = [super init])) {
        return nil;
    }
    
    _queuedRectTextureCommands = queuedRectTextureCommands;
    
    return self;
}

- (instancetype)init
{
    if (!(self = [self initWithQueuedBatchesRectTextureCommands:nil]))
    {
        return nil;
    }
    
    return self;
}

- (void)newFrameReadyAtTime:(CMTime)frameTime atIndex:(NSInteger)textureIndex {
    
//    [self informTargetsAboutNewFrameAtTime:frameTime];
}


@end
