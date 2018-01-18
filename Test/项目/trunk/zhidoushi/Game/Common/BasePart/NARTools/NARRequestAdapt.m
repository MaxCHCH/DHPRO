//
//  NARRequestAdapt.m
//  zhidoushi
//
//  Created by xinglei on 14-10-30.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "NARRequestAdapt.h"

@implementation NARRequestAdapt

+(id)NARRequestToUrlRequest:(NARBaseRequest*)baseRequest
{
    if (!baseRequest) {
        return nil;
    }
    if ([baseRequest requestID]==-1) {
        NSAssert(false, @"the request %@ need to set the request id",baseRequest);
    }
    
    if (![baseRequest respondsToSelector:@selector(requestPropertyToDictionary)]) {
        NSAssert(false, @"the request %@ need to implement the method (requestParametersToDictionary)",baseRequest);
    }
    return baseRequest;
}

@end
