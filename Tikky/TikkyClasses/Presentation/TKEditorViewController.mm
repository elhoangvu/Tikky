//
//  TKEditorViewController.m
//  Tikky
//
//  Created by Vu Le Hoang on 6/2/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "TKEditorViewController.h"

#import "Tikky.h"

#import "TKEditItemView.h"

#import "TKMenuCollectionViewCell.h"

#import "TKSNFacebookSDK.h"

#import "TKSocialNetworkSDK.h"

//#import "TKU"

#define kMenuCellIdentifier @"tikky.menucell"

@interface TKEditorViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
//TKEditItemViewDatasource,
TKEditItemViewDelegate,
SocialNetworkSDKDelegate
>

@property (nonatomic) UICollectionView* menuCollectionView;

@property (nonatomic) UICollectionView* selectingItemCollectionView;

@property (nonatomic) TKEditItemView* editView;

@property (nonatomic) UIButton* closeButton;

@property (nonatomic) UIButton* shareButton;

@property (nonatomic) NSArray* menuFeatureObjects;

@property (nonatomic) UIView* photoView;

@property (nonatomic) CGFloat menuHeight;

@property (nonatomic) CGSize menuItemSize;

@property (nonatomic) UIButton* saveButton;

@property (nonatomic) CGFloat itemSpacing;

@property (nonatomic) CGFloat headerViewHieght;

@property (nonatomic) CGFloat collectionViewWidth;

@property (nonatomic) TKPhoto* photo;

@property (nonatomic) TKImageFilter* imageFilter;

@property (nonatomic) NSArray* imageFilters;

@property (nonatomic) UIImage* lastProcessedImage;

@property (nonatomic) UIImage* lastPickedImage;

@property (nonatomic) BOOL isEdited;

@property (nonatomic) BOOL isEditing;

@end

@implementation TKEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _menuFeatureObjects = TKFeatureManager.sharedInstance.editMenuFeatureObjects;
    _itemSpacing = 5;
    _imageFilter = TikkyEngine.sharedInstance.imageFilter;
    /////
//    NSString* imagePath = [NSBundle.mainBundle pathForResource:@"demo4" ofType:@"jpg"];
//    UIImage* image = [UIImage imageWithContentsOfFile:imagePath];
//    _photo = [[TKPhoto alloc] initWithImage:image];
//    [_imageFilter setInput:_photo];
//    [_photo processImage];
    ////
//    NSAssert([_photo isKindOfClass:TKPhoto.class], @"TKPhoto is required!");
    _isEdited = NO;
    _isEditing = NO;
    CGRect mainViewRect = UIScreen.mainScreen.bounds;
    _menuHeight = 0.3*mainViewRect.size.width;
    _photoView = TikkyEngine.sharedInstance.view;
    _headerViewHieght = 40;
    CGRect photoFrame = CGRectMake(0, _headerViewHieght, mainViewRect.size.width, mainViewRect.size.height-_headerViewHieght-_menuHeight);
    _photo = (TKPhoto *)_imageFilter.input;
    UIImage* image = _photo.defaultImage;
    CGSize imageSize = image.size;
    CGFloat ratio = imageSize.width/imageSize.height;
    CGSize actualImageSize;
    if (ratio > 1.0) {
        actualImageSize = CGSizeMake(photoFrame.size.width, photoFrame.size.width*1.0/ratio);
        photoFrame.origin.y += (photoFrame.size.height - actualImageSize.height)*0.5;
        photoFrame.size.height = actualImageSize.height;
    } else {
        actualImageSize = CGSizeMake(photoFrame.size.height*ratio, photoFrame.size.height);
        photoFrame.origin.x += (mainViewRect.size.width - actualImageSize.width)*0.5;
        photoFrame.size.width = actualImageSize.width;
    }
    
    [TikkyEngine.sharedInstance.stickerPreviewer pause];
    [TikkyEngine.sharedInstance.imageFilter.view setFrame:photoFrame];
    [TikkyEngine.sharedInstance.stickerPreviewer.view setFrame:photoFrame];
    
    [TikkyEngine.sharedInstance.stickerPreviewer resume];
    [self.view addSubview:_photoView];
    
    TKFilter* filter = [[TKFilter alloc] initWithName:@"DEFAULT"];
    [self.imageFilter addFilter:filter];
    __weak __typeof(self)weakSelf = self;
    [self.photo processImageUpToFilter:filter withCompletionHandler:^(UIImage *processedImage) {
        if (processedImage) {
            weakSelf.lastProcessedImage = processedImage;
            weakSelf.lastPickedImage = processedImage;
            weakSelf.photo = [[TKPhoto alloc] initWithImage:processedImage];
            [weakSelf.imageFilter setInput:weakSelf.photo];
        }
        [weakSelf.imageFilter removeFilter:filter];
    }];
