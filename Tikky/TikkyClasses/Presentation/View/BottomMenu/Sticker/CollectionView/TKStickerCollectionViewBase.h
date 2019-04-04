//
//  TKStickerCollectionViewBase.h
//  Tikky
//
//  Created by LeHuuNghi on 3/2/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKModelViewObject.h"
NS_ASSUME_NONNULL_BEGIN

@protocol TKStickerCellClick <NSObject>

@optional
-(void)cellClickWith:(NSNumber *)identifier andType:(NSString *)type;

@end

@interface TKStickerCollectionViewBase : UICollectionView

@property (nonatomic) NSMutableArray<TKModelViewObject *> *dataArray;

@property (nonatomic, weak) id cameraViewController;

@property (nonatomic, weak) id viewController;

@end

NS_ASSUME_NONNULL_END
