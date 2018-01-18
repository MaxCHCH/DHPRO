//
//  NARURLConnectionDelegate.h
//  zhidoushi
//
//  Created by xinglei on 14-10-30.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NARBaseRequest.h"
#import "NARResponseError.h"

@protocol NARURLConnectionDelegate <NSObject>

@optional

-(void)urlConnectionBytesReceived:(unsigned long long)size totalSize:(unsigned long long)total request:(NARBaseRequest*)baseRequest;

-(void)urlConnectionBytesUploaded:(unsigned long long)size totalSize:(unsigned long long)total request:(NARBaseRequest*)baseRequest;

-(void)urlConnectionFinished:(id)data request:(NARBaseRequest*)baseRequest;

-(void)urlConnectionFailed:(NARResponseErrorType)errorType request:(NARBaseRequest*)baseRequest;

@end
