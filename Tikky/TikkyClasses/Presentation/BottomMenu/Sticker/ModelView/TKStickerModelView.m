//
//  StickerItem.m
//  TKPresentation
//
//  Created by LeHuuNghi on 1/29/19.
//  Copyright © 2019 LeHuuNghi. All rights reserved.
//

#import "TKStickerModelView.h"

@interface TKStickerModelView()

@property (nonatomic, strong) UITapGestureRecognizer *singleTap;

@end

@implementation TKStickerModelView

- (instancetype)initWithPath:(NSString *)path {
    self = [super init];
    if (self) {
        _path = [[NSBundle mainBundle] pathForResource:path ofType:@"png"];
        
    }
    return self;
}

@end
