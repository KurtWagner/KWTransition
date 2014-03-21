//
//  KWViewController.m
//  KWTransitionDemo
//
//  Created by Kurt Wagner on 19/03/2014.
//  Copyright (c) 2014 Kurt Wagner. All rights reserved.
//

#import "KWViewController.h"
#import "KWTransition.h"
#import "KWModalViewController.h"

@interface KWViewController ()

@property (nonatomic, strong) NSArray *transitions;
@property (nonatomic, strong) KWTransition *transition;

@end

@implementation KWViewController

- (void)viewDidLoad {
    	[super viewDidLoad];
	
	[self setTitle:@"KWTransition Demo"];
	[self setModalPresentationStyle: UIModalPresentationCustom];
	
	_transition = [KWTransition manager];
	_transitions = @[
		@{
			@"name" : @"KWTransitionStyleFadeBackOver",
			@"style" : @(KWTransitionStyleFadeBackOver)
		},
		@{
			@"name" : @"KWTransitionStyleBounceIn",
			@"style" : @(KWTransitionStyleBounceIn)
		},
		@{
			@"name": @"KWTransitionStyleDropOut",
			@"style": @(KWTransitionStyleDropOut)
		},
		@{
			@"name": @"KWTransitionStyleStepBackScroll",
			@"style": @(KWTransitionStyleStepBackScroll)
		},
		@{
			@"name": @"KWTransitionStyleStepBackSwipe",
			@"style": @(KWTransitionStyleStepBackSwipe)
		},
		@{
			@"name": @"KWTransitionStylePushUp",
			@"style": @(KWTransitionStylePushUp)
		},
		@{
			@"name": @"KWTransitionStyleUp",
			@"style": @(KWTransitionStyleUp)
		},
		@{
			@"name": @"KWTransitionStyleFall",
			@"style": @(KWTransitionStyleFall)
		},
		@{
			@"name" : @"KWTransitionStyleRotateFromTop",
			@"style" : @(KWTransitionStyleRotateFromTop)
		},
	];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.transitions.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString * const reuseIdentifier = @"cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	}
	NSString *name = [[self.transitions objectAtIndex:indexPath.row] objectForKey:@"name"];
	[cell.textLabel setText:name];
	return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	self.transition.style = [[[self.transitions objectAtIndex:indexPath.row] objectForKey:@"style"] unsignedIntegerValue];
	
	KWModalViewController *VC = [[KWModalViewController alloc] init];
	VC.transitioningDelegate = self;
	[self presentViewController:VC animated:YES completion:nil];
}

#pragma mark - UIVieControllerTransitioningDelegate -

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
								   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source {
	self.transition.action = KWTransitionStepPresent;
	return self.transition;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
	self.transition.action = KWTransitionStepDismiss;
	return self.transition;
}

@end
