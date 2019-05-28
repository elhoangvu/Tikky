//
//  TKStickerBottomMenu.h
//  TKPresentation
//
//  Created by LeHuuNghi on 1/27/19.
//  Copyright © 2019 LeHuuNghi. All rights reserved.
//

#import "TKBottomMenu.h"
#import "TKStickerCollectionView.h"
#import "TKSampleDataPool.h"
#import "TKStickerModel.h"
#import "TKTypeSelectionCollectionViewCell.h"
#import "TKTypeStickerCollectionView.h"
#import "TKFrameCollectionView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TKStickerCollectionViewCellDelegate <NSObject>

@optional

-(void)cellClickWith:(NSNumber *)identifier andType:(NSString *)type;

@end

@interface TKStickerBottomMenu : TKBottomMenu

@property (nonatomic) id<TKStickerCollectionViewCellDelegate> delegate;

@property (nonatomic) UICollectionView *selectionView;

@property (nonatomic) TKStickerCollectionViewBase *stickerCollectionView;


@end

NS_ASSUME_NONNULL_END
