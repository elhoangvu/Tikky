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

@interface TKStickerCollectionViewCell : TKStickerCollectionViewCellBase

@property (nonatomic) id viewController;

@property (nonatomic) UIImageView *imageView;

@end

NS_ASSUME_NONNULL_END
