//
//  WillBeginDetailResponseParser.m
//  zhidoushi
//
//  Created by xinglei on 14/12/11.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "WillBeginDetailResponseParser.h"

#import "JSONKit.h"
#import "WillBeginDetailModel.h"

@interface WillBeginDetailResponseParser ()
{
    NSMutableArray * modelArray;
}
@end

@implementation WillBeginDetailResponseParser

//解析返回的数据
-(void)parseBackJSONString:(NSString *)jsonString delegate:(id<NARURLConnectionDelegate>)delegate{

    modelArray = [[NSMutableArray alloc]initWithCapacity:7];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{//若解析量很大，则开启此线程

        //解析数据
        NSDictionary *jsonDictionary=[jsonString objectFromJSONString];
        NSLog(@"upcomingGameList_______%@",jsonDictionary);

        NSArray * starCoachListArray = [jsonDictionary objectForKey:@"upcomingGameList"];

//        NSLog(@"_______%@",starCoachListArray);

        for (int i =0; i<starCoachListArray.count; i++) {

            WillBeginDetailModel *willBegin = [[WillBeginDetailModel alloc]init];

            NSDictionary *imageDictionary = [starCoachListArray objectAtIndex:i];

            willBegin.imageurl = [imageDictionary objectForKey:@"imageurl"];//

            willBegin.gameid = [imageDictionary objectForKey:@"gameid"];

            willBegin.username = [imageDictionary objectForKey:@"username"];//

            willBegin.totalnumpeo = [imageDictionary objectForKey:@"totalnumpeo"];//

            willBegin.gmphase = [imageDictionary objectForKey:@"gmphase"];
            willBegin.frombghours = [imageDictionary objectForKey:@"frombghours"];
            willBegin.totalnumdis = [imageDictionary objectForKey:@"totalnumdis"];//

            willBegin.gamename = [imageDictionary objectForKey:@"gamename"];//

            [modelArray addObject:willBegin];
        }
        NSLog(@"__________%@",modelArray);

        if (delegate&&[delegate respondsToSelector:@selector(urlConnectionFinished:request:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [delegate urlConnectionFinished:modelArray request:nil];
            });
        }
        
    });
}

@end
