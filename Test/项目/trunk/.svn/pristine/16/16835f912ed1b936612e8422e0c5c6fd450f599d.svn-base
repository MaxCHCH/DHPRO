//
//  WINetTool.m
//  Tool
//
//  Created by licy on 14/11/20.
//  Copyright (c) 2014年 licy. All rights reserved.
//

#import "WINetTool.h"
#import "Reachability.h"

@interface WINetTool ()

@property (nonatomic,strong) Reachability *hostReach;//

@end

@implementation WINetTool

+ (WINetTool *)sharedTool {
    static WINetTool *tool = nil;
    @synchronized(self) {
        if (tool == nil) {
            tool = [[WINetTool alloc] init];
        }
    }
    
    return tool;
}   

//判断当前是否有网
+ (BOOL)isNetWork {
    
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            //NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            //NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            //NSLog(@"3G");
            break;
    }
    
    return isExistenceNetwork;
}

+ (BOOL)isWify {
    Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    return [reach currentReachabilityStatus] == ReachableViaWiFi;
    
}

- (void)networkNotificationWithExcept:(NetConnectExcept)connectExcept normal:(NetConnectNormal)connectNormal {
    
    _netConnectExcept = connectExcept;
    _netConnectNormal = connectNormal;
    
    //监听网络状况
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.hostReach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    [self.hostReach startNotifier];
}

#pragma mark 网络状况改变方法
- (void)reachabilityChanged:(NSNotification *)note {
    
    Reachability *currReach = [note object];
    //对连接改变做出响应处理动作
    NetworkStatus status = [currReach currentReachabilityStatus];
    if (status == NotReachable) {
        
        NSLog(@"网络连接异常");
        if (_netConnectExcept) {
            _netConnectExcept();
        }
    } else {
        
        NSLog(@"网络连接正常");
        if (_netConnectNormal) {
            _netConnectNormal();
        }
    }
}



@end







