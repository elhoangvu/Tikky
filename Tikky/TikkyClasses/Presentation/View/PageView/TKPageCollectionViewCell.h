//
//  TKPageCollectionViewCell.h
//  Tikky
//
//  Created by Le Hoang Vu on 4/1/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TKPageCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) NSString* title;
@property (nonatomic) BOOL isBold;

@end

NS_ASSUME_NONNULL_END