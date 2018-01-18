//
//  XLBaseRequest.h
//  zhidoushi
//
//  Created by xinglei on 14-10-30.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XLBaseResponse;

@interface XLBaseRequest : NSObject{
    int _requestID;//请求号
    XLBaseResponse *_responseParser;
    NSString *_requestString;
}

@property (assign,nonatomic) int requestID;
@property (weak,nonatomic) id connectRequest;
@property (assign,nonatomic) NSInteger tag;//可自己控制的tag值
@property (assign,nonatomic) NSTimeInterval timeoutInterval;//超时时间
@property(nonatomic,strong)NSString * requestString;

-(NSDictionary*)requestPropertyToDictionary;
-(XLBaseResponse*)responseParser;

@end
