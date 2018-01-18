//
//  GlobalUse.h
//  zhidoushi
//
//  Created by xinglei on 14-10-28.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "UserModel.h"
#import "MBProgressHUD.h"//提示框
#import "XLNavigationController.h"

extern XLNavigationController *xlNavigationController;
extern BOOL x_isWifi;//是否是wifi
extern BOOL x_isConnectToNetwork;//是否已经联网

extern BOOL x_isHasNewVersion;//是否有更新版本,true表示是
extern BOOL x_isLogin;//是否已经登录,true是已经登录，判断依据是此类的user是否存在

extern NSString *loginRandomString;

typedef enum {
    FirstTimeType_UserCenter,//用户中心的第一次
}FirstTimeType;

@interface GlobalUse : NSObject

+(GlobalUse*)shareGlobal;

+(UIFont*)fontForSpecialWithSize:(CGFloat)size;//界面中使用的MHeiRPC字体
+(UIFont*)fontForNormalWithSize:(CGFloat)size;//平常使用的字体
+(UIFont*)fontForNumberWithSize:(CGFloat)size;//存数字使用的HelveticaNeueLTPro-ThEx.otf字体

+(NSString*)shareUrlForPacket:(int)packetID;//分享帖子使用的链接
//+(NSString*)shareUrlForElement:(int)elementID;//分享楼层使用的链接

+(BOOL)isFirstTime:(FirstTimeType)type;//是否是第一次打开
+(void)updateFirstTime:(FirstTimeType)type;//更新第一次打开情况

@property (retain,nonatomic) UserModel *user;
@property (assign,nonatomic) NSTimeInterval timeOffsetServer;//与服务器的时间差

@property (assign,nonatomic) CLLocationCoordinate2D currentLocation;//当前的地点经纬度

//-(NSString*)timeConversion:(NSTimeInterval)timeInterval;//已删除

-(NSString*)refreshTimeCoversion:(NSTimeInterval)timeInterval;

-(MBProgressHUD*)showInfoHud:(NSString*)text inView:(UIView*)view;//半圆型加载框

-(MBProgressHUD*)showTextHud:(NSString*)text inView:(UIView*)view;//只有文字型

- (NSString *)idfvString;

+(UIImage*)backgroundImage;

@end