//    [_photo processImage];
    [self setUpMenuCollectionView];
    [self setUpEditView];
    [self setUpButtons];
    [self setUpHeaderView];
    self.view.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)setUpHeaderView {
    CGRect closeFrame = CGRectMake(_headerViewHieght*0.25, _headerViewHieght*0.25, _headerViewHieght*0.5, _headerViewHieght*0.5);
    _closeButton = [[UIButton alloc] initWithFrame:closeFrame];
    NSString* closePath = [NSBundle.mainBundle pathForResource:@"close-gray" ofType:@"png"];
    UIImage* closeImage = [UIImage imageWithContentsOfFile:closePath];
    [_closeButton setImage:closeImage forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(didTapCloseButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_closeButton];
    
    CGSize mainSize = UIScreen.mainScreen.bounds.size;
    _shareButton = [[UIButton alloc] initWithFrame:closeFrame];
    [_shareButton setTitleColor:UIColor.blackColor forState:(UIControlStateNormal)];
    [_shareButton setTitle:@"Share" forState:(UIControlStateNormal)];
    [_shareButton sizeToFit];
    [_shareButton.titleLabel setTextAlignment:(NSTextAlignmentCenter)];
    [_shareButton.titleLabel setFont:[_shareButton.titleLabel.font fontWithSize:15]];
    CGRect shareFrame = _shareButton.frame;
    shareFrame.origin.y = 0;
    shareFrame.origin.x = mainSize.width - _headerViewHieght*0.25 - shareFrame.size.width;
    shareFrame.size.height = _headerViewHieght;
    [_shareButton setFrame:shareFrame];
    [_shareButton addTarget:self action:@selector(didTapShareButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_shareButton];
    
    CGRect saveButtonFrame = CGRectMake(mainSize.width*0.5-shareFrame.size.width*0.5, _headerViewHieght*0.15, shareFrame.size.width, _headerViewHieght*0.7);
    _saveButton = [[UIButton alloc] initWithFrame:saveButtonFrame];
    NSString* saveImagePath = [NSBundle.mainBundle pathForResource:@"save-gray" ofType:@"png"];
    UIImage* saveImage = [UIImage imageWithContentsOfFile:saveImagePath];
    [_saveButton setImage:saveImage forState:(UIControlStateNormal)];
    [_saveButton.imageView setContentMode:(UIViewContentModeScaleAspectFit)];
    [_saveButton addTarget:self action:@selector(didTapSaveButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_saveButton];
}

- (void)setUpButtons {
//    CGSize mainSize = UIScreen.mainScreen.bounds.size;
//    CGRect frame = CGRectMake(mainSize.width-_menuItemSize.width, mainSize.height-_menuHeight+(_menuHeight-_menuItemSize.height)/2.0, _menuItemSize.width-_itemSpacing, _menuItemSize.height);
//    _saveButton = [[UIButton alloc] initWithFrame:frame];
//    [_saveButton setBackgroundColor:UIColor.whiteColor];
//    [_saveButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
//    [_saveButton setTitle:@"Save" forState:(UIControlStateNormal)];
//    [_saveButton setTitleColor:UIColor.blackColor forState:(UIControlStateNormal)];
//
//    [self.view addSubview:_saveButton];

}

- (void)setUpEditView {
    CGRect frame = _menuCollectionView.frame;
    frame.size.width = UIScreen.mainScreen.bounds.size.width;
    frame.origin.y = UIScreen.mainScreen.bounds.size.height;
    _editView = [[TKEditItemView alloc] initWithFrame:frame];
    _editView.delegate = self;
//    _editView.datasource = self;
    
    [self.view addSubview:_editView];
}

- (void)setUpMenuCollectionView {
    CGRect mainViewRect = UIScreen.mainScreen.bounds;
    UICollectionViewFlowLayout* collectionLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionLayout.itemSize = CGSizeMake(0.675*_menuHeight, 0.9*_menuHeight);
    _menuItemSize = collectionLayout.itemSize;
    collectionLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    collectionLayout.minimumInteritemSpacing = _itemSpacing;
    collectionLayout.minimumLineSpacing = _itemSpacing;

    _collectionViewWidth = mainViewRect.size.width;
//    _collectionViewWidth = mainViewRect.size.width - _menuItemSize.width - _itemSpacing;
    CGRect menuFrame = CGRectMake(0, mainViewRect.size.height - _menuHeight, _collectionViewWidth, _menuHeight);
    _menuCollectionView = [[UICollectionView alloc] initWithFrame:menuFrame collectionViewLayout:collectionLayout];
    _menuCollectionView.delegate = self;
    _menuCollectionView.dataSource = self;
    [_menuCollectionView setShowsHorizontalScrollIndicator:NO];
    
    [_menuCollectionView registerClass:TKMenuCollectionViewCell.class forCellWithReuseIdentifier:kMenuCellIdentifier];
    _menuCollectionView.backgroundColor = UIColor.clearColor;
    _menuCollectionView.alwaysBounceHorizontal = YES;
    
    [self.view addSubview:_menuCollectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _menuFeatureObjects.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TKMenuCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMenuCellIdentifier forIndexPath:indexPath];
    TKFeatureObject* fObject = (TKFeatureObject *)[_menuFeatureObjects objectAtIndex:indexPath.row];
    cell.imageName = fObject.imageName;
    cell.title = fObject.name;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray* viewModels = [NSMutableArray array];

    if (indexPath.row == TKFeatureTypeEffect) {
        _imageFilters = [TKDataAdapter.sharedIntance loadAllEffects];
    } else if (indexPath.row == TKFeatureTypeFaceSticker) {
        _imageFilters = [TKDataAdapter.sharedIntance loadAllFacialStickers];
    } else if (indexPath.row == TKFeatureTypeFrameSticker) {
        _imageFilters = [TKDataAdapter.sharedIntance loadAllFrameStickers];
    } else if (indexPath.row == TKFeatureTypeFilter) {
        _imageFilters = [TKDataAdapter.sharedIntance loadAllColorFilters];
    } else if (indexPath.row == TKFeatureTypeCommonSticker) {
        _imageFilters = [TKDataAdapter.sharedIntance loadAllCommonStickers];
    }
    
    for (TKStickerEntity* entity in _imageFilters) {
        TKEditItemViewModel* viewModel = [[TKEditItemViewModel alloc] initWithCommonEntity:entity];
        [viewModels addObject:viewModel];
    }
    
    _editView.viewModels = viewModels;
    
    CGRect editFrame = _editView.frame;
    CGRect menuFrame = editFrame;
    editFrame.origin.y = editFrame.origin.y - _menuHeight;
//    editFrame.size.width = UIScreen.mainScreen.bounds.size.width;
//    CGRect saveButtonFrame = _saveButton.frame;
//    saveButtonFrame.origin.y = menuFrame.origin.y;
    [_editView reset];
    TKFeatureObject* fObject = (TKFeatureObject *)[_menuFeatureObjects objectAtIndex:indexPath.row];
    [_editView setTitle:fObject.name];
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf.editView setFrame:editFrame];
        [weakSelf.menuCollectionView setFrame:menuFrame];
//        [weakSelf.saveButton setFrame:saveButtonFrame];
    }];
}

