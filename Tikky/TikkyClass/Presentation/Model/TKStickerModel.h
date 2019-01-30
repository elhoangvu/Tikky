//
//  TKStickerModel.h
//  TKPresentation
//
//  Created by LeHuuNghi on 1/28/19.
//  Copyright © 2019 LeHuuNghi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TKStickerModel : NSObject
@property (nonatomic) NSNumber *identifier;
@property (nonatomic) NSString *type;
@property (nonatomic) NSString *category;
@property (nonatomic) NSString *name;
@property (nonatomic) BOOL isFromBundle;
@property (nonatomic) NSString *thumbnailPath;
@property (nonatomic) NSArray<NSString *> *paths;
@property (nonatomic) NSString *path;

-(instancetype)initWithIdentifier:(NSNumber *)identifier andName:(NSString *)name andType:(NSString *)type andCategory:(NSString *)category andIsFromBundle:(BOOL)isFromBundle andThumbnailPath:(NSString *)thumbnailPath andPath:(NSString *)path;
@end

NS_ASSUME_NONNULL_END
