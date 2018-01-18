//
//  UIView+SSLAlertViewTap.m
//  zhidoushi
//
//  Created by licy on 15/6/17.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "UIView+SSLAlertViewTap.h"
#import <objc/runtime.h>

@implementation UIView (SSLAlertViewTap)

static const void * SSLAlertViewTapDelegate;

#pragma mark - Public Methods
#pragma mark 显示
- (void)ssl_show {
    
    self.alpha = 0;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1;
    }];
}

#pragma mark 隐藏
- (void)ssl_hidden {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if ([self.sslAlertViewTapDelegate respondsToSelector:@selector(sslAlertViewTapCancelTap)]) {
            [self.sslAlertViewTapDelegate sslAlertViewTapCancelTap];
        }
    }]; 
}   

#pragma mark 点击事件(底层为透明色)
- (void)ssl_addOnlyTap {
    UIView *tapView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:tapView];
    tapView.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapClick:)];
    [tapView addGestureRecognizer:tap];
}   

#pragma mark - 增加毛玻璃效果
- (void)ssl_addBlackBlur{
    UIView *BlurView;
    double version = [[UIDevice currentDevice].systemVersion doubleValue];
    if (version >= 8.0f) {
        
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        BlurView = [[UIVisualEffectView alloc] initWithEffect:blur];
        BlurView.alpha = 0.9;
        ((UIVisualEffectView *)BlurView).frame = self.bounds;
        
    }else if(version >= 7.0f){
        
        BlurView = [[UIToolbar alloc] initWithFrame:self.bounds];
        ((UIToolbar *)BlurView).barStyle = UIBarStyleBlack;
        
    }else{
        
        BlurView = [[UIView alloc] initWithFrame:self.bounds];
        [BlurView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.9f]];
    }
    BlurView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:BlurView];
}
- (void)ssl_addWhiteBlur{
    UIView *BlurView;
    double version = [[UIDevice currentDevice].systemVersion doubleValue];
    if (version >= 8.0f) {
        
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        BlurView = [[UIVisualEffectView alloc] initWithEffect:blur];
        BlurView.alpha = 0.9;
        ((UIVisualEffectView *)BlurView).frame = self.bounds;
        
    }else if(version >= 7.0f){
        
        BlurView = [[UIToolbar alloc] initWithFrame:self.bounds];
        ((UIToolbar *)BlurView).barStyle = UIBarStyleDefault;
        BlurView.alpha = 0.9;
        
    }else{
        
        BlurView = [[UIView alloc] initWithFrame:self.bounds];
        [BlurView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.9f]];
    }
    BlurView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:BlurView];
}

#pragma mark 点击事件(底层为黑色:透明度0.7)
- (void)ssl_addGeneralTap {
    
    UIView *tapView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:tapView];
    tapView.backgroundColor = [UIColor blackColor];
    tapView.alpha = 0.7;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapClick:)];
    [tapView addGestureRecognizer:tap];
}

#pragma mark - Event Responses
- (void)_tapClick:(UITapGestureRecognizer *)tap {
    [self ssl_hidden];
}

#pragma mark - Getters And Setters
- (id<SSLAlertViewTapDelegate>)sslAlertViewTapDelegate {
    return objc_getAssociatedObject(self, &SSLAlertViewTapDelegate);
}

- (void)setSslAlertViewTapDelegate:(id<SSLAlertViewTapDelegate>)sslAlertViewTapDelegate {
    objc_setAssociatedObject(self, &SSLAlertViewTapDelegate, sslAlertViewTapDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end









