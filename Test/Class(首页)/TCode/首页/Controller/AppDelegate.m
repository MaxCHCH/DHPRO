//
//  AppDelegate.m
//  Test
//
//  Created by Rillakkuma on 16/6/1.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//
#define kUseScreenShotGesture 1

#import "showView.h"

#import "AppDelegate.h"
#import "BaseTabBarViewController.h"
#import "IQKeyboardManager.h"
#import "AppDelegate+DHCategory.h"

@interface AppDelegate ()
{
	BMKMapManager* _mapManager;
}

@end

@implementation AppDelegate

//- (BOOL)application:(UIApplication *)application
//			openURL:(NSURL *)url
//  sourceApplication:(NSString *)sourceApplication
//		 annotation:(id)annotation {
//	
//	if ([url.host isEqualToString:@"safepay"]) {
//		//跳转支付宝钱包进行支付，处理支付结果
//		[[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//			NSLog(@"result = %@",resultDic);
//		}];
//	 // 授权跳转支付宝钱包进行支付，处理支付结果
//		[[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
//			NSLog(@"result = %@",resultDic);
//			// 解析 auth code
//			NSString *result = resultDic[@"result"];
//			NSString *authCode = nil;
//			if (result.length>0) {
//				NSArray *resultArr = [result componentsSeparatedByString:@"&"];
//				for (NSString *subResult in resultArr) {
//					if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
//						authCode = [subResult substringFromIndex:10];
//						break;
//					}
//				}
//			}
//			NSLog(@"授权结果 authCode = %@", authCode?:@"");
//		}];
//		
//	}
//	return YES;
//}

// NOTE: 9.0以后使用新API接口
//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
//{
//	if ([url.host isEqualToString:@"safepay"]) {
//		//跳转支付宝钱包进行支付，处理支付结果
//		[[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//			NSLog(@"result = %@",resultDic);
//		}];
//		// 授权跳转支付宝钱包进行支付，处理支付结果
//		[[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
//			NSLog(@"result = %@",resultDic);
//			// 解析 auth code
//			NSString *result = resultDic[@"result"];
//			NSString *authCode = nil;
//			if (result.length>0) {
//				NSArray *resultArr = [result componentsSeparatedByString:@"&"];
//				for (NSString *subResult in resultArr) {
//					if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
//						authCode = [subResult substringFromIndex:10];
//						break;
//					}
//				}
//			}
//			NSLog(@"授权结果 authCode = %@", authCode?:@"");
//		}];
//		
//	}
//	return YES;
//}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	[SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
	[SVProgressHUD setMinimumDismissTimeInterval:1.0];
	
	IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
	manager.enable = YES;//控制整个功能是否启用。
	manager.shouldResignOnTouchOutside = YES;//控制点击背景是否收起键盘。
	manager.shouldToolbarUsesTextFieldTintColor = YES;//控制键盘上的工具条文字颜色是否用户自定义。
	manager.enableAutoToolbar = NO;//控制是否显示键盘上的工具条。
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
	/*! 版本更新  */
//	[self VersonUpdate];
	/*! 保存当前时间  */
	[self saveCurrentTime];
//截屏
	[self screenshot];
	
	_mapManager = [[BMKMapManager alloc]init];
	// 如果要关注网络及授权验证事件，请设定     generalDelegate参数
	BOOL ret = [_mapManager start:@"GqPBelcjdgnnusGN3QjEQ45vjE7YkyE1"  generalDelegate:nil];
	if (!ret) {
		NSLog(@"manager start failed!");
	}
	
	self.window.rootViewController = [BaseTabBarViewController new];

    [self.window makeKeyWindow];
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
