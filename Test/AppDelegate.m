//
//  AppDelegate.m
//  Test
//
//  Created by Rillakkuma on 16/6/1.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//
#define kUseScreenShotGesture 1



#import "AppDelegate.h"
#import "ViewController.h"
#import "LSTabBarViewController.h"

@interface AppDelegate ()
{
	BMKMapManager* _mapManager;
}

@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	[SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
	[SVProgressHUD setMinimumDismissTimeInterval:1.0];
	
    ViewController *viewC = [[ViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:viewC];
	nav.navigationBar.barTintColor = [UIColor yellowColor];
//    nav.navigationBar.barTintColor = [UIColor colorWithRed:62/255.0 green:173/255.0 blue:176/255.0 alpha:1.0];
//    nav.navigationBar.topItem.title = @"我的小demo";
//    [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
	
	_mapManager = [[BMKMapManager alloc]init];
	// 如果要关注网络及授权验证事件，请设定     generalDelegate参数
	BOOL ret = [_mapManager start:@"GqPBelcjdgnnusGN3QjEQ45vjE7YkyE1"  generalDelegate:nil];
	if (!ret) {
		NSLog(@"manager start failed!");
	}
	
    self.window.rootViewController =nav;
	
	
	
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
