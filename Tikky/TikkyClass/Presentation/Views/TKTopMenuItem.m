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
        
//        _subMenuView = [TKTopSubViewMenu new];
//        _subMenuView.translatesAutoresizingMaskIntoConstraints = NO;
//        
//        [self addSubview:_subMenuView];
        
        
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
    [self.delegate clickItem:self.name];
}

@end
