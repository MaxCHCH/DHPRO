//
//  CoachDetailResponseParser.m
//  zhidoushi
//
//  Created by xinglei on 14/12/11.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "CoachDetailResponseParser.h"

#import "JSONKit.h"
#import "CoachModel.h"

@interface CoachDetailResponseParser ()
{
    NSMutableArray * modelArray;
}
@end

@implementation CoachDetailResponseParser

//解析返回的数据
-(void)parseBackJSONString:(NSString *)jsonString delegate:(id<NARURLConnectionDelegate>)delegate{


    modelArray = [[NSMutableArray alloc]initWithCapacity:6];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{//若解析量很大，则开启此线程

        //解析数据
        NSDictionary *jsonDictionary=[jsonString objectFromJSONString];
//        NSLog(@"_______%@",jsonDictionary);
        NSArray * starCoachListArray = [jsonDictionary objectForKey:@"starCoachList"];
        NSLog(@"_______%@",starCoachListArray);

        for (int i =0; i<starCoachListArray.count; i++) {

            CoachModel *coach = [[CoachModel alloc]init];

            NSDictionary *imageDictionary = [starCoachListArray objectAtIndex:i];

            coach.imageurl = [imageDictionary objectForKey:@"imageurl"];//
            NSLog(@"%@",[imageDictionary objectForKey:@"imageurl"]);

            coach.flwstatus = [imageDictionary objectForKey:@"flwstatus"];//
            NSLog(@"%@", [imageDictionary objectForKey:@"flwstatus"]);

            coach.username = [imageDictionary objectForKey:@"username"];//
            NSLog(@"%@", [imageDictionary objectForKey:@"username"]);

            coach.userid = [imageDictionary objectForKey:@"userid"];//
            NSLog(@"%@", [imageDictionary objectForKey:@"userid"]);

            coach.usersign = [imageDictionary objectForKey:@"usersign"];//
            NSLog(@"%@", [imageDictionary objectForKey:@"usersign"]);

            [modelArray addObject:coach];
        }
         NSLog(@"￥￥￥￥￥￥￥%@",modelArray);

        if (delegate&&[delegate respondsToSelector:@selector(urlConnectionFinished:request:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [delegate urlConnectionFinished:modelArray request:nil];
            });
        }

    });
}

@end
