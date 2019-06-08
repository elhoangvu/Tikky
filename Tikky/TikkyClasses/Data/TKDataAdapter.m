//
//  TKDataLoader.m
//  Tikky
//
//  Created by Vu Le Hoang on 6/2/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "TKDataAdapter.h"

#import "FMDB.h"

@interface TKDataAdapter ()

@property (nonatomic) NSString* dbPath;

@property (nonatomic) FMDatabase* db;

@end

@implementation TKDataAdapter

- (instancetype)init {
    if (!(self = [super init])) {
        return nil;
    }
    
    _dbPath = [NSBundle.mainBundle pathForResource:@"tikky" ofType:@"db"];
    _db = [FMDatabase databaseWithPath:_dbPath];
    
    return self;
}

+ (instancetype)sharedIntance {
    static TKDataAdapter* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TKDataAdapter alloc] init];
    });
    
    return instance;
}

- (NSArray *)loadAllStickers {
    return [self loadAllStickersWithType:TKStickerTypeUnknown];
}

- (NSArray *)loadAllFacialStickers {
    return [self loadAllStickersWithType:TKStickerTypeFace];
}

- (NSArray *)loadAllFrameStickers {
    return [self loadAllStickersWithType:TKStickerTypeFrame];
}

- (NSArray *)loadAllCommonStickers {
    return [self loadAllStickersWithType:TKStickerTypeCommmon];
}

- (NSArray *)loadAllStickersWithType:(TKStickerType)type {
    if (![_db open]) {
        _db = nil;
        return nil;
    }
    
    NSMutableArray* stickerEntities = [NSMutableArray array];
    
    NSString* query;
    if (type == TKStickerTypeUnknown) {
        query = [NSString stringWithFormat:@"SELECT * FROM sticker"];
    } else {
        query = [NSString stringWithFormat:@"SELECT * FROM sticker WHERE type = %lu", (unsigned long)type];
    }
    
    FMResultSet* s = [_db executeQuery:query];
    while ([s next]) {
        NSUInteger sid = [s intForColumn:@"id"];
        NSString* category = [s stringForColumn:@"category"];
        BOOL isBundle = [s boolForColumn:@"isbundle"];
        NSString* name = [s stringForColumn:@"name"];
        NSUInteger stickerCount = [s intForColumn:@"stickercount"];
        NSString* thumbnail = [NSString stringWithFormat:@"%@-thumb.png", name];
        
        TKStickerEntity* sticker;
        switch (type) {
            case TKStickerTypeFace: {
                NSMutableDictionary* landmarks;
                NSString* fetchLandmarkQuery = [NSString stringWithFormat:@"SELECT * FROM facialsticker WHERE id = %lu", (unsigned long)sid];
                FMResultSet* sLandmarks = [_db executeQuery:fetchLandmarkQuery];
                landmarks = [[NSMutableDictionary alloc] init];
                while ([sLandmarks next]) {
                    NSUInteger subid = [sLandmarks intForColumn:@"subid"];
                    NSUInteger lmk = [sLandmarks intForColumn:@"landmark"];
                    if (![landmarks objectForKey:@(subid)]) {
                        NSMutableArray* lmks = [NSMutableArray arrayWithObject:@(lmk)];
                        [landmarks setObject:lmks forKey:@(subid)];
                    } else {
                        NSMutableArray* landmarkArr = (NSMutableArray *)[landmarks objectForKey:@(subid)];
                        [landmarkArr addObject:@(lmk)];
                    }
                }
                
                sticker = [[TKFaceStickerEntity alloc] initWithID:sid
                                                         category:category
                                                             name:name
                                                        thumbnail:thumbnail
                                                         isBundle:isBundle
                                                            count:stickerCount
                                                        landmarks:landmarks];
                [stickerEntities addObject:sticker];
            }
                break;
            case TKStickerTypeFrame:
                sticker = [[TKFrameStickerEntity alloc] initWithID:sid
                                                          category:category
                                                              name:name
                                                         thumbnail:thumbnail
                                                          isBundle:isBundle
                                                             count:stickerCount];
                [stickerEntities addObject:sticker];
                break;
            default:
                sticker = [[TKCommonStickerEntity alloc] initWithID:sid
                                                           category:category
                                                               name:name
                                                          thumbnail:thumbnail
                                                           isBundle:isBundle
                                                              count:stickerCount];
                [stickerEntities addObject:sticker];
                break;
        }
    }
    
    return stickerEntities;
}

- (NSArray *)loadAllFiltersWithType:(TKFilterType)type {
    if (![_db open]) {
        _db = nil;
        return nil;
    }
    
    NSMutableArray* filterEntities = [NSMutableArray array];
    
    NSString* query;
    if (type == TKFilterTypeUnknown) {
        query = [NSString stringWithFormat:@"SELECT * FROM filter"];
    } else {
        query = [NSString stringWithFormat:@"SELECT * FROM filter WHERE type = %lu", (unsigned long)type];
    }
    
    FMResultSet* s = [_db executeQuery:query];
    while ([s next]) {
        NSUInteger sid = [s intForColumn:@"id"];
        NSString* subid = [s stringForColumn:@"subid"];
        NSString* category = [s stringForColumn:@"category"];
        BOOL isBundle = [s boolForColumn:@"isbundle"];
        NSString* name = [s stringForColumn:@"name"];
        NSString* thumbnail = [s stringForColumn:@"thumbnail"];
        NSUInteger type = [s intForColumn:@"type"];
        NSString* filterClass = [s stringForColumn:@"class"];
        Class class = NSClassFromString(filterClass);
        
        TKFilterEntity* filter = [[TKFilterEntity alloc] initWithID:sid
                                                           filterID:subid
                                                           caterory:category
                                                               name:name
                                                          thumbnail:thumbnail
                                                           isBundle:isBundle
                                                               type:type
                                                        filterClass:class];
        [filterEntities addObject:filter];
    }
    
    return filterEntities;
}


- (NSArray *)loadAllFilters {
    return [self loadAllFiltersWithType:(TKFilterTypeUnknown)];
}

- (NSArray *)loadAllEffects {
    return [self loadAllFiltersWithType:(TKFilterTypeEffect)];
}

- (NSArray *)loadAllColorFilters {
    return [self loadAllFiltersWithType:(TKFilterTypeColorFilter)];
}

+ (NSString *)stickerDirectoryForResource {
    NSString* documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    return [NSString stringWithFormat:@"%@/stickers", documentPath];
}

+ (NSString *)filterDirectoryForResource {
    NSString* documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    return [NSString stringWithFormat:@"%@/filters", documentPath];
}

+ (NSString *)stickerThumbnailDirectoryForResource {
    NSString* documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    return [NSString stringWithFormat:@"%@/stickers/thumbnail", documentPath];
}

+ (NSString *)filterThumbnailDirectoryForResource {
    NSString* documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    return [NSString stringWithFormat:@"%@/filters/thumbnail", documentPath];
}

@end
