//
//  MMDrawerControllerWithCenterScaleAnimation.m
//  MMDrawerControllerScaleExample
//
//  Created by 乐星宇 on 14/10/18.
//  Copyright (c) 2014年 Qi Cheng. All rights reserved.
//

#import "MMDrawerControllerWithCenterScaleAnimation.h"

#import <objc/message.h>

typedef void(^CompletionBlock)(BOOL finished);

@interface MMDrawerControllerWithCenterScaleAnimation()

/**
 *  Make sure the scale animation being operation only once during the opening or closing
 */
@property (nonatomic, assign) BOOL shouldOperateVisualBlock;

@property (nonatomic, assign) BOOL toggledByPanGesture;

@end


@implementation MMDrawerControllerWithCenterScaleAnimation

#pragma mark Controling shouldOperateVisualBlock
- (void)prepareToPresentDrawer:(MMDrawerSide)drawer animated:(BOOL)aniamated
{
    struct objc_super superInfo = {
        self,
        [self superclass]
    };
    
    ((void (*) (id, SEL, NSInteger, BOOL))objc_msgSendSuper)((__bridge id)(&superInfo), @selector(prepareToPresentDrawer: animated:), drawer, aniamated);
    
    self.shouldOperateVisualBlock = YES;
}

- (void)setNeedsStatusBarAppearanceUpdateIfSupported
{
    struct objc_super superInfo = {
        self,
        [self superclass]
    };
    
    ((void (*) (id, SEL))objc_msgSendSuper)((__bridge id)(&superInfo), @selector(setNeedsStatusBarAppearanceUpdateIfSupported));
    
    self.shouldOperateVisualBlock = YES;
}

- (void)openDrawerSide:(MMDrawerSide)drawerSide
              animated:(BOOL)animated
              velocity:(CGFloat)velocity
      animationOptions:(UIViewAnimationOptions)options
            completion:(void (^)(BOOL finished))completion
{
    __weak typeof(self) weakSelf = self;
    CompletionBlock wrapCompletion = ^(BOOL finished)
    {
        weakSelf.shouldOperateVisualBlock = NO;
        
        if (completion)
        {
            completion(finished);
        }
    };
    
    CompletionBlock realCompletion = [wrapCompletion copy];
    
    SEL selector = @selector(openDrawerSide:animated:velocity:animationOptions:completion:);
    
    struct objc_super superInfo = {
        self,
        [self superclass]
    };
    
    ((void (*) (id, SEL, NSInteger, BOOL, CGFloat, NSInteger, CompletionBlock))objc_msgSendSuper)((__bridge id)(&superInfo), selector, drawerSide, animated, velocity, options, realCompletion);
}

- (void)closeDrawerAnimated:(BOOL)animated
                   velocity:(CGFloat)velocity
           animationOptions:(UIViewAnimationOptions)options
                 completion:(void (^)(BOOL finished))completion
{
    __weak typeof(self) weakSelf = self;
    CompletionBlock wrapCompletion = ^(BOOL finished)
    {
        weakSelf.shouldOperateVisualBlock = NO;
        
        if (completion)
        {
            completion(finished);
        }
    };
    
    CompletionBlock realCompletion = [wrapCompletion copy];
    
    SEL selector = @selector(closeDrawerAnimated:velocity:animationOptions:completion:);
    
    struct objc_super superInfo = {
        self,
        [self superclass]
    };
    
    ((void (*) (id, SEL, BOOL, CGFloat, UIViewAnimationOptions, CompletionBlock))objc_msgSendSuper)((__bridge id)(&superInfo), selector, animated, velocity, options, realCompletion);
}

- (void)panGestureCallback:(UIPanGestureRecognizer *)panGesture
{
    if (panGesture.state == UIGestureRecognizerStateBegan)
    {
        self.shouldOperateVisualBlock = YES;
        self.toggledByPanGesture = YES;
    }
    
    struct objc_super superInfo = {
        self,
        [self superclass]
    };
    
    ((void (*) (id, SEL, id))objc_msgSendSuper)((__bridge id)(&superInfo), @selector(panGestureCallback:), panGesture);
    
    if (panGesture.state == UIGestureRecognizerStateEnded)
    {
        self.shouldOperateVisualBlock = NO;
        self.toggledByPanGesture = NO;
    }
}

