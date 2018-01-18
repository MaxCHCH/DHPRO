//
//  UpdatePasswordOriginalViewController.m
//  zhidoushi
//
//  Created by licy on 15/8/11.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "UpdatePasswordOriginalViewController.h"
#import "ZSDPaymentForm.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "UpdatePasswordNewViewController.h"
#import "GroupViewController.h"

@interface UpdatePasswordOriginalViewController ()

@property (nonatomic,strong) TPKeyboardAvoidingScrollView *tpBgView;
@property (nonatomic,strong) ZSDPaymentForm *pwdForm;

@end

@implementation UpdatePasswordOriginalViewController

#pragma mark - Life Cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //友盟打点
    [MobClick beginLogPageView:@"修改密码页面"];
    
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
    label.text = @"原始密码";
    
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
    [MobClick endLogPageView:@"修改密码页面"];
}

#pragma mark - Event Responses
#pragma mark 下一步
- (void)nextPage {
    
    if (self.pwdForm.inputPassword.length < 6) {
        [self showAlertMsg:@"请输入原始密码" yOffset:-50];
        return;
    }   
    
    __block GroupViewController *groupVC = nil;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[GroupHappyViewController class]]) {
            groupVC = (GroupHappyViewController *)obj;
        }
    }];

    
    if (![self.pwdForm.inputPassword isEqualToString:[WWTolls decodePwd:groupVC.gamePwd]]) {
        [self showAlertMsg:@"原始密码不正确请重新输入" yOffset:-50];
        return;
    }   
    
    UpdatePasswordNewViewController *newVC = [[UpdatePasswordNewViewController alloc] init];
    [self.navigationController pushViewController:newVC animated:YES];
}   
#pragma mark 返回
- (void)popButton {
    [self.navigationController popViewControllerAnimated:YES];
}

@end






