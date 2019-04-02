//
//  TKStickerCollectionViewCell.h
//  TKPresentation
//
//  Created by LeHuuNghi on 1/29/19.
//  Copyright © 2019 LeHuuNghi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKStickerCollectionViewCellBase.h"
NS_ASSUME_NONNULL_BEGIN

@protocol TKStickerItemDelegate <NSObject>

@optional

-(void)didSelectStickerWithIdentifier:(NSInteger)identifier;

@end

@interface TKStickerCollectionViewCell : TKStickerCollectionViewCellBase

@property (nonatomic) id viewController;

@property (nonatomic) id<TKStickerItemDelegate> delegate;

@property (nonatomic) UIImageView *imageView;

@end

NS_ASSUME_NONNULL_END
