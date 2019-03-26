//
//  TKFacialModel.h
//  Tikky
//
//  Created by LeHuuNghi on 3/26/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKModelObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface TKFacialModel : TKModelObject

@property (nonatomic) NSString *thumbnailPath;

- (instancetype)initWithIdentifier:(NSNumber *)identifier andType:(NSString *)type andThumbnailPath:(NSString *)thumbnailPath;


@end

NS_ASSUME_NONNULL_END
