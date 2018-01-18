//
//  AppDelegate.m
//  zhidoushi
//
//  Created by xiang on 14-9-10.
//  Copyright (c) 2014年 zhidoushi.com. All rights reserved.
//

#import "WWTolls.h"
#import "AppDelegate.h"
#import "WQPlaySound.h"
#import "UIColor+VNHex.h"
#import "MMDrawerController.h"
#import "InitViewController.h"
#import "GameViewController.h"
#import "LoginViewController.h"
#import "WelcomeViewController.h"
#import "XLNavigationController.h"
//..private..//
#import "GlobalUse.h"
#import "WeiXinEngine.h"
#import "NSDictionary+NARSafeDictionary.h"
#import "NSObject+NARSerializationCategory.h"
//..微信API..//
#import "WXApi.h"
//..netWork..//
#import "Reachability.h"
#import "JSONKit.h"
//****//
#import "ContactViewController.h"
#import "XTabBar.h"
//umeng
#import "MobClick.h"
#import "WWRequestOperationEngine.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocial.h"
#import "SensitiveTool.h"
//新浪原生
#import "WeiboSDK.h"

//启动停止调用类
#import "SASManager.h"
#import "KeyWindow.h"
#import "commentViewController.h"
#import "ChatListViewController.h"
#import "GroupHappyViewController.h"

#import <TuSDKGeeV1/TuSDKGeeV1.h>
@interface AppDelegate ()<WXApiDelegate,GexinSdkDelegate,WeiboSDKDelegate>
{
    UIImageView *zView;//Z图片ImageView
    UIImageView *fView;//F图片ImageView
    UIView *rView;//图片的UIView
    NSString *Token;//苹果推送标识
    
}

@property(nonatomic,strong)WQPlaySound *sound;
@property (nonatomic,retain) NSString *Token;

@end
static NSInteger msgidNumber = 0;

@implementation AppDelegate

@synthesize window = _window;

@synthesize gexinPusher = _gexinPusher;
@synthesize appKey = _appKey;
@synthesize appSecret = _appSecret;
@synthesize appID = _appID;
@synthesize clientId = _clientId;
@synthesize sdkStatus = _sdkStatus;
@synthesize lastPayloadIndex = _lastPaylodIndex;
@synthesize payloadId = _payloadId;

#define UMENG_APPKEY @"545c333cfd98c526c6004b5f"

- (void)umengTrack {
    //    [MobClick setCrashReportEnabled:NO]; // 如果不需要捕捉异常，注释掉此行
    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    //
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) REALTIME channelId:nil];
    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
    
    //      [MobClick checkUpdate];   //自动更新检查, 如果需要自定义更新请使用下面的方法,需要接收一个(NSDictionary *)appInfo的参数
    //    [MobClick checkUpdateWithDelegate:self selector:@selector(updateMethod:)];
    
    [MobClick updateOnlineConfig];  //在线参数配置
    [UMSocialData setAppKey:UMENG_APPKEY];
    //新浪
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/tencent2/callback"];
    //qq
    [UMSocialQQHandler setQQWithAppId:@"1104524335" appKey:@"HuwXqSaGp3frex2I" url:@"http://www.zhidoushi.com/"];
    //    1.6.8之前的初始化方法
    //    [MobClick setDelegate:self reportPolicy:REALTIME];  //建议使用新方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
    
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if ([url.absoluteString rangeOfString:@"sina."].length>0) {//新浪友盟
        return  [UMSocialSnsService handleOpenURL:url];
    } else if ([url.absoluteString rangeOfString:@"wb."].length > 0) {//新浪原生
        return [WeiboSDK handleOpenURL:url delegate:self];
    } else{//微信
        return [WXApi handleOpenURL:url delegate:self];
    }
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{   
    if ([url.absoluteString rangeOfString:@"sina."].length>0) {//新浪
        return  [UMSocialSnsService handleOpenURL:url];
    } else if ([url.absoluteString hasPrefix:@"wb"]) {//新浪原生
        return [WeiboSDK handleOpenURL:url delegate:self];
    } else{//微信
        return [WXApi handleOpenURL:url delegate:self];
    }
}
- (void)onlineConfigCallBack:(NSNotification *)note {
    
    NSLog(@"online config has fininshed and note = %@", note.userInfo);
}

