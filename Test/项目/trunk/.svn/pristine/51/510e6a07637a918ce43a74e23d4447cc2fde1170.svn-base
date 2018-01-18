//
//  WINetTool.h
//  Tool
//
//  Created by licy on 14/11/20.
//  Copyright (c) 2014年 licy. All rights reserved.
//

#import <Foundation/Foundation.h>

//网络连接异常回调
typedef void (^NetConnectExcept)(void);
//网络连接成常回调
typedef void (^NetConnectNormal)(void);

#define WINet [WINetTool sharedTool]

@interface WINetTool : NSObject

+ (WINetTool *)sharedTool;

//是否有网络
+ (BOOL)isNetWork;

//是否有wify
+ (BOOL)isWify;

//网络监听                                          
- (void)networkNotificationWithExcept:(NetConnectExcept)connectExcept normal:(NetConnectNormal)connectNormal;

@property (nonatomic,copy) NetConnectExcept netConnectExcept;
@property (nonatomic,copy) NetConnectNormal netConnectNormal;

@end
