//
//  WWResponseParser.m
//  zhidoushi
//
//  Created by xinglei on 14-10-30.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "WWResponseParser.h"

#import "JSONKit.h"
#import "WWBaseRequest.h"
#import "NARBaseResponse.h"

@implementation WWResponseParser

//请求中发生了错误
-(void)parseBackError:(NARBaseRequest *)request delegate:(id<NARURLConnectionDelegate>)delegate{
    NSLog(@"request=-----%@",[[request connectRequest]error]);
    if (!request) {
        NSLog(@"-->>parseBackJSONString find request nil");
    }
    switch ([request requestID])
    {
        case 10:
        {//是登录
            break;
        }
        case 0:
        {//是。。
            break;
        }
        default:
            break;
    }
    //*无网络情况下*//
    [self doParseError:NARResponseError_NoNetwork request:request delegate:delegate];
}

//具体的错误返回处理
-(void)doParseError:(NARResponseErrorType)errorType request:(NARBaseRequest*)request delegate:(id<NARURLConnectionDelegate>)delegate{
    [[request responseParser]parseBackError:errorType delegate:delegate];
}

//解析返回的数据
-(void)parseBackJSONString:(NSString *)jsonString delegate:(id<NARURLConnectionDelegate>)delegate{

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{//若解析量很大，则开启此线程

        //解析数据
        NSDictionary *jsonDictionary=[jsonString objectFromJSONString];

//         NSLog(@"%@",jsonDictionary);

//        NSArray * starCoachListArray = [jsonDictionary objectForKey:@"starCoachList"];

        if (delegate&&[delegate respondsToSelector:@selector(urlConnectionFinished:request:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
//                [delegate urlConnectionFinished:starCoachListArray request:nil];
            });
        }
#pragma mark - 废弃
//            [[request responseParser] parseBackData:obj delegate:delegate];
//             NSLog(@"obj------1------>>>>>>>>%@",obj);
//        }
    });
}

@end
