//
//  SetupGameViewController.m
//  zhidoushi
//
//  Created by xinglei on 14/12/30.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "SetupGameViewController.h"

#import "GexinSdk.h"
//..private..//
#import "WWTolls.h"
//..netWork..//
#import "JSONKit.h"
#import "WWRequestOperationEngine.h"

#import "SDImageCache.h"
#import "Define.h"
#import "UserProtocolViewController.h"
#import "LoginViewController.h"
#import "MobClick.h"

#import "IQKeyboardManager.h"
#import "UserFeedBackViewContorller.h"
#import "UMSocial.h"
#import "WINetTool.h"
#import "SASManager.h"

@interface SetupGameViewController ()
@property (strong, nonatomic) GexinSdk *gexinPusher;
@property (weak, nonatomic) IBOutlet UILabel *publicWeChatNumber;
@property (weak, nonatomic) IBOutlet UIButton *publicRules;
@property (weak, nonatomic) IBOutlet UILabel *publicCompanyName;
@property (weak, nonatomic) IBOutlet UILabel *lblStatusInformation;
@property (weak, nonatomic) IBOutlet UISwitch *notiSwitch;

//私信开关状态
@property (nonatomic,strong) NSString *letterswh;

@property (weak, nonatomic) IBOutlet UIView *lastView;


@property (weak, nonatomic) IBOutlet UIView *notiBgView;

@property (weak, nonatomic) IBOutlet UIView *cacheBgView;
@property (weak, nonatomic) IBOutlet UIView *versionBgView;
@property (weak, nonatomic) IBOutlet UIView *commontBgView;
@property (weak, nonatomic) IBOutlet UIView *ideaBgView;

//关闭私信label
@property (weak, nonatomic) IBOutlet UILabel *closeLetterLabel;

// 通知开关的高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *notiViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cacheMargin;

@end

@implementation SetupGameViewController

#pragma mark - Life Cycle
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"设置页面"];
}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [MobClick beginLogPageView:@"设置页面"];
    self.titleLabel.text = [NSString stringWithFormat:@"设置"];
    self.titleLabel.textColor = ZDS_DHL_TITLE_COLOR;
    self.titleLabel.font = MyFont(18);
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"BarBtn_goBack_32_32"] forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = MyFont(11);
    [self.leftButton addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width = 16;
    labelRect.size.height = 16;
    labelRect.origin.x = 0;
    self.leftButton.frame = labelRect;


    if (iOS8) {
        if ([[UIApplication sharedApplication] isRegisteredForRemoteNotifications]) {//通知已经开启
            self.lblStatusInformation.text = @"已开启";
        }else{//通知已经关闭
            self.lblStatusInformation.text = @"已关闭";
        }
    }else{
        if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes]>0) {//通知已经开启
            self.lblStatusInformation.text = @"已开启";
        }else{//通知已经关闭
            self.lblStatusInformation.text = @"已关闭";
        }
    }
    
    //通知已开启
    if ([WWTolls notiEnable]) {
        
        if (![WINetTool isNetWork]) {
            [self hiddenSwich];
        } else {
            [self showSwitch];
            [self requestWithMyinfo];
        }
        
        
    } else { //通知已关闭
        
        [self hiddenSwich];
    }
}

-(void)backTo{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [(UIScrollView *)self.view setDelaysContentTouches:NO];
    
    if (iPhone4) {
        [(UIScrollView *)self.view setContentSize:CGSizeMake(SCREEN_WIDTH, self.lastView.maxY + 10)];
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
//    for (UIView *chridView in self.view.subviews) {
//        for (UIView *chridchridView in chridView.subviews) {
//            if (chridchridView.bounds.size.height == 1) {
//                chridchridView.frame = CGRectMake(chridchridView.frame.origin.x, chridchridView.frame.origin.y, chridchridView.frame.size.width, 0.5);
//                chridchridView.backgroundColor = [WWTolls colorWithHexString:@"#cccccc"];
//            }
//        }
//    }
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [WWTolls colorWithHexString:@"#eeeeee"];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    [self.levelButton setText:[NSString stringWithFormat:@"%@",currentVersion]];
    
    NSString * informationStageString =  [NSUSER_Defaults objectForKey:ZDS_INFORMATIONSTAGE];
    if ([informationStageString isEqualToString:@"112"] ) {
        [self.informationControlSwitch setOn:NO];
    }else{
        [self.informationControlSwitch setOn:YES];
    }
}

#pragma mark - Event Response
#pragma mark 关闭通知
- (IBAction)closeNoti:(id)sender {
    
    if (![WWTolls notiEnable]) {
        [self hiddenSwich];
    } else {
        NSString *letterswh = [sender isOn] ? @"0" : @"1";
        [self requestWithLetterswhWithLetterswh:letterswh];
    }
}   

#pragma mark - Private Methods

- (void)hiddenSwich {
    
    if (!self.notiBgView.hidden) {
        
        self.notiBgView.hidden = YES;
        
        // 修改通知开关的高度约束
        self.notiViewHeight.constant = 0;
        self.cacheMargin.constant = 0;
        
        self.cacheBgView.top -= 63;
        self.versionBgView.top -= 63;
        self.commontBgView.top -= 63;
        self.ideaBgView.top -= 63;
        self.lastView.top -= 63;
        
        if (iPhone4) {
            [(UIScrollView *)self.view setContentSize:CGSizeMake(SCREEN_WIDTH, self.lastView.maxY + 10)];
        }
        
    }
}

- (void)showSwitch {
    
    if (self.notiBgView.hidden) {
        
        self.notiBgView.hidden = NO;
        
        // 修改通知开关的高度约束
        self.notiViewHeight.constant = 53;
        self.cacheMargin.constant = 9;
        
        self.cacheBgView.top += 63;
        self.versionBgView.top += 63;
        self.commontBgView.top += 63;
        self.ideaBgView.top += 63;
        self.lastView.top += 63;
    }
}

#pragma mark 切换switch
/**
 *  切换switch
 *
 *  @param letterswh 0 开启  1 关闭
 */
- (void)swichWith:(NSString *)letterswh {
    if ([letterswh isEqualToString:@"0"]) {
        self.closeLetterLabel.text = @"已开启私信通知";
    } else {
        self.closeLetterLabel.text = @"已关闭私信通知";
    }
}

#pragma mark - Request
#pragma mark 开启和关闭私信通知开关
- (void)requestWithLetterswhWithLetterswh:(NSString *)letterswh {
    
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    /**
     *  0 开启
     *  1 关闭
     */
    [dictionary setObject:letterswh forKey:@"letterswh"];
    
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_LETTERSWH parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        //成功
        if ([dic[@"result"] isEqualToString:@"0"]) {
            [weakSelf swichWith:letterswh];
        } else {
            [weakSelf hiddenSwich];
        }
    }];
}

