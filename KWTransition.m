// KWTransition.m
//
// Copyright (c) 2013 Kurt Wagner <krw521@uowmail.edu.au>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "KWTransition.h"

@interface KWTransition ()
@property (nonatomic, strong) UIView *overlayView;
@end

@implementation KWTransition

+ (instancetype)manager {
	KWTransition *manager = [[self alloc] init];
	return manager;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
	return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {

	UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
	UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
	CGRect fromRect = [transitionContext initialFrameForViewController:fromVC];
	
	UIView* inView = [transitionContext containerView];

	if (self.style == KWTransitionStyleRotateFromTop) {
		if (self.action == KWTransitionStepPresent){
			CGAffineTransform rotation;
			rotation = CGAffineTransformMakeRotation(M_PI);
			fromVC.view.frame = fromRect;
			fromVC.view.layer.anchorPoint = CGPointMake(0.5, 0.0);
			fromVC.view.layer.position = CGPointMake(160.0, 0);

			[inView insertSubview:toVC.view belowSubview:fromVC.view];
			CGPoint toVCCenter = toVC.view.center;

			toVC.view.center = CGPointMake(-fromRect.size.width, fromRect.size.height);
			toVC.view.transform = CGAffineTransformMakeRotation(M_PI/2);

			[UIView animateWithDuration:1.f delay:0.f usingSpringWithDamping:.8f initialSpringVelocity:6.f options:UIViewAnimationOptionCurveEaseIn animations:^{
				fromVC.view.transform = rotation;
				toVC.view.center = toVCCenter;
				toVC.view.transform = CGAffineTransformMakeRotation(0);
			} completion:^(__unused BOOL finished) {
				[transitionContext completeTransition:YES];
			}];
		} else {
			CGAffineTransform rotation;
			rotation = CGAffineTransformMakeRotation(M_PI);
			fromVC.view.frame = fromRect;
			fromVC.view.layer.anchorPoint = CGPointMake(0.5, 0.0);
			fromVC.view.layer.position = CGPointMake(160.0, 0);

			[inView insertSubview:toVC.view belowSubview:fromVC.view];

			toVC.view.layer.anchorPoint = CGPointMake(0.5, 0.0);
			toVC.view.layer.position = CGPointMake(160.0, 0);
			toVC.view.transform = CGAffineTransformMakeRotation(-M_PI);

			[UIView animateWithDuration:1.f delay:0.f usingSpringWithDamping:0.8f initialSpringVelocity:6.f options:UIViewAnimationOptionCurveEaseIn animations:^{
				fromVC.view.center = CGPointMake(fromVC.view.center.x - 320, fromVC.view.center.y);
				toVC.view.transform = CGAffineTransformMakeRotation(-0);
			} completion:^(__unused BOOL finished) {
				[transitionContext completeTransition:YES];
				fromVC.view.center = inView.center;
			}];
		}
	} else if (self.style == KWTransitionStyleBounceIn) {
		if (self.action == KWTransitionStepPresent) {
			[self addOverlayToViewController:fromVC.view];
			
			[inView addSubview:toVC.view];
			CGPoint centerOffScreen = inView.center;

			centerOffScreen.y = (-1)*inView.frame.size.height;
			toVC.view.center = centerOffScreen;

			[UIView animateWithDuration:1.f delay:0.f usingSpringWithDamping:0.4f initialSpringVelocity:6.f options:UIViewAnimationOptionCurveEaseIn animations:^{
				toVC.view.center = inView.center;
				self.overlayView.alpha = 0.3f;
			} completion:^(__unused BOOL finished) {
				[transitionContext completeTransition:YES];
			}];
		} else {
			[inView insertSubview:toVC.view belowSubview:fromVC.view];

			CGPoint centerOffScreen = inView.center;
			centerOffScreen.y = (-1)*inView.frame.size.height;

			[UIView animateKeyframesWithDuration:1.f delay:0.f options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
				[UIView addKeyframeWithRelativeStartTime:0.f relativeDuration:0.5f animations:^{
					CGPoint center = fromVC.view.center;
					center.y += 50;
					fromVC.view.center = center;
				}];
				[UIView addKeyframeWithRelativeStartTime:0.5f relativeDuration:0.5f animations:^{
					fromVC.view.center = centerOffScreen;
					
					if (self.overlayView) {
						self.overlayView.alpha = 0;
					}
				}];
			} completion:^(__unused BOOL finished) {
				if (self.overlayView) {
					[self.overlayView removeFromSuperview];
					self.overlayView = nil;
				}
			
				[transitionContext completeTransition:YES];
			}];
		}
	} else if (self.style == KWTransitionStyleFadeBackOver) {
		if (self.action == KWTransitionStepPresent) {
			
			[self addOverlayToViewController:fromVC.view];
			[inView addSubview:toVC.view];
			
			CGPoint centerOffScreen = inView.center;

			centerOffScreen.y = (2)*inView.frame.size.height;
			toVC.view.center = centerOffScreen;
			
			CGFloat fromScale = .8f;
			CGPoint fromVCCenterOffScreen = fromVC.view.center;
			fromVCCenterOffScreen.y = fromScale * fromVCCenterOffScreen.y;
			
			[UIView animateKeyframesWithDuration:.8f delay:0.f options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
				[UIView addKeyframeWithRelativeStartTime:0.f relativeDuration:.3f animations:^{
					CATransform3D t = CATransform3DIdentity;
					t.m34 = 1.0/ -500;
					t = CATransform3DRotate(t, 14.0f * M_PI / 180.0f, 1, 0, 0);
					fromVC.view.layer.transform = t;
					self.overlayView.alpha = 0.3f;
				}];
				[UIView addKeyframeWithRelativeStartTime:.3f relativeDuration:.5f animations:^{
					self.overlayView.alpha = 0.8f;
					fromVC.view.center = fromVCCenterOffScreen;
					fromVC.view.transform = CGAffineTransformMakeScale(fromScale, fromScale);
				}];
			} completion:nil];
			
			[UIView animateWithDuration:.5f delay:.5f usingSpringWithDamping:0.8f initialSpringVelocity:.4f options:UIViewAnimationOptionCurveEaseIn animations:^{
				toVC.view.center = inView.center;
			} completion:^(__unused BOOL finished) {
				[transitionContext completeTransition:YES];
			}];
			
		} else {
			[inView insertSubview:toVC.view belowSubview:fromVC.view];

			CGFloat toScale = .8f;
			CGPoint toVCCenterOffScreenFinal = inView.center;
			CGPoint toVCCenterOffScreen = inView.center;
			toVCCenterOffScreen.y = toScale * toVCCenterOffScreen.y;
			
			toVC.view.transform = CGAffineTransformMakeScale(toScale, toScale);
			toVC.view.center = toVCCenterOffScreen;
			
			CGPoint centerOffScreen = inView.center;
			centerOffScreen.y = (-1)*inView.frame.size.height;

			[UIView animateKeyframesWithDuration:.5f delay:0.f options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
				CGPoint center = fromVC.view.center;
				center.y = (2)*inView.frame.size.height;
				fromVC.view.center = center;
			} completion:nil];
			
			[UIView animateKeyframesWithDuration:.5f delay:0.2f options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
				[UIView addKeyframeWithRelativeStartTime:0.f relativeDuration:.3f animations:^{
					CATransform3D t = CATransform3DIdentity;
					t.m34 = 1.0/ -500;
					t = CATransform3DRotate(t, 14.0f * M_PI / 180.0f, 1, 0, 0);
					toVC.view.layer.transform = t;
					if (self.overlayView) {
						self.overlayView.alpha = 0.3f;
					}
				}];
				[UIView addKeyframeWithRelativeStartTime:.3f relativeDuration:.2f animations:^{
					toVC.view.transform = CGAffineTransformMakeScale(1, 1);
					toVC.view.center = toVCCenterOffScreenFinal;
					if (self.overlayView) {
						self.overlayView.alpha = 0.f;
					}
				}];
			} completion:^(__unused BOOL finished) {
				if (self.overlayView) {
					[self.overlayView removeFromSuperview];
					self.overlayView = nil;
				}
				[transitionContext completeTransition:YES];
			}];
		}
	} else if (self.style == KWTransitionStyleDropOut) {
		if (self.action == KWTransitionStepPresent) {
			
			[inView insertSubview:toVC.view belowSubview:fromVC.view];
			[UIView animateKeyframesWithDuration:.6f delay:0.f options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
				[UIView addKeyframeWithRelativeStartTime:0.f relativeDuration:.1f animations:^{
					fromVC.view.transform = CGAffineTransformMakeScale(1.1,1.1);
					
				}];
				[UIView addKeyframeWithRelativeStartTime:0.f relativeDuration:.5f animations:^{
					fromVC.view.transform = CGAffineTransformMakeScale(0.1,0.1);
					fromVC.view.alpha = 0;
				}];
			} completion:^(__unused BOOL finished) {
				[transitionContext completeTransition:YES];
			}];
		} else {
			[inView insertSubview:toVC.view aboveSubview:fromVC.view];
			toVC.view.transform = CGAffineTransformMakeScale(.1f,.1f);
			toVC.view.alpha = 0;
			[UIView animateWithDuration:.5f delay:.0f usingSpringWithDamping:0.8f initialSpringVelocity:.4f options:UIViewAnimationOptionCurveEaseIn animations:^{
				toVC.view.transform = CGAffineTransformMakeScale(1.0,1.0);
				toVC.view.alpha = 1;
			} completion:^(__unused BOOL finished) {
				[transitionContext completeTransition:YES];
			}];
			
			
			
		}
	}
}

- (void)addOverlayToViewController:(UIView *)view {
	if (self.overlayView) {
		[self.overlayView removeFromSuperview];
	}
	self.overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds))];
	self.overlayView.backgroundColor = [UIColor blackColor];
	self.overlayView.alpha = 0.f;
	[view addSubview:self.overlayView];
}

@end
