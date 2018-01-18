//
//  AwardListResponseParser.m
//  zhidoushi
//
//  Created by xinglei on 14/12/12.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "AwardListResponseParser.h"

#import "JSONKit.h"
#import "WWTolls.h"
#import "NSDictionary+NARSafeDictionary.h"
#import "Define.h"
#import "NSObject+NARSerializationCategory.h"

@interface AwardListResponseParser()
{
    
    NSMutableArray * starArray;
}
@end

@implementation AwardListResponseParser

//解析返回的数据
-(void)parseBackJSONString:(NSString *)jsonString delegate:(id<NARURLConnectionDelegate>)delegate{
    NSMutableArray * imageurlArray = [[NSMutableArray alloc]initWithCapacity:6];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{//若解析量很大，则开启此线程
        //解析数据
        NSDictionary *jsonDictionary=[jsonString objectFromJSONString];
        NSArray * starCoachListArray = nil;
        if ([jsonDictionary objectForKeySafe:@"prizeList"]) {
            starCoachListArray = [[jsonDictionary objectForKeySafe:@"prizeList"] restoreObjectsFromArray];
            [WWTolls setLocalArrayPlistInfo:(NSMutableArray*)starCoachListArray pathString:DOCUMENT_USER_GAMEARRAY  Key:@"awardDataListArray"];
        }else{
            starCoachListArray =  [WWTolls getArrayPostList:@"awardDataListArray" andPathString:DOCUMENT_USER_GAMEARRAY];
        }
         NSLog(@"商品信息*********%@",jsonDictionary);
        for (int i =0; i<starCoachListArray.count; i++) {
            NSDictionary *imageDictionary = [starCoachListArray objectAtIndex:i];
            //NSString *imageurl = [imageDictionary objectForKey:@"imageurl1"];
            
            [imageurlArray addObject:imageDictionary];
        }
        NSLog(@"图片数组imageurlArray_________%@",imageurlArray);
        if (delegate&&[delegate respondsToSelector:@selector(urlConnectionFinished:request:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [delegate urlConnectionFinished:imageurlArray request:nil];
            });
        }
    });
}

@end
