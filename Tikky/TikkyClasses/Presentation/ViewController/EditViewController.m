//
//  EditViewController.m
//  Tikky
//
//  Created by LeHuuNghi on 3/6/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "EditViewController.h"
#import "TKShareView.h"

@interface EditViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic) UIStackView *stackView;

@property (nonatomic) NSLayoutConstraint *bottomConstraint;

@property (nonatomic) TKShareView *shareView;

@property (nonatomic) UIPanGestureRecognizer *panGestureRecognize;

@property (nonatomic) UIImageView *backButton;

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self) {

        _imageView = [[UIImageView alloc] initWithImage:image];
        
        [self.view addSubview:_imageView];
        
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [[_imageView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor] setActive:YES];
        [[_imageView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor] setActive:YES];
        [[_imageView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor] setActive:YES];
        [[_imageView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:0.8] setActive:YES];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view layoutIfNeeded];
        
        _stackView = [UIStackView new];
        [self.view addSubview:_stackView];
        self.view.backgroundColor = [UIColor whiteColor];
        
        _stackView.backgroundColor = [UIColor whiteColor];
        _stackView.axis = UILayoutConstraintAxisHorizontal;
        _stackView.distribution = UIStackViewDistributionEqualSpacing;
        _stackView.alignment = UIStackViewAlignmentCenter;
        _stackView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [[_stackView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor] setActive:YES];
        [[_stackView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor] setActive:YES];
        [[_stackView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor] setActive:YES];
        [[_stackView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:0.1] setActive:YES];
        
        _deleteButton = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"delete" ofType:@"png"]]];
        _editButton = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"edit" ofType:@"png"]]];
        _shareButton = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"share" ofType:@"png"]]];
        
        _editButton.translatesAutoresizingMaskIntoConstraints = NO;
        _shareButton.translatesAutoresizingMaskIntoConstraints = NO;
        _deleteButton.translatesAutoresizingMaskIntoConstraints = NO;
        
        _editButton.contentMode = UIViewContentModeScaleAspectFit;
        _shareButton.contentMode = UIViewContentModeScaleAspectFit;
        _deleteButton.contentMode = UIViewContentModeScaleAspectFit;
        
        [_stackView addArrangedSubview:_deleteButton];
        [_stackView addArrangedSubview:_editButton];
        [_stackView addArrangedSubview:_shareButton];
        
        [[_deleteButton.heightAnchor constraintEqualToAnchor:_stackView.heightAnchor multiplier:0.5] setActive:YES];
        [[_editButton.heightAnchor constraintEqualToAnchor:_stackView.heightAnchor multiplier:0.5] setActive:YES];
        [[_shareButton.heightAnchor constraintEqualToAnchor:_stackView.heightAnchor multiplier:0.5] setActive:YES];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareTapDetected)];
        singleTap.numberOfTapsRequired = 1;
        [_shareButton setUserInteractionEnabled:YES];
        [_shareButton addGestureRecognizer:singleTap];
        
        [self.view layoutIfNeeded];
        
        _shareView = [TKShareView new];
        _shareView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_shareView];
        
        _shareView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [[_shareView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor] setActive:YES];
        [[_shareView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor] setActive:YES];
        [[_shareView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:0.2] setActive:YES];
        _bottomConstraint = [_shareView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:2*self.stackView.frame.size.height];
        [_bottomConstraint setActive:YES];
        
        self.panGestureRecognize = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self.view addGestureRecognizer:self.panGestureRecognize];
        [self.panGestureRecognize setMinimumNumberOfTouches:1];
        [self.panGestureRecognize setMaximumNumberOfTouches:1];
        self.panGestureRecognize.delegate = self;
        
        _backButton = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cross" ofType:@"png"]]];
        _backButton.contentMode = UIViewContentModeScaleAspectFit;
        _backButton.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.view addSubview:_backButton];
        [[_backButton.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:10] setActive:YES];
        [[_backButton.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:20] setActive:YES];
        [[_backButton.bottomAnchor constraintEqualToAnchor:self.imageView.topAnchor constant:-20] setActive:YES];
        [_backButton setUserInteractionEnabled:YES];
        [_backButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoBack)]];

    
    }
    return self;
}

-(void)gotoBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [UIView animateWithDuration:0.4 animations:^{
        self.bottomConstraint.constant = 2*self.stackView.frame.size.height;
        [self.view layoutIfNeeded];
    }];
}

-(void)shareTapDetected{
    NSLog(@"single Tap on imageview");
    
    [UIView animateWithDuration:0.4 animations:^{
        self.bottomConstraint.constant = 0;
        [self.view layoutIfNeeded];
    }];
}

- (void)pan:(UIPanGestureRecognizer *)panGesture {
//    CGPoint translation = [panGesture translationInView:self.view];
//    self.view.center = CGPointMake(self.view.center.x, self.view.center.y + translation.y);
}


@end
