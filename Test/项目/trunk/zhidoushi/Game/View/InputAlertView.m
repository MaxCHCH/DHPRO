//
//  InputAlertView.m
//  zhidoushi
//
//  Created by licy on 15/8/11.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "InputAlertView.h"
#import "UIView+SSLAlertViewTap.h"
#import "ZSDPaymentForm.h"
#import "IQKeyboardManager.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "UIButton+SSLPointBigger.h"

@interface InputAlertView ()

@property (nonatomic,strong) ZSDPaymentForm *pwdForm;

@end

@implementation InputAlertView



#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame delegate:(id <InputAlertViewDelegate>)delegate {
    if (self = [self initWithFrame:frame]) {
        self.delegate = delegate;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"InputAlertView 释放");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UI

#pragma mark 创建UI
- (void)createView {
    
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    self.backgroundColor = [UIColor clearColor];
    
    [self ssl_addGeneralTap];
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 117.5 - 216, self.width, 117.5 + 216)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteView];
    
    TPKeyboardAvoidingScrollView *bgView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:self.bounds];
    bgView.backgroundColor = [UIColor clearColor];
    [self addSubview:bgView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [bgView addGestureRecognizer:tap];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 117.5 - 216, self.width, 117.5)];
    bottomView.backgroundColor = [WWTolls colorWithHexString:@"#ffffff"];
    [bgView addSubview:bottomView];
    
//    CGFloat maxY = 117.5 + 216;
    
    NSString *string = @"请输入加入密码";
    float width = [WWTolls WidthForString:string fontSize:20];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(91, 21, width, 20)];
    label.text = string;
    label.textColor = [WWTolls colorWithHexString:@"#535353"];
    [bottomView addSubview:label];
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.width - 13 - 16, 24, 13, 13)];
    [bottomView addSubview:closeButton];
    [closeButton setImage:[UIImage imageNamed:@"close_password_input.png"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, label.maxY + 21, self.width, 0.5)];
    [bottomView addSubview:lineView];
    lineView.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
    
    ZSDPaymentForm *pwdForm = [[[NSBundle mainBundle]loadNibNamed:@"ZSDPaymentForm" owner:self options:nil]lastObject];
    pwdForm.frame = CGRectMake(24, lineView.bottom + 10, SCREEN_WIDTH - 48, 45);
    [bottomView addSubview:pwdForm];
    self.pwdForm = pwdForm;
    
    WEAKSELF_SS
    [pwdForm setCompleteHandle:^(NSString * inputPwd) {
        if (inputPwd.length == 6) {
            if ([weakSelf.delegate respondsToSelector:@selector(inputAlertViewFinishInput:withPassword:)]) {
                [weakSelf.delegate inputAlertViewFinishInput:self withPassword:inputPwd];
            }
            
        }
    }];
    
//    CGFloat maxY = pwdForm.maxY + 25;
    
//    NSLog(@"pwdForm.maxY:%f",pwdForm.maxY);
    
    //键盘高度
//    CGFloat keyboardHeight = 216;
//    CGFloat bottomeHeight = keyboardHeight + pwdForm.maxY + 25;
//    bottomView.frame = CGRectMake(0, self.height - bottomeHeight, self.width, bottomeHeight);
    
    [pwdForm fieldBecomeFirstResponder];
}

#pragma mark - Event Responses

#pragma mark 清除已输入内容
- (void)closeButtonClick:(UIButton *)closeButton {
    [self.pwdForm.inputView endEditing:YES];
    [self.pwdForm.inputView clearUpPassword];
    [self ssl_hidden];
}

#pragma mark 点击取消
- (void)cancelButtonClick:(UIButton *)button {
    [self ssl_hidden];
}

- (void)tap {
    
    if ([self.delegate respondsToSelector:@selector(inputAlertViewCancel:)]) {
        [self.delegate inputAlertViewCancel:self];
    }
    [self ssl_hidden];
}   

#pragma mark - Private Methods


@end









