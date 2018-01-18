//
//  WillBeginResponseParser.m
//  zhidoushi
//
//  Created by xinglei on 14/12/10.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "WillBeginResponseParser.h"

#import "JSONKit.h"
#import "WWTolls.h"
#import "NSDictionary+NARSafeDictionary.h"
#import "Define.h"
#import "NSObject+NARSerializationCategory.h"
#import "CoachImageModel.h"

@interface WillBeginResponseParser()
{

    NSMutableArray * starArray;
}
@end

@implementation WillBeginResponseParser

//解析返回的数据
-(void)parseBackJSONString:(NSString *)jsonString delegate:(id<NARURLConnectionDelegate>)delegate{

    starArray = [[NSMutableArray alloc]initWithCapacity:3];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{//若解析量很大，则开启此线程

        //解析数据
        NSDictionary *jsonDictionary=[jsonString objectFromJSONString];

        NSArray * starCoachListArray = nil;

         NSLog(@"明星教练所有数据%@",jsonDictionary);

        NSLog(@"%@",[jsonDictionary objectForKey:@"errinfo"]);

//        NSArray * starCoachListArray = [jsonDictionary objectForKey:@"starCoachList"];

        if ([jsonDictionary objectForKeySafe:@"starCoachList"]) {

            starCoachListArray =  [[jsonDictionary objectForKeySafe:@"starCoachList"] restoreObjectsFromArray];
            [WWTolls setLocalArrayPlistInfo:(NSMutableArray*)starCoachListArray pathString:DOCUMENT_USER_GAMEARRAY  Key:@"coachDataListArray"];
        }else{

            starCoachListArray = [WWTolls getArrayPostList:@"coachDataListArray" andPathString:DOCUMENT_USER_GAMEARRAY];
        }


//        if (data && data!=nil) {
//            [WWTolls setLocalArrayPlistInfo:data pathString:DOCUMENT_USER_GAMEARRAY  Key:@"coachDataListArray"];
//        }
//        NSLog(@"***回调成功***%@",data);
//
//        [coachImageView configureView: [WWTolls getArrayPostList:@"coachDataListArray" andPathString:DOCUMENT_USER_GAMEARRAY] nameArray_1:nil];
//        NSLog(@"返回出现错误%@",error);

        for (int i =0; i<starCoachListArray.count; i++) {
            CoachImageModel *coachModel = [[CoachImageModel alloc]init];
            NSDictionary *imageDictionary = [starCoachListArray objectAtIndex:i];
            coachModel.imageurl = [imageDictionary objectForKey:@"imageurl"];
            coachModel.username = [imageDictionary objectForKey:@"username"];
            coachModel.userid = [imageDictionary objectForKey:@"userid"];
            [starArray addObject:coachModel];
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
