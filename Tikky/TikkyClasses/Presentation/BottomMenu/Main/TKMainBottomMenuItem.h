//
//  TKBottomItem.h
//  TKPresentation
//
//  Created by LeHuuNghi on 12/4/18.
//  Copyright © 2018 LeHuuNghi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKBottomItemDelegate.h"
NS_ASSUME_NONNULL_BEGIN

@interface TKMainBottomMenuItem : UIImageView

@property (nonatomic) NSString *name;

@property (nonatomic) id<TKBottomItemDelegate> delegate;

/**
 set path image for image button

 @param path path of image
 */
-(void)setPathImage:(NSString *)path;

-(instancetype)initWithName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
