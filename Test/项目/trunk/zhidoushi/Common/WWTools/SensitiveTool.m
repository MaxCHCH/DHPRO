//
//  SensitiveTool.m
//  zhidoushi
//
//  Created by nick on 15/7/30.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "SensitiveTool.h"

@implementation SensitiveTool

#pragma mark - 获取敏感词集合
+(NSSet *)getWordsSet{
    NSSet *wordSet = nil;
    NSArray *jsonArray = nil;
    if ([NSUSER_Defaults objectForKey:@"SensitiveWords"] == nil) {
        NSString *path;
        path = [[NSBundle mainBundle] pathForResource:@"sentiveWords" ofType:@"txt"];
        NSData *fileData = [NSData dataWithContentsOfFile:path];
        NSString *str = [[NSString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
        jsonArray = [str componentsSeparatedByString:@",\r\n"];
        [NSUSER_Defaults setObject:@"432821831959689" forKey:@"sensitivenanosec"];
        [NSUSER_Defaults setObject:jsonArray forKey:@"SensitiveWords"];
        [NSUSER_Defaults synchronize];
    }
    else {
        jsonArray = [NSUSER_Defaults objectForKey:@"SensitiveWords"];
    }
    wordSet = [NSSet setWithArray:jsonArray];
    return wordSet;
}

#pragma mark - 更新敏感词
+ (void)updateSensitiveWords{
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:5];
    NSSet *set =  [self getWordsSet];
    NSString *nanosec = [NSUSER_Defaults objectForKey:@"sensitivenanosec"];
    if(nanosec.length>0) [dictionary setObject:nanosec forKey:@"nanosec"];
    //发送请求最新敏感词
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_SENSITIVEWORD];
    [WWRequestOperationEngine operationManagerRequest_Post:urlString parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if ([dic isKindOfClass:[NSDictionary class]]) {
            NSArray *newWords = dic[@"mgclist"];
            if (newWords.count > 0) {
                //获取敏感词
                NSMutableSet *Words = [NSMutableSet setWithSet:set];
                for (NSDictionary *wordDic in newWords) {
                    if ([wordDic[@"status"] isEqualToString:@"1"]) {//删除
                        [Words removeObject:wordDic[@"mgcvalue"]];
                    }else{
                        [Words addObject:wordDic[@"mgcvalue"]];
                    }
                }
                //存储最新敏感词
                [NSUSER_Defaults setObject:[Words allObjects] forKey:@"SensitiveWords"];
                //记录纳秒数
                NSString  *nanosec = newWords[0][@"nanosec"];
                [NSUSER_Defaults setObject:nanosec forKey:@"sensitivenanosec"];
                [NSUSER_Defaults synchronize];
            }
        }
    }];

}

@end
