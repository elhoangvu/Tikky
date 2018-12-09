//
//  ViewController.m
//  Tikky
//
//  Created by Le Hoang Vu on 12/9/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import "ViewController.h"
#import "CameraViewController.h"

@implementation ViewController

- (IBAction)didTapNghiButton:(id)sender {

}

- (IBAction)didTapVuButton:(id)sender {
    CameraViewController* camVC = [[CameraViewController alloc] init];
    [self presentViewController:camVC animated:YES completion:nil];
}

@end
