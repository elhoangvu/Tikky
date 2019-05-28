//
//  TKFrameCollectionViewCell.h
//  Tikky
//
//  Created by LeHuuNghi on 3/1/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKStickerCollectionViewCellBase.h"
NS_ASSUME_NONNULL_BEGIN

@protocol TKFrameItemDelegate <NSObject>

@optional

-(void)didSelectFrameWithIdentifier:(NSInteger)identifier;

@end

@interface TKFrameCollectionViewCell : TKStickerCollectionViewCellBase

@property (nonatomic) UIImageView *imageView;

@property (nonatomic) id<TKFrameItemDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
