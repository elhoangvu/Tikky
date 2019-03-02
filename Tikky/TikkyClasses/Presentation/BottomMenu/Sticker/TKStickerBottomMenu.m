//
//  TKStickerBottomMenu.m
//  TKPresentation
//
//  Created by LeHuuNghi on 1/27/19.
//  Copyright © 2019 LeHuuNghi. All rights reserved.
//

#import "TKStickerBottomMenu.h"
#import "TKTypeSelectionCollectionViewCell.h"
#import "TKTypeStickerCollectionView.h"
#import "TKFrameCollectionView.h"

@interface TKStickerBottomMenu()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic) UISwipeGestureRecognizer *swipeGesture;

@property (nonatomic) NSArray *typeSelection;

@property (nonatomic) NSMutableDictionary<NSString *, UICollectionView *> *collectionDictionary;

@end

@implementation TKStickerBottomMenu

- (instancetype)init
{
    self = [super init];
    if (self) {
        _collectionDictionary = [NSMutableDictionary new];
        _typeSelection = @[@"Sticker", @"Frame", @"Text", @"Drawing"];
        [self setUp];
    }
    return self;
}

-(void)setUp {
    UICollectionViewFlowLayout *layout1=[[UICollectionViewFlowLayout alloc] init];
    UICollectionViewFlowLayout *layout2=[[UICollectionViewFlowLayout alloc] init];
    _selectionView = [[TKTypeStickerCollectionView alloc] initWithFrame:self.frame collectionViewLayout:layout1];
    _stickerCollectionView = [[TKStickerCollectionView alloc] initWithFrame:self.frame collectionViewLayout:layout2];
    
    [self addSubview:self.selectionView];
    [self addSubview:self.stickerCollectionView];
    
    [_selectionView setBackgroundColor:[[UIColor alloc] initWithWhite:0 alpha:0.3]];
     
    _selectionView.dataSource = self;
    _selectionView.delegate = self;
    _selectionView.scrollEnabled = NO;
    
    _stickerCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [[self.stickerCollectionView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor] setActive:YES];
    [[self.stickerCollectionView.leftAnchor constraintEqualToAnchor:self.leftAnchor] setActive:YES];
    [[self.stickerCollectionView.rightAnchor constraintEqualToAnchor:self.rightAnchor] setActive:YES];
    [[self.stickerCollectionView.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:0.8] setActive:YES];
    
    _selectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [[self.selectionView.bottomAnchor constraintEqualToAnchor:self.stickerCollectionView.topAnchor] setActive:YES];
    [[self.selectionView.leftAnchor constraintEqualToAnchor:self.leftAnchor] setActive:YES];
    [[self.selectionView.rightAnchor constraintEqualToAnchor:self.rightAnchor] setActive:YES];
    [[self.selectionView.topAnchor constraintEqualToAnchor:self.topAnchor] setActive:YES];
     [_collectionDictionary setValue:self.stickerCollectionView forKey:@"sticker"];

    [self.selectionView registerClass:[TKTypeSelectionCollectionViewCell class] forCellWithReuseIdentifier:@"type_cell"];
}

- (void)setViewController:(id)viewController {
    [super setViewController:viewController];
    _delegate = viewController;
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
        TKTypeSelectionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"type_cell" forIndexPath:indexPath];
        if (cell) {
            if (!cell.label) {
                cell.label = [UILabel new];
            }
            cell.label.text = [self.typeSelection objectAtIndex:indexPath.row];
        }
        return cell;
    }
    return nil;
}

#pragma UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.selectionView) {
        switch (indexPath.row) {
            case 0: {
                [self.stickerCollectionView setHidden:YES];
                self.stickerCollectionView = [_collectionDictionary objectForKey:@"sticker"];
                [self.stickerCollectionView setHidden:NO];
                break;
            }
            case 1: {
                [self.stickerCollectionView setHidden:YES];
                if ([_collectionDictionary objectForKey:@"frame"]) {
                    self.stickerCollectionView = [_collectionDictionary objectForKey:@"frame"];
                    [self.stickerCollectionView setHidden:NO];
                } else {
                    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
                    UICollectionView *frameCollectionView = [[TKFrameCollectionView alloc] initWithFrame:self.frame collectionViewLayout:layout];
                    
                    [self addSubview:frameCollectionView];
                    frameCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
                    frameCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
                    [[frameCollectionView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor] setActive:YES];
                    [[frameCollectionView.leftAnchor constraintEqualToAnchor:self.leftAnchor] setActive:YES];
                    [[frameCollectionView.rightAnchor constraintEqualToAnchor:self.rightAnchor] setActive:YES];
                    [[frameCollectionView.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:0.8] setActive:YES];
                    self.stickerCollectionView = frameCollectionView;
                    [_collectionDictionary setValue:frameCollectionView forKey:@"frame"];
                }
                break;
            }
            case 2:
                
                break;
            case 3:
                
                break;
            default:
                break;
        }
        self.stickerCollectionView.delegate = self;
    } else {
        ((TKModelObject *)[((TKStickerCollectionViewBase *)collectionView).dataArray objectAtIndex:indexPath.row]).identifier;
    }
    
}

@end
