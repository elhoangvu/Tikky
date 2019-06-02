//
//  TKFeatureManager.h
//  Tikky
//
//  Created by Vu Le Hoang on 6/3/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TKFeatureType) {
    TKFeatureTypeEffect = 0,
    TKFeatureTypeFaceSticker,
    TKFeatureTypeFrameSticker,
    TKFeatureTypeFilter,
    TKFeatureTypeCommonSticker,
    TKFeatureTypeUnkonwn
};

NS_ASSUME_NONNULL_BEGIN

@interface TKFeatureObject : NSObject

@property (nonatomic, readonly) NSString* name;

@property (nonatomic, readonly) TKFeatureType type;

@property (nonatomic, readonly) NSString* imageName;

- (instancetype)initWithName:(NSString *)name type:(TKFeatureType)type imageName:(NSString *)imageName;

@end

@interface TKFeatureManager : NSObject

+ (instancetype)sharedInstance;

- (NSArray *)editMenuFeatureObjects;

@end

NS_ASSUME_NONNULL_END
