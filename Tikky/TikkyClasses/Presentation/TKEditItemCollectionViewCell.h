//
//  TKEditItemCollectionViewCell.h
//  Tikky
//
//  Created by Vu Le Hoang on 6/2/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TKEditItemViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TKEditItemCollectionViewCell : UICollectionViewCell

@property (nonatomic) TKEditItemViewModel* viewModel;

@end

NS_ASSUME_NONNULL_END
