//
//  EditViewController.m
//  Tikky
//
//  Created by LeHuuNghi on 3/6/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "EditViewController.h"
#import "TKShareView.h"
#import "TKBottomEditView.h"
#import "TKFacialCollectionViewCell.h"
#import "TKFilterCollectionViewCell.h"
#import "Tikky.h"
#import "TKNotification.h"
#import "TKGalleryUtilities.h"

@interface EditViewController () <UIGestureRecognizerDelegate, TKShareViewDataSource, TKFilterItemDelegate, TKStickerItemDelegate, TKFrameItemDelegate, TKFacialItemDelegate, TKBottomEditMenuItemDelegate>

@property (nonatomic) UIStackView *stackView;

@property (nonatomic) NSLayoutConstraint *bottomConstraintShareView;

@property (nonatomic) NSLayoutConstraint *bottomConstraintBottomMenuView;

@property (nonatomic) NSLayoutConstraint *heightImageView;

@property (nonatomic) TKShareView *shareView;

@property (nonatomic) BOOL isEdited;

@property (nonatomic) UIPanGestureRecognizer *panGestureRecognize;

@property (nonatomic) UIImageView *backButton;

@property (nonatomic) TKBottomEditView *bottomEditView;

@property (nonatomic) TKFilter* lastFilter;

@property (nonatomic) UIImage* lastProcessImage;

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isEdited = NO;
        
        _imageView = [UIImageView new];
        
        [self.view addSubview:_imageView];
        [self layoutMainView:_imageView];
        
        _stackView = [UIStackView new];
        [self.view addSubview:_stackView];
        self.view.backgroundColor = [UIColor whiteColor];
        
        _stackView.backgroundColor = [UIColor whiteColor];
        _stackView.axis = UILayoutConstraintAxisHorizontal;
        _stackView.distribution = UIStackViewDistributionEqualSpacing;
        _stackView.alignment = UIStackViewAlignmentCenter;
        _stackView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [[_stackView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor] setActive:YES];
        [[_stackView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor] setActive:YES];
        [[_stackView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor] setActive:YES];
        [[_stackView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:0.1] setActive:YES];
        
        _deleteButton = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"delete" ofType:@"png"]]];
        _editButton = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"edit" ofType:@"png"]]];
        _shareButton = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"share" ofType:@"png"]]];
        
        _editButton.translatesAutoresizingMaskIntoConstraints = NO;
        _shareButton.translatesAutoresizingMaskIntoConstraints = NO;
        _deleteButton.translatesAutoresizingMaskIntoConstraints = NO;
        
        _editButton.contentMode = UIViewContentModeScaleAspectFit;
        _shareButton.contentMode = UIViewContentModeScaleAspectFit;
        _deleteButton.contentMode = UIViewContentModeScaleAspectFit;
        
        [_stackView addArrangedSubview:_deleteButton];
        [_stackView addArrangedSubview:_editButton];
        [_stackView addArrangedSubview:_shareButton];
        
        [[_deleteButton.heightAnchor constraintEqualToAnchor:_stackView.heightAnchor multiplier:0.5] setActive:YES];
        [[_editButton.heightAnchor constraintEqualToAnchor:_stackView.heightAnchor multiplier:0.5] setActive:YES];
        [[_shareButton.heightAnchor constraintEqualToAnchor:_stackView.heightAnchor multiplier:0.5] setActive:YES];
        
        UITapGestureRecognizer *tapDeleteButton = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteTapDetected)];
        tapDeleteButton.numberOfTapsRequired = 1;
        [_deleteButton setUserInteractionEnabled:YES];
        [_deleteButton addGestureRecognizer:tapDeleteButton];
        
        UITapGestureRecognizer *tapEditButton = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editTapDetected)];
        tapEditButton.numberOfTapsRequired = 1;
        [_editButton setUserInteractionEnabled:YES];
        [_editButton addGestureRecognizer:tapEditButton];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareTapDetected)];
        singleTap.numberOfTapsRequired = 1;
        [_shareButton setUserInteractionEnabled:YES];
        [_shareButton addGestureRecognizer:singleTap];
        
        [self.view layoutIfNeeded];
        
        _shareView = [TKShareView new];
        _shareView.dataSource = self;
        _shareView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_shareView];
        
        _shareView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [[_shareView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor] setActive:YES];
        [[_shareView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor] setActive:YES];
        [[_shareView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:0.2] setActive:YES];
        _bottomConstraintShareView = [_shareView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:2*self.stackView.frame.size.height];
        [_bottomConstraintShareView setActive:YES];
        
        self.panGestureRecognize = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self.view addGestureRecognizer:self.panGestureRecognize];
        [self.panGestureRecognize setMinimumNumberOfTouches:1];
        self.panGestureRecognize.delegate = self;
        
        _bottomEditView = [TKBottomEditView new];
        _bottomEditView.translatesAutoresizingMaskIntoConstraints = NO;
        _bottomEditView.delegate = self;
        [self.view addSubview:_bottomEditView];

        
        [[_bottomEditView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor] setActive:YES];
        [[_bottomEditView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor] setActive:YES];
        [[_bottomEditView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:0.2] setActive:YES];
        _bottomConstraintBottomMenuView = [_bottomEditView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:2*self.stackView.frame.size.height];
        [_bottomConstraintBottomMenuView setActive:YES];
        
        _backButton = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cross" ofType:@"png"]]];
        _backButton.contentMode = UIViewContentModeScaleAspectFit;
        _backButton.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.view addSubview:_backButton];
        [[_backButton.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:10] setActive:YES];
        [[_backButton.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:20] setActive:YES];
        [[_backButton.bottomAnchor constraintEqualToAnchor:self.imageView.topAnchor constant:-20] setActive:YES];
        [[_backButton.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:0.1] setActive:YES];
        [_backButton setUserInteractionEnabled:YES];
        [_backButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoBack)]];
    
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image
{
    self = [self init];
    if (self) {
        _imageView.image = image;
    }
    return self;
}

