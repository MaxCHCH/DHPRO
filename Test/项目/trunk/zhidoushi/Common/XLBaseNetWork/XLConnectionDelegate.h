//
//  XLConnectionDelegate.h
//  zhidoushi
//
//  Created by xinglei on 14-10-30.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XLBaseRequest.h"
#import "XLResponseError.h"

@protocol XLConnectionDelegate <NSObject>

@optional

-(void)urlConnectionBytesReceived:(unsigned long long)size totalSize:(unsigned long long)total request:(XLBaseRequest*)baseRequest;

-(void)urlConnectionBytesUploaded:(unsigned long long)size totalSize:(unsigned long long)total request:(XLBaseRequest*)baseRequest;

-(void)urlConnectionFinished:(id)data request:(XLBaseRequest*)baseRequest;

-(void)urlConnectionFailed:(XLResponseErrorType)errorType request:(XLBaseRequest*)baseRequest;

@end
