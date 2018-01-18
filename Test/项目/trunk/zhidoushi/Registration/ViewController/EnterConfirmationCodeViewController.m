//
//  EnterConfirmationCodeViewController.m
//  zhidoushi
//
//  Created by xinglei on 14/11/10.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "EnterConfirmationCodeViewController.h"

#import "WWCodeButton.h"
#import "WWCodeTextField.h"
#import "MainViewController.h"
#import "MainViewController.h"
#import "PerfectInformationViewController.h"
//..netWork..//
#import "JSONKit.h"
#import "AFNetworking.h"
#import "AFHTTPRequestOperationManager.h"
#import "NSObject+NARSerializationCategory.h"
#import "UIActivityIndicatorView+AFNetworking.h"
//..private..//
#import "WWTolls.h"
#import "GlobalUse.h"
//....//
#import "LoginViewController.h"
#import "NSDictionary+NARSafeDictionary.h"

@interface EnterConfirmationCodeViewController ()<UITextFieldDelegate>
{
    WWCodeTextField *codeTextField;
    WWCodeButton *codeButton;
    UIActivityIndicatorView *activityIndica;//转轮
    UIButton *nextButton;
}

@end

@implementation EnterConfirmationCodeViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"BarBtn_goBack_32_32"] forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = MyFont(13);
    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width = 16;
    labelRect.size.height = 16;
    self.leftButton.frame = labelRect;
    
    CGRect labelRectRight = self.rightButton.frame;
    labelRectRight.size.width = 51;
    labelRectRight.size.height = 18;
    self.rightButton.frame = labelRectRight;
    
    self.titleLabel.text = @"输入验证码";
    self.titleLabel.font = MyFont(18);
    self.titleLabel.textColor = ZDS_DHL_TITLE_COLOR;

     NSLog(@"***********%@%@",_phoneCode,_registerstatus);
}

- (void)viewDidLoad {

    [super viewDidLoad];
    self.view.backgroundColor = ZDS_BACK_COLOR;
    UIView *back = [[UIView alloc] initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 50)];
    back.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:back];
    // Do any additional setup after loading the view from its nib.
    codeTextField = [[WWCodeTextField alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 145, 50) withType:codeType];
     NSLog(@"%f",codeTextField.frame.origin.y);
    codeTextField.delegate = self;
    codeTextField.placeholder = @"输入验证码";
    [codeTextField becomeFirstResponder];
    [back addSubview:codeTextField];

    self.showLabel.text = [NSString stringWithFormat:@"验证码已经发送到 %@",self.phoneNumber];
    CGRect showRect = self.showLabel.frame;
    showRect.origin.x = 15;
    showRect.origin.y = back.bottom + 7;
    self.showLabel.frame = showRect;

    //..点击下一步按钮..//
     nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setFrame:CGRectMake(0, SCREEN_HEIGHT - 64 - 50, SCREEN_WIDTH, 50)];
    [nextButton setTitleColor:OrangeColor forState:UIControlStateNormal];
    [nextButton setTitleColor:TimeColor forState:UIControlStateDisabled];
    nextButton.titleLabel.font = MyFont(15);
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
//    [nextButton setBackgroundColor:[WWTolls colorWithHexString:@"#5FEB59"]];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"dht-750-118"] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(createGame) forControlEvents:UIControlEventTouchUpInside];
    nextButton.enabled = YES;
    [self.view addSubview:nextButton];

