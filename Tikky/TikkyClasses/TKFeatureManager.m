//
//  TKFeatureManager.m
//  Tikky
//
//  Created by Vu Le Hoang on 6/3/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "TKFeatureManager.h"

@implementation TKFeatureObject

- (instancetype)initWithName:(NSString *)name type:(TKFeatureType)type imageName:(NSString *)imageName {
    if (!(self = [super init])) {
        return nil;
    }
    
    _name = name;
    _type = type;
    _imageName = imageName;
    
    return self;
}

@end

@implementation TKFeatureManager

- (instancetype)init {
    if (!(self = [super init])) {
        return nil;
    }

    return self;
}

+ (instancetype)sharedInstance {
    static TKFeatureManager* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TKFeatureManager alloc] init];
    });
    
    return instance;
}

- (NSArray *)editMenuFeatureObjects {
    TKFeatureObject* fObject1 = [[TKFeatureObject alloc] initWithName:@"Effect" type:(TKFeatureTypeEffect) imageName:@"filter.png"];
    TKFeatureObject* fObject2 = [[TKFeatureObject alloc] initWithName:@"Facial Sticker" type:(TKFeatureTypeFaceSticker) imageName:@"emoji.png"];
    TKFeatureObject* fObject3 = [[TKFeatureObject alloc] initWithName:@"Frame Sticker" type:(TKFeatureTypeFrameSticker) imageName:@"frame.png"];
    TKFeatureObject* fObject4 = [[TKFeatureObject alloc] initWithName:@"Filter" type:(TKFeatureTypeFilter) imageName:@"filter.png"];
    TKFeatureObject* fObject5 = [[TKFeatureObject alloc] initWithName:@"Sticker" type:(TKFeatureTypeCommonSticker) imageName:@"frame.png"];
    NSMutableArray* featureObjects = [NSMutableArray arrayWithObjects:fObject1, fObject2, fObject3, fObject4, fObject5, nil];
    
    return featureObjects;
}

@end
