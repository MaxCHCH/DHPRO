//
//  HotGameResponseParser.m
//  zhidoushi
//
//  Created by xinglei on 14/12/12.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "HotGameResponseParser.h"

#import "JSONKit.h"
#import "hotGameModel.h"
#import "WWTolls.h"
#import "NSDictionary+NARSafeDictionary.h"
#import "Define.h"
#import "NSObject+NARSerializationCategory.h"

@interface HotGameResponseParser ()
{
    NSMutableArray * modelArray;
}
@end

@implementation HotGameResponseParser

//解析返回的数据
-(void)parseBackJSONString:(NSString *)jsonString delegate:(id<NARURLConnectionDelegate>)delegate{

    modelArray = [[NSMutableArray alloc]initWithCapacity:4];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{//若解析量很大，则开启此线程

        //解析数据
        NSDictionary *jsonDictionary=[jsonString objectFromJSONString];
        NSLog(@"jsonDictionaryerrinfo_______%@",[jsonDictionary objectForKey:@"errinfo"]);

        NSArray * starCoachListArray = nil;
        if ([jsonDictionary objectForKeySafe:@"hotGameList"]) {
            starCoachListArray =  [[jsonDictionary objectForKeySafe:@"hotGameList"] restoreObjectsFromArray];

            [WWTolls setLocalArrayPlistInfo:(NSMutableArray*)starCoachListArray pathString:DOCUMENT_USER_GAMEARRAY  Key:@"hotGameDataListArray"];
        }else{
            starCoachListArray = [WWTolls getArrayPostList:@"hotGameDataListArray" andPathString:DOCUMENT_USER_GAMEARRAY];
        }
        for (int i =0; i<starCoachListArray.count; i++) {

            if (i<6) {
                
                hotGameModel *model = [[hotGameModel alloc]init];

                NSDictionary *imageDictionary = [starCoachListArray objectAtIndex:i];
                model.imageurl = [imageDictionary objectForKey:@"imageurl"];//游戏图像
                model.totalnumpeo = [imageDictionary objectForKey:@"totalnumpeo"];//游戏总人数
                model.totalnumdis = [imageDictionary objectForKey:@"totalnumdis"];//游戏讨论数
                model.gamename = [imageDictionary objectForKey:@"gamename"];//名字
                NSLog(@"_______%@",model.gamename);

                model.gameid = [imageDictionary objectForKey:@"gameid"];//游戏id
                [modelArray addObject:model];

            }
                  }

        if (delegate&&[delegate respondsToSelector:@selector(urlConnectionFinished:request:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [delegate urlConnectionFinished:modelArray request:nil];
            });
        }
#pragma mark - 废弃
        //            [[request responseParser] parseBackData:obj delegate:delegate];
        //             NSLog(@"obj------1------>>>>>>>>%@",obj);
        //        }
    });
}

@end
