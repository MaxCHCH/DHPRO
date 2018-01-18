//
//  TeamMemberResponseParser.m
//  zhidoushi
//
//  Created by xinglei on 14/12/28.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "TeamMemberResponseParser.h"

#import "JSONKit.h"
#import "TeamMemberModel.h"

@interface TeamMemberResponseParser ()
{
    NSMutableArray * modelArray;
}
@end

@implementation TeamMemberResponseParser

//解析返回的数据
-(void)parseBackJSONString:(NSString *)jsonString delegate:(id<NARURLConnectionDelegate>)delegate{


    modelArray = [[NSMutableArray alloc]initWithCapacity:6];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{//若解析量很大，则开启此线程

        //解析数据
        NSDictionary *jsonDictionary=[jsonString objectFromJSONString];
                NSLog(@"jsonDictionary_______%@",jsonDictionary);
        NSArray * starCoachListArray = [jsonDictionary objectForKey:@"parterList"];
        int partercount = [NSString stringWithFormat:@"%@",[jsonDictionary objectForKey:@"partercount"]].intValue;
        NSLog(@"starCoachListArray_______%@",starCoachListArray);

        for (int i =0; i<starCoachListArray.count; i++) {

            TeamMemberModel *coach = [[TeamMemberModel alloc]init];

            NSDictionary *imageDictionary = [starCoachListArray objectAtIndex:i];
            NSDictionary * userinfoDictionary = [imageDictionary objectForKey:@"userinfo"];

            coach.imageurl = [userinfoDictionary objectForKey:@"imageurl"];//
            NSLog(@"&&--%@",[userinfoDictionary objectForKey:@"imageurl"]);

            coach.flwstatus = [userinfoDictionary objectForKey:@"flwstatus"];//
            NSLog(@"&&--%@", [userinfoDictionary objectForKey:@"flwstatus"]);

            coach.username = [userinfoDictionary objectForKey:@"username"];//
            NSLog(@"&&--%@", [userinfoDictionary objectForKey:@"username"]);

            coach.userid = [userinfoDictionary objectForKey:@"userid"];//
            NSLog(@"&&--%@", [userinfoDictionary objectForKey:@"userid"]);

            coach.usersign = [userinfoDictionary objectForKey:@"usersign"];//
            NSLog(@"&&--%@", [userinfoDictionary objectForKey:@"usersign"]);

            coach.partercount = partercount;

            NSLog(@"&&--%d",partercount);

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
