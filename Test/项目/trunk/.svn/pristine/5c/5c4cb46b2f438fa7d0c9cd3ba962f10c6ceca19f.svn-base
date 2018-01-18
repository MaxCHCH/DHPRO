//
//  WeiXinEngine.h
//  zhidoushi
//
//  Created by xinglei on 14/11/20.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^weiXinEngineBlock) (NSString*openID , BOOL success);

@interface WeiXinEngine : NSObject

@property(nonatomic,copy)weiXinEngineBlock weixinEngineBlock;

/**
 *  Description 申请微信认证
 *
 *  @param view 添加一个检测是否安装微信的提示
 */
+(void)sendAuthRequest:(UIView*)view;
/**
 *  Description 通过微信验证码获取token
 *
 *  @param weixinCode 微信的验证码
 */
+(BOOL)getAccess_token:(NSString*)weixinCode;

@end