//程序内跳转 [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://m.kimiss.com"]];

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //涂图初始化
    [TuSDK initSdkWithAppKey:@"bd361c6eeb3f3b29-02-hxh6o1"];
    [TuSDK setLogLevel:lsqLogLevelDEBUG];

//    友盟初始化
    [self umengTrack];
    if ([NSUSER_Defaults objectForKey:@"newmsgid"]) {
        msgidNumber = [[NSUSER_Defaults objectForKey:@"newmsgid"] intValue];
    }
    
    
    //未激活状态下的推送通知
    //是否由推送通知调用
    //点击通知调用此方法
    if (launchOptions) {
        NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        [MobClick event:@"AppleCenterClick"];//通知中心点击统计
        /*if (userInfo) {
            
            NSString *payloadMsg = [userInfo objectForKey:@"payload"];
            
            //声音
            NSDictionary *aps = [userInfo objectForKey:@"aps"];
            _sound = [[WQPlaySound alloc]initForPlayingSoundEffectWith:aps[@"sound"]];
            [_sound play];
            [self performSelector:@selector(soundSender) withObject:nil afterDelay:1];
            
            NSDictionary *postDictionary = [self JSONValue:payloadMsg];
            switch ([[postDictionary objectForKeySafe:@"pushtype"] intValue]) {
                case 1://新浪好友
                case 2://微博好友
                {
                    break;
                }
                case 3://点赞
                case 4://团聊回复
                case 11://撒欢评论
                {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"myAppBeginWithTongZhi" object:@"1"];
                    });
                }
                    break;
                case 7://发起私信
                {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"myAppBeginWithTongZhi" object:[postDictionary objectForKeySafe:@"2"]];
                    });
                }
                    break;
                case 5://邀请朋友
                case 6://每日提示
                case 8://参加活动
                case 9://活动评论
                case 10://打招呼捏一下
                case 12://催团长发任务
                case 13://团长群发通知
                case 14://发布团组任务
                case 15://团组通
                case 16://新粉丝
                {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"myAppBeginWithTongZhi" object:nil];
                    });
                }
                default:
                    break;
            }
        }*/
    }else if([UIApplication sharedApplication].applicationIconBadgeNumber != 0){//直接打开,有团组通知
        
        [NSUSER_Defaults setObject:@"justdoit" forKey:@"everyNotification"];
        if ([NSUSER_Defaults objectForKey:@"newmsgid"]==nil) {
            msgidNumber = 0;
        }
        msgidNumber++;
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [NSUSER_Defaults setObject:[NSString stringWithFormat:@"%ld",(long)msgidNumber] forKey:@"newmsgid"];
        [NSUSER_Defaults synchronize];
    }
    
    self.window = [[KeyWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //..初始化根视图..//
    [self chooseRootviewController:NO];
    
    //************向微信注册*************//
    [WXApi registerApp:kWXAPP_ID withDescription:@"脂斗士"];
    
    //新浪
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:Sina_AppKey];
    
    // [1]:使用APPID/APPKEY/APPSECRENT创建个推实例
    if (![[NSUSER_Defaults objectForKey:ZDS_INFORMATIONSTAGE]isEqualToString:@"110"]) {

        [self startSdkWith:kAppId appKey:kAppKey appSecret:kAppSecret];
        // [2]:注册APNS
        [self registerRemoteNotification];

    }
    // [2-EXT]: 获取启动时收到的APN
    //启动app打点
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [SASManager startApp];
        [SensitiveTool updateSensitiveWords];
    });
    
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    return YES;
}

-(void)getClientidAgain{
    [self startSdkWith:kAppId appKey:kAppKey appSecret:kAppSecret];
}

#pragma mark - WeiboSDKDelegate
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    
    if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
        [[UIApplication sharedApplication].keyWindow.rootViewController showAlertMsg:@"分享成功" yOffset:0];
    }
    
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {   
        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
        NSString* accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
        if (accessToken)
        {
            self.wbtoken = accessToken;
        }
        NSString* userID = [sendMessageToWeiboResponse.authResponse userID];
        if (userID) {
            self.wbCurrentUserID = userID;
        }
    }
}   