- (void)didTapSaveButton:(UIButton *)button {
    
}


#pragma mark - TKEditItemViewDelegate

- (void)didCloseEditItemView:(TKEditItemView *)editItemView withoutEditing:(BOOL)withoutEditing {
    if (withoutEditing) {
        [self animationWhenPresentingMenu];
        return;
    }
    
    [self.imageFilter removeAllFilter];
    [TikkyEngine.sharedInstance.stickerPreviewer removeAllFrameStickers];
    [TikkyEngine.sharedInstance.stickerPreviewer removeAllFacialStickers];
    [TikkyEngine.sharedInstance.stickerPreviewer removeAllStaticStickers];
    
    if (!_isEdited) {
        [self animationWhenPresentingMenu];
        return;
    }
    _isEditing = NO;
    if (_lastPickedImage) {
        self.photo = [[TKPhoto alloc] initWithImage:self.lastPickedImage];
        [self.imageFilter setInput:self.photo];
        __weak __typeof(self)weakSelf = self;
        TKFilter* filter = [[TKFilter alloc] initWithName:@"DEFAULT"];
        [self.imageFilter addFilter:filter];
        [self.photo processImageUpToFilter:filter withCompletionHandler:^(UIImage *processedImage) {
            if (processedImage) {
                weakSelf.lastProcessedImage = processedImage;
                weakSelf.photo = [[TKPhoto alloc] initWithImage:processedImage];
                [weakSelf.imageFilter setInput:weakSelf.photo];
            }
            [weakSelf.imageFilter removeAllFilter];
        }];
    }
    [self animationWhenPresentingMenu];
}

