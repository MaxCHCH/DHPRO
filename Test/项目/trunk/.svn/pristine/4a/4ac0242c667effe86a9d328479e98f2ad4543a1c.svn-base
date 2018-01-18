//
//  WIUtilsDefine.h
//  Tool
//
//  Created by licy on 14/11/20.
//  Copyright (c) 2014年 licy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WIUtilsDefine : NSObject

#define WEAKSELF_SS __weak __typeof(self)weakSelf = self;
#define Weak(class) __weak class *weakCmd = cmd;
#define SSL_Height_Value  [UIScreen mainScreen].bounds.size.height / 568
#define SSL_Width_Value  [UIScreen mainScreen].bounds.size.width / 568

//版本号
#define current_version [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

#define RGB(r, g, b) [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

#define SysFont(f)  [UIFont systemFontOfSize:f]
#define BoldFont(f) [UIFont boldSystemFontOfSize:f]
#define GirlFont(f) [UIFont fontWithName:Font_Girl size:f]

//获取十六进制颜色值
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//关闭打印 置0 开启置1
//#define SADEBUG 0
//#if SADEBUG
//#define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
//#else
//#define NSLog(FORMAT, ...) nil
//#endif

#define PropertyString(p) @property (nonatomic,copy) NSString *p;
#define PropertyFloat(p)  @property (nonatomic) float p;
#define PropertyDouble(p) @property (nonatomic) double p;
#define PropertyInt(p)    @property (nonatomic) NSInteger p;
#define PropertyUInt(p)   @property (nonatomic) NSUInteger p;
#define PropertyBool(p)   @property (nonatomic) BOOL p;
#define PropertyNumber(p)   @property (nonatomic,strong) NSNumber *p;

// 动画
#define SS_ANIMATE_ALPHA_SHOW(time,view) \
[UIView animateWithDuration:time animations:^{ \
view.alpha = 1; \
}];

#define SS_ANIMATE_ALPHA_HIDD(time,view) \
[UIView animateWithDuration:time animations:^{ \
view.alpha = 0; \
}];

#define SS_ANIMATE_ALPHA_HIDDEN(time,view,superView) \
[UIView animateWithDuration:time animations:^{ \
view.alpha = 0; \
} completion:^(BOOL finished) { \
[view removeFromSuperview]; \
}];

// 添加通知
#define SS_NOTIFICATION_ADD(notificationName,method) \
[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(method) name:notificationName object:nil];

// 调用通知
#define SS_NOTIFICATION_POST(notificationName,param) \
[[NSNotificationCenter defaultCenter]postNotificationName:notificationName object:param];

// 删除通知
#define SS_NOTIFICATION_REMOVE(notificationName) \
[[NSNotificationCenter defaultCenter]removeObserver:self name:notificationName object:nil];

@end