-(void)onResp:(BaseReq *)resp{
    /***********************************************************
     1.ErrCode
     ERR_OK = 0(用户同意)
     ERR_AUTH_DENIED = -4（用户拒绝授权）
     ERR_USER_CANCEL = -2（用户取消）
     2.code
     用户换取access_token的code，仅在ErrCode为0时有效
     3.state
     第三方程序发送时用来标识其请求的唯一性的标志，由第三方程序调用sendReq时传入，由微信终端回传，state字符串长度不能超过1K
     4.lang
     微信客户端当前语言
     5.country
     微信用户当前国家信息
     *///*********************************************************
    SendAuthResp *aresp = (SendAuthResp *)resp;
    
    if (aresp.errCode== 0)
    {
//        [self.window.rootViewController showWaitView];
        if (![NSUSER_Defaults objectForKey:ZDS_WEIXINJUDGE]) {
            [WeiXinEngine getAccess_token:aresp.code];
        }
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"loginFail" object:nil];
    }
}

- (void)registerRemoteNotification
{
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
}

- (NSString *)currentLogFilePath
{   
    NSMutableArray * listing = [NSMutableArray array];
    NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray * fileNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:docsDirectory error:nil];
    if (!fileNames) {
        return nil;
    }

    for (NSString * file in fileNames) {
        if (![file hasPrefix:@"_log_"]) {
            continue;
        }

        NSString * absPath = [docsDirectory stringByAppendingPathComponent:file];
        BOOL isDir = NO;
        if ([[NSFileManager defaultManager] fileExistsAtPath:absPath isDirectory:&isDir]) {
            if (isDir) {
                [listing addObject:absPath];
            } else {
                [listing addObject:absPath];
            }
        }
    }
    
    [listing sortUsingComparator:^(NSString *l, NSString *r) {
        return [l compare:r];
    }];

    if (listing.count) {
        return [listing objectAtIndex:listing.count - 1];
    }

    return nil;
}

- (void) playSoundEffect
{
     _sound = [[WQPlaySound alloc]initForPlayingSoundEffectWith:@"Zhidoushi_demo.mp3"];
    [_sound play];
    [self performSelector:@selector(soundSender) withObject:nil afterDelay:3];
}

-(void)soundSender{
    
    [_sound stop];
}

