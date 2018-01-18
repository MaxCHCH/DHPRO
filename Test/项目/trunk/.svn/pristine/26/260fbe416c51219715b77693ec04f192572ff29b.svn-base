//
//  InitViewController.m
//  zhidoushi
//
//  Created by xinglei on 14-10-28.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#import "InitViewController.h"
#import "MainViewController.h"
#import "LoginViewController.h"
#import "WelcomeViewController.h"
#import "ContactViewController.h"
#import "XLNavigationController.h"
//..netWork..//
#import "Reachability.h"
//..private..//
#import "Define.h"
#import "WWTolls.h"
#import "GlobalUse.h"
#import "UserModel.h"
#import "NSObject+NARSerializationCategory.h"

@interface InitViewController ()<CLLocationManagerDelegate,MKMapViewDelegate>
{
    BOOL notFirstIn;//非第一次进入
    CLLocationManager *locationManager;
    MainViewController *mainViewController;
}

@property (retain, nonatomic) NSDictionary *pushInfoDictionary;//推送的信息

@end

@implementation InitViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [[[UIApplication sharedApplication]keyWindow]setUserInteractionEnabled:true];
    UIImageView *image = [[UIImageView alloc] initWithFrame:self.view.bounds];
    image.image = [UIImage imageNamed:@"LaunchImage-2"];
    [self.view addSubview:image];
    if (notFirstIn) {//起始为NO
//        [xlNavigationController pushViewController:mainViewController animated:false];
    }else{
        //请求更新
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self signSniffer];//网络监听

    //读取本地存储的用户信息
    id userModelInfo=[NSUSER_Defaults objectForKey:ZDS_USERDEFAULT_SYSTEM_SETTING_KEY_USER_MODEL_INFO];
     NSLog(@"读取本地存储的用户信息%@",userModelInfo);
    if (userModelInfo&&[userModelInfo isKindOfClass:[NSDictionary class]]) {
        UserModel *user=[[UserModel alloc]init];
        [user restorePropertiesFromDictionary:userModelInfo];
        [[GlobalUse shareGlobal]setUser:user];
         NSLog(@"是否已经登录------%d",x_isLogin);
    }

}

-(void)signSniffer{
    
    /* 注册网络状态监听 */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkNetworkStatus)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    [reach startNotifier];// * * 开启监听 * * //

//    if ([CLLocationManager locationServicesEnabled]) {
//        locationManager=[[CLLocationManager alloc]init];
//        locationManager.distanceFilter = kCLDistanceFilterNone;
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//        [locationManager setDelegate:self];
//    }
    //已不是第一次登陆
    notFirstIn=false;
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];

    NSString *userid = [NSUSER_Defaults objectForKey:ZDS_USERID];
    
    if (userid==nil)//如果没有登录
    {
        WelcomeViewController *wel = [[WelcomeViewController alloc] init];
        SHAREDAPPDELE.window.rootViewController = wel;

    }else{
        //        显示动画
        //        [[UIApplication sharedApplication]setStatusBarHidden:false];//是否显示状态栏
        
        MainViewController *mainController = [[MainViewController alloc]initWithNibName:@"MainViewController" bundle:nil];
        [self.navigationController pushViewController:mainController animated:YES];
    }
          //*******接驳数据*****//
//        SHRequestConfig *requestConfig=[[SHRequestConfig alloc]init];
//        [[SHURLConnection shareConnection]sendRequest:requestConfig delegate:self];
        
        notFirstIn=true;
        
        //检查推送打开的情况
//        [self performSelector:@selector(doRemotePushNotificationCheck) withObject:nil afterDelay:1];
        
        //做一些数据上的事
//        [self uploadCurrentLocation];
    
        if (!x_isConnectToNetwork) {
//            [[GlobalUse shareGlobal]showInfoHud:@"" inView:[[UIApplication sharedApplication]keyWindow]];
        }
//        [self tryToShowRater];//打印各种提示信息处
    [self checkTheLocalUnUploadPacket];
}

-(void)checkTheLocalUnUploadPacket{


}

#pragma mark networkchange
-(void)checkNetworkStatus{
    x_isWifi=[[Reachability reachabilityForLocalWiFi]currentReachabilityStatus]!=NotReachable;
    x_isConnectToNetwork=[[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable;
    if (x_isWifi) {
        [self checkTheLocalUnUploadPacket];
    }else{
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络状态" message:@"无网络连接请检查当前网络" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
//        [alert show];
//        [((AppDelegate*)[UIApplication sharedApplication].delegate).window.rootViewController showAlertMsg:@"无网络连接请检查当前网络" andFrame:CGRectZero];
//        [[GlobalUse shareGlobal]showInfoHud:@"无网络连接" inView:[[UIApplication sharedApplication] keyWindow]];
         NSLog(@"无网络连接");
    }
}
//
//-(void)doRemotePushNotificationCheck{
//    
//    if (!self.pushInfoDictionary) {
//        return;
//    }
//    
//    id typeObj=[self.pushInfoDictionary objectForKey:@"type"];
//    
//    if (typeObj&&[typeObj respondsToSelector:@selector(integerValue)]) {
//        
//        if([typeObj integerValue]==1){//如果是1，就是消息界面
//            if(x_isLogin){//如果是登录的
//                BOOL find=false;
//                UIViewController *viewController=nil;
//                for (long i=xlNavigationController.viewControllers.count-1; i>=0; i--) {
//                    viewController=xlNavigationController.viewControllers[i];
////                    if ([viewController isKindOfClass:[InformationCenterViewController class]]) {
////                        find=true;
////                        break;
////                    }
//                }
//                if (find&&viewController) {
//                    [xlNavigationController popToViewController:viewController animated:true];
//                }else{
////                    InformationCenterViewController * information = [[InformationCenterViewController alloc] initWithNibName:nil bundle:nil];
////                    [xlNavigationController pushViewController:information animated:YES];
//                }
//            }
//        }
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    // 删除通知对象
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"checkNetworkStatus" object:nil];
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
