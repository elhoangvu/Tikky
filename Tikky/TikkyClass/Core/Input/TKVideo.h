//
//  TKVideo.h
//  Tikky
//
//  Created by Le Hoang Vu on 12/11/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKImageInput.h"

@interface TKVideo : TKImageInput

@property (readonly, nonatomic) BOOL audioEncodingIsFinished;
@property (readonly, nonatomic) BOOL videoEncodingIsFinished;

- (instancetype)initWithAsset:(AVAsset *)asset;
- (instancetype)initWithPlayerItem:(AVPlayerItem *)playerItem;
- (instancetype)initWithURL:(NSURL *)url;

- (void)startProcessing;
- (void)endProcessing;
- (void)cancelProcessing;

@end
