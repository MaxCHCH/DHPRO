//
//  LoginViewController.m
//  zhidoushi
//
//  Created by xinglei on 14-9-10.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "GlobalUse.h"
#import "MainViewController.h"
#import "BaseViewController.h"
#import "LoginViewController.h"
//#import "RegistViewController.h"
#import "UserProtocolViewController.h"
#import "PerfectInformationViewController.h"
//#import "VerifyThephoneNumberViewController.h"
#import "EnterConfirmationCodeViewController.h"
//..private..//
#import "WWTolls.h"
#import "UIViewExt.h"
#import "WeiXinEngine.h"
#import "WWCodeTextField.h"
//#import "XLConnectionStore.h"
//#import "NSArray+NARSafeArray.h"
#import "NSString+NARSafeString.h"
#import "NSDictionary+NARSafeDictionary.h"
#import "NSObject+NARSerializationCategory.h"
//..netWork..//
#import "Define.h"
#import "JSONKit.h"
#import "AFNetworking.h"
#import "WWRequestOperationEngine.h"
#import "UIViewController+ShowAlert.h"
#import "AFHTTPRequestOperationManager.h"

#import "MBProgressHUD+MJ.h"
#import "ContactViewController.h"
#import "WXApi.h"
#import "UMSocial.h"
#import <CoreLocation/CoreLocation.h>

//..微信API..//
//#import "WXApi.h"
//#import "WXApiObject.h"
//..友盟API..//
//#import "UMSocial.h"
//#import "UMSocialWechatHandler.h"
//#import "UMSocialSnsPlatformManager.h"

#define Height 50
#define MyFont(A) [UIFont systemFontOfSize:A]

@interface LoginViewController ()<UITextFieldDelegate,CLLocationManagerDelegate>
{
    NSString *phoneCode;//获取的验证码
    NSString *registerstatus;//返回的注册状态
    NSString *access_token;
    NSString *openid;
    MainViewController *mainViewCor;
    UIButton *nextButton;
}
@property(nonatomic,strong)WWCodeTextField *phoneNumberField;
@property(nonatomic,strong)WWCodeTextField *passWordField;
@property(nonatomic,strong)UILabel     *promptLabel;
@property(nonatomic,strong)NSDictionary *phoneString;//微博好友
@property(nonatomic,strong)NSTimer *timer;//
@property (strong, nonatomic) CLLocationManager *locationManager;//定位

@end

@implementation LoginViewController
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // 清空导航条背景图片,系统判断当前是否为Nil,如果为nil,系统还是会自动生成一张背景图片
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    
    
    [self removeWaitView];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    NSLog(@"diviceToken====%@",[NSUSER_Defaults objectForKey:ZDS_DEVICETOKEN]);
    NSLog(@"CLientId====%@",[NSUSER_Defaults objectForKey:ZDS_CLIENTID]);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

-(instancetype)init{
    self = [super init];
    if (!self) {
        return nil;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    self.titleLabel.text = @"进入脂斗士";
    self.titleLabel.textColor = ZDS_DHL_TITLE_COLOR;
    self.titleLabel.font = MyFont(18);
    [UIApplication sharedApplication].statusBarHidden = NO;
    phoneCode = nil;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(js) userInfo:nil repeats:YES];
    [self.timer invalidate];
    self.timer = nil;
    self.timer = timer;
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}
-(void)js{
    self.djs -= 1;
}
-(void)backTo{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(void)concel{
    [self.view endEditing:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.djs = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(concel)];
    [self.view addGestureRecognizer:tap];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getSuccessOpenId) name:@"getOpenIdSuccess" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getFial) name:@"loginFail" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getFial) name:@"getdevicefail" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getFial) name:@"getclientfail" object:nil];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //删除用户记录
    [NSUSER_Defaults setObject:nil forKey:@"newMessage"];
    [NSUSER_Defaults setObject:nil forKey:@"flwsum"];
    [NSUSER_Defaults setObject:nil forKey:@"inform"];
    [NSUSER_Defaults setObject:nil forKey:@"newmsgid"];
    [NSUSER_Defaults setObject:nil forKey:@"newFriendPhones"];
    [NSUSER_Defaults setObject:nil forKey:@"newFriendSina"];
    [self refreshadd];
    [self creatLoginStyle];
