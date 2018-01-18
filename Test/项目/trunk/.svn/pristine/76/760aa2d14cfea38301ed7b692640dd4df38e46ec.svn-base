//
//  EnterCodeViewController.m
//  zhidoushi
//
//  Created by xinglei on 14-11-10.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "EnterCodeViewController.h"

#import "PerfectInformationViewController.h"
#import "MainViewController.h"
#import "WWCodeTextField.h"
#import "WWCodeButton.h"
//..netWork..//
#import "JSONKit.h"
#import "AFNetworking.h"
#import "AFHTTPRequestOperationManager.h"
#import "NSObject+NARSerializationCategory.h"
//..private..//
#import "WWTolls.h"
#import "GlobalUse.h"
#import "NSArray+NARSafeArray.h"
@interface EnterCodeViewController ()<UITextFieldDelegate>
{
    WWCodeTextField *codeTextField;
    NSString *phoneCode;//验证码
    NSString *urlString;//请求
    WWCodeButton *codeButton;//验证码按钮
}
@end

@implementation EnterCodeViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    [self.rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = MyFont(15);
    [self.rightButton addTarget:self action:@selector(createGame) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRectRight = self.rightButton.frame;
    labelRectRight.size.width = 50;
    labelRectRight.size.height = 25;
    self.rightButton.frame = labelRectRight;
    
    self.titleLabel.text = @"输入验证码";
    self.titleLabel.font = MyFont(17);
    self.titleLabel.textColor = ZDS_DHL_TITLE_COLOR;
    
}

- (void)viewDidLoad {

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.showCodeLabel.text = [NSString stringWithFormat:@"验证码已经发送到      %@",self.phoneNumber];

    codeTextField = [[WWCodeTextField alloc]initWithFrame:CGRectMake(23, 97, 188, 30) withType:codeType];
    codeTextField.delegate = self;
    codeTextField.placeholder = @"输入验证码";
    [self.view addSubview:codeTextField];
    
    UIView *maskView = [[UIView alloc]initWithFrame:CGRectMake(codeTextField.right-40, codeTextField.top, 20, 30)];
    [self.view addSubview:maskView];
    
    codeButton = [[WWCodeButton alloc]initWithFrame:CGRectMake(codeTextField.right+3, codeTextField.top, 75, 30)];
     NSLog(@"%f",codeTextField.right-30);
    [codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    codeButton.backgroundColor = [WWTolls colorWithHexString:@"f2e8dc"];
    [codeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    codeButton.titleLabel.font = MyFont(12);
    codeButton.layer.cornerRadius = 5;
    [codeButton addTarget:self action:@selector(getCodeSender) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:codeButton];
    [codeButton startTimerNmu];//首先开启倒计时
    [self showAlertMsg:@"验证码已经发送" andFrame:CGRectMake(70,100,200,60)];
}

-(void)getCodeSender{
    [codeButton startTimerNmu];
    urlString =[NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_URLREQUEST_GETCODE];
    self.showCodeLabel.text = [NSString stringWithFormat:@"验证码已经发送到      %@",self.phoneNumber];
    [self operationManagerRequest];
}

-(void)popButton{
    [codeButton stopTimer];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)createGame{
    long long code = [self.verifyCode longLongValue];
    long long Value = (code-1126L-0126L)/9299L;
    if ([codeTextField.text isEqualToString:[NSString stringWithFormat:@"%lld",Value]]) {
        [self operationManagerRequest:nil parameter:nil];
    }
    else{
        [self showAlertMsg:@"请输入验证码" andFrame:CGRectMake(70,100,200,60)];
    }
}

/******************************
 * -----微信登录获取验证码------
 *///**************************
-(void)operationManagerRequest{
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:4];
//    [dictionary setObject:@"0" forKey:@"logintype"];
    [dictionary setObject:self.phoneNumber forKey:@"userid"];
    NSString * keyString = [self.phoneNumber stringByAppendingString:ZDS_M_PI];
    NSString * keyStringMD5 = [WWTolls md5:keyString];
    [dictionary setObject:keyStringMD5 forKey:@"key"];
//    [dictionary setObject:[WWTolls getkeyChain] forKey:@"deviceid"];
//    [dictionary setObject:self.openid forKey:@"openid"];
    if (!phoneCode) {
        [dictionary setObject:@"meiyouyanzhengma" forKey:@"vcode"];
    }else{
        [dictionary setObject:phoneCode forKey:@"vcode"];
    }
     NSLog(@"%@",dictionary);
    __weak typeof(self)weakSelf = self;
    
    [WWRequestOperationEngine operationManagerRequest_Post:urlString parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        if (dic.count>0) {
            weakSelf.verifyCode = [dic objectForKey:@"vcode"];
            NSLog(@"dic*****************%@,%@",[dic objectForKey:@"vcode"],phoneCode);
        }else{
            
        }
        
    }];
//    
//    [manager POST:urlString parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        __strong typeof(weakSelf)strongSelf = weakSelf;
//        NSLog(@"%@",responseObject);
//        NSDictionary *dic = [operation.responseString objectFromJSONString];
//        strongSelf.verifyCode = [dic objectForKey:@"vcode"];
//        NSLog(@"dic*****************%@,%@",[dic objectForKey:@"vcode"],phoneCode);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"------------------%@",error);
//        NSDictionary *dic = [operation.responseString objectFromJSONString];
//        phoneCode = [dic objectForKey:@"vcode"];
//        NSLog(@"*****************%@",dic);
//    }];
}

//..获取验证码信息之后（肯定未注册）进行微信注册登录..//
-(void)operationManagerRequest:(NSString*)string parameter:(NSMutableDictionary*)para{

    id userModelInfo=[NSUSER_Defaults objectForKey:ZDS_USERDEFAULT_SYSTEM_SETTING_KEY_USER_MODEL_INFO];
    NSLog(@"%@",userModelInfo);
    UserModel *user=[[UserModel alloc]init];
    if (userModelInfo&&[userModelInfo isKindOfClass:[NSDictionary class]]) {
        [user restorePropertiesFromDictionary:userModelInfo];
    }

    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:3];

    [dictionary setObject:self.phoneNumber forKey:@"userid"];
    NSString * keyString = [self.phoneNumber stringByAppendingString:ZDS_M_PI];
    NSString * keyStringMD5 = [WWTolls md5:keyString];
    [dictionary setObject:keyStringMD5 forKey:@"key"];

    [dictionary setObject:@"0" forKey:@"registerstatus"];

    [dictionary setObject: self.phoneNumber forKey:@"phonenumber"];

    [dictionary setObject: [[NSUserDefaults standardUserDefaults] objectForKey:@"ZDS_UUID"] forKey:@"deviceid"];

    [dictionary setObject:@"0" forKey:@"logintype"];

    NSString *sexString = [NSString stringWithFormat:@"%u",user.sex];

    if (sexString.length!=0) {
        [dictionary setObject:sexString forKey:@"usersex"];
    }
    if (user.nickName.length!=0) {
          [dictionary setObject:user.nickName  forKey:@"username"];
    }
//    if (user.city.length!=0) {
//        [dictionary setObject:user.city  forKey:@"city"];
//    }
//    if (user.province.length!=0) {
//        [dictionary setObject:user.province  forKey:@"province"];
//    }
    if (user.unionid.length!=0) {
        [dictionary setObject:user.unionid  forKey:@"unionid"];
    }
    if(self.openid.length!=0){
        [dictionary setObject:self.openid  forKey:@"openid"];
    }
    if (user.headUrl.length!=0) {
        [dictionary setObject:user.headUrl forKey:@"headimgurl"];
    }

    __weak typeof(self)weakSelf = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSLog(@"%@",[NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_URLREQUEST_ATGV_POSTUSERDICTIONARY]);
    [manager POST:[NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_URLREQUEST_ATGV_POSTUSERDICTIONARY] parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        __strong typeof(weakSelf)strongSelf = weakSelf;
            NSDictionary *dictionary = [operation.responseString objectFromJSONString];
            NSLog(@"%@",dictionary);
            NSString *loginstatus = [dictionary objectForKey:@"loginstatus"];
            //..把接收到的手机号存储起来..//
            NSString *phoneStr = [dictionary objectForKey:@"userid"];
            UserModel *user=[[UserModel alloc]init];
            user.userID = phoneStr;
            [NSUSER_Defaults setObject:user.userID forKey:ZDS_USERID];
            //..把key也储存起来..//
            [NSUSER_Defaults synchronize];
            if ([loginstatus intValue]==1) {//登录成功
                MainViewController *mainController = [[MainViewController alloc]initWithNibName:@"MainViewController" bundle:nil];
                [weakSelf.navigationController pushViewController:mainController animated:YES];
            }
            else if ([loginstatus intValue]==2){
                [weakSelf showAlertMsg:@"该手机号已被绑定" andFrame:CGRectMake(70,100,200,60)];
            }
            else{
                [weakSelf showAlertMsg:@"登录发生异常" andFrame:CGRectMake(70,100,200,60)];
            }

} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//    __strong typeof(weakSelf)strongSelf = weakSelf;
    [weakSelf showAlertMsg:@"登录发生异常" andFrame:CGRectMake(70,100,200,60)];
     NSLog(@"%@",error);
}];

