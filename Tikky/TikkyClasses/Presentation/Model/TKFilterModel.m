//
//  TKFilterModel.m
//  TKPresentation
//
//  Created by LeHuuNghi on 1/28/19.
//  Copyright © 2019 LeHuuNghi. All rights reserved.
//

#import "TKFilterModel.h"

@implementation TKFilterModel

//-(instancetype)initWithIdentifier:(NSNumber *)identifier andName:(NSString *)name andType:(NSString *)type andCategory:(NSString *)category andIsFromBundle:(BOOL)isFromBundle andThumbnailPath:(NSString *)thumbnailPath{
//    self = [super init];
//    if (self) {
//        _category = category;
//        _isFromBundle = isFromBundle;
//        _thumbnailPath = thumbnailPath;
//    }
//    return self;
//}

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
