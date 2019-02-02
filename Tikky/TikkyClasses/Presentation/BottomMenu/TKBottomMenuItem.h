//
//  TKBottomItem.h
//  TKPresentation
//
//  Created by LeHuuNghi on 12/4/18.
//  Copyright © 2018 LeHuuNghi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TKBottomItemDelegate <NSObject>
@optional
- (void)clickBottomMenuItem:(NSString *)nameItem;
@end

@interface TKBottomMenuItem : UIImageView

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) id<TKBottomItemDelegate> delegate;

/**
 set path image for image button

 @param path path of image
 */
-(void)setPathImage:(NSString *)path;

-(instancetype)initWithName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
