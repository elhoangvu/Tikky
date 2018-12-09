//
//  TKNavigationItem.h
//  TKPresentation
//
//  Created by LeHuuNghi on 12/4/18.
//  Copyright © 2018 LeHuuNghi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKTopSubViewMenu.h"

@protocol TKTopItemDelegate <NSObject>
@optional
- (void)clickItem:(NSString *)nameItem;
@end

NS_ASSUME_NONNULL_BEGIN

@interface TKTopMenuItem : UIImageView

@property (nonatomic, strong) id<TKTopItemDelegate> delegate;

@property (nonatomic, strong) NSString *name;

-(instancetype)initWithName:(NSString *)name;

@property (nonatomic, strong) TKTopSubViewMenu *subMenuView;

@end

NS_ASSUME_NONNULL_END
