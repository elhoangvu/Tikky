//
//  TKStickerBottomMenu.h
//  TKPresentation
//
//  Created by LeHuuNghi on 1/27/19.
//  Copyright © 2019 LeHuuNghi. All rights reserved.
//

#import "TKBottomMenu.h"
#import "TKStickerTypeSelection.h"
#import "TKStickerCollectionView.h"
#import "TKStickerCollectionViewCell.h"
#import "TKSampleDataPool.h"
#import "TKStickerModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TKStickerCollectionViewCellDelegate <NSObject>

@optional

-(void)cellClickWith:(NSNumber *)identifier andType:(NSString *)type;

@end

@interface TKStickerBottomMenu : TKBottomMenu

@property (nonatomic) id<TKStickerCollectionViewCellDelegate> delegate;

@property (nonatomic) UIView *selectionView;

@property (nonatomic) UICollectionView *stickerCollectionView;

@property (nonatomic) NSMutableArray<TKStickerModel *> *stickers;



@end

NS_ASSUME_NONNULL_END
