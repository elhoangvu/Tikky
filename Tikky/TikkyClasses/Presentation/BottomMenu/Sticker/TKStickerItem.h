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

@interface TKStickerItem : UIImageView

@property (nonatomic, strong) id<TKStickerCollectionViewCellDelegate> delegate;

@property (nonatomic) NSNumber *identifier;

- (instancetype)initWithPath:(NSString *)path;

- (void)setTap:(Boolean)granted;

@end

NS_ASSUME_NONNULL_END
