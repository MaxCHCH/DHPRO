//
//  WWRequestAdapt.m
//  zhidoushi
//
//  Created by xinglei on 14-10-30.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "WWRequestAdapt.h"

#import "GlobalUse.h"
#import "AFNetworking.h"
#import "AFHTTPRequestOperationManager.h"

@implementation WWRequestAdapt

+(AFHTTPRequestOperation*)NARRequestToUrlRequest2:(WWBaseRequest*)baseRequest{

    if (!baseRequest) {
        return nil;
    }
    if ([baseRequest requestID]==-1) {
        NSAssert(false, @"the request %@ need to set the request id",baseRequest);
    }
    if (![baseRequest respondsToSelector:@selector(requestPropertyToDictionary)]) {
        NSAssert(false, @"the request %@ need to implement the method (requestParametersToDictionary)",baseRequest);
    }
    
    NSLog(@"baseRequest.requestString_____%@",baseRequest.requestString);

    NSString *requestString = ZDS_DEFAULT_HTTP_SERVER_HOST;//服务器地址

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:requestString]];

    [request setTimeoutInterval:baseRequest.timeoutInterval];

    __autoreleasing AFHTTPRequestOperation *operation=[[AFHTTPRequestOperation alloc]initWithRequest:request];

    return operation;
    
}

@end
