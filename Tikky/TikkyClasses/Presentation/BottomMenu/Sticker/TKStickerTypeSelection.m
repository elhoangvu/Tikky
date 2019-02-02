//
//  TKStickerTypeSelection.m
//  TKPresentation
//
//  Created by LeHuuNghi on 1/28/19.
//  Copyright © 2019 LeHuuNghi. All rights reserved.
//

#import "TKStickerTypeSelection.h"

@interface TKStickerTypeSelection()

@property (nonatomic) UITapGestureRecognizer *singleTap;

@property (nonatomic) NSArray *items;

@end

@implementation TKStickerTypeSelection

- (void)tap {
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.1]];
        _items = @[[UILabel new], [UILabel new], [UILabel new], [UILabel new]];
        [_items[0] setText:@"Sticker"];
        [_items[1] setText:@"Frame"];
        [_items[2] setText:@"Text"];
        [_items[3] setText:@"Drawing"];
        _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        _singleTap.numberOfTapsRequired = 1;
//        [self setUserInteractionEnabled:YES];
//        [self addGestureRecognizer:_singleTap];
        
        UIStackView *stackView = [UIStackView new];
        stackView.axis = UILayoutConstraintAxisHorizontal;
        stackView.translatesAutoresizingMaskIntoConstraints = NO;
//        stackView.distribution = UIStackViewDistributionEqualSpacing;
        stackView.alignment = UIStackViewAlignmentCenter;
        [self addSubview:stackView];
        
        for (UILabel *item in _items) {
            //item.delegate = self;
            [item setTextAlignment:NSTextAlignmentLeft];
            item.translatesAutoresizingMaskIntoConstraints = NO;
            item.contentMode = UIViewContentModeScaleAspectFit;
            [stackView addArrangedSubview:item];
            
            [[item.heightAnchor constraintEqualToAnchor:self.heightAnchor] setActive:YES];
            [[item.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:0.2] setActive:YES];
            
            [item setUserInteractionEnabled:YES];
            [item addGestureRecognizer:_singleTap];
        }
        
        [[stackView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor] setActive:YES];
        [[stackView.leftAnchor constraintEqualToAnchor:self.leftAnchor] setActive:YES];
    }
    return self;
}

@end
