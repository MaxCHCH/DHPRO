//
//  WeiXinEngine.m
//  zhidoushi
//
//  Created by xinglei on 14/11/20.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "WeiXinEngine.h"

#import "Define.h"
//..微信API..//
#import "WXApi.h"
#import "WXApiObject.h"
//..private..//
#import "WWTolls.h"
#import "GlobalUse.h"
#import "UserModel.h"
//..category..//
#import "NSDictionary+NARSafeDictionary.h"
#import "NSObject+NARSerializationCategory.h"
//..netWork..//
#import "JSONKit.h"
#import "ContactViewController.h"
#import "WWRequestOperationEngine.h"

@interface WeiXinEngine()

@end

@implementation WeiXinEngine

+(void)sendAuthRequest:(UIView*)view{
    if (![WXApi isWXAppInstalled]) {
        [[GlobalUse shareGlobal]showTextHud:@"请安装微信" inView:view];
    }else{
        [NSUSER_Defaults setObject:nil forKey:ZDS_WEIXINJUDGE];
        [NSUSER_Defaults synchronize];
        SendAuthReq* req =[[SendAuthReq alloc ] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"74272hd934uiw079dao";
        [WXApi sendReq:req];
    }
}

/**
 *  获取微信的token值
 */
+(BOOL)getAccess_token:(NSString*)weixinCode{
    
    //https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code
    
    __block BOOL result = false;
    
    __weak __typeof(self)weakSelf = self;

    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",kWXAPP_ID,kWXAPP_SECRET,weixinCode];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURL *zoneUrl = [NSURL URLWithString:url];
        
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data) {
                /*         {
                 "access_token" = "OezXcEiiBSKSxW0eoylIeJDUKD6z6dmr42JANLPjNN7Kaf3e4GZ2OncrCfiKnGWiusJMZwzQU8kXcnT1hNs_ykAFDfDEuNp6waj-bDdepEzooL_k1vb7EQzhP8plTbD0AgR8zCRi1It3eNS7yRyd5A";
                 
                 "expires_in" = 7200;
                 
                 openid = oyAaTjsDx7pl4Q42O3sDzDtA7gZs;
                 
                 "refresh_token" = "OezXcEiiBSKSxW0eoylIeJDUKD6z6dmr42JANLPjNN7Kaf3e4GZ2OncrCfiKnGWi2ZzH_XfVVxZbmha9oSFnKAhFsS0iyARkXCa7zPu4MqVRdwyb8J16V8cWw7oNIff0l-5F-4-GJwD8MopmjHXKiA";
                 
                 scope = "snsapi_userinfo,snsapi_base";
                 }
                 *///oqIUCs_3HSyvi40ih7UXKyB-AtS0

//                openid = "oqIUCs5pSpUUVv69IrWlC_pX5kJ8";
//                unionid = oU44Mt8fQnldO9euBgguySZ347eE;
//                userid = "oqIUCs5pSpUUVv69IrWlC_pX5kJ8";
//                oqIUCs2BIOaEvD2HLg2CNlL3yUZU;

                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSString * access_token = nil;
                NSString * openid = nil;
                if ([dic isKindOfClass:[NSMutableDictionary class]] && dic!=nil) {

                    access_token = [dic objectForKey:@"access_token"];
                    openid = [dic objectForKey:@"openid"];
                    [NSUSER_Defaults setObject:openid forKey:ZDS_OPENID];
                    [NSUSER_Defaults synchronize];

                    }

                if (access_token.length!=0 && access_token!=nil) {
                    __strong __typeof(weakSelf)strongSelf = weakSelf;
                    result = [strongSelf getUserInfo:access_token openid:openid];
                }
            }
        });
    });
        return result;
}

+(BOOL)getUserInfo:(NSString*)access_token openid:(NSString*)openid{
    
    // https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID
    
    __block BOOL result = false;
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",access_token,openid];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURL *zoneUrl = [NSURL URLWithString:url];
        
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data) {
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"dic----------%@",dic);
                /*
                 {
                 city = Haidian;
                 country = CN;
                 headimgurl = "http://wx.qlogo.cn/mmopen/FrdAUicrPIibcpGzxuD0kjfnvc2klwzQ62a1brlWq1sjNfWREia6W8Cf8kNCbErowsSUcGSIltXTqrhQgPEibYakpl5EokGMibMPU/0";
                 language = "zh_CN";
                 nickname = "xxx";
                 openid = oyAaTjsDx7pl4xxxxxxx;
                 privilege =     (                 );
                 province = Beijing;
                 sex = 1;
                 unionid = oyAaTjsxxxxxxQ42O3xxxxxxs;
                 }
                 */
                //================================================================
                //构建parameter
                NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:3];
                [dictionary setObject:openid forKey:@"openid"];
                [NSUSER_Defaults setObject:openid forKey:ZDS_USERID];
                NSString *deviceString = [[NSUserDefaults standardUserDefaults] objectForKey:ZDS_DEVICETOKEN];
                NSString *clientString = [[NSUserDefaults standardUserDefaults] objectForKey:ZDS_CLIENTID];
                if (deviceString.length!=0) {
                    [dictionary setObject:[NSString stringWithFormat:@"%@",deviceString]  forKey:@"deviceid"];
                    
                }else{
                    [dictionary setObject:@"0"  forKey:@"deviceid"];
                }
                if (clientString.length!=0) {
                    [dictionary setObject:[NSString stringWithFormat:@"%@",clientString] forKey:@"clientid"];
                }else{
                    [dictionary setObject:@"0" forKey:@"clientid"];
                }
                [dictionary setObject:@"0" forKey:@"logintype"];//ios 0 android 1
                //==================================================================
                //用户的微信信息
                UserModel *user=[[UserModel alloc]init];

                NSString *nickName = [dic objectForKey:@"nickname"];
                int sexInteger =[[dic objectForKey:@"sex"]intValue];
                NSString *headImageUrl = [dic objectForKey:@"headimgurl"];
