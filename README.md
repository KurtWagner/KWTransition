# KWTransition

Experimental Implementations of UIViewControllerAnimatedTransitioning.

## Requirements

- Objective-C ARC
- iOS 7 or above

## Installation
### Cocoapods

    pod 'KWTransition'

###Manual

You can manually install this library by copying the `KWTransition.h` and `KWTransition.m` into your project.

## Usage

1. Import the header.

        #import <KWTransition.h>

2. Implement delegate transitioning delegate on the initial view controller (the one doing the presenting).

        <UIViewControllerTransitioningDelegate>

3. Implement a transition manager property on the initial view controller.

        @property (nonatomic, strong) KWTransition *transition;

    Be sure to initialise the manager somewhere.
        
        _transition = [KWTransition manager];

4. Set the controller to use custom presentations

        [self setModalPresentationStyle: UIModalPresentationCustom];

5. Implement the transitioning delegate


        #pragma mark - UIVieControllerTransitioningDelegate
        - (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
								                                           presentingController:(UIViewController *)presenting
                                                                               sourceController:(UIViewController *)source {
	        self.transition.action = KWTransitionStepPresent;
	        return self.transition;
        }
        -(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
	        self.transition.action = KWTransitionStepDismiss;
	        return self.transition;
        }

6. Select your animation and present!

        self.transition.style = KWTransitionStyleFadeBackOver;
	    KWModalViewController *VC = [[KWModalViewController alloc] init];
	    VC.transitioningDelegate = self;
	    [self presentViewController:VC animated:YES completion:nil];

##Styles

All styles support the `KWTransitionSettingReverse` setting.

####KWTransitionFadeBackOver

![](https://raw.github.com/KurtWagner/KWTransition/master/Sample/KWTransitionFadeBackOver.gif "KWTransitionFadeBackOver")

####KWTransitionRotateFromTop

![](https://raw.github.com/KurtWagner/KWTransition/master/Sample/KWTransitionRotateFromTop.gif "KWTransitionRotateFromTop")

####KWTransitionStyleUp

![](https://raw.github.com/KurtWagner/KWTransition/master/Sample/KWTransitionStyleUp.gif "KWTransitionStyleUp")

####KWTransitionStylePushUp

![](https://raw.github.com/KurtWagner/KWTransition/master/Sample/KWTransitionStylePushUp.gif "KWTransitionStylePushUp")

####KWTransitionStyleFall

![](https://raw.github.com/KurtWagner/KWTransition/master/Sample/KWTransitionStyleFall.gif "KWTransitionStyleFall")

####KWTransitionStyleStepBackScroll

![](https://raw.github.com/KurtWagner/KWTransition/master/Sample/KWTransitionStyleStepBackScroll.gif "KWTransitionStyleStepBackScroll")

####KWTransitionStyleBounceIn

![](https://raw.github.com/KurtWagner/KWTransition/master/Sample/KWTransitionStyleBounceIn.gif "KWTransitionStyleBounceIn")

####KWTransitionStyleDropOut

![](https://raw.github.com/KurtWagner/KWTransition/master/Sample/KWTransitionStyleDropOut.gif "KWTransitionStyleDropOut")

####KWTransitionStyleStepBackSwipe

![](https://raw.github.com/KurtWagner/KWTransition/master/Sample/KWTransitionStyleStepBackSwipe.gif "KWTransitionStyleStepBackSwipe")


####KWTransitionStyleSink

Supports:  `KWTransitionSettingDirectionRight`, `KWTransitionSettingDirectionLeft`, `KWTransitionSettingDirectionDown`, `KWTransitionSettingDirectionUp` and `KWTransitionSettingReverse`.

Sample is using: `KWTransitionSettingDirectionDown`

![](https://raw.github.com/KurtWagner/KWTransition/master/Sample/KWTransitionStyleSink.gif "KWTransitionStyleSink")

## Settings

You can manipulate the way some transitions behave by setting the manager's `settings` property. e.g,

    manager.style = KWTransitionStyleSink;
    manager.settings = KWTransitionSettingDirectionUp | KWTransitionSettingDirectionRight | KWTransitionSettingReverse; 

Would result in the transition operating against the top right corner performing the present and dismiss in reverse animation.

Below are the available settings. As not all styles support or settings (yet), please refer to the style documentation found at the start of this document for specific style support.

    typedef NS_OPTIONS(NSUInteger, KWTransitionSetting){
	    KWTransitionSettingNone = 0,
	    KWTransitionSettingDirectionRight = 1 << 0,
	    KWTransitionSettingDirectionLeft = 1 << 1,
	    KWTransitionSettingDirectionDown = 1 << 2,
	    KWTransitionSettingDirectionUp = 1 << 3,
	    KWTransitionSettingReverse = 1 << 5
    };

## Contributing

All contributions are welcome! Please feel free to improve existing or submit your own transitions.

## License

The MIT License (MIT)

Copyright (c) 2014 Kurt Wagner

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

