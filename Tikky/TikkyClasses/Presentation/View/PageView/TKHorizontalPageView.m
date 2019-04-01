//
//  TKHorizontalPageView.m
//  Tikky
//
//  Created by Le Hoang Vu on 4/1/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "TKHorizontalPageView.h"
#import "TKPageCollectionViewCell.h"

@interface TKHorizontalPageView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic) NSArray* pageData;
@property (nonatomic) UICollectionView* pageCollectionView;
@property (nonatomic) NSUInteger selectedIndex;

@end

@implementation TKHorizontalPageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) {
        return nil;
    }
    
    _pageData = [NSArray arrayWithObjects:@"Photo", @"Video", nil];
    _selectedIndex = 0;
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(frame.size.height, frame.size.height);
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowLayout.minimumLineSpacing = 10;
    _pageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:flowLayout];
    _pageCollectionView.backgroundColor = [UIColor clearColor];
    [_pageCollectionView setAlwaysBounceHorizontal:YES];
    [_pageCollectionView setScrollEnabled:YES];
    [_pageCollectionView setShowsHorizontalScrollIndicator:NO];
    [_pageCollectionView setShowsVerticalScrollIndicator:NO];
    _pageCollectionView.delegate = self;
    _pageCollectionView.dataSource = self;
    [_pageCollectionView registerClass:TKPageCollectionViewCell.class forCellWithReuseIdentifier:@"PageCollectionViewCell"];
    [self addSubview:_pageCollectionView];
//    [_pageCollectionView setContentInset:UIEdgeInsetsMake(0, self.frame.size.width/2.0 - self.frame.size.height/2.0, 0, 0)];
    [_pageCollectionView reloadData];
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self performSelectCellWithIndexPath:indexPath];
    return self;
}

- (instancetype)init {
    NSAssert(NO, @"Unavailable method, use initWithFrame:");
    return nil;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _pageData.count;
}

#pragma mark - UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TKPageCollectionViewCell* cell = (TKPageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PageCollectionViewCell" forIndexPath:indexPath];
    cell.title = [_pageData objectAtIndex:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSelectCellWithIndexPath:indexPath];
}

- (void)performSelectCellWithIndexPath:(NSIndexPath *)indexPath {
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.15 animations:^{
        [weakSelf.pageCollectionView setContentInset:UIEdgeInsetsMake(0,
                                                                      weakSelf.frame.size.width/2.0
                                                                      - weakSelf.frame.size.height/2.0
                                                                      - weakSelf.frame.size.height*indexPath.row,
                                                                      0,
                                                                      0)];
    }];
    
    if (_delegate && [_delegate respondsToSelector:@selector(horizontalPageView:didSelectPageType:)]) {
        [_delegate horizontalPageView:self didSelectPageType:indexPath.row];
    }
    
    NSIndexPath* lastIndexPath = [NSIndexPath indexPathForRow:_selectedIndex inSection:0];
    TKPageCollectionViewCell* lastCell = (TKPageCollectionViewCell *)[_pageCollectionView cellForItemAtIndexPath:lastIndexPath];
    lastCell.isBold = NO;
    
    TKPageCollectionViewCell* cell = (TKPageCollectionViewCell *)[_pageCollectionView cellForItemAtIndexPath:indexPath];
    cell.isBold = YES;
    _selectedIndex = indexPath.row;
}

@end
