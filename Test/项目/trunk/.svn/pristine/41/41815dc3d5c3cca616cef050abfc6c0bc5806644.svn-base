//
//  WWRequestOperationEngine.h
//  zhidoushi
//
//  Created by jiankangyouyi on 14/11/20.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void (^WWRequestOperationEngineBlock) (NSDictionary* object);
@interface WWRequestOperationEngine : NSObject

/**
 *  未登录状态网络请求接口（不传userId）
 *
 *  @param urlString 接口地址
 *  @param para      参数
 *  @param block     回调block
 *
 *  @return 网络操作
 */
+ (AFHTTPRequestOperation*)operationManagerRequest_NoUserIdPost:(NSString*)urlString parameters:(id)para requestOperationBlock:(WWRequestOperationEngineBlock)block;

/**
 *  登陆状态网络请求接口
 *
 *  @param urlString 接口地址
 *  @param para      参数
 *  @param block     回调block
 *
 *  @return 网络操作
 */
+ (AFHTTPRequestOperation*)operationManagerRequest_Post:(NSString*)urlString parameters:(id)para requestOperationBlock:(WWRequestOperationEngineBlock)block;

@end
