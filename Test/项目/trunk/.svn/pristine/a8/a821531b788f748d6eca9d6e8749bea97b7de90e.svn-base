//
//  UpdatePasswordNewViewController.m
//  zhidoushi
//
//  Created by licy on 15/8/11.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "UpdatePasswordNewViewController.h"
#import "ZSDPaymentForm.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "UpdatePasswordConfirmViewController.h"

@interface UpdatePasswordNewViewController ()

@property (nonatomic,strong) TPKeyboardAvoidingScrollView *tpBgView;
@property (nonatomic,strong) ZSDPaymentForm *pwdForm;

@end

@implementation UpdatePasswordNewViewController

#pragma mark - Life Cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //友盟打点
    [MobClick beginLogPageView:@"修改密码入团密码页面"];
    
    self.navigationController.navigationBarHidden = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    //导航栏标题
    self.titleLabel.text = @"修改密码";
    self.titleLabel.textColor = ZDS_DHL_TITLE_COLOR;
    self.titleLabel.font = MyFont(18);
    
    //导航栏返回
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"BarBtn_goBack_32_32"] forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = MyFont(13);
    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width = 16;
    labelRect.size.height = 16;
    self.leftButton.frame = labelRect;
    
    //导航栏下一步
    [self.rightButton setTitle:@"下一步" forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(nextPage) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton setTitleColor:[WWTolls colorWithHexString:@"#959595"] forState:UIControlStateNormal];
    self.rightButton.width = 54;
    self.rightButton.left += 110;
    self.rightButton.titleLabel.font = MyFont(16);
    
    [self.pwdForm fieldBecomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *tpBgView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:tpBgView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(24, 25, 70, 16)];
    [tpBgView addSubview:label];
    label.font = MyFont(16.0);
    label.textColor = [WWTolls colorWithHexString:@"#535353"];
    label.text = @"入团密码";
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(label.right + 5, 29, 200, 11)];
    [tpBgView addSubview:messageLabel];
    messageLabel.font = MyFont(11.0);
    messageLabel.textColor = [WWTolls colorWithHexString:@"#999999"];
    messageLabel.text = @"密码由6位数字组成";
    messageLabel.textAlignment = NSTextAlignmentLeft;
    
    ZSDPaymentForm *pwdForm = [[[NSBundle mainBundle]loadNibNamed:@"ZSDPaymentForm" owner:self options:nil]lastObject];
    pwdForm.frame = CGRectMake(24, label.bottom + 10, SCREEN_WIDTH - 48, 45);
    [tpBgView addSubview:pwdForm];
    self.pwdForm = pwdForm;
    
    WEAKSELF_SS
    [pwdForm setCompleteHandle:^(NSString * inputPwd) {
        if (inputPwd.length == 6) {
            [weakSelf nextPage];
        }
    }];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"修改密码入团密码页面"];
}

#pragma mark - Event Responses
#pragma mark 下一步
- (void)nextPage {
    
    if (self.pwdForm.inputPassword.length < 6) {
        [self showAlertMsg:@"请输入新密码" yOffset:-50];
        return;
    }
    
    UpdatePasswordConfirmViewController *confirmVC = [[UpdatePasswordConfirmViewController alloc] init];
    confirmVC.groupPassword = self.pwdForm.inputPassword;
    [self.navigationController pushViewController:confirmVC animated:YES];
}
#pragma mark 返回
- (void)popButton {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