//                NSString *city = [dic objectForKey:@"city"];
//                NSString *country = [dic objectForKey:@"CN"];
//                NSString *province = [dic objectForKey:@"Beijing"];
                NSString *unionid = [dic objectForKey:@"unionid"];
                //===================================================================
                if (nickName.length!=0) {
                    if(user.nickName.length==0){
                        [user setNickName:nickName];
                        [dictionary setObject:nickName forKey:@"username"];
                    }
                }
                if (sexInteger!=0) {
                    [user setSex:sexInteger];
                    [dictionary setObject:[NSString stringWithFormat:@"%d",sexInteger] forKey:@"usersex"];
                }
                if (headImageUrl.length!=0) {
                    if (user.headUrl.length==0) {
                        [user setHeadUrl:headImageUrl];
                        [dictionary setObject:headImageUrl forKey:@"headimgurl"];
                    }else{
                        [dictionary setObject:headImageUrl forKey:@"headimgurl"];
                    }
                }else{
                    [dictionary setObject:@"imgs/default/head.jpg?FrmRhCmNQrWYNgUlI6JSCQJzTJ2Q" forKey:@"headimgurl"];
                }
                if ([NSUSER_Defaults objectForKey:@"zdslatitude"]!=nil) {
                    [dictionary setObject:[NSUSER_Defaults objectForKey:@"zdscountry"] forKey:@"country"];
                    [dictionary setObject:[NSUSER_Defaults objectForKey:@"zdsprovince"] forKey:@"province"];
                    if([NSUSER_Defaults objectForKey:@"zdscity"]!=nil) [dictionary setObject:[NSUSER_Defaults objectForKey:@"zdscity"] forKey:@"city"];
                    [dictionary setObject:[NSUSER_Defaults objectForKey:@"zdslongitude"] forKey:@"longitude"];
                    [dictionary setObject:[NSUSER_Defaults objectForKey:@"zdslatitude"] forKey:@"latitude"];
                }
                
//                if (city.length!=0) {
//                    if (user.city.length==0) {
//                        [user setCity:city];
//                    }
//                    [dictionary setObject:city forKey:@"city"];
//                }
//                if (country.length!=0) {
//                    if (user.country.length==0) {
//                        [user setCountry:country];
//                    }
//                    [dictionary setObject:country forKey:@"country"];
//                }
//                if(province.length!=0){
//                    if (user.province.length==0) {
//                        [user setProvince:province];
//                    }
//                    [dictionary setObject:province forKey:@"province"];
//                }
                if(unionid.length!=0){
                    if (user.unionid.length==0) {
                        [user setUnionid:unionid];
                    }
                    [dictionary setObject:unionid forKey:@"unionid"];
                }
                [dictionary setObject:@"appstore" forKey:@"channel"];
                [[NSUserDefaults standardUserDefaults]setObject:[user savePropertiesToDictionary] forKey:ZDS_USERDEFAULT_SYSTEM_SETTING_KEY_USER_MODEL_INFO];
                [NSUSER_Defaults synchronize];

                NSLog(@"微信用户信息________%@",dictionary);

                [WWRequestOperationEngine operationManagerRequest_Post:[NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_URLREQUEST_GETWEIXINCODE] parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
                    
                    if (![dic isKindOfClass:[NSDictionary class]] || dic==nil) {

                        NSLog(@"获取微信信息失败！！！！！！！！！！");
                                                [[NSNotificationCenter defaultCenter]postNotificationName:@"loginFail" object:nil];
                    }else{

                    NSLog(@"微信登陆---------------%@",dic);

                    NSString *userID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"userid"] ];
                    [NSUSER_Defaults setObject:userID forKey:ZDS_USERID];
                    [NSUSER_Defaults synchronize];
                    NSLog(@"%@", [dic objectForKey:@"errinfo"]);
                    NSString *loginstatus = [dic objectForKey:@"loginstatus"];

                    if([loginstatus intValue]==0){//微信号注册过
#warning 老用户引导
                        if ([NSUSER_Defaults objectForKey:@"openoldnew"] == nil) {
                            [NSUSER_Defaults setObject:@"YES" forKey:@"openoldnew"];
                        }
                        
                        
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"getOpenIdSuccess" object:nil];
                    }
                    else if ([loginstatus intValue]==1){

                        
                        NSLog(@"*******初始化通讯录并调取");
                        //初始化通讯录并调取
                        ContactViewController * contanct = [[ContactViewController alloc]init];
                        [contanct readContacts];
                        [contanct uploadPhoneNumber];
                        [contanct writePhoneNumber];
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"getOpenIdSuccess" object:nil];
                    }
                    else if ([loginstatus intValue]==2) {//登陆失败
                         NSLog(@"******微信登陆失败*******");
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"loginFail" object:nil];
                        }
                    }
                }];
            }
        });
    });
    
    return result;
}

@end