//    UIView *maskView = [[UIView alloc]initWithFrame:CGRectMake(codeTextField.right, codeTextField.top, 20, 30)];
//    [self.view addSubview:maskView];
    if (codeButton==nil) {
        codeButton = [[WWCodeButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 130, 0, 130, 50)];
        [codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [codeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        codeButton.titleLabel.font = MyFont(17);
//        codeButton.layer.cornerRadius = 5;
//        codeButton.layer.borderColor = [WWTolls colorWithHexString:@"888c91"].CGColor;
//        codeButton.layer.borderWidth = 0.5f;
        [codeButton addTarget:self action:@selector(getCodeSender) forControlEvents:UIControlEventTouchUpInside];
        [codeButton startTimerNmu];
        [back addSubview:codeButton];
    }
    activityIndica = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndica.frame = CGRectMake(SCREEN_MIDDLE(50), SCREEN_HEIGHT-200, 50, 50);
    [activityIndica setCenter:CGPointMake(160, 140)];//指定进度轮中心点
    [self.view addSubview:activityIndica];

    //..提示用户验证码已发送..//
    [self showAlertMsg:@"验证码已发送" yOffset:-50];
}

-(void)popButton{
    [codeButton stopTimer];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createGame{
    NSLog(@"-----------%@,%@",_phoneCode,_registerstatus);
    long long code = [self.phoneCode longLongValue];
    long long Value = (code-1126L-0126L)/9299L;
    NSLog(@"验证码-----%lld",Value);
    if ([codeTextField.text isEqualToString:[NSString stringWithFormat:@"%lld",Value]]) {
        
        if([_registerstatus intValue]==1){//手机号注册过
#warning 老用户引导
            if ([NSUSER_Defaults objectForKey:@"openoldnew"] == nil) {
                [NSUSER_Defaults setObject:@"YES" forKey:@"openoldnew"];
            }
            [self loginManagerRequest:nil parameter:nil];
            [codeButton stopTimer];
        }
        else if([_registerstatus intValue]!=1){//手机没注册//去注册界面
            PerfectInformationViewController *PerfectInformation = [[PerfectInformationViewController alloc]initWithNibName:@"PerfectInformationViewController" bundle:nil];
            PerfectInformation.codeEnter = _phoneCode;
            PerfectInformation.phoneNumber = self.phoneNumber;
            NSString * deviceString = [NSUSER_Defaults objectForKey:ZDS_DEVICETOKEN];
            if (deviceString.length!=0) {
                PerfectInformation.deviceID = [NSString stringWithFormat:@"%@",deviceString];
            }
            PerfectInformation.registerStatus = @"0";
            PerfectInformation.logintype = @"0";
            [self.navigationController pushViewController:PerfectInformation animated:YES];
            [codeTextField resignFirstResponder];//回收键盘
            [codeButton stopTimer];
        }
    }else{
        [self showAlertMsg:@"验证码错啦" yOffset:-50];
    }
}

-(void)loginPushViewController{
    MainViewController *mainController = [[MainViewController alloc]initWithNibName:@"MainViewController" bundle:nil];
    [self.navigationController pushViewController:mainController animated:YES];
}

-(void)getCodeSender{

    

    NSString *urlString =[NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_URLREQUEST_GETCODE];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:self.phoneNumber forKey:@"phonenumber"];
    [dic setObject:self.phoneNumber forKey:@"userid"];
    NSString *key = [NSString getMyKey:self.phoneNumber];
    [dic setObject:key forKey:@"key"];
    if(_phoneCode.length!=0){
        [dic setObject:_phoneCode forKey:@"vcode"];
    }
    [self operationManagerRequest:urlString parameter:dic];
    self.showLabel.text = [NSString stringWithFormat:@"验证码已经发送到    %@",self.phoneNumber];
}

-(void)operationManagerRequest:(NSString*)string parameter:(NSMutableDictionary*)para
{
    [self showWaitView];
    
    WEAKSELF_SS
    [WWRequestOperationEngine operationManagerRequest_NoUserIdPost:string parameters:para requestOperationBlock:^(NSDictionary *dic) {
        [weakSelf showAlertMsg:@"验证码已发送" yOffset:-50];
        if (dic.count>0) {
            if([weakSelf.navigationController.viewControllers[0] isKindOfClass:[LoginViewController class]]){

                int s = 60;
                if (codeButton.clickDownNum>2) {
                    s = 60*codeButton.clickDownNum-2;
                }
                ((LoginViewController*)weakSelf.navigationController.viewControllers[0]).djs = s;
            }
            _phoneCode = [dic objectForKey:@"vcode"];
            _registerstatus = [dic objectForKey:@"registerstatus"];
            [codeButton startTimerNmu];
            [weakSelf removeWaitView];
        }else{
            [weakSelf showAlertMsg:@"获取验证码失败" yOffset:-50];
            [weakSelf removeWaitView];
        }
        
    }];
}

//..获取登录状态..//
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark textFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{  //string就是此时输入的那个字符 textField就是此时正在输入的那个输入框 返回YES就是可以改变输入框的值 NO相反

    if ([string isEqualToString:@"\n"])  //按回车可以改变
    {
        return YES;
    }

    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容

    if ([toBeString length] > 9) { //如果输入框内容大于10则弹出警告
        return NO;
    }
    if ([toBeString isEqualToString:@" "]) {
        [[GlobalUse shareGlobal]showInfoHud:@"验证码不允许输入空格!" inView:textField.superview];
        return NO;
    }

    if ([toBeString length] > 0) {
//        [nextButton setBackgroundImage:[UIImage imageNamed:@"next_on_.png"] forState:UIControlStateNormal];
        nextButton.enabled = YES;
    }else{
//        [nextButton setBackgroundImage:[UIImage imageNamed:@"next_off_.png"] forState:UIControlStateNormal];
        nextButton.enabled = NO;
    }
    return YES;

}

-(void)getFial{
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:uns];
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
#else
    UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
#endif
    [self showAlertMsg:@"登录失败，请重试" yOffset:-50];
}

