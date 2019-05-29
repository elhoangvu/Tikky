//
//  TKStickerCollectionViewCellBase.m
//  Tikky
//
//  Created by LeHuuNghi on 3/3/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "TKStickerCollectionViewCellBase.h"

@implementation TKStickerCollectionViewCellBase

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _isSelected = NO;
    }
    return self;
}
@end
