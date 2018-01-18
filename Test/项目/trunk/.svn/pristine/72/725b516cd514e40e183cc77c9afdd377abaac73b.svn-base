//
//  NARBaseRequest.h
//  zhidoushi
//
//  Created by xinglei on 14-10-30.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NARBaseResponse;

@interface NARBaseRequest : NSObject
{
    int _requestID;//请求号
    NARBaseResponse *_responseParser;
    NSString *_requestString;//请求地址
}

@property (assign,nonatomic) int requestID;
@property (weak,nonatomic) id connectRequest;
@property (assign,nonatomic) NSInteger tag;//可自己控制的tag值
@property(nonatomic,strong)NSString * requestString;
@property (assign,nonatomic) NSTimeInterval timeoutInterval;//超时时间

-(NSDictionary*)requestPropertyToDictionary;
-(NARBaseResponse*)responseParser;

@end
