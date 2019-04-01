//
//  shareView.m
//  Tikky
//
//  Created by LeHuuNghi on 3/13/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "TKShareView.h"
#import "TKSNFacebookSDK.h"

@implementation TKShareView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _facebook = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"facebook" ofType:@"png"]]];
        _twitter = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"twitter" ofType:@"png"]]];
        
        _facebook.userInteractionEnabled = YES;
        UITapGestureRecognizer* fbTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapFBButtonView:)];
        fbTapGesture.numberOfTapsRequired = 1;
        [_facebook addGestureRecognizer:fbTapGesture];
        
        UIStackView *stackView = [UIStackView new];
        stackView.axis = UILayoutConstraintAxisHorizontal;
        stackView.translatesAutoresizingMaskIntoConstraints = NO;
        stackView.distribution = UIStackViewDistributionEqualSpacing;
        stackView.spacing = 30;
        stackView.alignment = UIStackViewAlignmentCenter;
        [self addSubview:stackView];
        
        [[stackView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor] setActive:YES];
        [[stackView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor] setActive:YES];
        [[stackView.heightAnchor constraintEqualToAnchor:self.heightAnchor] setActive:YES];

        [stackView addArrangedSubview:_facebook];
        [stackView addArrangedSubview:_twitter];
        
        _facebook.translatesAutoresizingMaskIntoConstraints = NO;
        _twitter.translatesAutoresizingMaskIntoConstraints = NO;
        
        _facebook.contentMode = UIViewContentModeScaleAspectFit;
        _twitter.contentMode = UIViewContentModeScaleAspectFit;
        
        [[_facebook.heightAnchor constraintEqualToAnchor:stackView.heightAnchor] setActive:YES];
        [[_twitter.heightAnchor constraintEqualToAnchor:stackView.heightAnchor] setActive:YES];
        
    }
    return self;
}

- (void)didTapFBButtonView:(UIGestureRecognizer *)gesture {
    UIImage* sharedImage = nil;
    __weak UIViewController* myVC = nil;
    if (_dataSource && [_dataSource respondsToSelector:@selector(sharedImage)]) {
        sharedImage = [_dataSource sharedImage];
        if (!sharedImage) {
            return;
        }
    }

    if (_dataSource && [_dataSource respondsToSelector:@selector(myViewController)]) {
        myVC = [_dataSource myViewController];
        if (!myVC) {
            return;
        }
    }

    [TKSNFacebookSDK.sharedInstance sharePhotoWithPhoto:@[sharedImage]
                                                caption:@""
                                          userGenerated:YES
                                          hashtagString:@"#Tikky"
                                   showedViewController:myVC
                                               delegate:nil];
}

@end
