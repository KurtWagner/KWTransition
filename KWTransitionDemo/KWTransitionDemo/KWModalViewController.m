//
//  KWModalViewController.m
//  KWTransitionDemo
//
//  Created by Kurt Wagner on 19/03/2014.
//  Copyright (c) 2014 Kurt Wagner. All rights reserved.
//

#import "KWModalViewController.h"

@interface KWModalViewController ()
- (IBAction)userTouchedDismissButton:(UIButton *)sender;
@end

@implementation KWModalViewController

- (IBAction)userTouchedDismissButton:(UIButton *)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
