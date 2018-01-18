//
//  NARURLConnection.h
//  zhidoushi
//
//  Created by xinglei on 14-10-30.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NARBaseRequest.h"
#import "NARResponseParser.h"
#import "NARURLConnectionDelegate.h"

//@protocol NARURLConnectionDelegate <NSObject>
//*****重复导入协议*****//
//@end

@interface NARURLConnection : NSObject
{
//    NARResponseParser *responseParser;

}

-(void)sendRequest:(NARBaseRequest*)baseRequest;

-(void)sendRequest:(NARBaseRequest*)baseRequest delegate:(__weak id<NARURLConnectionDelegate>)delegate;

@end
