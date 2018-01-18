//
//  WillBeginGameResponseParser.m
//  zhidoushi
//
//  Created by xinglei on 14/12/10.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "WillBeginGameResponseParser.h"

#import "JSONKit.h"
#import "WillBeginCollectionModel.h"
#import "WWTolls.h"
#import "Define.h"
#import "NSDictionary+NARSafeDictionary.h"
#import "NSObject+NARSerializationCategory.h"

@interface WillBeginGameResponseParser ()
{
    NSMutableArray * starArray;
}
@end

@implementation WillBeginGameResponseParser

//解析返回的数据
-(void)parseBackJSONString:(NSString *)jsonString delegate:(id<NARURLConnectionDelegate>)delegate{

    starArray = [[NSMutableArray alloc]initWithCapacity:4];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{//若解析量很大，则开启此线程

        //解析数据
        NSDictionary *jsonDictionary=[jsonString objectFromJSONString];
         NSLog(@"即将开始的游戏_______%@",jsonDictionary);

        NSArray * starCoachListArray = nil;

        if ([jsonDictionary objectForKeySafe:@"upcomingGameList"]) {
            starCoachListArray = [[jsonDictionary objectForKeySafe:@"upcomingGameList"] restoreObjectsFromArray] ;
//            [WWTolls setLocalArrayPlistInfo:(NSMutableArray*)starCoachListArray pathString:DOCUMENT_USER_GAMEARRAY  Key:@"willBeginDataListArray"];
        }else{
//            starCoachListArray = [WWTolls getArrayPostList:@"willBeginDataListArray" andPathString:DOCUMENT_USER_GAMEARRAY];
        }

        for (int i =0; i<starCoachListArray.count; i++) {
            WillBeginCollectionModel *model = [[WillBeginCollectionModel alloc]init];
            NSDictionary *imageDictionary = [starCoachListArray objectAtIndex:i];
            model.imageurl = [imageDictionary objectForKey:@"imageurl"];//游戏图像
            model.totalnumpeo = [imageDictionary objectForKey:@"totalnumpeo"];//游戏总人数
            model.totalnumdis = [imageDictionary objectForKey:@"totalnumdis"];//游戏讨论数
            model.gamename = [imageDictionary objectForKey:@"gamename"];//名字
            model.gameid = [imageDictionary objectForKey:@"gameid"];//
            [starArray addObject:model];
        }

        if (delegate&&[delegate respondsToSelector:@selector(urlConnectionFinished:request:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [delegate urlConnectionFinished:starArray request:nil];
            });
        }
#pragma mark - 废弃
        //            [[request responseParser] parseBackData:obj delegate:delegate];
        //             NSLog(@"obj------1------>>>>>>>>%@",obj);
        //        }
    });
}

@end
