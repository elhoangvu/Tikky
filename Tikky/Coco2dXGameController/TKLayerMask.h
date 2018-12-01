//
//  TKLayerMask.h
//  Tikky
//
//  Created by Le Hoang Vu on 12/2/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TKLayerMask : NSObject

+ (instancetype)sharedInstance;

- (void)newStickerWithPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
