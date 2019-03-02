//
//  TKStickerCollectionViewBase.h
//  Tikky
//
//  Created by LeHuuNghi on 3/2/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKModelObject.h"
NS_ASSUME_NONNULL_BEGIN

@interface TKStickerCollectionViewBase : UICollectionView

@property (nonatomic) NSMutableArray<TKModelObject *> *dataArray;

@end

NS_ASSUME_NONNULL_END
