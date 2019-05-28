//
//  TKBottomEditView.m
//  Tikky
//
//  Created by LeHuuNghi on 5/6/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "TKBottomEditView.h"

@interface TKBottomEditView()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic) UISwipeGestureRecognizer *swipeGesture;

@property (nonatomic) NSArray *typeSelection;

@property (nonatomic) NSMutableDictionary<NSString *, UICollectionView *> *collectionDictionary;

@end

@implementation TKBottomEditView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _collectionDictionary = [NSMutableDictionary new];
        _typeSelection = @[@"sticker", @"frame", @"filter", @"emoji", @"done"];
        [self setUp];
    }
    return self;
}

-(void)setUp {
    UICollectionViewFlowLayout *layout1=[[UICollectionViewFlowLayout alloc] init];
    UICollectionViewFlowLayout *layout2=[[UICollectionViewFlowLayout alloc] init];
    layout1.minimumInteritemSpacing = ([[UIScreen mainScreen] bounds].size.width - self.typeSelection.count * 50) / (self.typeSelection.count + 1);
    _selectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:layout1];
    _stickerCollectionView = [[TKStickerCollectionView alloc] initWithFrame:self.frame collectionViewLayout:layout2];
    
    [self addSubview:self.selectionView];
    [self addSubview:self.stickerCollectionView];
    
    [_selectionView setBackgroundColor:[[UIColor alloc] initWithWhite:0 alpha:0.3]];
    
    _selectionView.dataSource = self;
    _selectionView.delegate = self;
    _selectionView.scrollEnabled = NO;
    
    _stickerCollectionView.backgroundColor = [UIColor whiteColor];
    _stickerCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [[self.stickerCollectionView.bottomAnchor constraintEqualToAnchor:self.selectionView.topAnchor] setActive:YES];
    [[self.stickerCollectionView.leftAnchor constraintEqualToAnchor:self.leftAnchor] setActive:YES];
    [[self.stickerCollectionView.rightAnchor constraintEqualToAnchor:self.rightAnchor] setActive:YES];
    [[self.stickerCollectionView.topAnchor constraintEqualToAnchor:self.topAnchor] setActive:YES];
    
    _selectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [[self.selectionView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor] setActive:YES];
    [[self.selectionView.leftAnchor constraintEqualToAnchor:self.leftAnchor] setActive:YES];
    [[self.selectionView.rightAnchor constraintEqualToAnchor:self.rightAnchor] setActive:YES];
    [[self.selectionView.heightAnchor constraintEqualToConstant:50] setActive:YES];
    [_collectionDictionary setValue:self.stickerCollectionView forKey:@"sticker"];
    self.stickerCollectionView.cameraViewController = self.cameraViewController;
    
    [self.selectionView registerClass:[TKSelectionBottomMenuCollectionViewCell class] forCellWithReuseIdentifier:@"selection_edit_bottom_menu"];
}

- (void)setViewController:(id)viewController {
    [super setViewController:viewController];
    _delegate = viewController;
}

- (void)setCameraViewController:(id)cameraViewController {
    [super setCameraViewController:cameraViewController];
    self.stickerCollectionView.cameraViewController = self.cameraViewController;
    [self.stickerCollectionView reloadData];
}

#pragma UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == _selectionView) {
        return self.typeSelection.count;
    }
    return 0;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.selectionView) {
        TKSelectionBottomMenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"selection_edit_bottom_menu" forIndexPath:indexPath];
        if (cell) {
            cell.imageView.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[self.typeSelection objectAtIndex:indexPath.row] ofType:@"png"]];
        }
        return cell;
    }
    return nil;
}

- (void)setDelegate:(id<TKBottomEditMenuItemDelegate>)delegate {
    _delegate = delegate;
    self.cameraViewController = delegate;
    self.viewController = delegate;
}

