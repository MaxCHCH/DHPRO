//
//  WWBaseResponse.m
//  zhidoushi
//
//  Created by xinglei on 14-10-30.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "WWBaseResponse.h"

#import "GlobalUse.h"
#import "WWBaseRequest.h"
#import "NARResponseError.h"

@implementation WWBaseResponse

-(void)parseBackError:(NARResponseErrorType)errorType delegate:(id<NARURLConnectionDelegate>)delegate{

    if ([(WWBaseRequest*)self.request needLogIn]) {
        switch (errorType){
            case NARResponseError_TokenExpire:{
                NSLog(@"--->>token已经过期，请先登录");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self needExpiredLogin];
                });
                break;
            }
            case NARResponseError_UnLogin:{
             NSLog(@"-->>还未登录请先登录");
                break;
            }
        
            default:
                break;
        }
    }
}

-(void)needExpiredLogin{

    //账号登出
    [[GlobalUse shareGlobal]setUser:nil];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:USERDEFAULT_SYSTEM_SETTING_KEY_USER_MODEL_INFO];
    [[NSUserDefaults standardUserDefaults]synchronize];

}

@end