//  [[GlobalUse shareGlobal]showInfoHud:@"请等待" inView:self.view];
}

-(void)getFial{
    static int i = 0;
    [self removeWaitView];
    [self showAlertMsg:@"登录失败，请重试" yOffset:-50];
    i++;
    if (i==3) {
        i=0;
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:ZDS_CLIENTID];
    }
}

- (void)creatLoginStyle
{
    self.view.backgroundColor = ZDS_BACK_COLOR;
    UIView *tt = [[UIView alloc] initWithFrame:CGRectMake(0, 15, 15, 50)];
    tt.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tt];
    self.phoneNumberField = [[WWCodeTextField alloc]initWithFrame:CGRectMake(15, 15,SCREEN_WIDTH, 50) withType:phoneType];
    self.phoneNumberField.delegate = self;
    self.phoneNumberField.backgroundColor = [UIColor whiteColor];
    [self.phoneNumberField setPlaceholder:@"输入手机号"];
    [self.view addSubview:self.phoneNumberField];

    UILabel* CountdownLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.phoneNumberField.bottom+8, 150, 20)];
    CountdownLabel.font = [UIFont systemFontOfSize:13];
    CountdownLabel.textColor = [WWTolls colorWithHexString:@"#a7a7a7"];
//  CountdownLabel.lineBreakMode = NSLineBreakByCharWrapping;
    CountdownLabel.numberOfLines = 0;
//    CountdownLabel.backgroundColor = ZDS_BACK_COLOR;
    [self.view addSubview:CountdownLabel];
    CountdownLabel.text = @"点击下一步表示同意";

    UIButton *protocolButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [protocolButton setBackgroundColor:ZDS_BACK_COLOR];
    [protocolButton setFrame:CGRectMake(CountdownLabel.right-40,  self.phoneNumberField.bottom+9, 110, 20)];
    [protocolButton setTitle:@"《脂斗士用户协议》" forState:UIControlStateNormal];
    [protocolButton setTitleColor:TimeColor forState:UIControlStateNormal];
    [protocolButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [protocolButton addTarget:self action:@selector(proBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:protocolButton];

    //..点击下一步按钮..//
    nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"dht-750-118"] forState:UIControlStateNormal];
    [nextButton setFrame:CGRectMake(0, SCREEN_HEIGHT - 50 - 62, SCREEN_WIDTH, 50)];
    [nextButton setTitleColor:TimeColor forState:UIControlStateNormal];
//    [nextButton setBackgroundImage:[UIImage imageNamed:@"next_off_.png"] forState:UIControlStateNormal];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(netStepSender) forControlEvents:UIControlEventTouchUpInside];
    nextButton.enabled = NO;
    [self.view addSubview:nextButton];
