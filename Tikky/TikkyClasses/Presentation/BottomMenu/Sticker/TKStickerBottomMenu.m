//
//  TKStickerBottomMenu.m
//  TKPresentation
//
//  Created by LeHuuNghi on 1/27/19.
//  Copyright © 2019 LeHuuNghi. All rights reserved.
//

#import "TKStickerBottomMenu.h"
@interface TKStickerBottomMenu()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic) UISwipeGestureRecognizer *swipeGesture;

@end

@implementation TKStickerBottomMenu

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

-(void)setUp {
    _selectionView = [TKStickerTypeSelection new];
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    _stickerCollectionView=[[TKStickerCollectionView alloc] initWithFrame:self.frame collectionViewLayout:layout];
    
    [self addSubview:self.selectionView];
    [self addSubview:self.stickerCollectionView];
    
    _stickerCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.stickerCollectionView.dataSource = self;
    self.stickerCollectionView.delegate = self;
    [[self.stickerCollectionView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor] setActive:YES];
    [[self.stickerCollectionView.leftAnchor constraintEqualToAnchor:self.leftAnchor] setActive:YES];
    [[self.stickerCollectionView.rightAnchor constraintEqualToAnchor:self.rightAnchor] setActive:YES];
    [[self.stickerCollectionView.heightAnchor constraintEqualToAnchor:self.heightAnchor] setActive:YES];
    
    _selectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [[self.selectionView.bottomAnchor constraintGreaterThanOrEqualToAnchor:self.stickerCollectionView.topAnchor] setActive:YES];
    [[self.selectionView.leftAnchor constraintEqualToAnchor:self.leftAnchor] setActive:YES];
    [[self.selectionView.rightAnchor constraintEqualToAnchor:self.rightAnchor] setActive:YES];
    [[self.selectionView.heightAnchor constraintEqualToAnchor:self.stickerCollectionView.heightAnchor multiplier:0.3] setActive:YES];
    [self.stickerCollectionView registerClass:[TKStickerCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
}

- (void)setViewController:(id)viewController {
    [super setViewController:viewController];
    _delegate = viewController;
}

#pragma UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    long numberOfRows = [[TKSampleDataPool class] getStickers].count / 5;
//    return [[TKSampleDataPool class] getStickers].count % 5 == 0 ? numberOfRows : numberOfRows + 1;
    return self.stickers.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {    
    TKStickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if (cell) {
    cell.viewController = self.viewController;
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[self.stickers objectAtIndex:indexPath.row].thumbnailPath ofType:@"png"]];
    cell.imageView = [[UIImageView alloc] initWithImage:image];
        
    }
    return cell;
}

#pragma UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate cellClickWith:[self.stickers objectAtIndex:indexPath.row].identifier andType:@"sticker"];
}


@end
