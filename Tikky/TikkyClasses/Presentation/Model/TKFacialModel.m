//
//  TKFacialModel.m
//  Tikky
//
//  Created by LeHuuNghi on 3/26/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "TKFacialModel.h"

@implementation TKFacialModel

-(instancetype)initWithIdentifier:(NSNumber *)identifier andType:(NSString *)type andThumbnailPath:(NSString *)thumbnailPath {
    self = [super init];
    if (self) {
        self.identifier = identifier;
        self.type = type;
        _thumbnailPath = thumbnailPath;
    }
    return self;
}

@end
