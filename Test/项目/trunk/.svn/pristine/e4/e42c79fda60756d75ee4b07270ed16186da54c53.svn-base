//
//  SASManager.m
//  zhidoushi
//
//  Created by licy on 15/7/14.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "SASManager.h"
#import "OpenUDID.h"
#import "WINetTool.h"
#import <AdSupport/ASIdentifierManager.h>
/**
 *  是否第一次启动
 *  0 第一次
 *  1 非第一次
 */
#define ZDS_ISFIRSTStart @"isFirstStart"
//是否第一次关闭
#define ZDS_ISFIRSTStop @"isFirstStop"

#define ZDS_VERSION @"currentVersion"

//版本号
#define CURRENTVERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

@implementation SASManager

#pragma mark - Public Methods
#pragma mark 启动app
+ (void)startApp {
    
    //本地没存储版本号时
    if ([WWTolls isNull:[NSUSER_Defaults objectForKey:ZDS_VERSION]]) {
        [NSUSER_Defaults setObject:CURRENTVERSION forKey:ZDS_VERSION];
    } else {
        
        //版本更新  将第一次启动置0
        if (![[NSUSER_Defaults objectForKey:ZDS_VERSION] isEqualToString:CURRENTVERSION]) {
            [NSUSER_Defaults setObject:CURRENTVERSION forKey:ZDS_VERSION];
            [NSUSER_Defaults setObject:@"0" forKey:ZDS_ISFIRSTStart];
//            [NSUSER_Defaults setObject:@"0" forKey:ZDS_ISFIRSTStop];
        }
    }
    
    //非第一次启动
    if ([[NSUSER_Defaults objectForKey:ZDS_ISFIRSTStart] isEqualToString:@"1"]) {
        
        NSLog(@"非第一次启动");
        //启动或停止借口
        [[self class] sasRequestWithIsfirst:@"1" andSastype:@"1"];
    }   
    
    //第一次启动
    else {
        
        NSLog(@"第一次启动");
        //启动或停止借口
        [[self class] sasRequestWithIsfirst:@"0" andSastype:@"1"];
    }
}

#pragma mark 停止app
+ (void)stopApp {
    
    NSLog(@"关闭");
    [[self class] sasRequestWithIsfirst:@"1" andSastype:@"2"];
    
//    //非第一次停止
//    if ([[NSUSER_Defaults objectForKey:ZDS_ISFIRSTStop] isEqualToString:@"1"]) {
//        
//        NSLog(@"非第一次关闭");
//        //启动或停止借口
//        [[self class] sasRequestWithIsfirst:@"1" andSastype:@"2"];
//    }
//    
//    //第一次停止
//    else {
//        
//        NSLog(@"第一次关闭");
//        [[self class] sasRequestWithIsfirst:@"1" andSastype:@"2"];
//    }
}

#pragma mark - Private Methods
#pragma mark 首次启动存储
+ (void)firstStorageWithIsfirst:(NSString *)isfirst andSastype:(NSString *)sastype {
    
    //首次启动
    if ([isfirst isEqualToString:@"0"] && [sastype isEqualToString:@"1"]) {
        
        [NSUSER_Defaults setObject:@"1" forKey:ZDS_ISFIRSTStart];
        [NSUSER_Defaults synchronize];
    }
}

#pragma mark - app停止
+ (void)loginOut{
    NSString *isfirst = @"1";
    NSString *sastype = @"2";
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setObject:isfirst forKey:@"isfirst"];
    [dictionary setObject:sastype forKey:@"sastype"];
    //idfa
    if ([isfirst isEqualToString:@"0"]) {
        NSString *IDFA = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        [dictionary setObject:IDFA forKey:@"idfa"];
    }
    
    NSString *userID = nil;
    /**
     *  islogin
     *  是否已登录
     *  0 是
     *  1 否
     */
    if ([WWTolls isNull:[NSUSER_Defaults objectForKey:ZDS_USERID]]) {
        [dictionary setObject:@"1" forKey:@"islogin"];
        userID =  [OpenUDID value];
        
    } else {
        
        [dictionary setObject:@"0" forKey:@"islogin"];
        userID =  [NSUSER_Defaults objectForKey:ZDS_USERID];
        
        //登陆状态传输统计记录
        //统计数组
        NSArray *tjSts = TJ_TJSZ;
        
        //统计标示
        NSString *timestamp = [NSUSER_Defaults objectForKey:@"sastimestamp"];

        
        //不存在 重新生成
        if (!timestamp || timestamp.length < 1) {
            timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
            [NSUSER_Defaults setObject:timestamp forKey:@"sastimestamp"];
        }
        //换天 重新生成
        double timezoneFix = [NSTimeZone localTimeZone].secondsFromGMT;
        int now = (int)(([[NSDate date] timeIntervalSince1970] + timezoneFix)/(24*3600));
        int last = (int)((timestamp.doubleValue + timezoneFix)/(24*3600));
        if (
            now -
            last
            != 0){
            timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
            [NSUSER_Defaults setObject:timestamp forKey:@"sastimestamp"];
            //统计归零
            for (NSString *tjstr in tjSts) {
                NSString *tjkey = [NSString stringWithFormat:@"tj_%@",tjstr];
                [NSUSER_Defaults setObject:@"0" forKey:tjkey];
            }
        }
        [dictionary setObject:timestamp forKey:@"timestamp"];
        [NSUSER_Defaults removeObjectForKey:@"sastimestamp"];
        //传输统计次数
        for (NSString *tjstr in tjSts) {
            //点击次数
            NSString *tjkey = [NSString stringWithFormat:@"tj_%@",tjstr];
            NSString *jznum = [NSUSER_Defaults objectForKey:tjkey]?[NSUSER_Defaults objectForKey:tjkey]:@"0";
            if(![jznum isEqualToString:@"0"])[dictionary setObject:jznum forKey:tjstr];
            [NSUSER_Defaults setObject:@"0" forKey:tjkey];
        }
    }
    
    NSString *userid = [NSString stringWithFormat:@"%@",userID];
    NSLog(@"userid:%@",userid);
    
    NSString *key = [NSString getMyKey:userID];
    [dictionary setObject:userid forKey:@"userid"];
    [dictionary setObject:key forKey:@"key"];
    
    //app启动和停止时调用该接口
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_SASSTAiCS];
    
    WEAKSELF_SS
    [WWRequestOperationEngine operationManagerRequest_NoUserIdPost:urlString parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        if (dic[ERRCODE]) {
            [[weakSelf class] firstStorageWithIsfirst:isfirst andSastype:sastype];
            NSLog(@"网络不给力哦");
        }else{
            
            if ([dic[@"result"] isEqualToString:@"0"]) {
                NSLog(@"处理成功");
                
                [[weakSelf class] firstStorageWithIsfirst:isfirst andSastype:sastype];
                
            } else if ([dic[@"result"] isEqualToString:@"1"]) {
                NSLog(@"处理失败");
            }
        }
    }];
}