#pragma mark 个人信息
- (void)requestWithMyinfo {
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_GETMYINFO parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (dic[ERRCODE]) {
            [weakSelf hiddenSwich];
        }else{
            if ([dic[@"letterswh"] isEqualToString:@"1"]) {
                weakSelf.notiSwitch.on = NO;
            } else {
                weakSelf.notiSwitch.on = YES;
            }
        }
    }];
}

#pragma mark - end

- (IBAction)gotoProtocol:(id)sender {
    UserProtocolViewController *userProtocol = [[UserProtocolViewController alloc] init];
    [self.navigationController pushViewController:userProtocol animated:YES];
}

- (IBAction)informationSwitch:(id)sender {

    BOOL isButtonOn = [sender isOn];
    if (isButtonOn) {//开关开启

        [self openAPNSsender];
           }else {//开关关闭

               [self closeAPNSsender];
           }
}


-(void)closeAPNSsender
{
    SHAREDAPPDELE.stopSdk;
    [NSUSER_Defaults setObject:@"112" forKey:ZDS_INFORMATIONSTAGE];
    [NSUSER_Defaults synchronize];
    NSLog(@"推送关闭");
}

-(void)openAPNSsender
{
    // [1]:使用APPID/APPKEY/APPSECRENT创建个推实例
    [SHAREDAPPDELE startSdkWith:kAppId appKey:kAppKey appSecret:kAppSecret];
    [NSUSER_Defaults setObject:@"110" forKey:ZDS_INFORMATIONSTAGE];
    [NSUSER_Defaults synchronize];
    NSLog(@"推送开启");
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==88) {//清除缓存
        if (buttonIndex == 1) {
            [self.cacheButton setText:[NSString stringWithFormat:@"0M"]];
            [NSUSER_Defaults setObject:nil forKey:DISCOVER_COACHE_UESR];
            [NSUSER_Defaults setObject:nil forKey:DISCOVER_COACHE_ACTIVE];
            [NSUSER_Defaults setObject:nil forKey:GROUP_COACHE_CALENDAR];
            [NSUSER_Defaults setObject:nil forKey:@"discoverhottagcoache"];
            [NSUSER_Defaults setObject:nil forKey:@"discoverdatacoache"];
            [NSUSER_Defaults setObject:nil forKey:@"discovergroupmessagecoache"];
            NSFileManager *filemanage = [NSFileManager defaultManager];
            NSError *error;
            if([filemanage fileExistsAtPath:MYGAME_CACHE_PATH]) [filemanage removeItemAtPath:MYGAME_CACHE_PATH error:&error];
            if([filemanage fileExistsAtPath:MYGAME_GM_CACHE_PATH]) [filemanage removeItemAtPath:MYGAME_GM_CACHE_PATH error:&error];
            if([filemanage fileExistsAtPath:STORE_AD_CACHE_PATH]) [filemanage removeItemAtPath:STORE_AD_CACHE_PATH error:&error];
            if([filemanage fileExistsAtPath:GAME_RECORD_CACHE_PATH]) [filemanage removeItemAtPath:GAME_RECORD_CACHE_PATH error:&error];
            if([filemanage fileExistsAtPath:STORE_GOODS_CACHE_PATH]) [filemanage removeItemAtPath:STORE_GOODS_CACHE_PATH error:&error];
            if([filemanage fileExistsAtPath:USERINFO_CACHE_PATH]) [filemanage removeItemAtPath:USERINFO_CACHE_PATH error:&error];
            if([filemanage fileExistsAtPath:GAME_COACH_CACHE_PATH]) [filemanage removeItemAtPath:GAME_COACH_CACHE_PATH error:&error];
            if([filemanage fileExistsAtPath:GAME_RIGHTNOW_CACHE_PATH]) [filemanage removeItemAtPath:GAME_RIGHTNOW_CACHE_PATH error:&error];
            if([filemanage fileExistsAtPath:GAME_HOTGAME_CACHE_PATH]) [filemanage removeItemAtPath:GAME_HOTGAME_CACHE_PATH error:&error];
            [[SDImageCache sharedImageCache] clearMemory];
            [[SDImageCache sharedImageCache] clearDisk];
            //****依次去除各个本地字典*******//
            [WWTolls removePostList:MYINFORMATIN];
            [self showAlertMsg:@"缓存已清除" yOffset:0];
        }
    }else if(alertView.tag == 99){//安全退出
        if(buttonIndex == 1)
            [self logOffAction];
    }else if (alertView.tag==10000) {//检查更新
        
        if (buttonIndex==1) {
            
            NSURL *url = [NSURL URLWithString:ZDS_APPSTOREURL];//应用地址
            
            [[UIApplication sharedApplication]openURL:url];
            
        }
        
    }
}

