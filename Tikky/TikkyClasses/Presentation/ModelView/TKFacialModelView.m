//
//  TKFacialModel.m
//  Tikky
//
//  Created by LeHuuNghi on 3/26/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "TKFacialModelView.h"

@implementation TKFacialModelView

-(instancetype)initWithIdentifier:(NSNumber *)identifier andType:(NSString *)type andThumbnailImage:(UIImageView *)imageView {
    self = [super init];
    if (self) {
        self.identifier = identifier;
        self.type = type;
        _thumbImageView = imageView;
    }
    return self;
}

@end
