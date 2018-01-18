//
//  WWURLConnection.m
//  zhidoushi
//
//  Created by xinglei on 14-10-30.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "WWURLConnection.h"

#import "NARURLConnection.h"
#import "WWResponseParser.h"
#import "AFHTTPRequestOperationManager.h"

#import "JSONKit.h"

@implementation WWURLConnection

+(WWURLConnection *)shareConnection{
    static WWURLConnection *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance=[[WWURLConnection alloc]init];
        }
    });
    return instance;
}

-(id)init{
    if (self=[super init]) {
        //..已不需要..//
//        responseParser=[[WWResponseParser alloc]init];//*初始化WWResponseParser对象*//
    }
    return self;
}

-(void)sendUrl:(NSString *)baseUrl parameter:(NSDictionary*)para parser:(NARResponseParser*)responseParser delegate:(__weak id<NARURLConnectionDelegate>)delegate{

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    [manager POST:baseUrl parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *responseString=operation.responseString;
            #pragma -mark 请求完数据后进行解析
        [responseParser parseBackJSONString:responseString delegate:delegate];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
#pragma -mark 没有数据缓存
        [responseParser parseBackJSONString:nil delegate:delegate];
         NSLog(@"%@",error);
    }];
//     NSLog(@"baseRequest-----------------%@,%@",baseRequest.requestString,baseRequest);
//    
//    __autoreleasing AFHTTPRequestOperation *operation=[WWRequestAdapt NARRequestToUrlRequest2:baseRequest];
//
//    [baseRequest setConnectRequest:operation];//记录下这个请求数据使用的请求
//    
//    NSLog(@"baseRequest-----------------%@",baseRequest);
//
//    [baseRequest responseParser].delegate=delegate;
//    NSLog(@"baseRequest-----------------%@",baseRequest);
//
//    if (delegate&&[delegate respondsToSelector:@selector(urlConnectionBytesUploaded:totalSize:request:)]) {
//        [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//            [delegate urlConnectionBytesUploaded:totalBytesWritten totalSize:totalBytesExpectedToWrite request:baseRequest];
//        }];
//         NSLog(@"我执行了！！！！！");
//    }
//    
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operationt, id responseObject) {
//        @autoreleasepool {
//            NSString *responseString=operationt.responseString;
//             NSLog(@"___________%@",operationt.responseString);
//            NSLog(@"--->>>operation responseString=%@",[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
//    #pragma -mark 请求完数据后进行解析
//            [responseParser parseBackJSONString:responseString withRequest:baseRequest delegate:delegate];
//        }
//    } failure:^(AFHTTPRequestOperation *operationt, NSError *error) {
//        NSLog(@"--->>>operation error=%@",error);
//#pragma -mark 输出错误信息的回调、这里包含注销登录
//        [responseParser parseBackError:baseRequest delegate:delegate];
//        [responseParser parseBackJSONString:operationt.responseString withRequest:baseRequest delegate:delegate];
//
//    }];
//    [operation start];
//    return;
#pragma mark--废弃的部分
    //一般的请求使用asihttp//暂时未使用
//    ASIHTTPRequest *request=[WWRequestAdapt NARRRequestToUrlRequest:baseRequest];
//    [baseRequest setConnectRequest:request];//记录下这个请求数据使用的请求
//    [request setResponseEncoding:NSUTF8StringEncoding];
//    //可以处理代理
//    if (delegate&&[delegate respondsToSelector:@selector(urlConnectionBytesReceived:totalSize:request:)]) {
//        [request setBytesReceivedBlock:^(unsigned long long size, unsigned long long total) {
//            [delegate urlConnectionBytesReceived:size totalSize:total request:baseRequest];
//        }];
//    }
//    if (delegate&&[delegate respondsToSelector:@selector(urlConnectionBytesUploaded:totalSize:request:)]) {
//        //        long long postLength=[request postLength];
//        ASIHTTPRequest *tempRequest=request;
//        [request setUploadSizeIncrementedBlock:^(long long size) {
//            [delegate urlConnectionBytesUploaded:size totalSize:[tempRequest postLength] request:baseRequest];
//        }];
//    }
#if DEBUG
//    DLog(@"---->>>>request=%d，%@,%@,post=%@",[baseRequest requestID],[[request url] absoluteString],[request requestHeaders],[request postBody]);
//    if ([self testBackString:baseRequest]) {
//        [responseParser parseBackJSONString:[self testBackString:baseRequest] withRequest:baseRequest delegate:delegate];
//        return;
//    }
#endif
//    __block ASIHTTPRequest *blockRequest=request;//解除block强引用问题
//    [request setCompletionBlock:^{
//        NSString *responseString=[blockRequest responseString];
//        [responseParser parseBackJSONString:responseString withRequest:baseRequest delegate:delegate];
//    }];
//    [request setFailedBlock:^{
//        [responseParser parseBackError:baseRequest delegate:delegate];
//    }];
//    [request startAsynchronous];
}

@end