-(void)configureInitViewController:(BOOL)isTongzhi{
    if ([NSUSER_Defaults objectForKey:ZDS_USERID] != nil) {
        LoginViewController *login = [[LoginViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
        login.navigationItem.title = @"进入脂斗士";
        //[login.navigationController setNavigationBarHidden:YES];
        [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_640_98"] forBarMetrics:UIBarMetricsDefault];
        login.navigationController.navigationBar.tintColor = [UIColor greenColor];
        self.window.rootViewController = nav;
    }else{
        InitViewController *initViewController = [[InitViewController alloc]init];
        XLNavigationController *navi = [[XLNavigationController alloc]initWithRootViewController:initViewController];
        self.window.rootViewController = navi;
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"%@",deviceToken);
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
//    [_deviceToken release];
    _deviceToken = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (_deviceToken.length!=0) {
        [self setDeviceToken:_deviceToken];
        if ([NSUSER_Defaults objectForKey:ZDS_USERID]!=nil) {
            if ([NSUSER_Defaults objectForKey:ZDS_DEVICETOKEN]==nil||[[NSUSER_Defaults objectForKey:ZDS_DEVICETOKEN] isEqualToString:@"0"]||![_deviceToken isEqualToString:[NSUSER_Defaults objectForKey:ZDS_DEVICETOKEN]]) {
                NSString *userID =  [NSUSER_Defaults objectForKey:ZDS_USERID];
                NSLog(@"用户ID__________%@",userID);
                NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:2];
                [dictionary setObject:_deviceToken forKey:@"deviceid"];
                //..给服务器发送状态..//
                [WWRequestOperationEngine operationManagerRequest_Post:[NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_UPDATEDEVICEIDCLIENTID] parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
                    
                }];
            }
        }
        [[NSUserDefaults standardUserDefaults]setObject:_deviceToken forKey:ZDS_DEVICETOKEN];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        [self.window.rootViewController showAlertMsg:@"登录失败，请重试" andFrame:CGRectZero];
        return;
    }

    NSLog(@"deviceToken:%@", _deviceToken);

    // [3]:向个推服务器注册deviceToken
    if (_gexinPusher) {
        [_gexinPusher registerDeviceToken:_deviceToken];
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
//    [self registerRemoteNotification];
//    // [3-EXT]:如果APNS注册失败，通知个推服务器
    if (_gexinPusher) {
        [_gexinPusher registerDeviceToken:@""];
    }
}


// 接收到远程服务器推送过来的内容就会调用
// 注意: 只有应用程序是打开状态(前台/后台), 才会调用该方法
/// 如果应用程序是关闭状态会调用didFinishLaunchingWithOptions
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userinfo
{
    /*
     如果应用程序在后台 , 只有用户点击了通知之后才会调用
     如果应用程序在前台, 会直接调用该方法
     即便应用程序关闭也可以接收到远程通知
     */
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // [4-EXT]:处理APN
    NSString *payloadMsg = [userinfo objectForKey:@"payload"];
    NSString *record = [NSString stringWithFormat:@"[APN]%@, %@", [NSDate date], payloadMsg];
    NSLog(@"record*********%@",record);
    
    // [4-EXT]:处理APN
    
    NSDictionary *aps = [userinfo objectForKey:@"aps"];
    //声音
    _sound = [[WQPlaySound alloc]initForPlayingSoundEffectWith:aps[@"sound"]];
    [_sound play];
    [self performSelector:@selector(soundSender) withObject:nil afterDelay:1];


}


#pragma mark - 远程推送
//接收到远程服务器推送过来的内容就会调用
// ios7以后用这个处理后台任务接收到得远程通知
/*
 UIBackgroundFetchResultNewData, 成功接收到数据
 UIBackgroundFetchResultNoData, 没有;接收到数据
 UIBackgroundFetchResultFailed 接收失败
 后台锁屏状态接收到通知
 激活状态下调用
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    // [4-EXT]:处理APN
    /*
    NSString *payloadMsg = [userInfo objectForKey:@"payload"];

    NSDictionary *aps = [userInfo objectForKey:@"aps"];
    NSNumber *contentAvailable = aps == nil ? nil : [aps objectForKeyedSubscript:@"content-available"];

    NSString *record = [NSString stringWithFormat:@"[APN]%@, %@, [content-available: %@]", [NSDate date], payloadMsg, contentAvailable];
    NSLog(@"record*********%@",record);
    
    //声音
    _sound = [[WQPlaySound alloc]initForPlayingSoundEffectWith:aps[@"sound"]];
    [_sound play];
    [self performSelector:@selector(soundSender) withObject:nil afterDelay:1];
    
    NSDictionary *postDictionary = [self JSONValue:payloadMsg];
    switch ([[postDictionary objectForKeySafe:@"pushtype"] intValue]) {
        case 1://新浪好友
        case 2://微博好友
        {
            break;
        }
        case 3://点赞
        case 4://团聊回复
        case 11://撒欢评论
        {
            [((UINavigationController*)((UITabBarController*)self.window.rootViewController).selectedViewController) pushViewController:[[commentViewController alloc] init] animated:YES];
        }
            break;
        case 7://发起私信
        {
            [((UINavigationController*)((UITabBarController*)self.window.rootViewController).selectedViewController) pushViewController:[[ChatListViewController alloc] init] animated:YES];
        }
            break;
        case 5://邀请朋友
        case 6://每日提示
        case 8://参加活动
        case 9://活动评论
        case 10://打招呼捏一下
        case 12://催团长发任务
        case 13://团长群发通知
        case 14://发布团组任务
        case 15://团组通
        case 16://新粉丝
        {
            [((UITabBarController*)self.window.rootViewController) setSelectedIndex:2];
        }
        default:
            break;
    }
     */
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)startSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret
{
    if (!_gexinPusher) {
        _sdkStatus = SdkStatusStoped;

        self.appID = appID;
        self.appKey = appKey;
        self.appSecret = appSecret;

        _clientId = nil;

        NSError *err = nil;
        _gexinPusher = [GexinSdk createSdkWithAppId:_appID
                                             appKey:_appKey
                                          appSecret:_appSecret
                                         appVersion:@"0.0.0"
                                           delegate:self
                                              error:&err];
        if (!_gexinPusher) {
//            [_viewController logMsg:[NSString stringWithFormat:@"%@", [err localizedDescription]]];
        } else {
            _sdkStatus = SdkStatusStarting;
        }

//        [_viewController updateStatusView:self];
    }
}

- (void)stopSdk
{
    if (_gexinPusher) {
        [_gexinPusher destroy];
        _gexinPusher = nil;

        _sdkStatus = SdkStatusStoped;

        _clientId = nil;

//        [_viewController updateStatusView:self];
    }
}

- (BOOL)checkSdkInstance
{
    if (!_gexinPusher) {
        return NO;
    }
    return YES;
}

- (void)setDeviceToken:(NSString *)aToken
{
    if (![self checkSdkInstance]) {
        return;
    }

    [_gexinPusher registerDeviceToken:aToken];
}

- (BOOL)setTags:(NSArray *)aTags error:(NSError **)error
{
    if (![self checkSdkInstance]) {
        return NO;
    }

    return [_gexinPusher setTags:aTags];
}

- (NSString *)sendMessage:(NSData *)body error:(NSError **)error {
    if (![self checkSdkInstance]) {
        return nil;
    }
    return [_gexinPusher sendMessage:body error:error];
}

- (void)testSdkFunction
{
//    UIViewController *funcsView = [[TestFunctionController alloc] initWithNibName:@"TestFunctionController" bundle:nil];
//    [_naviController pushViewController:funcsView animated:YES];
//    [funcsView release];
}

- (void)testSendMessage
{
//    UIViewController *sendMessageView = [[SendMessageController alloc] initWithNibName:@"SendMessageController" bundle:nil];
//    [_naviController pushViewController:sendMessageView animated:YES];
//    [sendMessageView release];
}

#pragma mark - GexinSdkDelegate
- (void)GexinSdkDidRegisterClient:(NSString *)clientId
{
    // [4-EXT-1]: 个推SDK已注册
    _sdkStatus = SdkStatusStarted;
    NSLog(@"clientId**************%@",clientId);
    NSLog(@"useriID%@",[NSUSER_Defaults objectForKey:ZDS_USERID]);
    if ([NSUSER_Defaults objectForKey:ZDS_USERID]!=nil) {
        if ([NSUSER_Defaults objectForKey:ZDS_CLIENTID]==nil||[[NSUSER_Defaults objectForKey:ZDS_CLIENTID] isEqualToString:@"0"]||![clientId isEqualToString:[NSUSER_Defaults objectForKey:ZDS_CLIENTID]]) {
            NSString *userID =  [NSUSER_Defaults objectForKey:ZDS_USERID];
            NSLog(@"用户ID__________%@",userID);
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:2];
            [dictionary setObject:clientId forKey:@"clientid"];
            //..给服务器发送状态..//
            [WWRequestOperationEngine operationManagerRequest_Post:[NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_UPDATEDEVICEIDCLIENTID] parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
            }];
        }
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:clientId forKey:ZDS_CLIENTID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 收到个推消息
- (void)GexinSdkDidReceivePayload:(NSString *)payloadId fromApplication:(NSString *)appId
{
    
    // [4]: 收到个推消息

    NSData *payload = [_gexinPusher retrivePayloadById:payloadId];
    NSString *payloadMsg = nil;
    if (payload) {
        payloadMsg = [[NSString alloc] initWithBytes:payload.bytes
                                              length:payload.length
                                            encoding:NSUTF8StringEncoding];
        }


    NSDictionary *postDictionary = [self JSONValue:payloadMsg];

    NSLog(@"收到任意的消息******************%@",postDictionary);
    switch ([[postDictionary objectForKeySafe:@"pushtype"] intValue]) {
        case 1://新浪好友
        {
            NSString *s = [postDictionary objectForKey:@"newFriendPhones"];
            NSArray *temp = [s componentsSeparatedByString:@","];
            int num = 0;
            if ([NSUSER_Defaults objectForKey:@"newFriendPhones"] != nil) {
                num = [[NSUSER_Defaults objectForKey:@"newFriendPhones"] intValue];
            }
            num += temp.count;
            [NSUSER_Defaults setObject:[NSString stringWithFormat:@"%d",num] forKey:@"newFriendPhones"];
            [NSUSER_Defaults synchronize];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"newFriendPhones" object: [NSDictionary dictionaryWithObjectsAndKeys:[postDictionary objectForKeySafe:@"newFriendPhones"],@"newFriendPhones",nil]];
        }
            break;
        case 2://微博好友
        {
            //及时记录下新增朋友信息
            NSString *s = [postDictionary objectForKey:@"uids"];
            NSArray *temp = [s componentsSeparatedByString:@","];
            int num = 0;
            if ([NSUSER_Defaults objectForKey:@"newFriendSina"] != nil) {
                num = [[NSUSER_Defaults objectForKey:@"newFriendSina"] intValue];
            }
            num += temp.count;
            [NSUSER_Defaults setObject:[NSString stringWithFormat:@"%d",num] forKey:@"newFriendSina"];
            [NSUSER_Defaults synchronize];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"newFriendPhones" object: [NSDictionary dictionaryWithObjectsAndKeys:[postDictionary objectForKeySafe:@"uids"],@"newFriendPhones",nil]];
        }
            break;
        case 3://点赞
        case 4://团聊回复
        case 11://撒欢评论
        {
            [NSUSER_Defaults setObject:@"YES" forKey:@"tabbarreddian"];
            if ([NSUSER_Defaults objectForKey:@"inform"] == nil) {
                [NSUSER_Defaults setObject:@"1" forKey:@"inform"];
            }else{
                int s = [[NSUSER_Defaults objectForKey:@"inform"] intValue];
                s = s+1;
                [NSUSER_Defaults setObject:[NSString stringWithFormat:@"%d",s] forKey:@"inform"];
            }
            [NSUSER_Defaults synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"newinformation" object:nil];
        }
            break;
        case 7://发起私信
        {
            [NSUSER_Defaults setObject:@"YES" forKey:@"tabbarreddian"];
            if([[postDictionary objectForKey:@"rcvuserid"] isEqualToString:[NSUSER_Defaults objectForKey:ZDS_USERID]]){
                NSMutableDictionary *dict =[NSMutableDictionary dictionaryWithDictionary:[NSUSER_Defaults objectForKey:@"newMessage"]];
                if(dict.count == 0){
                    dict = [NSMutableDictionary dictionary];
                }
                int sum = 0;
                if (dict[[postDictionary objectForKeySafe:@"snduserid"]]!=nil) {
                    sum = [dict[[postDictionary objectForKeySafe:@"snduserid"]] intValue] +1;
                }else{
                    sum = 1;
                }
                [dict setObject:[NSString stringWithFormat:@"%d",sum] forKey:[postDictionary objectForKeySafe:@"snduserid"]];
                [NSUSER_Defaults setObject:dict forKey:@"newMessage"];
                [NSUSER_Defaults setObject:@"YES" forKey:@"messagechatred"];
                [NSUSER_Defaults synchronize];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"newmessage" object:postDictionary[@"snduserid"]];
            }
        }
            break;
        case 5://邀请朋友
        case 6://每日提示
        case 8://参加活动
        case 9://活动评论
        case 10://打招呼捏一下
        case 12://催团长发任务
        case 13://团长群发通知
        case 14://发布团组任务
        case 15://团组通知
        {
            [NSUSER_Defaults setObject:@"YES" forKey:@"tabbarreddian"];
            [NSUSER_Defaults setObject:@"YES" forKey:@"groupinform"];
            [NSUSER_Defaults synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"newinformation" object:nil];
        }
            break;
        case 16://新粉丝
        {
            [NSUSER_Defaults setObject:@"YES" forKey:@"tabbarreddian"];
            if (![[NSUSER_Defaults objectForKey:@"flwsum"] isKindOfClass:[NSDictionary class]]) {
                [NSUSER_Defaults setObject:[NSDictionary dictionary] forKey:@"flwsum"];
            }
            NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:[NSUSER_Defaults objectForKey:@"flwsum"]];
            [temp setObject:@"YES" forKey:postDictionary[@"flwid" ]];
            [NSUSER_Defaults setObject:temp forKey:@"flwsum"];
            [NSUSER_Defaults synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"newinformation" object:nil];
        }
            break;
        case 17://周记
        {
            [NSUSER_Defaults setObject:@"YES" forKey:@"weekreddian"];
            [NSUSER_Defaults setObject:@"YES" forKey:@"tabbarreddian"];
            [NSUSER_Defaults setObject:@"YES" forKey:@"groupinform"];
            [NSUSER_Defaults synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"newinformation" object:nil];
        }
            break;
        case 18://打卡唤醒
        {
            [NSUSER_Defaults setObject:@"YES" forKey:@"tabbarreddian"];
            [NSUSER_Defaults setObject:@"YES" forKey:@"groupinform"];
            [NSUSER_Defaults synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"newinformation" object:nil];
        }
            break;
        default:
            break;
    }
    
    
