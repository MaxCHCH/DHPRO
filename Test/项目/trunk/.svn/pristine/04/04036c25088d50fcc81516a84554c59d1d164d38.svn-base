//
//  CreateGroupSetPasswordNewViewController.m
//  zhidoushi
//
//  Created by glaivelee on 15/11/10.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import "CreateGroupSetPasswordNewViewController.h"
#import "IQKeyboardManager.h"
#import "GroupViewController.h"
@interface CreateGroupSetPasswordNewViewController ()

@end

@implementation CreateGroupSetPasswordNewViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"设置密码页面"];
    [self.view endEditing:YES];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"设置密码页面"];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [WWTolls colorWithHexString:@"#f7f1f1"];
    _tempDic = [NSMutableDictionary dictionary];
    
    UIView *titleViews = [[UIView alloc] init];
    [titleViews addSubview:self.leftButton];
    [titleViews addSubview:self.rightButton];
    self.navigationItem.titleView = titleViews;
    //导航栏返回
    self.leftButton.frame = CGRectMake(0, 0, 13, 20);
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"fh-36"] forState:UIControlStateNormal];
    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width = 13;
    labelRect.size.height = 20;
    self.leftButton.frame = labelRect;
    
    
    [self.rightButton setTitle:@"跳过" forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(Next) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton setTitleColor:[WWTolls colorWithHexString:@"#fe5303"] forState:UIControlStateNormal];
    //    self.rightButton.width = 54;
    //    self.rightButton.left += 110;
    self.rightButton.frame = CGRectMake(0, 0, 60, 20);
    self.rightButton.titleLabel.font = MyFont(16);
    //导航栏标题
    UILabel *title = [[UILabel alloc] init];
    title.text = @"设置密码";
    title.textColor = [WWTolls colorWithHexString:@"#4a5767"];
    title.font = MyFont(18);
    title.textAlignment = NSTextAlignmentCenter;
    title.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    title.center = titleViews.center;
    [titleViews addSubview:title];
    
    
    //底部分割线  YES : VIP
    UILabel *labelBottomline = [UILabel new];
    labelBottomline.backgroundColor = OrangeColor;
    labelBottomline.frame = CGRectMake(0 ,self.view.bottom-68 ,SCREEN_WIDTH , 4);
    [self.view addSubview:labelBottomline];
    
    
    [_inputNewPasswordTextField setValue:[WWTolls colorWithHexString:@"95acb2"] forKeyPath:@"_placeholderLabel.textColor"];
    [_confirmTextField setValue:[WWTolls colorWithHexString:@"95acb2"] forKeyPath:@"_placeholderLabel.textColor"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tap];

    // Do any additional setup after loading the view from its nib.
}
-(void)Next{
    
    NSString *quan = @"";
    for (NSString *btntitle in _titleAllArr) {
        quan = [quan stringByAppendingString:[NSString stringWithFormat:@"%@",btntitle]];
        quan = [quan stringByAppendingString:@","];
        
    }
    [_tempDic setObject:quan forKey:@"gamecircle"];
}
#pragma mark - 下一步
-(IBAction)overSettingMethod:(id)sender{
        if (self.confirmTextField.text.length<6) {
            [self showAlertMsg:@"密码由六位数字组成" yOffset:0];
            return;
        }else if (![self.inputNewPasswordTextField.text isEqualToString:self.confirmTextField.text]) {
            [self showAlertMsg:@"两次密码不一致" yOffset:0];
            return;
        }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认创建吗?" message:@"是否确认创建" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        self.rightButton.userInteractionEnabled = NO;
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:self.tempDic];
        [dictionary removeObjectsForKeys:@[@"hotTags",@"passwordBool",@"tagArray"]];
        if (self.inputNewPasswordTextField.text.length==6) {
            long long pwd = self.inputNewPasswordTextField.text.longLongValue;
            pwd = pwd*9299L+1126L+0126L;
            [dictionary setObject:[NSString stringWithFormat:@"%lld",pwd] forKey:@"gmpassword"];
        }
        __weak typeof(self)weakSelf = self;
        [WWRequestOperationEngine operationManagerRequest_Post:ZDS_CREATEPTDO parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
            if ([dic[@"createflg"] isEqualToString:@"0"]) {
                [weakSelf showAlertMsg:@"创建成功" andFrame:CGRectMake(70,100,200,60)];
                [NSUSER_Defaults setValue:@"YES" forKey:@"tuanzubianhua"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"createGroupSucess" object:nil];
                NSLog(@"*********%@", [dic objectForKey:@"errinfo"]);
                NSString *gameid = [dic objectForKey:@"gameid"];
                GroupViewController *detail = [[GroupViewController alloc]init];
                detail.clickevent = 0;
                detail.joinClickevent = @"0";
                detail.groupId = gameid;//20150206020000000078
                detail.gameDetailStatus = @"10086";
                [weakSelf.navigationController pushViewController:detail animated:YES];
                weakSelf.rightButton.userInteractionEnabled = NO;
            }else{
                weakSelf.rightButton.userInteractionEnabled = YES;
            }
        }];
    }
}



-(void)popButton{
    [WWTolls zdsClick:TJ_CREATEGROUP_QX];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)hideKeyboard{
    [self.view endEditing:YES];
    [_inputNewPasswordTextField resignFirstResponder];
    
    [_confirmTextField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self.view endEditing:YES];
    [_inputNewPasswordTextField resignFirstResponder];

    [_confirmTextField resignFirstResponder];
return YES;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [_inputNewPasswordTextField resignFirstResponder];
    
    [_confirmTextField resignFirstResponder];
}
- (void)keyBoardWillHide:(NSNotification *)note{
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.transform = CGAffineTransformIdentity;
        //        self.table.contentOffset = CGPointZero;
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