#pragma mark Init
- (void)commonSetup
{
    struct objc_super superInfo = {
        self,
        [self superclass]
    };
    
    ((void (*) (id, SEL))objc_msgSendSuper)((__bridge id)(&superInfo), @selector(commonSetup));
    
    [self setup];
}

- (void)setup
{
    self.showsShadow = NO;
    
    _centerViewScalePercent = 0.9f;
    
    __weak typeof(self) weakSelf = self;
    [self setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
        if (weakSelf.shouldOperateVisualBlock)
        {
            if (weakSelf.toggledByPanGesture)
            {
                [weakSelf scaleAnimationDuringPanGestureAtPercent:percentVisible drawerSide:drawerSide];
            }
            else
            {
                if (weakSelf.openSide == MMDrawerSideNone)
                {
                    [weakSelf openDrawerWithScaleAnimation:drawerSide];
                }
                else
                {
                    [weakSelf closeDrawerWithScaleAnimation:drawerSide];
                }
            }
        }
    }];
}

#pragma mark Real animation
- (void)openDrawerWithScaleAnimation:(MMDrawerSide)drawerSide
{
    self.centerViewController.view.layer.transform = CATransform3DMakeScale(_centerViewScalePercent, _centerViewScalePercent, 1.f);
    
    UIView *centerContainerView = [self valueForKey:@"centerContainerView"];
    
    CGFloat yCenter = centerContainerView.frame.size.height / 2;
    if (drawerSide == MMDrawerSideLeft)
    {
        CGFloat xCenter = self.centerViewController.view.frame.size.width / 2;
        self.centerViewController.view.center = CGPointMake(xCenter, yCenter);
    }
    else if (drawerSide == MMDrawerSideRight)
    {
        CGFloat xCenter = centerContainerView.frame.size.width
        - self.centerViewController.view.frame.size.width / 2;
        self.centerViewController.view.center =  CGPointMake(xCenter, yCenter);
    }
}

- (void)closeDrawerWithScaleAnimation:(MMDrawerSide)drawerSide
{
    self.centerViewController.view.transform = CGAffineTransformMakeScale(1.f,1.f);
    
    UIView *centerContainerView = [self valueForKey:@"centerContainerView"];
    
    self.centerViewController.view.bounds = centerContainerView.bounds;
    self.centerViewController.view.center = centerContainerView.center;
}

- (void)scaleAnimationDuringPanGestureAtPercent:(CGFloat)percentVisible drawerSide:(MMDrawerSide)drawerSide
{
    //*这里修改了侧拉的最后位置percentVisible * 0.2*//
    CGFloat scalePercent = 1 - (percentVisible * 0.2);
    
    self.centerViewController.view.transform = CGAffineTransformMakeScale(scalePercent, scalePercent);
    
    UIView *centerContainerView = [self valueForKey:@"centerContainerView"];
    CGFloat yCenter = centerContainerView.frame.size.height / 2;
    if (drawerSide == MMDrawerSideLeft)//*在初始位置时，如果是拉动上层抽屉向右*//
    {
        CGFloat xCenter = self.centerViewController.view.frame.size.width / 2;
        self.centerViewController.view.center = CGPointMake(xCenter, yCenter);
        self.leftDrawerViewController.view.alpha =((158-xCenter)/10);//*控制左侧视图*//
        NSLog(@"xCenter--------->>>>>>>>>>>>%f,%f",self.leftDrawerViewController.view.alpha,xCenter);
    }
    else if (drawerSide == MMDrawerSideRight)
    {
        CGFloat xCenter = centerContainerView.frame.size.width
        - self.centerViewController.view.frame.size.width / 2;
        self.centerViewController.view.center =  CGPointMake(xCenter, yCenter);
    }else
    {
        self.centerViewController.view.transform = CGAffineTransformMakeScale(1, 1);
        CGFloat yCenter = centerContainerView.frame.size.height / 2;
        CGFloat xCenter = self.centerViewController.view.frame.size.width / 2;
        self.centerViewController.view.center = CGPointMake(xCenter, yCenter);
    }
}


@end

