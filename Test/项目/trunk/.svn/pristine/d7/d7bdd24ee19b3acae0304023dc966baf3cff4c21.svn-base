//
//  NARBaseResponse.m
//  zhidoushi
//
//  Created by xinglei on 14-10-30.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "NARBaseResponse.h"

@implementation NARBaseResponse

-(id)init{
    if (self=[super init]) {
        if (![self respondsToSelector:@selector(parseBackData:delegate:)]||![self respondsToSelector:@selector(parseBackError:delegate:)]) {
            NSAssert(false, @"you need to overwrite the parseBackData:delegate: and parseBackError:delegate: method");
        }
    }
    return self;
}

-(void)showFinishedResultDataInMainThreadToUI:(id)resultData{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(urlConnectionFinished:request:)]) {
        if ([NSThread isMainThread]) {
            [self.delegate urlConnectionFinished:resultData request:self.request];
        }else{
            __strong __block id requestObj=self.request;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate urlConnectionFinished:resultData request:requestObj];
                requestObj=nil;
            });
        }
    }
}

-(void)showErrorResultInMainThreadToUI:(NARResponseErrorType)errorType{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(urlConnectionFailed:request:)]) {
        if ([NSThread isMainThread]) {
            [self.delegate urlConnectionFailed:errorType request:self.request];
        }else{
            if (self.delegate&&[self.delegate respondsToSelector:@selector(urlConnectionFailed:request:)]) {
                __strong __block id requestObj=self.request;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate urlConnectionFailed:errorType request:requestObj];
                    requestObj=nil;
                });
            }
        }
    }
}

-(void)parseBackData:(id)backData delegate:(id<NARURLConnectionDelegate>)delegate{


}

-(void)parseBackError:(NARResponseErrorType)errorType delegate:(id<NARURLConnectionDelegate>)delegate{


}

@end
