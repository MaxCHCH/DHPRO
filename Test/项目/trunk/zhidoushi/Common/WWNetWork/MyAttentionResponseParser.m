//
//  MyAttentionResponseParser.m
//  zhidoushi
//
//  Created by xinglei on 15/1/5.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "MyAttentionResponseParser.h"

#import "JSONKit.h"
#import "CoachModel.h"

@interface MyAttentionResponseParser ()
{
    NSMutableArray * modelArray;
}
@end

@implementation MyAttentionResponseParser

//解析返回的数据
-(void)parseBackJSONString:(NSString *)jsonString delegate:(id<NARURLConnectionDelegate>)delegate{


        modelArray = [[NSMutableArray alloc]initWithCapacity:6];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{//若解析量很大，则开启此线程

        //解析数据
        NSDictionary *jsonDictionary=[jsonString objectFromJSONString];

        NSArray * starCoachListArray = nil;

        NSLog(@" 获取我关注列表信息_______%@",jsonDictionary);
        if ([self.atype isEqualToString:@"1"]) {
            starCoachListArray = [jsonDictionary objectForKey:@"flwList"];
        }
        else if ([self.atype isEqualToString:@"2"]){
            starCoachListArray = [jsonDictionary objectForKey:@"fansList"];
        }
        else {
            starCoachListArray = [jsonDictionary objectForKey:@"newFriendList"];
        }
        NSLog(@"关注列表数组_______%@",starCoachListArray);

        for (int i =0; i<starCoachListArray.count; i++) {

            CoachModel *coach = [[CoachModel alloc]init];

            NSDictionary *imageDictionary = [starCoachListArray objectAtIndex:i];

//            NSDictionary *bizUserinfBaseModelDictionary = [imageDictionary objectForKey:@"bizUserinfBaseModel"];

            if ([self.atype isEqualToString:@"1"]) {
                coach.userid = [imageDictionary objectForKey:@"rcvuserid"];
                coach.flwstatus = [imageDictionary objectForKey:@"flwstatus"];
            }
            else if ([self.atype isEqualToString:@"2"]){
                coach.userid = [imageDictionary objectForKey:@"snduserid"];
                coach.flwstatus = [imageDictionary objectForKey:@"flwstatus"];
            }
            else{
//                NSDictionary *bizInteractFnsflwModelDictionary = [imageDictionary objectForKey:@"bizInteractFnsflwModel"];
                coach.userid = [imageDictionary objectForKey:@"userid"];
                coach.flwstatus = [imageDictionary objectForKey:@"flwstatus"];
            }
            coach.usersex = [imageDictionary objectForKey:@"usersex"];
            coach.imageurl = [imageDictionary objectForKey:@"imageurl"];

            coach.usersign = [imageDictionary objectForKey:@"usersign"];

            coach.username = [imageDictionary objectForKey:@"username"];

            [modelArray addObject:coach];
        }

        if (delegate&&[delegate respondsToSelector:@selector(urlConnectionFinished:request:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [delegate urlConnectionFinished:modelArray request:nil];
            });
        }
        
    });
}

@end
