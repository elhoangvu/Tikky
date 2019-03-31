//
//  TKBottomItem.m
//  TKPresentation
//
//  Created by LeHuuNghi on 12/4/18.
//  Copyright © 2018 LeHuuNghi. All rights reserved.
//

#import "TKBottomMenuItem.h"

@interface TKBottomMenuItem()

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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.delegate clickBottomMenuItem:self.name];
}

-(instancetype)initWithName:(NSString *)name {
    self = [self init];
    if (self) {
        _name = name;
        
        [self setPathImage:[[NSBundle mainBundle] pathForResource:_name ofType:@"png"]];
    }
    return self;
}

- (void)setPathImage:(NSString *)path {
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
    
    [self setImage:image];

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
    singleTap.numberOfTapsRequired = 1;
    [self setUserInteractionEnabled:YES];
    [self addGestureRecognizer:singleTap];
}

-(void)tapDetected {
}

@end