//    //..中间修饰图..//
//    UIImageView *maskImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"disanfang_580_24.png"]];
//    maskImageView.frame = CGRectMake(nextButton.left, nextButton.bottom+18, nextButton.width, 12*SCREEN_WIDTH/320);
//    [self.view addSubview:maskImageView];
    CGFloat h = self.phoneNumberField.bottom + 38;
    //微博
    UIView *weibo = [[UIView alloc] initWithFrame:CGRectMake(0, h, SCREEN_WIDTH, 50)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(weibo)];
    [weibo addGestureRecognizer:tap];
    weibo.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:weibo];
    //新粉丝图标
    UIImageView *imag = [[UIImageView alloc] init];
    imag.frame = CGRectMake(15, 15, 19, 19);
    imag.image = [UIImage imageNamed:@"wb-46"];
    [weibo addSubview:imag];
    //新粉丝文字
    UILabel *lbl = [[UILabel alloc] init];
    lbl.frame = CGRectMake(50, 15, 120, 16);
    lbl.text = @"微博登陆";
    lbl.textColor = ContentColor;
    lbl.font = MyFont(16);
    [weibo addSubview:lbl];
    //右边箭头
    UIImageView *row = [[UIImageView alloc] init];
    row.frame = CGRectMake(SCREEN_WIDTH-25, 20, 10, 10);
    row.image = [UIImage imageNamed:@"home_more_26_26"];
    [weibo addSubview:row];
    
    
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]]||[[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]] || [WXApi isWXAppInstalled]) {
        //微信
        UIView *back = [[UIButton alloc] init];
        back.backgroundColor = [UIColor whiteColor];
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickQQButton)];
        [back addGestureRecognizer:tap];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(50, 0, SCREEN_WIDTH-50, 1)];
        line.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
        [back addSubview:line];
        back.frame = CGRectMake(0, h+50, SCREEN_WIDTH, 50);
        [self.view addSubview:back];
        //评论图标
        imag = [[UIImageView alloc] init];
        imag.frame = CGRectMake(15, 15, 19, 19);
        imag.image = [UIImage imageNamed:@"wx-46"];
        [back addSubview:imag];
        //评论文字
        lbl = [[UILabel alloc] init];
        lbl.frame = CGRectMake(50, 15, 120, 18);
        lbl.text = @"微信登陆";
        lbl.textColor = ContentColor;
        lbl.font = MyFont(16);
        [back addSubview:lbl];
        
        //右边箭头
        row = [[UIImageView alloc] init];
        row.frame = CGRectMake(SCREEN_WIDTH-25, 20, 10, 10);
        row.image = [UIImage imageNamed:@"home_more_26_26"];
        [back addSubview:row];
