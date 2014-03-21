// KWTransition.h
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


typedef NS_ENUM(NSUInteger, KWTransitionStep){
	KWTransitionStepDismiss = 0,	/* Moving back to the inital step */
	KWTransitionStepPresent		/* Moving to the modal */
};

typedef NS_ENUM(NSUInteger, KWTransitionStyle){
	KWTransitionStyleRotateFromTop = 0,
	KWTransitionStyleFadeBackOver,
	KWTransitionStyleBounceIn,
	KWTransitionStyleDropOut,
	KWTransitionStyleStepBackScroll,
	KWTransitionStyleStepBackSwipe,
	KWTransitionStyleUp,
	KWTransitionStylePushUp,
	KWTransitionStyleFall,
	KWTransitionStyleSink
};

typedef NS_OPTIONS(NSUInteger, KWTransitionSetting){
	KWTransitionSettingNone = 0,
	KWTransitionSettingDirectionRight = 1 << 0,
	KWTransitionSettingDirectionLeft = 1 << 1,
	KWTransitionSettingDirectionDown = 1 << 2,
	KWTransitionSettingDirectionUp = 1 << 3,
	KWTransitionSettingReverse = 1 << 5
};

@interface KWTransition : NSObject<UIViewControllerAnimatedTransitioning>

/// Transition the view controller to this step.
@property (nonatomic) KWTransitionStep action;

/// Style the transition this way
@property (nonatomic) KWTransitionStyle style;

/// The duration of the transition
@property (nonatomic) NSTimeInterval duration;

/// The settings of the transitions
@property (nonatomic) KWTransitionSetting settings;

/**
 *  Creates a transition manager object for you.
 *
 *  @return Transition manager object
 */
+ (instancetype)manager;

@end