#pragma mark - 清理缓存按钮
- (IBAction)cacheButton:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"清除缓存" message:@"是否确认清除缓存" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.tag = 88;
    [alert show];
}
#pragma mark - 版本按钮
- (IBAction)levelButton:(id)sender {
}

- (IBAction)fankui:(id)sender {
    UserFeedBackViewContorller *feed = [[UserFeedBackViewContorller alloc] init];
    [self.navigationController pushViewController:feed animated:YES];
}


#pragma mark - 去评分按钮（去往苹果商店评分）
- (IBAction)gradeButton:(id)sender {
    
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://itunes.apple.com/cn/app/id963050782"]];
}
#pragma mark - 安全退出按钮
- (IBAction)cancelButton:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注销登录" message:@"是否确认退出" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.tag = 99;
    [alert show];
    
}

#pragma mark - 注销登录
//..注销登录..//________________________________________//
- (void)logOffAction
{
    NSString *userID =  [NSUSER_Defaults objectForKey:ZDS_USERID];
    NSLog(@"用户ID__________%@",userID);
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:2];
    NSLog(@"________%@",dictionary);
    __weak typeof(self)weakSelf = self;
    [self showWaitView];
    //..给服务器发送状态..//
    [WWRequestOperationEngine operationManagerRequest_Post:[NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_USER_LOGOUT] parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        [self removeWaitView];
        if ([dic[@"logoutstatus"] isEqualToString:@"0"]) {
            [SASManager loginOut];
            [weakSelf showAlertMsg:@"退出成功" andFrame:CGRectMake(70,100,200,60)];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"outLgoin" object:nil];
            [NSUSER_Defaults setObject:nil forKey:@"newMessage"];
            [NSUSER_Defaults setObject:nil forKey:@"flwsum"];
            [NSUSER_Defaults setObject:nil forKey:@"inform"];
            [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina  completion:^(UMSocialResponseEntity *response){
                NSLog(@"response is %@",response);
            }];
            [NSUSER_Defaults removeObjectForKey:@"cacheChatList"];
            [NSUSER_Defaults setObject:nil forKey:@"newmsgid"];
            [NSUSER_Defaults setObject:nil forKey:@"newFriendSina"];
            [NSUSER_Defaults setObject:nil forKey:ZDS_USERID];
            [NSUSER_Defaults setObject:nil forKey:DISCOVER_COACHE_UESR];
            [NSUSER_Defaults setObject:nil forKey:GROUP_COACHE_CALENDAR];
            [NSUSER_Defaults setObject:nil forKey:DISCOVER_COACHE_ACTIVE];
            [NSUSER_Defaults setObject:nil forKey:@"discoverhottagcoache"];
            [NSUSER_Defaults setObject:nil forKey:@"discoverdatacoache"];
            [NSUSER_Defaults setObject:nil forKey:@"discovergroupmessagecoache"];
            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:ZDS_USERDEFAULT_SYSTEM_SETTING_KEY_USER_MODEL_INFO];
            [[NSUserDefaults standardUserDefaults]synchronize];
            double delayInSeconds = 0.4;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                //用户状态发生了变化
                //self.navigationController.tabBarController.selectedIndex = 5;
                LoginViewController *login = [[LoginViewController alloc] init];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
                login.navigationItem.title = @"进入脂斗士";
                //[login.navigationController setNavigationBarHidden:YES];
                [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_640_98"] forBarMetrics:UIBarMetricsDefault];
                login.navigationController.navigationBar.tintColor = [UIColor greenColor];
                weakSelf.view.window.transform = CGAffineTransformMakeTranslation(0,0);
                weakSelf.view.window.rootViewController = nav;
                [weakSelf.view.window makeKeyAndVisible];
                //跳转回登陆界面... ...
            });
        }
    }];

}





@end
