//
//  TKFilterModel.h
//  TKPresentation
//
//  Created by LeHuuNghi on 1/28/19.
//  Copyright © 2019 LeHuuNghi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKModelObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface TKFilterModel : TKModelObject
//@property (nonatomic) NSString *category;
//@property (nonatomic) NSString *name;
//@property (nonatomic) BOOL isFromBundle;
@property (nonatomic) NSString *thumbnailPath;
//@property (nonatomic) NSArray<NSString *> *paths;
//@property (nonatomic) NSString *path;


//-(instancetype)initWithIdentifier:(NSNumber *)identifier andName:(NSString *)name andType:(NSString *)type andCategory:(NSString *)category andIsFromBundle:(BOOL)isFromBundle andThumbnailPath:(NSString *)thumbnailPath;

- (instancetype)initWithIdentifier:(NSNumber *)identifier andType:(NSString *)type andThumbnailPath:(NSString *)thumbnailPath;

@end

NS_ASSUME_NONNULL_END