/**
    if ([postDictionary objectForKeySafe:@"newFriendPhones"]) {//***收到新朋友信息
        //及时记录下新增朋友信息
        NSString *s = [postDictionary objectForKey:@"newFriendPhones"];
        NSArray *temp = [s componentsSeparatedByString:@","];
        int num = 0;
        if ([NSUSER_Defaults objectForKey:@"newFriendPhones"] != nil) {
            num = [[NSUSER_Defaults objectForKey:@"newFriendPhones"] intValue];
        }
        num += temp.count;
        [NSUSER_Defaults setObject:[NSString stringWithFormat:@"%d",num] forKey:@"newFriendPhones"];
        [NSUSER_Defaults synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newFriendPhones" object: [NSDictionary dictionaryWithObjectsAndKeys:[postDictionary objectForKeySafe:@"newFriendPhones"],@"newFriendPhones",nil]];
    }else if ([[postDictionary objectForKeySafe:@"pushtype"] isEqualToString:@"2"]) {//***收到新朋友信息
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newFriendPhones" object:nil];
        
        //及时记录下新增朋友信息
        NSString *s = [postDictionary objectForKey:@"uids"];
        NSArray *temp = [s componentsSeparatedByString:@","];
        int num = 0;
        if ([NSUSER_Defaults objectForKey:@"newFriendSina"] != nil) {
            num = [[NSUSER_Defaults objectForKey:@"newFriendSina"] intValue];
        }
        num += temp.count;
        [NSUSER_Defaults setObject:[NSString stringWithFormat:@"%d",num] forKey:@"newFriendSina"];
        [NSUSER_Defaults synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newFriendPhones" object: [NSDictionary dictionaryWithObjectsAndKeys:[postDictionary objectForKeySafe:@"uids"],@"newFriendPhones",nil]];
    }else{
        [NSUSER_Defaults setObject:@"YES" forKey:@"tabbarreddian"];
        [NSUSER_Defaults synchronize];
        if ([postDictionary objectForKeySafe:@"letterid"]) {//***收到私信信息
            NSLog(@"***收到私信信息***,%@",[postDictionary objectForKeySafe:@"letterid"]);
            if([[postDictionary objectForKey:@"rcvuserid"] isEqualToString:[NSUSER_Defaults objectForKey:ZDS_USERID]]){
                NSMutableDictionary *dict =[NSMutableDictionary dictionaryWithDictionary:[NSUSER_Defaults objectForKey:@"newMessage"]];
                if(dict.count == 0){
                    dict = [NSMutableDictionary dictionary];
                }
                int sum = 0;
                if (dict[[postDictionary objectForKeySafe:@"snduserid"]]!=nil) {
                    sum = [dict[[postDictionary objectForKeySafe:@"snduserid"]] intValue] +1;
                }else{
                    sum = 1;
                }
                [dict setObject:[NSString stringWithFormat:@"%d",sum] forKey:[postDictionary objectForKeySafe:@"snduserid"]];
                [NSUSER_Defaults setObject:dict forKey:@"newMessage"];
                [NSUSER_Defaults setObject:@"YES" forKey:@"messagechatred"];
                [NSUSER_Defaults synchronize];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"newmessage" object:postDictionary[@"snduserid"]];
            }
            
        }else{
            if ([postDictionary objectForKeySafe:@"flwid"]) {//关注

                if (![[NSUSER_Defaults objectForKey:@"flwsum"] isKindOfClass:[NSDictionary class]]) {
                    [NSUSER_Defaults setObject:[NSDictionary dictionary] forKey:@"flwsum"];
                }
                NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:[NSUSER_Defaults objectForKey:@"flwsum"]];
                [temp setObject:@"YES" forKey:postDictionary[@"flwid" ]];
                [NSUSER_Defaults setObject:temp forKey:@"flwsum"];
                [NSUSER_Defaults synchronize];
            }else if([postDictionary objectForKeySafe:@"helloid"]){//捏一下
                [NSUSER_Defaults setObject:@"YES" forKey:@"groupinform"];
                [NSUSER_Defaults synchronize];
            }else if([postDictionary objectForKeySafe:@"msgid"]){//团组通知
                [NSUSER_Defaults setObject:@"YES" forKey:@"groupinform"];
                [NSUSER_Defaults synchronize];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"newinformation" object:nil];
            } else{//通知
                if ([NSUSER_Defaults objectForKey:@"inform"] == nil) {
                    [NSUSER_Defaults setObject:@"1" forKey:@"inform"];
                }else{
                    int s = [[NSUSER_Defaults objectForKey:@"inform"] intValue];
                    s = s+1;
                    [NSUSER_Defaults setObject:[NSString stringWithFormat:@"%d",s] forKey:@"inform"];
                }
                [NSUSER_Defaults synchronize];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"newinformation" object:nil];
        }
    }
    **/
}

