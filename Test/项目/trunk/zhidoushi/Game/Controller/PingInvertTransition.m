//
//  PingInvertTransition.m
//  KYPingTransition
//
//  Created by Kitten Yang on 1/30/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import "PingInvertTransition.h"
#import "GroupTypeViewController.h"
#import "CreateGroupTwoViewController.h"

@interface PingInvertTransition()

@property(nonatomic,strong)id<UIViewControllerContextTransitioning>transitionContext;

@end

@implementation PingInvertTransition



- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.7f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    
    self.transitionContext = transitionContext;
    
    CreateGroupTwoViewController *fromVC = (CreateGroupTwoViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    GroupTypeViewController *toVC   = (GroupTypeViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    UIButton *button = toVC.creatBtn;
    
    CGRect rect = [button.superview convertRect:button.frame toView:fromVC.view];
    
    [containerView addSubview:toVC.view];
    [containerView addSubview:fromVC.view];

    
    UIBezierPath *finalPath = [UIBezierPath bezierPathWithOvalInRect:rect];
    
    CGPoint finalPoint;
    
    //判断触发点在那个象限
    if(rect.origin.x > (toVC.view.bounds.size.width / 2)){
        if (rect.origin.y < (toVC.view.bounds.size.height / 2)) {
            //第一象限
            finalPoint = CGPointMake(rect.origin.x + rect.size.width / 2 - 0, rect.origin.y + rect.size.height / 2 - CGRectGetMaxY(toVC.view.bounds)+30);
        }else{
            //第四象限
            finalPoint = CGPointMake(rect.origin.x + rect.size.width / 2 - 0, rect.origin.y + rect.size.height / 2 - 0);
        }
    }else{
        if (rect.origin.y < (toVC.view.bounds.size.height / 2)) {
            //第二象限
            finalPoint = CGPointMake(rect.origin.x + rect.size.width / 2 - CGRectGetMaxX(toVC.view.bounds), rect.origin.y + rect.size.height / 2 - CGRectGetMaxY(toVC.view.bounds)+30);
        }else{
            //第三象限
            finalPoint = CGPointMake(rect.origin.x + rect.size.width / 2 - CGRectGetMaxX(toVC.view.bounds), rect.origin.y + rect.size.height / 2 - 0);
        }
    }

    

    CGFloat radius = sqrt(finalPoint.x * finalPoint.x + finalPoint.y * finalPoint.y);
    UIBezierPath *startPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(rect, -radius, -radius)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = finalPath.CGPath;
    fromVC.view.layer.mask = maskLayer;
    
    
    CABasicAnimation *pingAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pingAnimation.fromValue = (__bridge id)(startPath.CGPath);
    pingAnimation.toValue   = (__bridge id)(finalPath.CGPath);
    pingAnimation.duration = [self transitionDuration:transitionContext];
    pingAnimation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

    pingAnimation.delegate = self;
    
    [maskLayer addAnimation:pingAnimation forKey:@"pingInvert"];
    
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;

}


@end