#pragma UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.selectionView) {
        switch (indexPath.row) {
            case 0: {
                [self.stickerCollectionView setHidden:YES];
                self.stickerCollectionView = [self.collectionDictionary objectForKey:@"sticker"];
                [self.stickerCollectionView setHidden:NO];
                self.stickerCollectionView.cameraViewController = self.cameraViewController;
                break;
            }
            case 1: {
                [self.stickerCollectionView setHidden:YES];
                if ([_collectionDictionary objectForKey:@"frame"]) {
                    self.stickerCollectionView = [self.collectionDictionary objectForKey:@"frame"];
                    [self.stickerCollectionView setHidden:NO];
                    self.stickerCollectionView.cameraViewController = self.cameraViewController;
                } else {
                    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
                    UICollectionView *frameCollectionView = [[TKFrameCollectionView alloc] initWithFrame:self.frame collectionViewLayout:layout];
                    
                    [self addSubview:frameCollectionView];
                    frameCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
                    [[frameCollectionView.bottomAnchor constraintEqualToAnchor:self.selectionView.topAnchor] setActive:YES];
                    [[frameCollectionView.leftAnchor constraintEqualToAnchor:self.leftAnchor] setActive:YES];
                    [[frameCollectionView.rightAnchor constraintEqualToAnchor:self.rightAnchor] setActive:YES];
                    [[frameCollectionView.topAnchor constraintEqualToAnchor:self.topAnchor] setActive:YES];
                    self.stickerCollectionView = frameCollectionView;
                    [self.collectionDictionary setValue:frameCollectionView forKey:@"frame"];
                    self.stickerCollectionView.cameraViewController = self.cameraViewController;
                }
                break;
            }
            case 2: {
                [self.stickerCollectionView setHidden:YES];
                if ([_collectionDictionary objectForKey:@"filter"]) {
                    self.stickerCollectionView = [self.collectionDictionary objectForKey:@"filter"];
                    [self.stickerCollectionView setHidden:NO];
                    self.stickerCollectionView.cameraViewController = self.cameraViewController;
                } else {
                    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
                    UICollectionView *filterCollectionView = [[TKFilterCollectionView alloc] initWithFrame:self.frame collectionViewLayout:layout];
                    
                    [self addSubview:filterCollectionView];
                    filterCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
                    [[filterCollectionView.bottomAnchor constraintEqualToAnchor:self.selectionView.topAnchor] setActive:YES];
                    [[filterCollectionView.leftAnchor constraintEqualToAnchor:self.leftAnchor] setActive:YES];
                    [[filterCollectionView.rightAnchor constraintEqualToAnchor:self.rightAnchor] setActive:YES];
                    [[filterCollectionView.topAnchor constraintEqualToAnchor:self.topAnchor] setActive:YES];
                    self.stickerCollectionView = filterCollectionView;
                    [self.collectionDictionary setValue:filterCollectionView forKey:@"filter"];
                    self.stickerCollectionView.cameraViewController = self.cameraViewController;
                }
                break;
            }
            case 3: {
                [self.stickerCollectionView setHidden:YES];
                if ([_collectionDictionary objectForKey:@"facial"]) {
                    self.stickerCollectionView = [self.collectionDictionary objectForKey:@"facial"];
                    [self.stickerCollectionView setHidden:NO];
                    self.stickerCollectionView.cameraViewController = self.cameraViewController;
                } else {
                    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
                    UICollectionView *facialCollectionView = [[TKFacialCollectionView alloc] initWithFrame:self.frame collectionViewLayout:layout];
                    
                    [self addSubview:facialCollectionView];
                    facialCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
                    [[facialCollectionView.bottomAnchor constraintEqualToAnchor:self.selectionView.topAnchor] setActive:YES];
                    [[facialCollectionView.leftAnchor constraintEqualToAnchor:self.leftAnchor] setActive:YES];
                    [[facialCollectionView.rightAnchor constraintEqualToAnchor:self.rightAnchor] setActive:YES];
                    [[facialCollectionView.topAnchor constraintEqualToAnchor:self.topAnchor] setActive:YES];
                    self.stickerCollectionView = facialCollectionView;
                    [self.collectionDictionary setValue:facialCollectionView forKey:@"facial"];
                    self.stickerCollectionView.cameraViewController = self.cameraViewController;
                }
                break;
            }
            case 4: {
                [self.delegate enableEditMode:NO];
                break;
            }

                
                break;
            default:
                break;
        }
    }
}



@end