- (void)layoutMainView:(UIView *)view {
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [[view.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor] setActive:YES];
    _heightImageView = [view.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor];
    [_heightImageView setActive:YES];
    [[view.widthAnchor constraintEqualToAnchor:self.view.widthAnchor] setActive:YES];
    [[view.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:0.8] setActive:true];
    view.contentMode = UIViewContentModeScaleAspectFit;
    [self.view layoutIfNeeded];
}

-(void)gotoBack {
    [[NSNotificationCenter defaultCenter] postNotificationName:kEditViewControllerWillDismiss object:nil];
    [TikkyEngine.sharedInstance.imageFilter removeAllFilter];
    __weak __typeof(self)weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        [weakSelf.editView setHidden:NO];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    CGPoint locationPoint = [[touches anyObject] locationInView:self.shareView];
    if (locationPoint.y < 0 && self.bottomConstraintShareView.constant == 0) {
        [self setShareViewIsHidden:YES];
    }
    
}

- (void)deleteTapDetected{
    
    
}

- (void)editTapDetected{
    NSLog(@"edit Tap on imageview");
    _editView = TikkyEngine.sharedInstance.view;
    [TikkyEngine.sharedInstance.imageFilter removeAllFilter];
    
    TKImageInput* input = TikkyEngine.sharedInstance.imageFilter.input;
    TKPhoto* photo = [[TKPhoto alloc] initWithImage:self.imageView.image];
    
    if ([input isKindOfClass:TKCamera.class]) {
        TKCamera* camera = (TKCamera *)input;
        [camera stopCameraCapture];
    }
    [TikkyEngine.sharedInstance.imageFilter setInput:photo];

    [self setBottomEditViewIsHidden:NO];
    
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        self.heightImageView.constant = -2*self.deleteButton.bounds.size.height;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [weakSelf.editView setHidden:NO];
        [weakSelf.imageView setHidden:YES];
        [weakSelf.view addSubview:weakSelf.editView];
        [weakSelf.view sendSubviewToBack:weakSelf.editView];
        UIImageView *iv = weakSelf.imageView;
        CGSize imageSize = iv.image.size;
        CGFloat imageScale = fminf(CGRectGetWidth(iv.bounds)/imageSize.width, CGRectGetHeight(iv.bounds)/imageSize.height);
        CGSize scaledImageSize = CGSizeMake(imageSize.width*imageScale, imageSize.height*imageScale);
        CGRect imageFrame = CGRectMake(roundf(0.5f*(CGRectGetWidth(iv.bounds)-scaledImageSize.width)), roundf(0.5f*(CGRectGetHeight(iv.bounds)-scaledImageSize.height)), roundf(scaledImageSize.width), roundf(scaledImageSize.height));
        [TikkyEngine.sharedInstance.imageFilter.view setFrame:imageFrame];
        [photo processImage];
    }];
}

- (void)shareTapDetected{

    [self setShareViewIsHidden:NO];
}

