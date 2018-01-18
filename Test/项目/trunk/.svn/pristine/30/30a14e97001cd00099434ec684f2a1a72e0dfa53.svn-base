//
//  InputAlertView.h
//  zhidoushi
//
//  Created by licy on 15/8/11.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InputAlertView;

@protocol InputAlertViewDelegate <NSObject>

//密码输入完成回调
- (void)inputAlertViewFinishInput:(InputAlertView *)removeAlert withPassword:(NSString *)password;

//取消
- (void)inputAlertViewCancel:(InputAlertView *)removeAlert;

@end

@interface InputAlertView : UIView

/**
 *  初始化
 *
 *  @param frame    frame
 *  @param delegate 设置delegate
 *
 *  @return InputAlertView
 */
- (instancetype)initWithFrame:(CGRect)frame delegate:(id <InputAlertViewDelegate>)delegate;

@property (nonatomic,weak) id <InputAlertViewDelegate> delegate;

//创建UI
- (void)createView;

@end
