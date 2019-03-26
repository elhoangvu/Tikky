//
//  TKFacialCollectionViewCell.h
//  Tikky
//
//  Created by LeHuuNghi on 3/11/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "TKStickerCollectionViewCellBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface TKFacialCollectionViewCell : TKStickerCollectionViewCellBase

@property (nonatomic) UIImageView *imageView;
 
@property (nonatomic) UILabel *nameLabel;

- (instancetype)initWithImage:(UIImageView *)image;

@end

NS_ASSUME_NONNULL_END