//
//  TKEditItemViewModel.m
//  Tikky
//
//  Created by Vu Le Hoang on 6/2/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "TKEditItemViewModel.h"

#import "TKDataAdapter.h"

@implementation TKEditItemViewModel

- (instancetype)initWithCommonEntity:(TKCommonEntity *)entity {
    if (!(self = [super init])) {
        return nil;
    }
    
    _entity = entity;
    _isSelected = NO;
    
    if (entity.isBundle) {
        NSString* path = [NSBundle.mainBundle pathForResource:entity.thumbnail ofType:nil];
        if (!path) {
            path = [NSBundle.mainBundle pathForResource:@"filter-default.jpg" ofType:nil];
        }
        _thumbnail = [UIImage imageWithContentsOfFile:path];
    } else {
        NSString* path;
        if (entity.type == TKEntityTypeSticker) {
            path = TKDataAdapter.stickerThumbnailDirectoryForResource;
        } else if (entity.type == TKEntityTypeFilter) {
            path = TKDataAdapter.filterThumbnailDirectoryForResource;
        }
        path = [NSString stringWithFormat:@"%@/%@", path, entity.thumbnail];
        _thumbnail = [UIImage imageWithContentsOfFile:path];
    }
    
    return self;
}

@end
