//
//  TKBottomItem.m
//  TKPresentation
//
//  Created by LeHuuNghi on 12/4/18.
//  Copyright © 2018 LeHuuNghi. All rights reserved.
//

#import "TKBottomMenuItem.h"

@interface TKBottomMenuItem()

@property (nonatomic, strong) NSString *name;

@end

@implementation TKBottomMenuItem

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(instancetype)initWithName:(NSString *)name {
    self = [self init];
    if (self) {
        _name = name;
    }
    return self;
}

- (void)setPathImage:(NSString *)path {
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
    
//    image = [self imageWithImage:image convertToSize:self.frame.size];
    
    self.imageView = [[UIImageView alloc] initWithImage:image];

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
    singleTap.numberOfTapsRequired = 1;
    [self setUserInteractionEnabled:YES];
    [self addGestureRecognizer:singleTap];
}

-(void)tapDetected {
    [self.delegate clickItem:self.name];
}

- (void)setImageView:(UIImageView *)imageView {
    if (!self.imageView) {
        _imageView = imageView;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.imageView];
//        _imageView.center = self.center;
//        [_imageView setFrame:CGRectMake(self.frame.origin.x + self.frame.size.width/4,
//                                         self.frame.origin.y - self.frame.size.width/4,
//                                         self.frame.size.width/2,
//                                         self.frame.size.width/2)];
    }
}

//- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
//    CGSize newSize;
//    newSize.width = size.width / 2.0;
//    newSize.height = size.height / 2.0;
//    UIGraphicsBeginImageContext(newSize);
//    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
//    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return destImage;
//}

@end
