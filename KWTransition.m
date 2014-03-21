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
@property (nonatomic, strong) UIView *overlayViewA;
@property (nonatomic, strong) UIView *overlayViewB;
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
		if ((self.action == KWTransitionStepPresent && !(self.settings & KWTransitionSettingReverse)) ||
			(self.action == KWTransitionStepDismiss && (self.settings & KWTransitionSettingReverse))) {
			
			CGAffineTransform rotation;
			rotation = CGAffineTransformMakeRotation(M_PI);
			fromVC.view.frame = fromRect;
			
			CGPoint fromAnchorPoint = fromVC.view.layer.anchorPoint;
			CGPoint fromPosition = fromVC.view.layer.position;
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
				
				fromVC.view.layer.anchorPoint = fromAnchorPoint;
				fromVC.view.layer.position = fromPosition;
			}];
		} else {
			CGAffineTransform rotation;
			rotation = CGAffineTransformMakeRotation(M_PI);
			
			CGPoint fromAnchorPoint = fromVC.view.layer.anchorPoint;
			CGPoint fromPosition = fromVC.view.layer.position;
			fromVC.view.frame = fromRect;
			fromVC.view.layer.anchorPoint = CGPointMake(0.5, 0.0);
			fromVC.view.layer.position = CGPointMake(160.0, 0);

			[inView insertSubview:toVC.view belowSubview:fromVC.view];

			CGPoint toAnchorPoint = toVC.view.layer.anchorPoint;
			CGPoint toPosition = toVC.view.layer.position;
			toVC.view.layer.anchorPoint = CGPointMake(0.5, 0.0);
			toVC.view.layer.position = CGPointMake(160.0, 0);
			toVC.view.transform = CGAffineTransformMakeRotation(-M_PI);

			[UIView animateWithDuration:1.f delay:0.f usingSpringWithDamping:0.8f initialSpringVelocity:6.f options:UIViewAnimationOptionCurveEaseIn animations:^{
				fromVC.view.center = CGPointMake(fromVC.view.center.x - 320, fromVC.view.center.y);
				toVC.view.transform = CGAffineTransformMakeRotation(-0);
			} completion:^(__unused BOOL finished) {
				[transitionContext completeTransition:YES];
				
				fromVC.view.center = inView.center;
				fromVC.view.layer.anchorPoint = fromAnchorPoint;
				fromVC.view.layer.position = fromPosition;
				toVC.view.layer.anchorPoint = toAnchorPoint;
				toVC.view.layer.position = toPosition;
			}];
		}
	} else if (self.style == KWTransitionStyleBounceIn) {
		if ((self.action == KWTransitionStepPresent && !(self.settings & KWTransitionSettingReverse)) ||
			(self.action == KWTransitionStepDismiss && (self.settings & KWTransitionSettingReverse))) {
			
			[self addOverlayAToView:fromVC.view];
			
			[inView addSubview:toVC.view];
			CGPoint centerOffScreen = inView.center;

			centerOffScreen.y = (-1)*inView.frame.size.height;
			toVC.view.center = centerOffScreen;

			[UIView animateWithDuration:1.f delay:0.f usingSpringWithDamping:0.4f initialSpringVelocity:6.f options:UIViewAnimationOptionCurveEaseIn animations:^{
				toVC.view.center = inView.center;
				self.overlayViewA.alpha = 0.3f;
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
					self.overlayViewA.alpha = 0;
				}];
			} completion:^(__unused BOOL finished) {
				[self.overlayViewA removeFromSuperview];
				self.overlayViewA = nil;
				[transitionContext completeTransition:YES];
			}];
		}
	} else if (self.style == KWTransitionStyleFadeBackOver) {
		if ((self.action == KWTransitionStepPresent && !(self.settings & KWTransitionSettingReverse)) ||
			(self.action == KWTransitionStepDismiss && (self.settings & KWTransitionSettingReverse))) {
			
			[self addOverlayAToView:fromVC.view];
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
					self.overlayViewA.alpha = 0.3f;
				}];
				[UIView addKeyframeWithRelativeStartTime:.3f relativeDuration:.5f animations:^{
					self.overlayViewA.alpha = 0.8f;
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
					self.overlayViewA.alpha = 0.3f;
				}];
				[UIView addKeyframeWithRelativeStartTime:.3f relativeDuration:.2f animations:^{
					toVC.view.transform = CGAffineTransformMakeScale(1, 1);
					toVC.view.center = toVCCenterOffScreenFinal;
					self.overlayViewA.alpha = 0.f;
				}];
			} completion:^(__unused BOOL finished) {
				[self.overlayViewA removeFromSuperview];
				self.overlayViewA = nil;
				[transitionContext completeTransition:YES];
			}];
		}
	} else if (self.style == KWTransitionStyleDropOut) {
		if ((self.action == KWTransitionStepPresent && !(self.settings & KWTransitionSettingReverse)) ||
			(self.action == KWTransitionStepDismiss && (self.settings & KWTransitionSettingReverse))) {
			
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
	} else if (self.style == KWTransitionStyleUp) {

		NSInteger direction = ((self.action == KWTransitionStepPresent && !(self.settings & KWTransitionSettingReverse)) ||
			(self.action == KWTransitionStepDismiss && (self.settings & KWTransitionSettingReverse))) ? 1 : -1;
		
		fromVC.view.frame = fromRect;
		[inView addSubview:toVC.view];

		CGPoint toCenter = inView.center;
		toCenter.y += direction * CGRectGetHeight(inView.bounds);
		toVC.view.center = toCenter;
		
		[UIView animateWithDuration:.4f delay:.0f usingSpringWithDamping:0.8f initialSpringVelocity:.4f options:UIViewAnimationOptionCurveEaseIn animations:^{
			CGPoint fromCenter = inView.center;
			fromCenter.y -= direction * CGRectGetHeight(inView.bounds);
			fromVC.view.center = fromCenter;
			toVC.view.center = inView.center;
		} completion:^(__unused BOOL finished) {
			[transitionContext completeTransition:YES];
		}];
			
		
	} else if (self.style == KWTransitionStylePushUp) {
		
		fromVC.view.frame = fromRect;
		[inView addSubview:toVC.view];
		if ((self.action == KWTransitionStepPresent && !(self.settings & KWTransitionSettingReverse)) ||
			(self.action == KWTransitionStepDismiss && (self.settings & KWTransitionSettingReverse))) {
			CGPoint toCenter = inView.center;
			toCenter.y += CGRectGetHeight(inView.bounds);
			toVC.view.center = toCenter;
			
			[UIView animateWithDuration:.2f animations:^{
				CGPoint downCenter = inView.center;
				downCenter.y += 25;
				fromVC.view.center = downCenter;
			} completion:^(__unused BOOL finished) {
				[UIView animateWithDuration:.4f delay:.0f usingSpringWithDamping:0.8f initialSpringVelocity:.4f options:UIViewAnimationOptionCurveEaseIn animations:^{
					CGPoint fromCenter = inView.center;
					fromCenter.y -= CGRectGetHeight(inView.bounds);
					fromVC.view.center = fromCenter;
					toVC.view.center = inView.center;
				} completion:^(__unused BOOL finished) {
					[transitionContext completeTransition:YES];
				}];
			}];
		} else {
			CGPoint toCenter = inView.center;
			toCenter.y -= CGRectGetHeight(inView.bounds);
			toVC.view.center = toCenter;
			
			[UIView animateWithDuration:.3f delay:.0f usingSpringWithDamping:0.8f initialSpringVelocity:.4f options:UIViewAnimationOptionCurveEaseIn animations:^{
				CGPoint fromCenter = inView.center;
				fromCenter.y += CGRectGetHeight(inView.bounds);
				fromVC.view.center = fromCenter;
				toVC.view.center = inView.center;
			} completion:^(__unused BOOL finished) {
				[transitionContext completeTransition:YES];
			}];
		}
	} else if (self.style == KWTransitionStyleStepBackSwipe) {

		NSInteger direction = ((self.action == KWTransitionStepPresent && !(self.settings & KWTransitionSettingReverse)) ||
			(self.action == KWTransitionStepDismiss && (self.settings & KWTransitionSettingReverse))) ? 1 : -1;
		
		fromVC.view.frame = fromRect;
		CGFloat scale = 0.65f;
		[inView insertSubview:toVC.view belowSubview:fromVC.view];
		toVC.view.frame = fromRect;

		CATransform3D toTransform = CATransform3DMakeAffineTransform(CGAffineTransformMakeScale(scale, scale));
		toTransform.m34 = 1.0/ -500;
		toVC.view.layer.transform = CATransform3DRotate(toTransform, -40.0f * M_PI / 180.0f, 1, 0, 0);
			
		CGPoint toCenter = fromVC.view.center;
		toCenter.y *= scale;
		toVC.view.center = toCenter;
		toVC.view.alpha = 0;
		[inView bringSubviewToFront:fromVC.view];
		
		[self addOverlayAToView:fromVC.view];
		[self addOverlayBToView:toVC.view];
		self.overlayViewB.alpha = 0.1f;
		[UIView animateWithDuration:0.5f delay:.0f usingSpringWithDamping:0.6f initialSpringVelocity:.4f options:UIViewAnimationOptionCurveEaseIn animations:^{

			CATransform3D transform = CATransform3DMakeAffineTransform(CGAffineTransformMakeScale(scale, scale));
			transform.m34 = 1.0/ -500;
			fromVC.view.layer.transform = CATransform3DRotate(transform, -40.0f * M_PI / 180.0f, 1, 0, 0);
			
			CGPoint fromCenter = fromVC.view.center;
			fromCenter.y *= (scale + .1);
			fromVC.view.center = fromCenter;

			self.overlayViewA.alpha = 0.1f;
			
		} completion:^(__unused BOOL finished) {
			toVC.view.alpha = 1;
			[UIView animateWithDuration:1.5f delay:.0f usingSpringWithDamping:0.8f initialSpringVelocity:.4f options:UIViewAnimationOptionCurveEaseIn animations:^{
			
				CGPoint fromCenter = inView.center;
				fromCenter.y *= (scale + .1);
				fromCenter.x = direction * -2 * CGRectGetWidth(inView.bounds);
				fromVC.view.center = fromCenter;
				
			} completion:^(__unused BOOL finished) {
			
				[UIView animateWithDuration:0.25f delay:.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
				
					toVC.view.center = inView.center;
			
					CATransform3D transform = CATransform3DIdentity;
					transform.m34 = 1.0/ -500;
					toVC.view.layer.transform = transform;
					self.overlayViewB.alpha = 0;
					
				} completion:^(__unused BOOL finished) {
				
					[transitionContext completeTransition:YES];
					[self.overlayViewA removeFromSuperview];
					[self.overlayViewB removeFromSuperview];
					self.overlayViewA = nil;
					self.overlayViewB = nil;
					
				}];
			}];
		}];
	} else if (self.style == KWTransitionStyleStepBackScroll) {

		NSInteger direction = ((self.action == KWTransitionStepPresent && !(self.settings & KWTransitionSettingReverse)) ||
			(self.action == KWTransitionStepDismiss && (self.settings & KWTransitionSettingReverse))) ? 1 : -1;

		fromVC.view.frame = fromRect;
		CGFloat scale = 0.65f;
		[inView addSubview: toVC.view];
		toVC.view.frame = fromRect;

		CATransform3D toTransform = CATransform3DMakeAffineTransform(CGAffineTransformMakeScale(scale, scale));
		toTransform.m34 = 1.0/ -500;
		toVC.view.layer.transform = CATransform3DRotate(toTransform, -40.0f * M_PI / 180.0f, 1, 0, 0);
			
		CGPoint toCenter = fromVC.view.center;
		toCenter.y *= scale;
		toCenter.x = direction * -2 * CGRectGetWidth(inView.bounds);
		toVC.view.center = toCenter;
		
		[self addOverlayAToView:fromVC.view];
		[self addOverlayBToView:toVC.view];
		self.overlayViewB.alpha = 0.1f;
		[UIView animateWithDuration:.4f delay:.0f usingSpringWithDamping:0.8f initialSpringVelocity:.4f options:UIViewAnimationOptionCurveEaseIn animations:^{

			CATransform3D transform = CATransform3DMakeAffineTransform(CGAffineTransformMakeScale(scale, scale));
			transform.m34 = 1.0/ -500;
			fromVC.view.layer.transform = CATransform3DRotate(transform, -40.0f * M_PI / 180.0f, 1, 0, 0);
			
			CGPoint fromCenter = fromVC.view.center;
			fromCenter.y *= (scale + .1);
			fromVC.view.center = fromCenter;

			self.overlayViewA.alpha = 0.1f;
			
		} completion:^(__unused BOOL finished) {
		
			[UIView animateWithDuration:.4f delay:.03f usingSpringWithDamping:0.8f initialSpringVelocity:.4f options:UIViewAnimationOptionCurveEaseIn animations:^{
			
				CGPoint fromCenter = inView.center;
				fromCenter.y *= (scale + .1);
				fromCenter.x = direction * 2 * CGRectGetWidth(inView.bounds);
				fromVC.view.center = fromCenter;
			
				CGPoint c = inView.center;
				c.y *= (scale + .1);
				toVC.view.center = c;
				
			} completion:^(__unused BOOL finished) {
			
				[UIView animateWithDuration:.4f delay:.03f options:UIViewAnimationOptionCurveEaseIn animations:^{
				
					toVC.view.center = inView.center;
			
					CATransform3D transform = CATransform3DIdentity;
					transform.m34 = 1.0/ -500;
					toVC.view.layer.transform = transform;
					self.overlayViewB.alpha = 0;
					
				} completion:^(__unused BOOL finished) {
				
					[transitionContext completeTransition:YES];
					[self.overlayViewA removeFromSuperview];
					[self.overlayViewB removeFromSuperview];
					self.overlayViewA = nil;
					self.overlayViewB = nil;
					
				}];
			}];
		}];
	} else if (self.style == KWTransitionStyleSink) {
		if ((self.action == KWTransitionStepPresent && !(self.settings & KWTransitionSettingReverse)) ||
			(self.action == KWTransitionStepDismiss && (self.settings & KWTransitionSettingReverse))) {
			[inView addSubview:toVC.view];
			
			fromVC.view.frame = fromRect;
			toVC.view.frame = inView.frame;

			[self addOverlayAToView:fromVC.view];
			
			CGPoint center = inView.center;
			if (self.settings & KWTransitionSettingDirectionRight) {
				center.x += CGRectGetWidth(fromVC.view.bounds);
			} else if (self.settings & KWTransitionSettingDirectionLeft) {
				center.x -= CGRectGetWidth(fromVC.view.bounds);
			}
			if (self.settings & KWTransitionSettingDirectionDown) {
				center.y += CGRectGetHeight(fromVC.view.bounds);
			} else if (self.settings & KWTransitionSettingDirectionUp) {
				center.y -= CGRectGetHeight(fromVC.view.bounds);
			}
			toVC.view.center = center;
			
			CGFloat scale = .7f;
			toVC.view.transform = CGAffineTransformMakeScale(scale, scale);
			[UIView animateKeyframesWithDuration:.5f delay:0.f options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
				[UIView addKeyframeWithRelativeStartTime:0.f relativeDuration:.5f animations:^{
					self.overlayViewA.alpha = 0.3f;
					toVC.view.center = inView.center;
				}];
				[UIView addKeyframeWithRelativeStartTime:0.5f relativeDuration:.5f animations:^{
					self.overlayViewA.alpha = 0.0f;
					toVC.view.transform = CGAffineTransformMakeScale(1.f,1.f);
				}];
			} completion:^(__unused BOOL finished) {
				[transitionContext completeTransition:YES];
				
				[self.overlayViewA removeFromSuperview];
				self.overlayViewA = nil;
			}];
		} else {
			[inView addSubview:toVC.view];
			[inView bringSubviewToFront:fromVC.view];
			
			fromVC.view.frame = fromRect;
			toVC.view.frame = inView.frame;

			[self addOverlayAToView:toVC.view];
			
			CGFloat scale = .7f;
			[UIView animateKeyframesWithDuration:.5f delay:0.f options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
				[UIView addKeyframeWithRelativeStartTime:0.f relativeDuration:.5f animations:^{
					self.overlayViewA.alpha = 0.3f;
					fromVC.view.transform = CGAffineTransformMakeScale(scale, scale);
				}];
				[UIView addKeyframeWithRelativeStartTime:0.5f relativeDuration:.5f animations:^{
					self.overlayViewA.alpha = 0.0f;
					
					CGPoint center = inView.center;
					if (self.settings & KWTransitionSettingDirectionRight) {
						center.x += CGRectGetWidth(fromVC.view.bounds);
					} else if (self.settings & KWTransitionSettingDirectionLeft) {
						center.x -= CGRectGetWidth(fromVC.view.bounds);
					}
					if (self.settings & KWTransitionSettingDirectionDown) {
						center.y += CGRectGetHeight(fromVC.view.bounds);
					} else if (self.settings & KWTransitionSettingDirectionUp) {
						center.y -= CGRectGetHeight(fromVC.view.bounds);
					}
					
					fromVC.view.center = center;
				}];
			} completion:^(__unused BOOL finished) {
				[transitionContext completeTransition:YES];
				
				[self.overlayViewA removeFromSuperview];
				self.overlayViewA = nil;
			}];
		}
	} else if (self.style == KWTransitionStyleFall) {
		[inView addSubview:toVC.view];
		[inView bringSubviewToFront:fromVC.view];
		
		fromVC.view.frame = fromRect;
		toVC.view.frame = inView.frame;
		
		CGPoint fromAnchorPoint = fromVC.view.layer.anchorPoint;
		CGPoint fromPosition = fromVC.view.layer.position;
		fromVC.view.layer.anchorPoint = CGPointMake(0.0, 0.0);
		fromVC.view.layer.position = CGPointMake(0.0, 0);
		
		[self addOverlayAToView:toVC.view];
		self.overlayViewA.alpha = 0.2f;
		
		[UIView animateWithDuration:1.5f delay:0 usingSpringWithDamping:0.3f initialSpringVelocity:2.f options:UIViewAnimationOptionCurveEaseIn animations:^{
			fromVC.view.transform = CGAffineTransformMakeRotation(30 * M_PI / 180.0);
			self.overlayViewA.alpha = 0.1f;
		} completion:nil];
		
		[UIView animateWithDuration:.4f delay:0.7f options:UIViewAnimationOptionCurveEaseIn animations:^{
			CGPoint center = inView.center;
			center.y = 2 * CGRectGetHeight(inView.bounds);
			center.x -= 20;
			fromVC.view.center = center;
			self.overlayViewA.alpha = 0.f;
		} completion:^(BOOL finished) {
			[transitionContext completeTransition:YES];
			
			[self.overlayViewA removeFromSuperview];
			self.overlayViewA = nil;
			
			fromVC.view.layer.anchorPoint = fromAnchorPoint;
			fromVC.view.layer.position = fromPosition;
		}];
	}
}

- (void)addOverlayAToView:(UIView *)view {
	if (self.overlayViewA) {
		[self.overlayViewA removeFromSuperview];
	}
	self.overlayViewA = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds))];
	self.overlayViewA.backgroundColor = [UIColor blackColor];
	self.overlayViewA.alpha = 0.f;
	[view addSubview:self.overlayViewA];
}

- (void)addOverlayBToView:(UIView *)view {
	if (self.overlayViewB) {
		[self.overlayViewB removeFromSuperview];
	}
	self.overlayViewB = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds))];
	self.overlayViewB.backgroundColor = [UIColor blackColor];
	self.overlayViewB.alpha = 0.f;
	[view addSubview:self.overlayViewB];
}

@end
