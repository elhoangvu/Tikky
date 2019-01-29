//
//  TKStickerModel.m
//  TKPresentation
//
//  Created by LeHuuNghi on 1/28/19.
//  Copyright © 2019 LeHuuNghi. All rights reserved.
//

#import "TKStickerModel.h"

@implementation TKStickerModel

-(instancetype)initWithIdentifier:(NSNumber *)identifier andName:(NSString *)name andType:(NSString *)type andCategory:(NSString *)category andIsFromBundle:(BOOL)isFromBundle andThumbnailPath:(NSString *)thumbnailPath andPath:(NSString *)path {
    self = [super init];
    if (self) {
        _identifier = identifier;
        _name = name;
        _type = type;
        _category = category;
        _isFromBundle = isFromBundle;
        _thumbnailPath = thumbnailPath;
        _path = path;
    }
    return self;
}

@end
