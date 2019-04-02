//
//  TKFacialCollectionView.h
//  Tikky
//
//  Created by LeHuuNghi on 1/29/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//
#import "TKSampleDataPool.h"

@interface TKFacialCollectionView : UICollectionView

@property (nonatomic) NSMutableArray<TKFacialModelView *> *dataArray;

@property (nonatomic) id viewController;

@property (nonatomic) id cameraViewController;

@end
