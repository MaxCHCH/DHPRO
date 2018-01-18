//
//  UIView+SSLAlertViewTap.h
//  zhidoushi
//
//  Created by licy on 15/6/17.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SSLAlertViewTapDelegate <NSObject>

//点击取消回调
- (void)sslAlertViewTapCancelTap;

@end

@interface UIView (SSLAlertViewTap)

//显示
- (void)ssl_show;

//隐藏
- (void)ssl_hidden;

//增加毛玻璃效果
- (void)ssl_addBlackBlur;
- (void)ssl_addWhiteBlur;

//点击事件(底层为透明色)
- (void)ssl_addOnlyTap;

//点击事件(底层为黑色:透明度0.7)
- (void)ssl_addGeneralTap;

@property (nonatomic,strong) id <SSLAlertViewTapDelegate> sslAlertViewTapDelegate;

@end