//        //..微信登录按钮..//
//        UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [loginButton setFrame:CGRectMake(SCREEN_WIDTH-86-57, maskImageView.bottom+23, 57, 57)];
//        [loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [loginButton setBackgroundImage:[UIImage imageNamed:@"weixindenglu"] forState:UIControlStateNormal];
//        [loginButton addTarget:self action:@selector(clickQQButton) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:loginButton];
//        //新浪微博登陆
//        UIButton *btn = [[UIButton alloc] init];
//        btn.frame = CGRectMake(86, maskImageView.bottom+23, 57, 57);
//        [btn setBackgroundImage:[UIImage imageNamed:@"weibodenglu-114-114"] forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(weibo) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:btn];
//        
//        self.promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, Height * 2 + 10, 220, 40)];
//        //    [self.promptLabel setTextColor:[UIColor redColor]];
//        [self.promptLabel setTextAlignment:NSTextAlignmentLeft];
//        [self.promptLabel setFont:[UIFont systemFontOfSize:13]];
//        [self.view addSubview:self.promptLabel];
    }else{
        //..微博登录按钮..//
//        UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [loginButton setFrame:CGRectMake(SCREEN_MIDDLE(57), maskImageView.bottom+20, 57, 57)];
//        [loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [loginButton setBackgroundImage:[UIImage imageNamed:@"weibodenglu-114-114"] forState:UIControlStateNormal];
//        [loginButton addTarget:self action:@selector(weibo) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:loginButton];
//        
//        self.promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, Height * 2 + 10, 220, 40)];
//        //    [self.promptLabel setTextColor:[UIColor redColor]];
//        [self.promptLabel setTextAlignment:NSTextAlignmentLeft];
//        [self.promptLabel setFont:[UIFont systemFontOfSize:13]];
//        [self.view addSubview:self.promptLabel];
    }
    
    self.view.backgroundColor = ZDS_BACK_COLOR;

}
#pragma mark - 微博登陆
-(void)weibo{
    [self showWaitView];
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    __weak typeof(self) weakself = self;
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
            //获取accestoken以及新浪用户信息，得到的数据在回调Block对象形参respone的data属性
            [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToSina  completion:^(UMSocialResponseEntity *response){
                NSLog(@"SnsInformation is %@",response.data);
                //获取到新浪用户信息
                //构建parameter
                NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:3];
                [NSUSER_Defaults setObject:snsAccount.usid forKey:ZDS_USERID];
                NSString *deviceString = [[NSUserDefaults standardUserDefaults] objectForKey:ZDS_DEVICETOKEN];
                NSString *clientString = [[NSUserDefaults standardUserDefaults] objectForKey:ZDS_CLIENTID];
                if (deviceString.length!=0) {
                    [dictionary setObject:[NSString stringWithFormat:@"%@",deviceString]  forKey:@"deviceid"];
                    
                }else{
                    [dictionary setObject:@"0"  forKey:@"deviceid"];
                }
                if (clientString.length!=0) {
                    [dictionary setObject:[NSString stringWithFormat:@"%@",clientString] forKey:@"clientid"];
                }else{
                    [dictionary setObject:@"0" forKey:@"clientid"];
                }
                [dictionary setObject:@"0" forKey:@"logintype"];//ios 0 android 1

                NSString *nickName = snsAccount.userName;
                NSString *uid = snsAccount.usid;
                int sexInteger = [response.data[@"gender"] intValue];
                NSString *headImageUrl = snsAccount.iconURL;
                //===================================================================
                if (nickName.length!=0) {
                    [dictionary setObject:nickName forKey:@"username"];
                }
                if (sexInteger!=0) {
                    [dictionary setObject:[NSString stringWithFormat:@"%d",sexInteger] forKey:@"usersex"];
                }
                if (headImageUrl.length!=0) {
                    [dictionary setObject:headImageUrl forKey:@"imageurl"];
                }else{
                    [dictionary setObject:@"imgs/default/head.jpg?FrmRhCmNQrWYNgUlI6JSCQJzTJ2Q" forKey:@"imageurl"];
                }
                [dictionary setObject:uid forKey:@"uid"];
                [dictionary setObject:@"appstore" forKey:@"channel"];
                if ([NSUSER_Defaults objectForKey:@"zdslatitude"]!=nil) {
                    [dictionary setObject:[NSUSER_Defaults objectForKey:@"zdscountry"] forKey:@"country"];
                    [dictionary setObject:[NSUSER_Defaults objectForKey:@"zdsprovince"] forKey:@"province"];
                    if([NSUSER_Defaults objectForKey:@"zdscity"]!=nil) [dictionary setObject:[NSUSER_Defaults objectForKey:@"zdscity"] forKey:@"city"];
                    [dictionary setObject:[NSUSER_Defaults objectForKey:@"zdslongitude"] forKey:@"longitude"];
                    [dictionary setObject:[NSUSER_Defaults objectForKey:@"zdslatitude"] forKey:@"latitude"];
                }
                
                NSLog(@"微信用户信息________%@",dictionary);
                
                WEAKSELF_SS
                [WWRequestOperationEngine operationManagerRequest_Post:[NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_URLREQUEST_WBLOGIN] parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
                    
                    if (dic[ERRCODE]) {
                        [weakself removeWaitView];
                    }else{
                        
                        NSLog(@"微博登陆---------------%@",dic);
                        
                        NSString *userID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"userid"] ];
                        [NSUSER_Defaults setObject:userID forKey:ZDS_USERID];
                        [NSUSER_Defaults synchronize];
                        NSLog(@"%@", [dic objectForKey:@"errinfo"]);
                        NSString *loginstatus = [dic objectForKey:@"loginstatus"];
                        //上传新浪好友关系
                        if(userID.length>0){
                            [[UMSocialDataService defaultDataService] requestSnsFriends:UMShareToSina  completion:^(UMSocialResponseEntity *response){
                                //上传新浪信息/cpwbflws.do
                                weakSelf.phoneString = [NSUSER_Defaults objectForKey:[NSString stringWithFormat:@"sina.%@",[NSUSER_Defaults objectForKey:ZDS_USERID]]];
                                if (![weakSelf.phoneString isKindOfClass:[NSDictionary class]]) {
                                    [NSUSER_Defaults setObject:nil forKey:[NSString stringWithFormat:@"sina.%@",[NSUSER_Defaults objectForKey:ZDS_USERID]]];
                                    weakSelf.phoneString = nil;
                                }
                                NSMutableDictionary * resultString = [NSMutableDictionary dictionary];
                                for (NSString *s in response.data.allKeys) {
                                    if(weakSelf.phoneString[s]==nil) [resultString setObject:response.data[s] forKey:s];
                                }
                                weakSelf.phoneString = response.data;
                                if (resultString.count!=0) {
                                    NSLog(@"有新的用户噢噢噢噢噢噢噢噢哦哦哦");
                                    [weakSelf upDataUserPhoneBook:resultString];
                                }

                            }];

                        }
                        [weakself removeWaitView];
                        if([loginstatus intValue]==0){//注册过
                            [weakSelf showAlertMsg:@"登录成功" yOffset:-20];
                            [weakSelf showWaitView];
                            [weakSelf loginPushViewController];
                        }
                        else if ([loginstatus intValue]==1){
                            [weakSelf showAlertMsg:@"注册成功" yOffset:-20];
                            NSLog(@"*******初始化通讯录并调取");
                            //初始化通讯录并调取
                            ContactViewController * contanct = [[ContactViewController alloc]init];
                            [contanct readContacts];
                            [contanct uploadPhoneNumber];
                            [contanct writePhoneNumber];
                            [weakSelf showWaitView];
                            [weakSelf loginPushViewController];
                        }
                        else if ([loginstatus intValue]==2) {//登陆失败
                            [weakSelf showAlertMsg:@"登录失败" yOffset:-20];
                        }
                    }
                }];
            }];
            
            //            获取好友列表调用下面的方法,由于新浪官方限制，获取好友列表只能获取到30%好友
            
            
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
        }
        else {
            [weakself removeWaitView];
            [self showAlertMsg:@"授权失败" yOffset:-10];
        }
    });
}


