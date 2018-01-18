//
//  NARBaseResponse.h
//  zhidoushi
//
//  Created by xinglei on 14-10-30.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NARBaseRequest.h"
#import "NARResponseError.h"
#import "NARURLConnectionDelegate.h"

@interface NARBaseResponse : NSObject

@property (weak,nonatomic) NARBaseRequest *request;
@property (weak,nonatomic) id<NARURLConnectionDelegate> delegate;

//1.使用这两个方法进行不同情况的解析处理
-(void)parseBackData:(id)backData delegate:(id<NARURLConnectionDelegate>)delegate;
-(void)parseBackError:(NARResponseErrorType)errorType delegate:(id<NARURLConnectionDelegate>)delegate;

//2.使用上面的两个方法对返回的数据进行处理和解析后，完成后给上层返回结果时调用此方法
-(void)showFinishedResultDataInMainThreadToUI:(id)resultData;
-(void)showErrorResultInMainThreadToUI:(NARResponseErrorType)errorType;

@end
