//
//  TKBottomEditView.h
//  Tikky
//
//  Created by LeHuuNghi on 5/6/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKBottomMenu.h"
#import "TKStickerCollectionView.h"
#import "TKSelectionBottomMenuCollectionViewCell.h"
#import "TKSampleDataPool.h"
#import "TKFrameCollectionView.h"
#import "TKFilterCollectionView.h"
#import "TKFacialCollectionView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TKBottomEditMenuItemDelegate <NSObject>

@optional

-(void)cellClickWith:(NSNumber *)identifier andType:(NSString *)type;

- (void)enableEditMode:(BOOL)isEnable;

@end

@interface TKBottomEditView : TKBottomMenu

@property (nonatomic) id<TKBottomEditMenuItemDelegate> delegate;

@property (nonatomic) UICollectionView *selectionView;

@property (nonatomic) TKStickerCollectionViewBase *stickerCollectionView;

@end

NS_ASSUME_NONNULL_END
