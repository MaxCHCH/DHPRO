//
//  UIView+ViewController.m
//  zhidoushi
//
//  Created by xinglei on 14-9-11.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "UIView+ViewController.h"

@implementation UIView (ViewController)

-(UIViewController *)viewController{
    
    id next = [self nextResponder];
    
    while (next) {
        next = [next nextResponder];
        if ([next isKindOfClass:[UIViewController class]]) {
            
            return next;
        }
    }
    return nil;
}

@end