//    [manager POST:[NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_URLREQUEST_ATGV_POSTUSERDICTIONARY] parameters:dictionary constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
////        NSLog(@"%@",self.phoneNumber);
////        //返回注册状态：(2、微信没有注册过,3、微信号注册过,0、手机没注册,1、手机号注册过)
////        [formData appendPartWithFormData:[@"2" dataUsingEncoding:NSUTF8StringEncoding] name:@"registerstatus"];
////        [formData appendPartWithFormData:[self.phoneNumber dataUsingEncoding:NSUTF8StringEncoding] name:@"phonenumber"];
////        [formData appendPartWithFormData:[[WWTolls getkeyChain] dataUsingEncoding:NSUTF8StringEncoding] name:@"deviceid"];
////        if (user.nickName.length!=0) {
////           [formData appendPartWithFormData:[user.nickName  dataUsingEncoding:NSUTF8StringEncoding] name:@"username"];
////        }
////        //登录方式:(0、手机号,1微信)
////        [formData appendPartWithFormData:[@"1"  dataUsingEncoding:NSUTF8StringEncoding] name:@"logintype"];
////        NSString *sexString = [NSString stringWithFormat:@"%u",user.sex];
////        if (sexString.length!=0) {
////            [formData appendPartWithFormData:[sexString  dataUsingEncoding:NSUTF8StringEncoding] name:@"usersex"];
////        }
////        if (user.city.length!=0) {
////            [formData appendPartWithFormData:[user.city  dataUsingEncoding:NSUTF8StringEncoding] name:@"city"];
////        }
////        if (user.country.length!=0) {
////            [formData appendPartWithFormData:[user.country  dataUsingEncoding:NSUTF8StringEncoding] name:@"country"];
////        }
////        if (user.province.length!=0) {
////            [formData appendPartWithFormData:[user.province  dataUsingEncoding:NSUTF8StringEncoding] name:@"province"];
////        }
////        if (user.unionid.length!=0) {
////            [formData appendPartWithFormData:[user.unionid dataUsingEncoding:NSUTF8StringEncoding] name:@"unionid"];
////        }
////        NSLog(@"self.openid---------%@",self.openid);
////        if(self.openid.length!=0){
////            [formData appendPartWithFormData:[self.openid  dataUsingEncoding:NSUTF8StringEncoding] name:@"openid"];
////        }
////        if (user.headUrl.length!=0) {
////            [formData appendPartWithFormData:[user.headUrl  dataUsingEncoding:NSUTF8StringEncoding] name:@"headimgurl"];
////        }
//
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        //    NSDictionary *dictionary =  [responseObject objectFromJSONString];
//
//        NSDictionary *dictionary = [operation.responseString objectFromJSONString];
//        NSLog(@"%@",dictionary);
//        NSString *loginstatus = [dictionary objectForKey:@"loginstatus"];
//        //..把接收到的手机号存储起来..//
//        NSString *phoneStr = [dictionary objectForKey:@"phonenumber"];
//        UserModel *user=[[UserModel alloc]init];
//        user.userID = phoneStr;
//        [NSUSER_Defaults setObject:user.userID forKey:@"userPhoneNumber"];
//        [NSUSER_Defaults synchronize];
//        if ([loginstatus intValue]==1) {//登录成功
//            MainViewController *mainController = [[MainViewController alloc]initWithNibName:@"MainViewController" bundle:nil];
//            [self.navigationController pushViewController:mainController animated:YES];
//        }
//        else if ([loginstatus intValue]==2){
//            [self showAlertMsg:@"该手机号已被绑定" andFrame:CGRectMake(70,100,200,60)];
//        }
//        else{
//            [self showAlertMsg:@"登录发生异常" andFrame:CGRectMake(70,100,200,60)];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [self showAlertMsg:@"登录发生异常" andFrame:CGRectMake(70,100,200,60)];
//         NSLog(@"%@",error);
//    }];
//
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

    if ([toBeString length] > 10) { //如果输入框内容大于10则弹出警告
        [[GlobalUse shareGlobal]showTextHud:@"内容不能超过10个字" inView:textField.superview];
        return NO;
    }
    if ([toBeString isEqualToString:@" "]) {
        [[GlobalUse shareGlobal]showInfoHud:@"验证码不允许输入空格!" inView:textField.superview];
        return NO;
    }

    return YES;

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
