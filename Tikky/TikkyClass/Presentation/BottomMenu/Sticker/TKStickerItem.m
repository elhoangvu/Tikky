//
//  StickerItem.m
//  TKPresentation
//
//  Created by LeHuuNghi on 1/29/19.
//  Copyright © 2019 LeHuuNghi. All rights reserved.
//

#import "TKStickerItem.h"

@interface TKStickerItem()

@property (nonatomic, strong) UITapGestureRecognizer *singleTap;

@end

@implementation TKStickerItem

- (instancetype)initWithPath:(NSString *)path {
    self = [super init];
    if (self) {
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:path ofType:@"png"]];
        [self setImage:image];
        
    }
    return self;
}

- (void)tap {
    [self.delegate cellClickWith:self.identifier andType:@"sticker"];
}

- (void)setTap:(Boolean)granted {
    if (granted) {
        if (!_singleTap) {
            _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
            _singleTap.numberOfTapsRequired = 1;
            [self setUserInteractionEnabled:YES];
            [self addGestureRecognizer:_singleTap];
        } else {
            [self.singleTap setEnabled:YES];
        }
    } else {
        [self.singleTap setEnabled:NO];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

@end
