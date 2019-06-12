//
//  TKEditItemCollectionViewCell.m
//  Tikky
//
//  Created by Vu Le Hoang on 6/2/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "TKEditItemCollectionViewCell.h"

#import "TKFilterEntity.h"

#include <pthread.h>

@interface TKEditItemCollectionViewCell () {
    pthread_mutex_t _lock;
}

@property (nonatomic) UIImageView* imageView;

//@property (nonatomic) UILabel* title;

@end

@implementation TKEditItemCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) {
        return nil;
    }
    
    pthread_mutex_init(&_lock, NULL);

    _imageView = [[UIImageView alloc] initWithFrame:frame];
    _imageView.clipsToBounds = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_imageView];

    _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [[_imageView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor] setActive:YES];
    [[_imageView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor] setActive:YES];
    [[_imageView.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:0.85] setActive:YES];
//    [[_imageView.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:frame.size.width/frame.size.height] setActive:YES];
    [[_imageView.widthAnchor constraintEqualToAnchor:self.heightAnchor multiplier:0.85] setActive:YES];
    _imageView.layer.borderColor = UIColor.cyanColor.CGColor;
    _imageView.layer.cornerRadius = _imageView.frame.size.height*0.5;
//    _title = [[UILabel alloc] init];
//    [_title setFont:[_title.font fontWithSize:12]];
//    [_title setTextColor:UIColor.blackColor];
//    [self addSubview:_title];
//
//    _title.translatesAutoresizingMaskIntoConstraints = NO;
//    [[_title.widthAnchor constraintEqualToAnchor:self.widthAnchor] setActive:YES];
//    [[_title.bottomAnchor constraintEqualToAnchor:self.bottomAnchor] setActive:YES];
//    [[_title.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:1.0-frame.size.width/frame.size.height] setActive:YES];
//    [[_title.leftAnchor constraintEqualToAnchor:self.leftAnchor] setActive:YES];
//    [_title setTextAlignment:(NSTextAlignmentCenter)];
    
    return self;
}

- (void)dealloc {
    pthread_mutex_destroy(&_lock);
}

- (void)setViewModel:(TKEditItemViewModel *)viewModel {
    _viewModel = viewModel;
    _imageView.image = viewModel.thumbnail;
    
//    if (viewModel.entity.type == TKEntityTypeFilter) {
//        TKFilterEntity* filter = (TKFilterEntity *)viewModel.entity;
//        if (true || filter.filterType == TKFilterTypeEffect) {
//            _imageView.layer.cornerRadius = _imageView.frame.size.height*0.5;
//        } else {
//            _imageView.layer.cornerRadius = _imageView.frame.size.height*0.1;
//        }
//    } else {
////        [_title setText:viewModel.entity.name];
//        _imageView.layer.cornerRadius = _imageView.frame.size.height*0.5;
//    }
//    if (_viewModel.isSelected) {
//        self.imageView.layer.borderWidth = 2.0;
//    }
}

- (void)didSelectCell {
    pthread_mutex_lock(&_lock);
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.1 animations:^{
        weakSelf.imageView.layer.borderWidth = 2.0;
    } completion:^(BOOL finished) {
        weakSelf.viewModel.isSelected = YES;
        pthread_mutex_unlock(&self->_lock);
    }];
}

- (void)didDeselectCell {
//    pthread_mutex_lock(&_lock);
//    __weak __typeof(self)weakSelf = self;
//    [UIView animateWithDuration:0.1 animations:^{
//        weakSelf.imageView.layer.borderWidth = 0.0;
//    } completion:^(BOOL finished) {
//        weakSelf.viewModel.isSelected = NO;
//        pthread_mutex_unlock(&self->_lock);
//    }];
}

- (void)prepareForReuse {
    self.imageView.layer.borderWidth = 0.0;
//    [_title setText:@""];
}

@end
