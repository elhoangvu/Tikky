//
//  TKFrameModel.h
//  TKPresentation
//
//  Created by LeHuuNghi on 1/28/19.
//  Copyright © 2019 LeHuuNghi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKModelViewObject.h"
NS_ASSUME_NONNULL_BEGIN

@interface TKFrameModelView : TKModelViewObject
@property (nonatomic) UIImageView *thumbImageView;

-(instancetype)initWithIdentifier:(NSNumber *)identifier andType:(NSString *)type andThumbnailImage:(UIImageView *)imageView;

@end

NS_ASSUME_NONNULL_END
