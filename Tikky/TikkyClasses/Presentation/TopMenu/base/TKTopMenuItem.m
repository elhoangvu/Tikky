//
//  TKNavigationItem.m
//  TKPresentation
//
//  Created by LeHuuNghi on 12/4/18.
//  Copyright © 2018 LeHuuNghi. All rights reserved.
//

#import "TKTopMenuItem.h"

@interface TKTopMenuItem()

@end

@implementation TKTopMenuItem

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithName:(NSString *)name {
    self = [self init];
    if (self) {
        _name = name;
        
        [self setPathImage:[[NSBundle mainBundle] pathForResource:_name ofType:@"png"]];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
        singleTap.numberOfTapsRequired = 1;
        [self setUserInteractionEnabled:YES];
        [self addGestureRecognizer:singleTap];
    }
    return self;
}

- (void)setPathImage:(NSString *)path {
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
    
    [self setImage:image];
    

}

-(void)tapDetected {
    if([self.delegate respondsToSelector:@selector(tapTopItem:)]) {
        [self.delegate tapTopItem:self.name];
    }
}

@end
