//
//  TKMainBottomMenu.m
//  TKPresentation
//
//  Created by LeHuuNghi on 1/20/19.
//  Copyright © 2019 LeHuuNghi. All rights reserved.
//

#import "TKMainBottomMenu.h"
#import "TKMainBottomMenuItem.h"



@interface TKMainBottomMenu()

@property (nonatomic, strong) NSArray<TKMainBottomMenuItem *> *items;

@property (nonatomic) NSArray<UIImage *> *images;


@end

@implementation TKMainBottomMenu

- (instancetype)init
{
    self = [super init];
    if (self) {
        _items = @[[[TKMainBottomMenuItem alloc] initWithName:@"photo"],
                   [[TKMainBottomMenuItem alloc] initWithName:@"emoji"],
                   [[TKMainBottomMenuItem alloc] initWithName:@"capture"],
                   [[TKMainBottomMenuItem alloc] initWithName:@"frame"],
                   [[TKMainBottomMenuItem alloc] initWithName:@"filter"],];
        
        _items = @[[[TKMainBottomMenuItem alloc] initWithName:@"emoji"],
                   [[TKMainBottomMenuItem alloc] initWithName:@"capture"],
                   [[TKMainBottomMenuItem alloc] initWithName:@"filter"],];

        
        _images = @[[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"capture" ofType:@"png"]],
                [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"rec-start-button" ofType:@"png"]],
                [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"rec-stop-button" ofType:@"png"]]];
        
        UIStackView *stackView = [UIStackView new];
        stackView.axis = UILayoutConstraintAxisHorizontal;
        stackView.translatesAutoresizingMaskIntoConstraints = NO;
        stackView.distribution = UIStackViewDistributionEqualSpacing;
        stackView.alignment = UIStackViewAlignmentCenter;
        stackView.spacing = 20;
        [self addSubview:stackView];
        
        for (TKMainBottomMenuItem *item in _items) {
            item.delegate = self.viewController;
            item.translatesAutoresizingMaskIntoConstraints = NO;
            item.contentMode = UIViewContentModeScaleAspectFit;
            [stackView addArrangedSubview:item];
            
            if ([item.name isEqualToString:@"capture"]) {
                [[item.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:0.5] setActive:YES];
                [[item.widthAnchor constraintEqualToAnchor:self.heightAnchor multiplier:0.5] setActive:YES];
                [[item.centerXAnchor constraintEqualToAnchor:self.centerXAnchor] setActive:YES];
            } else {
                [[item.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:0.1] setActive:YES];
                [[item.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:0.25] setActive:YES];
            }
        }
        
        [[stackView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor] setActive:YES];
    }
    return self;
}

- (void)setCaptureType:(CaptureButtonType)captureType {
    if (self.captureType != captureType) {
        TKMainBottomMenuItem *item = _items[2];
        if (captureType == capture) {
            item.image = self.images[0];
        } else if (captureType == startvideo) {
            item.image = self.images[1];
        } else if (captureType == stopvideo) {
            item.image = self.images[2];
        }
        _captureType = captureType;
    }
}

-(void)setIsCapturePhotoType:(BOOL)isCapturePhotoType {
    if (isCapturePhotoType) {
        [self setCaptureType:capture];
    } else {
        [self setCaptureType:startvideo];
    }
}

@end
