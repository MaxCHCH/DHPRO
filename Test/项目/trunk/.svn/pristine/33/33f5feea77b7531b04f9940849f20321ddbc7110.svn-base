//
//  NARResponseParser.h
//  zhidoushi
//
//  Created by xinglei on 14-10-30.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NARBaseRequest.h"
#import "NARURLConnectionDelegate.h"

@interface NARResponseParser : NSObject

/*!
 *	@brief	解析返回的数据
 *
 *	@param 	jsonString 	返回的JSON格式的数据
 *	@param 	request 	请求时候的Request，里面包含解析要用到的一些数据
 */
-(void)parseBackJSONString:(NSString *)jsonString delegate:(id<NARURLConnectionDelegate>)delegate;

/*!
 *	@brief	请求发生错误时候的处理
 *
 *	@param 	request 	请求时候的Request，里面包含解析要用到的一些数据
 */
-(void)parseBackError:(NARBaseRequest*)request delegate:(id<NARURLConnectionDelegate>)delegate;


@end
