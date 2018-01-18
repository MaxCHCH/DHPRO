//
//  XLConnection.m
//  zhidoushi
//
//  Created by xinglei on 14-10-30.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "XLURLConnection.h"
#import "NARURLConnectionDelegate.h"

static NSMutableArray *sharedConnectionArray = nil;

@implementation XLURLConnection

@synthesize connectionBlock, request,paraDictionary,parser;

-(instancetype)initWithUrlString:(id)req paraMeter:(NSDictionary*)para parser:(NARResponseParser*)parser_{
    NSMutableDictionary *temp =[NSMutableDictionary dictionaryWithDictionary:para];
    temp[@"logintype"] = @"0";//登陆类型ios
    temp[@"channel"] = @"appstore";//下载渠道
    temp[@"version"] = @"ios_2.3";//版本

    self = [super init];
    if (self) {
        //给本类
        [self setRequest:req];
        [self setParaDictionary:temp];
        [self setParser:parser_];
    }
    return self;
}

-(void)start{
    
    [[WWURLConnection shareConnection]sendUrl:request parameter:paraDictionary parser:parser delegate:self];
    
    if (!sharedConnectionArray) {
        
        sharedConnectionArray = [[NSMutableArray alloc]initWithCapacity:1];
    }

    [sharedConnectionArray addObject:self];
}

#pragma mark - NARURLConnection delegate

- (void)urlConnectionFinished:(id)data request:(NARBaseRequest *)baseRequest {
    if (data == nil) {
         NSLog(@"****返回数据失败****");
        // 优质返回状态的情况
    }
    if (connectionBlock) {
        NSLog(@"****返回数据成功****");
        connectionBlock(data, nil);
    }
    [sharedConnectionArray removeObject:self];
}

- (void)urlConnectionFailed:(NARResponseErrorType)errorType request:(NARBaseRequest *)baseRequest {
    NSLog(@"请求数据错误 错误类型为 %d", errorType);
    if (connectionBlock) {
        NSString *err = [NSString stringWithFormat:@"%d", errorType];
        connectionBlock(nil, err);
    }
    [sharedConnectionArray removeObject:self];
}

- (void)dealloc
{
    NSLog(@"urlConnection release %lu", (unsigned long)sharedConnectionArray.count);
}

@end