- (void)setBottomEditViewIsHidden:(BOOL)isHidden {
    if (isHidden) {
        [UIView animateWithDuration:0.4 animations:^{
            self.bottomConstraintBottomMenuView.constant = 2*self.stackView.frame.size.height;
            [self.view layoutIfNeeded];
        }];
    } else {
        [UIView animateWithDuration:0.4 animations:^{
            self.bottomConstraintBottomMenuView.constant = 0;
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)setShareViewIsHidden:(BOOL)isHidden {
    if (isHidden) {
        [UIView animateWithDuration:0.4 animations:^{
            self.bottomConstraintShareView.constant = 2*self.stackView.frame.size.height;
            [self.view layoutIfNeeded];
        }];
    } else {
        [UIView animateWithDuration:0.4 animations:^{
            self.bottomConstraintShareView.constant = 0;
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)pan:(UIPanGestureRecognizer *)panGesture {
//    CGPoint translation = [panGesture translationInView:self.view];
//    self.view.center = CGPointMake(self.view.center.x, self.view.center.y + translation.y);
}

- (UIImage *)sharedImage {
    return _imageView.image;
}

- (UIViewController *)myViewController {
    return self;
}

#pragma TKFilterItemDelegate

-(void)didSelectFilterWithIdentifier:(NSInteger)identifier {
    NSLog(@"tap edit filter item %ld", (long)identifier);
    if (identifier < 0 && identifier >= TKSampleDataPool.sharedInstance.orderedIndexFilterArray.count) {
        NSLog(@"vulh > Filters' identifier is out of range!!!");
        return;
    }
    NSString* filterName = [TKSampleDataPool.sharedInstance.orderedIndexFilterArray objectAtIndex:identifier-1];
    TKFilter* filter = [[TKFilter alloc] initWithName:filterName];
    TKImageFilter* imageFilter = TikkyEngine.sharedInstance.imageFilter;
    [imageFilter replaceFilter:_lastFilter withFilter:filter addNewFilterIfNotExist:YES];
    _lastFilter = filter;
    GPUImageFilter* gpufilter = (GPUImageFilter *)_lastFilter.sharedObject;
    if ([imageFilter.input isKindOfClass:TKPhoto.class]) {
        TKPhoto* photo = (TKPhoto *)imageFilter.input;
        [gpufilter useNextFrameForImageCapture];
        [photo processImage];
        _lastProcessImage = [gpufilter imageFromCurrentFramebuffer];
    }
    
    _isEdited = YES;
}

-(void)didDeselectFilterWithIdentifier:(NSInteger)identifier {
    NSLog(@"deselect filter");
    
}

#pragma TKStickerItemDelegate

-(void)didSelectStickerWithIdentifier:(NSInteger)identifier {
    //    if (identifier < 0 && identifier >= _frameStickers->size()) {
    //        NSLog(@"vulh > Static stickers' identifier is out of range!!!");
    //        return;
    //    }
    //    [_tikkyEngine.stickerPreviewer newStaticStickerWithPath:[_stickers objectAtIndex:identifier-1]];
}

-(void)didDeselectStickerWithIdentifier:(NSInteger)identifier {
    NSLog(@"deselect filter");

}


#pragma TKFrameItemDelegate

-(void)didSelectFrameWithIdentifier:(NSInteger)identifier {
    //    if (identifier < 0 && identifier >= _frameStickers->size()) {
    //        NSLog(@"vulh > Frame stickers' identifier is out of range!!!");
    //        return;
    //    }
    //    [_tikkyEngine.stickerPreviewer removeAllFrameStickers];
    //    [_tikkyEngine.stickerPreviewer newFrameStickerWithStickers:_frameStickers->at(identifier-1)];
}

-(void)didDeselectFrameWithIdentifier:(NSInteger)identifier {
    NSLog(@"deselect frame");

}

#pragma TKFacialItemDelegate
-(void)didSelectFacialWithIdentifier:(NSInteger)identifier {
    //    if (identifier < 0 && identifier >= _facialStickers->size()) {
    //        NSLog(@"vulh > Facial stickers' identifier is out of range!!!");
    //        return;
    //    }
    //    [_tikkyEngine.stickerPreviewer newFacialStickerWithStickers:_facialStickers->at(identifier-1)];
}

-(void)didDeselectFacialWithIdentifier:(NSInteger)identifier {
    NSLog(@"deselect facial");

}


#pragma TKBottomEditView

- (void)enableEditMode:(BOOL)isEnable {
    if (isEnable) {
        
    } else {
        TKImageInput* input = TikkyEngine.sharedInstance.imageFilter.input;
        if ([input isKindOfClass:TKPhoto.class]) {
            TKPhoto* photo = (TKPhoto *)input;
            __weak __typeof(self)weakSelf = self;

            if (_lastProcessImage) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.imageView.image = weakSelf.lastProcessImage;
                    [weakSelf.imageView setHidden:NO];
                    [weakSelf.editView setHidden:YES];
                    [weakSelf setBottomEditViewIsHidden:YES];
                    [UIView animateWithDuration:0.5 animations:^{
                        weakSelf.heightImageView.constant = 0;
                        [weakSelf.view layoutIfNeeded];
                    } completion:^(BOOL finished) {
                        if (weakSelf.isEdited) {
                            [TKGalleryUtilities saveImageToGalleryWithImage:weakSelf.imageView.image];
                        }
                    }];
                });
            } else {
                [photo processImageUpToFilter:_lastFilter withCompletionHandler:^(UIImage *processedImage) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (processedImage) {
                            weakSelf.imageView.image = processedImage;
                        }

                        [weakSelf.imageView setHidden:NO];
                        [weakSelf.editView setHidden:YES];
                        [weakSelf setBottomEditViewIsHidden:YES];
                        [UIView animateWithDuration:0.5 animations:^{
                            weakSelf.heightImageView.constant = 0;
                            [weakSelf.view layoutIfNeeded];
                        } completion:^(BOOL finished) {
                            if (weakSelf.isEdited) {
                                [TKGalleryUtilities saveImageToGalleryWithImage:weakSelf.imageView.image];
                            }
                        }];
                    });
                }];
            }
        }
    }
}


@end