- (void)GexinSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // [4-EXT]:发送上行消息结果反馈
    NSString *record = [NSString stringWithFormat:@"Received sendmessage:%@ result:%d", messageId, result];
     NSLog(@"发送上行消息结果反馈***********%@",record);
//    [_viewController logMsg:record];
}

//************判断是否跳转新特性页面**********/
- (void)chooseRootviewController:(BOOL)isTongzhi
{
    // 判断应用显示新特性还是欢迎界面
    // 1.获取沙盒中的版本号
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *key = @"CFBundleShortVersionString";
//    NSString *sandboxVersion = [defaults objectForKey:key];
//    
//    // 2.获取软件当前的版本号
//    NSDictionary *dict = [NSBundle mainBundle].infoDictionary;
//    NSString *currentVersion = dict[key];
//    
//    // 3.比较沙盒中的版本号和软件当前的版本号
//    if([currentVersion compare:sandboxVersion] == NSOrderedDescending )
//    {
//        self.window.rootViewController = [[WelcomeViewController alloc] init];
//        
//    }else
//    {
        [self configureInitViewController:isTongzhi];
//    }
}

- (void)GexinSdkDidOccurError:(NSError *)error
{
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    
//    [_viewController logMsg:[NSString stringWithFormat:@">>>[GexinSdk error]:%@", [error localizedDescription]]];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

#pragma mark 进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [SASManager stopApp];
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //初始化通讯录并调取
    if ([NSUSER_Defaults objectForKey:ZDS_USERID]) {

        ContactViewController * contanct = [[ContactViewController alloc]init];
        [contanct readContacts];
        [contanct comparisonPhoneBook];
    }
}

