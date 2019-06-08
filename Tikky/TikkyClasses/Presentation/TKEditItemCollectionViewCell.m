//
//  TKEditItemCollectionViewCell.m
//  Tikky
//
//  Created by Vu Le Hoang on 6/2/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "TKEditItemCollectionViewCell.h"

#include <pthread.h>

@interface TKEditItemCollectionViewCell () {
    pthread_mutex_t _lock;
}

@property (nonatomic) UIImageView* imageView;

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
    [[_imageView.leftAnchor constraintEqualToAnchor:self.leftAnchor] setActive:YES];
    [[_imageView.topAnchor constraintEqualToAnchor:self.topAnchor] setActive:YES];
    [[_imageView.rightAnchor constraintEqualToAnchor:self.rightAnchor] setActive:YES];
    [[_imageView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor] setActive:YES];
    _imageView.layer.borderColor = UIColor.cyanColor.CGColor;
    
    return self;
}

- (void)dealloc {
    pthread_mutex_destroy(&_lock);
}

- (void)setViewModel:(TKEditItemViewModel *)viewModel {
    _viewModel = viewModel;
    _imageView.image = viewModel.thumbnail;
    [self bringSubviewToFront:_imageView];
    
    if (viewModel.entity.type == TKEntityTypeSticker) {
        _imageView.layer.cornerRadius = self.frame.size.height*0.1;
    } else {
        _imageView.layer.cornerRadius = self.frame.size.height*0.1;
    }
    if (_viewModel.isSelected) {
        self.imageView.layer.borderWidth = 2.0;
    }
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
    pthread_mutex_lock(&_lock);
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.1 animations:^{
        weakSelf.imageView.layer.borderWidth = 0.0;
    } completion:^(BOOL finished) {
        weakSelf.viewModel.isSelected = NO;
        pthread_mutex_unlock(&self->_lock);
    }];
}

- (void)prepareForReuse {
    self.imageView.layer.borderWidth = 0.0;
}

@end
