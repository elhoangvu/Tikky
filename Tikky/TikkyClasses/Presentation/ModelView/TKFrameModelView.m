//
//  TKFrameModel.m
//  TKPresentation
//
//  Created by LeHuuNghi on 1/28/19.
//  Copyright © 2019 LeHuuNghi. All rights reserved.
//

#import "TKFrameModelView.h"

@implementation TKFrameModelView

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