#pragma mark - 上传新浪微博好友
-(void)upDataUserPhoneBook:(NSMutableDictionary*)pbookstring
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:2];
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:pbookstring options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *phone = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    phone = [phone stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [dictionary setObject:phone forKey:@"wbflwmap"];
    NSLog(@"上传通讯录dictionary——————————————%@",dictionary);
    __weak typeof(self)weakSelf = self;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_CPSINAFRIENDDO];
    [WWRequestOperationEngine operationManagerRequest_Post:urlString parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (![dic isKindOfClass:[NSDictionary class]] || dic==nil) {
            NSLog(@"上传新浪好友失败");
        }else{
            [NSUSER_Defaults setValue:weakSelf.phoneString forKey:[NSString stringWithFormat:@"sina.%@",[NSUSER_Defaults objectForKey:ZDS_USERID]]];
            [NSUSER_Defaults synchronize];
        }
    }];
    
}

#pragma mark - 点击下一步时获取验证码
-(void)netStepSender{
    BOOL result = [WWTolls isMobileNumber:self.phoneNumberField.text];
    if (result) {
        if(self.djs>0){
            [self showAlertMsg:[NSString stringWithFormat:@"请%d秒后重试",self.djs] yOffset:-50];
            return;
        }
        self.djs = 60;
        [self getCodeSender];
    }else{
        [self showAlertMsg:@"请输入正确的手机号" yOffset:-50];
    }
}

-(void)getCodeSender{

    NSString *urlString =[NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_URLREQUEST_GETCODE];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:self.phoneNumberField.text forKey:@"phonenumber"];
    NSString *userid = [NSString stringWithFormat:@"%@",self.phoneNumberField.text];
    NSString *key = [NSString getMyKey:userid];
    [dic setObject:userid forKey:@"userid"];
    [dic setObject:key forKey:@"key"];
    if (!phoneCode) {
        [dic setObject:@"meiyouyanzhengma" forKey:@"vcode"];
    }else{
        [dic setObject:phoneCode forKey:@"vcode"];
    }
    [self operationManagerRequest:urlString parameter:dic];
}