- (void)didDoneEditItemView:(TKEditItemView *)editItemView withoutEditing:(BOOL)withoutEditing {
    if (withoutEditing) {
        [self animationWhenPresentingMenu];
        return;
    }
    _isEdited = YES;
    _isEditing = NO;
    self.photo = [[TKPhoto alloc] initWithImage:_lastProcessedImage];
    [self.imageFilter setInput:self.photo];
    [self.imageFilter removeAllFilter];
    _lastPickedImage = _lastProcessedImage;

    [self animationWhenPresentingMenu];
}

- (void)editItemView:(TKEditItemView *)editItemView didSelectItem:(nonnull TKEditItemViewModel *)item atIndex:(NSUInteger)index {
    if (_lastProcessedImage && !_isEditing) {
        _lastPickedImage = _lastProcessedImage;
    }
    _isEditing = YES;
    __weak __typeof(self)weakSelf = self;
    [_imageFilters enumerateObjectsUsingBlock:^(TKCommonEntity*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.cid == item.entity.cid) {
            if (obj.type == TKEntityTypeFilter) {
                weakSelf.isEdited = YES;
                TKFilterEntity* filterEntity = (TKFilterEntity *)obj;
                TKFilter* filter = [[TKFilter alloc] initWithName:filterEntity.filterID];
                [filter randomTime];
                
                [weakSelf.imageFilter removeAllFilter];
                [weakSelf.imageFilter addFilter:filter];
                [weakSelf.photo processImageUpToFilter:filter withCompletionHandler:^(UIImage *processedImage) {
                    weakSelf.lastProcessedImage = processedImage;
                }];
            } else if (obj.type == TKEntityTypeSticker) {
                TKStickerEntity* stickerEntity = (TKStickerEntity *)obj;
                if (stickerEntity.stickerType == TKStickerTypeFace) {
                    TKFaceStickerEntity* faceEntitty = (TKFaceStickerEntity *)stickerEntity;
                    std::vector<TKSticker>* facialStickers = (std::vector<TKSticker> *)faceEntitty.facialSticker;
                    [TikkyEngine.sharedInstance.stickerPreviewer newFacialStickerWithStickers:*facialStickers];
                } else if (stickerEntity.stickerType == TKStickerTypeFrame) {
                    TKFrameStickerEntity* frameEntitty = (TKFrameStickerEntity *)stickerEntity;
                    std::vector<TKSticker>* frameStickers = (std::vector<TKSticker> *)frameEntitty.frameStickers;
                    [TikkyEngine.sharedInstance.stickerPreviewer removeAllFrameStickers];
                    [TikkyEngine.sharedInstance.stickerPreviewer newFrameStickerWithStickers:*frameStickers];
                } else if (stickerEntity.stickerType == TKStickerTypeCommmon) {
                    TKCommonStickerEntity* commonEntitty = (TKCommonStickerEntity *)stickerEntity;
                } else {
                    
                }
            }
            *stop = YES;
        }
    }];
}