//..登录判断..//
-(void)loginManagerRequest:(NSString*)string parameter:(NSMutableDictionary*)para{

    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:3];

    [dictionary setObject:self.phoneNumber forKey:@"userid"];
    NSString * keyString = [self.phoneNumber stringByAppendingString:ZDS_M_PI];
    NSString * keyStringMD5 = [WWTolls md5:keyString];
    [dictionary setObject:keyStringMD5 forKey:@"key"];

    [dictionary setObject:self.registerstatus forKey:@"registerstatus"];

    [dictionary setObject:self.phoneNumber forKey:@"phonenumber"];

    NSString *clientString = [NSString stringWithFormat:@"%@",[NSUSER_Defaults objectForKey:ZDS_CLIENTID]];
    if (clientString.length != 0) {
        [dictionary setObject:clientString forKey:@"clientid"];
    }
    
    NSString *deviceString = [NSString stringWithFormat:@"%@",[NSUSER_Defaults objectForKey:ZDS_DEVICETOKEN]];
    if (deviceString.length > 7) {
        [dictionary setObject: deviceString forKey:@"deviceid"];
    }
    

    [dictionary setObject:@"0" forKey:@"logintype"];
    if ([NSUSER_Defaults objectForKey:@"zdslatitude"]!=nil) {
        [dictionary setObject:[NSUSER_Defaults objectForKey:@"zdscountry"] forKey:@"country"];
        [dictionary setObject:[NSUSER_Defaults objectForKey:@"zdsprovince"] forKey:@"province"];
        if([NSUSER_Defaults objectForKey:@"zdscity"]!=nil) [dictionary setObject:[NSUSER_Defaults objectForKey:@"zdscity"] forKey:@"city"];
        [dictionary setObject:[NSUSER_Defaults objectForKey:@"zdslongitude"] forKey:@"longitude"];
        [dictionary setObject:[NSUSER_Defaults objectForKey:@"zdslatitude"] forKey:@"latitude"];
    }

 NSLog(@"*****dictionary**********%@",dictionary);
    __weak typeof(self)weakSelf = self;
    
    
    [WWRequestOperationEngine operationManagerRequest_NoUserIdPost:[NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_URLREQUEST_ATGV_POSTUSERDICTIONARY] parameters:dictionary requestOperationBlock:^(NSDictionary *dictionary) {
        NSLog(@"dictionary————————————————%@",dictionary);
        NSString *loginstatus = [dictionary objectForKey:@"loginstatus"];
        //..把接收到的手机号存储起来..//
        NSString *phoneStr = [dictionary objectForKey:@"userid"];
        UserModel *user=[[UserModel alloc]init];
        user.userID = phoneStr;
        
        if ([loginstatus intValue]==0) {//登录成功
            [NSUSER_Defaults setObject:user.userID forKey:ZDS_USERID];
            //..把key也储存起来..//
            [NSUSER_Defaults synchronize];
            [weakSelf loginPushViewController];
        }
    }];

}

@end
