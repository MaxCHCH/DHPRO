//
//  NARBaseRequest.m
//  zhidoushi
//
//  Created by xinglei on 14-10-30.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "NARBaseRequest.h"

@implementation NARBaseRequest

@synthesize requestString;

-(id)init{
    if (self=[super init]) {
        _requestString = @"1";
        _timeoutInterval=30;
    }
    if (![self respondsToSelector:@selector(requestPropertyToDictionary)]||![self respondsToSelector:@selector(responseParser)]) {
        NSAssert(false, @"you need to overwrite the requestPropertyToDictionary and responseParser method");
    }
    return self;
}

-(void)dealloc{
    XLRelease(_connectRequest);
    XLRelease(_responseParser);
    XLDealloc(super);
}

@end
