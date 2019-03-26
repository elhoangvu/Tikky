//
//  EditViewController.m
//  Tikky
//
//  Created by LeHuuNghi on 3/6/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "EditViewController.h"

@interface EditViewController ()

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    

}


- (void)setImageView:(UIImageView *)imageView {
    
    _deleteButton = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"delete" ofType:@"png"]]];
    _editButton = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"edit" ofType:@"png"]]];
    _shareButton = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"share" ofType:@"png"]]];
    
    _editButton.contentMode = UIViewContentModeScaleAspectFit;
    _shareButton.contentMode = UIViewContentModeScaleAspectFit;
    _deleteButton.contentMode = UIViewContentModeScaleAspectFit;
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareTapDetected)];
    singleTap.numberOfTapsRequired = 1;
    [_shareButton setUserInteractionEnabled:YES];
    [_shareButton addGestureRecognizer:singleTap];
    
    UIStackView *stackView = [UIStackView new];
    [self.view addSubview:stackView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    stackView.backgroundColor = [UIColor whiteColor];
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    stackView.distribution = UIStackViewDistributionEqualSpacing;
    stackView.alignment = UIStackViewAlignmentCenter;
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [stackView addArrangedSubview:_deleteButton];
    [stackView addArrangedSubview:_editButton];
    [stackView addArrangedSubview:_shareButton];
    
    [[stackView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor] setActive:YES];
    [[stackView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor] setActive:YES];
    [[stackView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor] setActive:YES];
    [[stackView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:0.1] setActive:YES];

    _imageView = imageView;
    
    [self.view addSubview:_imageView];
    
    _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [[_imageView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor] setActive:YES];
    [[_imageView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor] setActive:YES];
    [[_imageView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor] setActive:YES];
    [[_imageView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:0.8] setActive:YES];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)shareTapDetected{
    NSLog(@"single Tap on imageview");
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
