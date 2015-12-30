//
//  NSView+NSView_Animate.m
//  MagicMirror2
//
//  Created by James Tang on 30/12/2015.
//  Copyright © 2015 James Tang. All rights reserved.
//

#import "NSView+Animate.h"
#import "QCMethod.h"
@import QuartzCore;

@implementation NSView (Animate)

- (void)shake {
    self.wantsLayer = YES;
    [self addShakeAnimation];
}

#pragma mark - Animation Setup

- (void)addShakeAnimation{
    [self addShakeAnimationCompletionBlock:nil];
}

- (void)addShakeAnimationCompletionBlock:(void (^)(BOOL finished))completionBlock{
    if (completionBlock){
        CABasicAnimation * completionAnim = [CABasicAnimation animationWithKeyPath:@"completionAnim"];;
        completionAnim.duration = 1;
        completionAnim.delegate = self;
        [completionAnim setValue:@"shake" forKey:@"animId"];
        [completionAnim setValue:@(NO) forKey:@"needEndAnim"];
        [self.layer addAnimation:completionAnim forKey:@"shake"];
    }

    NSString * fillMode = kCAFillModeForwards;

    ////Rectangle animation
    CAKeyframeAnimation * rectangleTransformAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    rectangleTransformAnim.values   = @[[NSValue valueWithCATransform3D:CATransform3DIdentity],
                                        [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-1, 0, 0)],
                                        [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(2, 0, 0)],
                                        [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-4, 0, 0)],
                                        [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(4, 0, 0)],
                                        [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-4, 0, 0)],
                                        [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(4, 0, 0)],
                                        [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-4, 0, 0)],
                                        [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(2, 0, 0)],
                                        [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-1, 0, 0)],
                                        [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    rectangleTransformAnim.keyTimes = @[@0, @0.1, @0.2, @0.3, @0.4, @0.5, @0.6, @0.7, @0.8, @0.9, @1];
    rectangleTransformAnim.duration = 1;

    CAAnimationGroup * rectangleShakeAnim = [QCMethod groupAnimations:@[rectangleTransformAnim] fillMode:fillMode];
    [self.layer addAnimation:rectangleShakeAnim forKey:@"rectangleShakeAnim"];
}


@end