#pragma mark - Request
#pragma mark app启动和停止请求
/**
 *  app启动和停止时调用该接口
 *
 *  @param isfirst 是否首次启动  0 是、1 否
 *  @param sastype 启停类型     1 启动、2 停止
 */
+ (void)sasRequestWithIsfirst:(NSString *)isfirst andSastype:(NSString *)sastype {
    
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setObject:isfirst forKey:@"isfirst"];
    [dictionary setObject:sastype forKey:@"sastype"];
    //idfa
    if ([isfirst isEqualToString:@"0"]) {
        NSString *IDFA = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        [dictionary setObject:IDFA forKey:@"idfa"];
    }
    
    NSString *userID = nil;
    /**
     *  islogin
     *  是否已登录
     *  0 是
     *  1 否
     */
    if ([WWTolls isNull:[NSUSER_Defaults objectForKey:ZDS_USERID]]) {
        [dictionary setObject:@"1" forKey:@"islogin"];
        userID =  [OpenUDID value];
        
    } else {
        
        [dictionary setObject:@"0" forKey:@"islogin"];
        userID =  [NSUSER_Defaults objectForKey:ZDS_USERID];
        
        //登陆状态传输统计记录
        //统计数组
        NSArray *tjSts = TJ_TJSZ;

        //统计标示
        NSString *timestamp = [NSUSER_Defaults objectForKey:@"sastimestamp"];
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        //不存在 重新生成
        if (!timestamp || timestamp.length < 1) {
            timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
            [NSUSER_Defaults setObject:timestamp forKey:@"sastimestamp"];
        }
        //换天 重新生成
        double timezoneFix = [NSTimeZone localTimeZone].secondsFromGMT;
        int now = (int)(([[NSDate date] timeIntervalSince1970] + timezoneFix)/(24*3600));
        int last = (int)((timestamp.doubleValue + timezoneFix)/(24*3600));
        if (
            now -
            last
            != 0){
            timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
            [NSUSER_Defaults setObject:timestamp forKey:@"sastimestamp"];
            //统计归零
            for (NSString *tjstr in tjSts) {
                NSString *tjkey = [NSString stringWithFormat:@"tj_%@",tjstr];
                [NSUSER_Defaults setObject:@"0" forKey:tjkey];
            }
        }
        [dictionary setObject:timestamp forKey:@"timestamp"];
        //传输统计次数
        for (NSString *tjstr in tjSts) {
            //点击次数
            NSString *tjkey = [NSString stringWithFormat:@"tj_%@",tjstr];
            NSString *jznum = [NSUSER_Defaults objectForKey:tjkey]?[NSUSER_Defaults objectForKey:tjkey]:@"0";
            if(![jznum isEqualToString:@"0"]) [dictionary setObject:jznum forKey:tjstr];
        }
    }   
    
    NSString *userid = [NSString stringWithFormat:@"%@",userID];
    NSLog(@"userid:%@",userid);
    
    NSString *key = [NSString getMyKey:userID];
    [dictionary setObject:userid forKey:@"userid"];
    [dictionary setObject:key forKey:@"key"];
    
    //app启动和停止时调用该接口
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_SASSTAiCS];
    
    WEAKSELF_SS
    [WWRequestOperationEngine operationManagerRequest_NoUserIdPost:urlString parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        if (dic[ERRCODE]) {
            [[weakSelf class] firstStorageWithIsfirst:isfirst andSastype:sastype];
            NSLog(@"网络不给力哦");
        }else{
            
            if ([dic[@"result"] isEqualToString:@"0"]) {
                NSLog(@"处理成功");
                
                [[weakSelf class] firstStorageWithIsfirst:isfirst andSastype:sastype];
                
            } else if ([dic[@"result"] isEqualToString:@"1"]) {
                NSLog(@"处理失败");
            }
        }
    }];
}

@end