#pragma mark 进入前台
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [SASManager startApp];
    if([application.keyWindow.rootViewController isKindOfClass:[UITabBarController class]]){
        UIViewController *cc = [((UINavigationController*)((UITabBarController*)application.keyWindow.rootViewController).selectedViewController).viewControllers lastObject];
        if ([cc isKindOfClass:[GroupHappyViewController class]]) {
            [cc.view setNeedsLayout];
        }
    }
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    //********* [EXT] 切后台关闭SDK，让SDK第一时间断线，让个推先用APN推送
    //收起键盘
    [self.window endEditing:YES];
    [self stopSdk];

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    x_isWifi=[[Reachability reachabilityForLocalWiFi]currentReachabilityStatus]!=NotReachable;
    x_isConnectToNetwork=[[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable;

    // [EXT] 重新上线
    if (![[NSUSER_Defaults objectForKey:ZDS_INFORMATIONSTAGE]isEqualToString:@"110"]) {

        [self startSdkWith:_appID appKey:_appKey appSecret:_appSecret];

    }
    
    if([UIApplication sharedApplication].applicationIconBadgeNumber != 0){//直接打开,有团组通知
        
        [NSUSER_Defaults setObject:@"justdoit" forKey:@"everyNotification"];
        if ([NSUSER_Defaults objectForKey:@"newmsgid"]==nil) {
            msgidNumber = 0;
        }else{
            msgidNumber = [[NSUSER_Defaults objectForKey:@"newmsgid"] intValue];
        }
        msgidNumber++;
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [NSUSER_Defaults setObject:[NSString stringWithFormat:@"%ld",(long)msgidNumber] forKey:@"newmsgid"];
        [NSUSER_Defaults synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newinformation" object:nil];
    }
    //***右上角数字清除***//
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
}
#pragma mark --app结束执行
- (void)applicationWillTerminate:(UIApplication *)application
{
    [self stopSdk];
    
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
//** * * *  是否只支持竖屏
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

-(id)JSONValue:(NSString*)string;
{
    if(!string || string.length<1) return nil;
    NSData* data = [string dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}
-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    [self stopSdk];
}
@end
