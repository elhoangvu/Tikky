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
    [self initNewPageCollectionView];
    return self;
}

- (void)initNewPageCollectionView {
    if (_pageCollectionView) {
        [_pageCollectionView removeFromSuperview];
    }
    
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(self.frame.size.height, self.frame.size.height);
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowLayout.minimumLineSpacing = self.frame.size.width*0.03;
    _pageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:flowLayout];
    _pageCollectionView.backgroundColor = [UIColor clearColor];
    [_pageCollectionView setAlwaysBounceHorizontal:YES];
    [_pageCollectionView setScrollEnabled:YES];
    [_pageCollectionView setShowsHorizontalScrollIndicator:NO];
    [_pageCollectionView setShowsVerticalScrollIndicator:NO];
    _pageCollectionView.delegate = self;
    _pageCollectionView.dataSource = self;
    [_pageCollectionView registerClass:TKPageCollectionViewCell.class forCellWithReuseIdentifier:@"PageCollectionViewCell"];
    [self addSubview:_pageCollectionView];
    [_pageCollectionView reloadData];
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:_selectedIndex inSection:0];
    [self performSelectCellWithIndexPath:indexPath];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    // Can be optimized by re-setting frame for collectionview
    [self initNewPageCollectionView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // Can be optimized by re-setting frame for collectionview
    [self initNewPageCollectionView];
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

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    static BOOL endableScrolling = YES;
    if (endableScrolling) {
        CGFloat cellWidth = self.frame.size.height;
        CGFloat scrollOffset = _pageCollectionView.contentInset.left + scrollView.contentOffset.x;
        NSInteger passedCell = roundf(scrollOffset/cellWidth);
        NSInteger scrollingRow = _selectedIndex + passedCell;
        if (scrollingRow < 0) {
            scrollingRow = 0;
        } else if (scrollingRow >= _pageData.count) {
            scrollingRow = _pageData.count - 1;
        }
        endableScrolling = NO;
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:scrollingRow inSection:0];
        [self performSelectCellWithIndexPath:indexPath];
        endableScrolling = YES;
    }
}

- (void)performSelectCellWithIndexPath:(NSIndexPath *)indexPath {
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.15 animations:^{
        CGFloat cellOffset = [self calculateCellOffsetWithCellIndex:indexPath.row];
        [weakSelf.pageCollectionView setContentInset:UIEdgeInsetsMake(0, cellOffset, 0, 0)];
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

- (CGFloat)calculateCellOffsetWithCellIndex:(NSUInteger)cellIndex {
    
    return self.frame.size.width/2.0
         - self.frame.size.height/2.0
         - self.frame.size.height*cellIndex
         - self.frame.size.width*0.03*cellIndex;
}

@end
