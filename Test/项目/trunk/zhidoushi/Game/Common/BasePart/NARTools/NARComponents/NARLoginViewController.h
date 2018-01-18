//
//  NARLoginViewController.h
//  zhidoushi
//
//  Created by xinglei on 14-11-5.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NARTextField.h"

typedef void (^NARLoginButtonEventBlock) (NSString*name,NSString*pass);

@interface NARLoginViewController : UIViewController<UITextFieldDelegate>

//可根据自身需要，对如下几个控件进行位置修改等
@property (readonly,nonatomic) NARTextField *nameTextField;
@property (readonly,nonatomic) NARTextField *passTextField;
@property (readonly,nonatomic) UIButton *inputContentView;//输入区域
@property (readonly,nonatomic) UIButton *loginButton;
@property (assign,nonatomic) BOOL autoShowKeyboard;//当页面viewDidAppear的时候是否弹出键盘
@property (copy,nonatomic) NARLoginButtonEventBlock loginEventBlock;

- (void)setLoginButtonEventBlock:(NARLoginButtonEventBlock)loginButtonEventBlock;
- (void)textFieldAllResignFirstResponder;//让键盘消失

@end
