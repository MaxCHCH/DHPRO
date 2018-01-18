//
//  WWURLConnection.h
//  zhidoushi
//
//  Created by xinglei on 14-10-30.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

/*!
 *	@brief	请求使用的控制类
 */
#import "NARURLConnection.h"

@interface WWURLConnection : NARURLConnection

+(WWURLConnection*)shareConnection;

-(void)sendUrl:(NSString *)baseUrl parameter:(NSDictionary*)para parser:(NARResponseParser*)responseParser delegate:(__weak id<NARURLConnectionDelegate>)delegate;
@end
