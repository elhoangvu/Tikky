//
//  TKPhotoPickerViewController.m
//  Tikky
//
//  Created by LeHuuNghi on 5/29/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "TKPhotosPickerViewController.h"
#import "TKPHAsset.h"

@protocol TKPhotosPickerViewControllerDelegate <NSObject>

@optional
- (void)dismissPhotoPickerWithPHAssets:(NSArray<PHAsset *> *)phAssets;
- (void)dismissPhotoPickerWithTKPHAssets:(NSArray<TKPHAsset *> *)phAssets;
- (void)dismissComplete;
- (void)photoPickerDidCancel;
- (BOOL)canSelectAsset:(PHAsset *)phAssets;
- (BOOL)didExceedMaximumNumberOfSelection:(TKPhotosPickerViewController *)picker;
- (BOOL)handleNoAlbumPermissions:(TKPhotosPickerViewController *)phAssets;


@end


@interface TKPhotosPickerViewController ()

@property (weak, nonatomic) id<TKPhotosPickerViewControllerDelegate> delegate;

@end

@implementation TKPhotosPickerViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        return [super initWithNibName:@"TKPhotosPickerViewController" bundle:[NSBundle bundleForClass:TKPhotosPickerViewController.class]];
    }
    return self;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete implementation, return the number of sections
    return 0;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of items
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