-(void)operationManagerRequest:(NSString*)string parameter:(NSMutableDictionary*)para
{
    [self showWaitView];
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_NoUserIdPost:string parameters:para requestOperationBlock:^(NSDictionary *dic) {
        
        if (!dic[ERRCODE]) {
            phoneCode = [dic objectForKey:@"vcode"];
            registerstatus = [dic objectForKey:@"registerstatus"];
            NSLog(@"获取验证码信息dic*****************registerstatus==%@",dic);
            [weakSelf.phoneNumberField resignFirstResponder];//回收键盘
            //..获取验证码成功后跳转..//
            EnterConfirmationCodeViewController *enter_view = [[EnterConfirmationCodeViewController alloc]initWithNibName:@"EnterConfirmationCodeViewController" bundle:nil];
            enter_view.phoneNumber = weakSelf.phoneNumberField.text;
            enter_view.registerstatus = registerstatus;
            enter_view.phoneCode = phoneCode;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.navigationController pushViewController:enter_view animated:YES];
            });
        }
        [weakSelf removeWaitView];
           
        
    }];
}

- (void)proBtnAction
{
    UserProtocolViewController *userProtocol = [[UserProtocolViewController alloc] init];
    [self.navigationController pushViewController:userProtocol animated:YES];

//    MainViewController *main  = [[MainViewController alloc]initWithNibName:@"MainViewController" bundle:nil];
//    [self.navigationController pushViewController:main animated:YES];
}

#pragma mark textFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{  //string就是此时输入的那个字符 textField就是此时正在输入的那个输入框 返回YES就是可以改变输入框的值 NO相反
    
    if ([string isEqualToString:@"\n"])  //按回车可以改变
    {
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
//    if (self.phoneNumberField.wwFieldType == phoneType)
//    {
        if ([toBeString length] > 0) {
//            [nextButton setBackgroundImage:[UIImage imageNamed:@"next_on_.png"] forState:UIControlStateNormal];
            [nextButton setTitleColor:OrangeColor forState:UIControlStateNormal];
            nextButton.enabled = YES;
        }else{
            [nextButton setTitleColor:TimeColor forState:UIControlStateNormal];
//            [nextButton setBackgroundImage:[UIImage imageNamed:@"next_off_.png"] forState:UIControlStateNormal];
            nextButton.enabled = NO;
        }
        if ([toBeString length] > 11) { //如果输入框内容大于10则弹出警告
            textField.text = [toBeString substringToIndex:11];
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
            [self.view addSubview:view];
            [self showAlertMsg:@"请输入正确的手机格式" yOffset:-50];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [view removeFromSuperview];
            });
            
            //[[GlobalUse shareGlobal]showTextHud:@"请输入正确的手机格式" inView:textField.superview];
            return NO;
        }
        if ([toBeString isEqualToString:@" "]) {
            [[GlobalUse shareGlobal]showInfoHud:@"验证码不允许输入空格!" inView:textField.superview];
            return NO;
        }
//    }
    return YES;
}

#pragma mark - textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder]; //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    return YES;
}

-(void)loginPushViewController{
    [self removeWaitView];
    MainViewController *mainController = [[MainViewController alloc]initWithNibName:@"MainViewController" bundle:nil];
    [self.navigationController pushViewController:mainController animated:YES];
}

#pragma mark - 微信登陆
-(void)clickQQButton{
    [self showWaitView];
    [WeiXinEngine sendAuthRequest:self.view];
    //..测试用方法..//
//        VerifyThephoneNumberViewController *verify = [[VerifyThephoneNumberViewController alloc]initWithNibName:@"VerifyThephoneNumberViewController" bundle:nil];
//    [self.navigationController pushViewController:verify animated:YES];
}

#pragma mark - 微信登陆返回状态
-(void)getSuccessOpenId{//以前注册过
//    [self showWaitView];
    [self loginPushViewController];
}
-(void)getfail{
    [self removeWaitView];
    [self showAlertMsg:@"登录失败，请重试" yOffset:-40];
}
-(void)pushPerfectInformationViewController:(NSString*)status{
//    VerifyThephoneNumberViewController *verify = [[VerifyThephoneNumberViewController alloc]initWithNibName:@"VerifyThephoneNumberViewController" bundle:nil];
//    NSString *openID = [NSUSER_Defaults objectForKey:@"openid"];
//     NSLog(@"openID==============%@",openID);
//    if (openID.length!=0) {
//        verify.openid = [NSUSER_Defaults objectForKey:@"openid"];
//    }
//    [self.navigationController pushViewController:verify animated:YES];
}

