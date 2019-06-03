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

#define kMenuCellIdentifier @"tikky.menucell"

@interface TKEditorViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
//TKEditItemViewDatasource,
TKEditItemViewDelegate
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

@end

@implementation TKEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _menuFeatureObjects = TKFeatureManager.sharedInstance.editMenuFeatureObjects;
    _itemSpacing = 5;
    [self setUpMenuCollectionView];
    /////
    NSString* imagePath = [NSBundle.mainBundle pathForResource:@"aquaman" ofType:@"png"];
    UIImage* image = [UIImage imageWithContentsOfFile:imagePath];
    TKPhoto* photo = [[TKPhoto alloc] initWithImage:image];
    [TikkyEngine.sharedInstance.imageFilter setInput:photo];
    [photo processImage];
    ////
    
    _photoView = TikkyEngine.sharedInstance.imageFilter.view;
    CGRect mainViewRect = UIScreen.mainScreen.bounds;
    _headerViewHieght = 40;
    CGRect photoFrame = CGRectMake(0, _headerViewHieght, mainViewRect.size.width, mainViewRect.size.height-_headerViewHieght-_menuHeight);
    [_photoView setFrame:photoFrame];

    [self.view addSubview:_photoView];
    
    [self setUpEditView];
    [self setUpButtons];
    [self setUpHeaderView];
    self.view.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0];
}

- (void)setUpHeaderView {
    CGRect closeFrame = CGRectMake(_headerViewHieght*0.25, _headerViewHieght*0.25, _headerViewHieght*0.5, _headerViewHieght*0.5);
    _closeButton = [[UIButton alloc] initWithFrame:closeFrame];
    NSString* closePath = [NSBundle.mainBundle pathForResource:@"cross" ofType:@"png"];
    UIImage* closeImage = [UIImage imageWithContentsOfFile:closePath];
    [_closeButton setImage:closeImage forState:UIControlStateNormal];
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
    [self.view addSubview:_shareButton];
}

- (void)setUpButtons {
    CGSize mainSize = UIScreen.mainScreen.bounds.size;
    CGRect frame = CGRectMake(mainSize.width-_menuItemSize.width, mainSize.height-_menuHeight+(_menuHeight-_menuItemSize.height)/2.0, _menuItemSize.width-_itemSpacing, _menuItemSize.height);
    _saveButton = [[UIButton alloc] initWithFrame:frame];
    [_saveButton setBackgroundColor:UIColor.whiteColor];
    [_saveButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_saveButton setTitle:@"Save" forState:(UIControlStateNormal)];
    [_saveButton setTitleColor:UIColor.blackColor forState:(UIControlStateNormal)];
    
    [self.view addSubview:_saveButton];
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
    _menuHeight = 0.3*mainViewRect.size.width;
    UICollectionViewFlowLayout* collectionLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionLayout.itemSize = CGSizeMake(0.75*_menuHeight, 0.9*_menuHeight);
    _menuItemSize = collectionLayout.itemSize;
    collectionLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    collectionLayout.minimumInteritemSpacing = _itemSpacing;
    collectionLayout.minimumLineSpacing = _itemSpacing;

    _collectionViewWidth = mainViewRect.size.width - _menuItemSize.width - _itemSpacing;
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
    NSArray* loadedData;
    if (indexPath.row == TKFeatureTypeEffect) {
        loadedData = [TKDataAdapter.sharedIntance loadAllEffects];
    } else if (indexPath.row == TKFeatureTypeFaceSticker) {
        loadedData = [TKDataAdapter.sharedIntance loadAllFacialStickers];
    } else if (indexPath.row == TKFeatureTypeFrameSticker) {
        loadedData = [TKDataAdapter.sharedIntance loadAllFrameStickers];
    } else if (indexPath.row == TKFeatureTypeFilter) {
        loadedData = [TKDataAdapter.sharedIntance loadAllFilters];
    } else if (indexPath.row == TKFeatureTypeCommonSticker) {
        loadedData = [TKDataAdapter.sharedIntance loadAllCommonStickers];
    }
    
    for (TKStickerEntity* entity in loadedData) {
        TKEditItemViewModel* viewModel = [[TKEditItemViewModel alloc] initWithCommonEntity:entity];
        [viewModels addObject:viewModel];
    }
    
    _editView.viewModels = viewModels;
    
    CGRect editFrame = _editView.frame;
    CGRect menuFrame = editFrame;
    editFrame.origin.y = editFrame.origin.y - _menuHeight;
    editFrame.size.width = UIScreen.mainScreen.bounds.size.width;
    CGRect saveButtonFrame = _saveButton.frame;
    saveButtonFrame.origin.y = menuFrame.origin.y;
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf.editView setFrame:editFrame];
        [weakSelf.menuCollectionView setFrame:menuFrame];
        [weakSelf.saveButton setFrame:saveButtonFrame];
    }];
}


#pragma mark - TKEditItemViewDelegate

- (void)didCloseEditItemView:(TKEditItemView *)editItemView {
    [self animationWhenPresentingMenu];
}

- (void)didDoneEditItemView:(TKEditItemView *)editItemView {
    [self animationWhenPresentingMenu];
}

- (void)editItemView:(TKEditItemView *)editItemView didSelectItem:(nonnull TKEditItemViewModel *)item atIndex:(NSUInteger)index {
    
}

- (void)animationWhenPresentingMenu {
    CGRect editFrame = _menuCollectionView.frame;
    CGRect menuFrame = editFrame;
    menuFrame.origin.y = menuFrame.origin.y - _menuHeight;
    menuFrame.size.width = _collectionViewWidth;
    CGRect saveButtonFrame = _saveButton.frame;
    saveButtonFrame.origin.y = menuFrame.origin.y;
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf.editView setFrame:editFrame];
        [weakSelf.menuCollectionView setFrame:menuFrame];
        [weakSelf.saveButton setFrame:saveButtonFrame];
    }];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
