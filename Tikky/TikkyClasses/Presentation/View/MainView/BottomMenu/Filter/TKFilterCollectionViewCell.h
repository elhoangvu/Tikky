//
//  TKFilterCollectionViewCell.h
//  Tikky
//
//  Created by LeHuuNghi on 3/11/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "TKStickerCollectionViewCellBase.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TKFilterItemDelegate <NSObject>

@optional

-(void)didSelectFilterWithIdentifier:(NSInteger)identifier;

-(void)didDeselectFilterWithIdentifier:(NSInteger)identifier;


@end

@interface TKFilterCollectionViewCell : TKStickerCollectionViewCellBase

@property (nonatomic) UIImageView *imageView;
 
@property (nonatomic) UILabel *nameLabel;

- (instancetype)initWithImage:(UIImageView *)image;

@property (nonatomic) id<TKFilterItemDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
