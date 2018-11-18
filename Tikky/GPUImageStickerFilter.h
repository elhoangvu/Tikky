//
//  GPUImageStickerFilter.h
//  Tikky
//
//  Created by Le Hoang Vu on 11/17/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import "GPUImage.h"
#import "renderer/TKUtilities.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GPUImageStickerOuput : GPUImageOutput <GPUImageInput>

@property (nonatomic) std::vector<int>* queuedTriangleCommands;

- (instancetype)initWithQueuedTriangleCommands:(std::vector<int> * __nullable)queuedTriangleCommands;

@end

NS_ASSUME_NONNULL_END