- (void)editItemView:(TKEditItemView *)editItemView didDeselectItem:(TKEditItemViewModel *)item atIndex:(NSUInteger)index {
    __weak __typeof(self)weakSelf = self;
    [_imageFilters enumerateObjectsUsingBlock:^(TKCommonEntity*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.cid == item.entity.cid) {
            if (obj.type == TKEntityTypeFilter) {
                [weakSelf.imageFilter removeAllFilter];
                [weakSelf.photo processImage];
            } else if (obj.type == TKEntityTypeSticker) {
                TKStickerEntity* stickerEntity = (TKStickerEntity *)obj;
                if (stickerEntity.stickerType == TKStickerTypeFace) {
                    [TikkyEngine.sharedInstance.stickerPreviewer removeAllFacialStickers];
                } else if (stickerEntity.stickerType == TKStickerTypeFrame) {
                    [TikkyEngine.sharedInstance.stickerPreviewer removeAllFrameStickers];
                } else if (stickerEntity.stickerType == TKStickerTypeCommmon) {
                    [TikkyEngine.sharedInstance.stickerPreviewer removeAllStaticStickers];
                } else {
                    [TikkyEngine.sharedInstance.stickerPreviewer removeAllFacialStickers];
                    [TikkyEngine.sharedInstance.stickerPreviewer removeAllFrameStickers];
                    [TikkyEngine.sharedInstance.stickerPreviewer removeAllStaticStickers];
                }
            }
            *stop = YES;
        }
    }];
}

- (void)animationWhenPresentingMenu {
    CGRect editFrame = _menuCollectionView.frame;
    CGRect menuFrame = editFrame;
    menuFrame.origin.y = menuFrame.origin.y - _menuHeight;
//    menuFrame.size.width = _collectionViewWidth;
//    CGRect saveButtonFrame = _saveButton.frame;
//    saveButtonFrame.origin.y = menuFrame.origin.y;
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf.editView setFrame:editFrame];
        [weakSelf.menuCollectionView setFrame:menuFrame];
//        [weakSelf.saveButton setFrame:saveButtonFrame];
    }];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didTapCloseButton:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(didTapCloseButtonAtEditorViewController:)]) {
        [_delegate didTapCloseButtonAtEditorViewController:self];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didTapShareButton:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(didTapShareButtonAtEditorViewController:)]) {
        [_delegate didTapShareButtonAtEditorViewController:self];
    }
    NSArray* photos = [NSArray arrayWithObject:_lastProcessedImage];
    [TKSNFacebookSDK.sharedInstance sharePhotoWithPhoto:photos caption:@"123" userGenerated:YES hashtagString:@"#Tikky" showedViewController:self delegate:self];
}

- (void)socialNetworkSDK:(TKSocialNetworkSDK *)socialNetworkSDK didCompleteWithResults:(NSDictionary *)results {
    if (_delegate && [_delegate respondsToSelector:@selector(didTapCloseButtonAtEditorViewController:)]) {
        [_delegate didTapCloseButtonAtEditorViewController:self];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
