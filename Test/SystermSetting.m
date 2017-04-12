//
//  SystermSetting.m
//  Test
//
//  Created by Rillakkuma on 2016/11/18.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import "SystermSetting.h"

@implementation SystermSetting
+ (SystermSetting *)ba_systermSettingManage
{
	static SystermSetting *ba_systermSettingManage;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		ba_systermSettingManage = [[SystermSetting alloc] init];
	});
	return ba_systermSettingManage;
}
- (void)ba_gotoSystermWIFISettings
{
	/*!
	 (1.)需要先配置plist文件:在URL types--URL Schemes中添加 prefs的字符串.因为苹果在iOS5.0后把系统自带的URL Schemes删除了
	 */
	[[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBtn4:) name:@"changeTabar4" object:nil];


//	NSURL *url = [NSURL URLWithString:@"prefs:root=WIFI"];
//	if ([[UIApplication sharedApplication] canOpenURL:url])
//	{
//		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
//
//	}

	
}
- (void)changeBtn4:(NSNotification *)notification{
	NSLog(@"当前类名：%@",NSStringFromClass([self class]));
//	NSDictionary *dic=  notification.userInfo;
//	NSLog(@"当前调用 %@  %@  %@",dic,notification.name,notification.object);
		NSDictionary *dic=  [notification object];
		NSLog(@"当前调用 %@  %@",dic,notification.object);

	
	
}
@end