- (void)dealloc {
   [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getOpenIdSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loginFail" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getdevicefail" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getclientfail" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 定位
#pragma mark 定位代理方法

//允许定位后执行的代理方法
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error)
     {
         
         if (array.count > 0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             
             NSDictionary *placeDict = placemark.addressDictionary;
             NSLog(@"placeDict %@",placeDict);
             
             
             NSString *cityStr = [placeDict objectForKey:@"City"];
             
             //             国家
             NSString *countryStr = [placeDict objectForKey:@"Country"];
             
             //             城市
             NSString *stateStr = [placeDict objectForKey:@"State"];
             NSLog(@"%@ %@ %@",cityStr,countryStr,stateStr);
             
             //             区
             NSString *SubLocality = [placeDict objectForKey:@"SubLocality"];
             if ([SubLocality rangeOfString:@"市"].length>0) {
                 SubLocality = [SubLocality substringToIndex:SubLocality.length-1];
             }
             if ([stateStr rangeOfString:@"市"].length>0) {
                 stateStr = [stateStr substringToIndex:SubLocality.length-1];
             }
             if ([stateStr rangeOfString:@"省"].length>0) {
                 stateStr = [stateStr substringToIndex:SubLocality.length-1];
             }
             NSLog(@"%@",SubLocality);
             NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
             
             NSString * userID =  [NSUSER_Defaults objectForKey:ZDS_USERID];
             if (userID.length!=0) {
                 [dic setObject:userID forKey:@"userid"];
             }
             NSString *key = [NSString getMyKey:userID];
             [dic setObject:key forKey:@"key"];
             
             [NSUSER_Defaults setObject:countryStr forKey:@"zdscountry"];
             [NSUSER_Defaults setObject:stateStr forKey:@"zdsprovince"];
             [NSUSER_Defaults setObject:SubLocality forKey:@"zdscity"];
             [NSUSER_Defaults setObject:[NSString stringWithFormat:@"%lf", newLocation.coordinate.longitude] forKey:@"zdslongitude"];
             [NSUSER_Defaults setObject:[NSString stringWithFormat:@"%lf", newLocation.coordinate.latitude] forKey:@"zdslatitude"];
             [NSUSER_Defaults synchronize];
         }
         else if (error == nil && [array count] == 0)
         {
             NSLog(@"No results were returned.");
         }
         else if (error != nil)
         {
             NSLog(@"An error occurred = %@", error);
         }
     }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
}
#pragma mark - 定位
-(void)refreshadd{
    if (![CLLocationManager locationServicesEnabled]) {
            NSLog(@"定位服务当前可能尚未打开，请设置打开！");
            return;
        }
        
        if(iOS8){
            //创建CLLocationManager对象
            self.locationManager = [[CLLocationManager alloc] init];
            //设置代理为自己
            self.locationManager.delegate = self;
            
            //    请求使用期间定位
            //    [self.locationManager requestAlwaysAuthorization];
            [self.locationManager requestWhenInUseAuthorization];
            
            //    定位请求状态
            CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
            
            //    如果使用期间可以定位则定位
            
            if (status == kCLAuthorizationStatusDenied)
            {
                NSString *alertStr = @"您关闭了应用的定位请求，请选择您的所在区域";
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:alertStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                
                [alertView show];
                
                NSLog(@"用户需要选择区域");
            }
            else
            {
                
                [self.locationManager startUpdatingLocation];
                NSLog(@"定位");
            }
        }else{
            //创建CLLocationManager对象
            self.locationManager = [[CLLocationManager alloc] init];
            //设置代理为自己
            self.locationManager.delegate = self;
            [self.locationManager startUpdatingLocation];
            NSLog(@"定位");
        }
}

@end
