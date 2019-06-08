//
//  TKEditItemView.h
//  Tikky
//
//  Created by Vu Le Hoang on 6/2/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TKEditItemViewModel.h"

typedef NS_ENUM(NSUInteger, TKEditItemViewType) {
    TKEditItemViewTypeSticker,
    TKEditItemViewTypeFilter
};

NS_ASSUME_NONNULL_BEGIN

//@protocol TKEditItemViewDatasource;
@protocol TKEditItemViewDelegate;

@interface TKEditItemView : UIView

//@property (nonatomic) id<TKEditItemViewDatasource> datasource;

@property (nonatomic) NSArray<TKEditItemViewModel *>* viewModels;

@property (nonatomic) NSString* title;

@property (nonatomic) id<TKEditItemViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)reset;

@end

//@protocol TKEditItemViewDatasource <NSObject>
//
//- (NSArray<TKEditItemViewModel *> *)viewModelsForEditItemView:(TKEditItemView *)editItemView type:(TKEditItemViewType)type;
//
//@end

@protocol TKEditItemViewDelegate <NSObject>

- (void)editItemView:(TKEditItemView *)editItemView didSelectItem:(TKEditItemViewModel *)item atIndex:(NSUInteger)index;

- (void)editItemView:(TKEditItemView *)editItemView didDeselectItem:(TKEditItemViewModel *)item atIndex:(NSUInteger)index;

- (void)didCloseEditItemView:(TKEditItemView *)editItemView withoutEditing:(BOOL)withoutEditing;

- (void)didDoneEditItemView:(TKEditItemView *)editItemView withoutEditing:(BOOL)withoutEditing;

@end

NS_ASSUME_NONNULL_END
