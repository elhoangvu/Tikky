//
//  TKBottomItemDelegate.h
//  Tikky
//
//  Created by LeHuuNghi on 3/30/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

@protocol TKBottomItemDelegate <NSObject>
@optional
- (void)clickBottomMenuItem:(NSString *)nameItem;
@end
