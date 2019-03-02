//
//  StickerItem.h
//  TKPresentation
//
//  Created by LeHuuNghi on 1/29/19.
//  Copyright © 2019 LeHuuNghi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TKStickerCollectionViewCellDelegate <NSObject>

@optional

-(void)cellClickWith:(NSNumber *)identifier andType:(NSString *)type;

@end

@interface TKStickerModelView : NSObject

@property (nonatomic, strong) id<TKStickerCollectionViewCellDelegate> delegate;

@property (nonatomic) NSNumber *identifier;

@property (nonatomic) NSString *path;

- (instancetype)initWithPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
