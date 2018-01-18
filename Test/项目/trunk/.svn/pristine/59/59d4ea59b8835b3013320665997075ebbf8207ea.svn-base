//
//  GlobalUse.m
//  zhidoushi
//
//  Created by xinglei on 14-10-28.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//


#import "GlobalUse.h"

XLNavigationController *xlNavigationController;
BOOL x_isWifi=false;//是否是wifi
BOOL x_isConnectToNetwork=false;//是否已经联网
BOOL x_isHasNewVersion=false;//是否有更新版本,true表示是
int x_isNeedBackgroundTaskCount=0;//是否需要后台下载任务，当不为0是表示需要

BOOL x_isLogin=false;
NSString *loginRandomString;

@interface GlobalUse ()
{
    MBProgressHUD *hud;
}
@end

@implementation GlobalUse

static GlobalUse *instance;

+(GlobalUse *)shareGlobal{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance=[[GlobalUse alloc]init];
        }
    });
    return instance;
}

+(UIFont*)fontForSpecialWithSize:(CGFloat)size{//界面顶部标题使用的字体
    return [self fontForNormalWithSize:size];
    //    return [UIFont fontWithName:@"MHeiPRC-Medium" size:size];
}
+(UIFont*)fontForNormalWithSize:(CGFloat)size{//平常使用的字体
    return [UIFont systemFontOfSize:size];
}
+(UIFont*)fontForNumberWithSize:(CGFloat)size{//数字使用的字体
    return [UIFont fontWithName:@"Helvetica Neue LT Pro" size:size];
}

+(NSString*)shareUrlForPacket:(int)packetID{//分享帖子使用的链接
    return [NSString stringWithFormat:@"http://look.onlylady.com/gallery.html?id=%d",packetID];
}
+(NSString*)shareUrlForElement:(int)elementID{//分享楼层使用的链接
    return [NSString stringWithFormat:@"http://ishare.onlylady.com/post-%d.html",elementID];
}
+(BOOL)isFirstTime:(FirstTimeType)type{
    NSDictionary *dictionary=[[NSUserDefaults standardUserDefaults]objectForKey:USERDEFAULT_SYSTEM_SETTING_KEY_FIRST_TIME_SHOW];
    if (dictionary&&[dictionary objectForKey:[NSString stringWithFormat:@"%d",type]]) {
        return false;
    }
    return true;
}
+(void)updateFirstTime:(FirstTimeType)type{
    NSDictionary *dictionary=[[NSUserDefaults standardUserDefaults]objectForKey:USERDEFAULT_SYSTEM_SETTING_KEY_FIRST_TIME_SHOW];
    NSMutableDictionary *firstTimeDictionary=[NSMutableDictionary dictionaryWithDictionary:dictionary];
    [firstTimeDictionary setObject:@"y" forKey:[NSString stringWithFormat:@"%d",type]];
    [[NSUserDefaults standardUserDefaults] setObject:firstTimeDictionary forKey:USERDEFAULT_SYSTEM_SETTING_KEY_FIRST_TIME_SHOW];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(id)init{
    if (self=[super init]) {
        loginRandomString=[[NSUserDefaults standardUserDefaults]objectForKey:USERDEFAULT_SYSTEM_SETTING_KEY_LOGIN_RANDOM];
    }
    return self;
}

-(NSString*)refreshTimeCoversion:(NSTimeInterval)timeInterval{
    NSDate * publishDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate:publishDate];
}


-(void)setUser:(UserModel *)user{
    _user=user;
    x_isLogin=(_user!=nil);
}


-(MBProgressHUD*)showInfoHud:(NSString*)text inView:(UIView*)view{
    hud=[MBProgressHUD showHUDAddedTo:view animated:true];
    [hud setLabelText:text];
    [hud setMargin:10];
    [hud setMode:MBProgressHUDModeDeterminate];
    [hud showWhileExecuting:@selector(myProgressTask) onTarget:self withObject:nil animated:YES];
    return hud;
}

-(MBProgressHUD*)showTextHud:(NSString*)text inView:(UIView*)view{
    hud=[MBProgressHUD showHUDAddedTo:view animated:true];
    [hud setLabelText:text];
    [hud setMode:MBProgressHUDModeText];
    [hud hide:YES afterDelay:0.7];
    return hud;
}

- (NSString *)idfvString
{
    if([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
        return [[UIDevice currentDevice].identifierForVendor UUIDString];
    }
    
    return @"";
}

+(UIImage *)backgroundImage{
    DLogMemoryUsed;
    static UIImage *bgImage=nil;
    if (bgImage==nil) {
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [imageView setImage:[UIImage imageNamed:@"底图素材.png"]];
        
        UIGraphicsBeginImageContext(imageView.bounds.size);
        CGContextRef context=UIGraphicsGetCurrentContext();
        [imageView.layer renderInContext:context];
        [[UIColor colorWithWhite:0 alpha:0.7] setFill];
        CGContextFillRect(context, imageView.bounds);
        bgImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    DLogMemoryUsed;
    return bgImage;
}

- (void)myProgressTask {
    // This just increases the progress indicator in a loop
    float progress = 0.0f;
    while (progress < 1.0f) {
        progress += 0.1f;
        hud.progress = progress;
        usleep(50000);
    }
}

@end
