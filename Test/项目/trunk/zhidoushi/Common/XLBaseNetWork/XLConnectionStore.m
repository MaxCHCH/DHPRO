//
//  XLConnectionStore.m
//  zhidoushi
//
//  Created by xinglei on 14-10-29.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "XLConnectionStore.h"

#import "XLURLConnection.h"
//..privateParser..//
//#import "HotGameResponseParser.h"
//#import "AwardListResponseParser.h"
//#import "WillBeginResponseParser.h"
//#import "TeamMemberResponseParser.h"
#import "CoachDetailResponseParser.h"
#import "MyAttentionResponseParser.h"
//#import "WillBeginGameResponseParser.h"
//#import "WillBeginDetailResponseParser.h"
//..gateGory..//
#import "NSString+NARSafeString.h"
#import "Define.h"

@implementation XLConnectionStore

+(XLConnectionStore*)shareConnectionStore{

    static XLConnectionStore * xlStore;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!xlStore) {
            xlStore = [[XLConnectionStore alloc]init];
        }
    });
        return xlStore;
}

#pragma mark - 构建大厅请求数据Url字典
-(NSMutableDictionary*)createDictionary:(NSString*)loadType{
    NSString *userID =  [NSUSER_Defaults objectForKey:ZDS_USERID];
    NSString *userid = [NSString stringWithFormat:@"%@",userID];
    NSString *key = [NSString getMyKey:userID];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:7];
    [dic setObject:userid forKey:@"userid"];
    [dic setObject:key forKey:@"key"];
    [dic setObject:@"4" forKey:@"adcount"];
    [dic setObject:@"8" forKey:@"startcount"];
    [dic setObject:@"6" forKey:@"comingcount"];
    [dic setObject:@"6" forKey:@"hotcount"];
    [dic setObject:@"6" forKey:@"prizecount"];
    [dic setObject:loadType forKey:@"loadtype"];
     NSLog(@"userID____-%@",dic);
    return dic;
}

//#pragma mark - 明星教练数量
//- (void)getCoachListWithPage:(int)page andComplection:(XLDataStoreBlock)block
//{
//    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_GAMELOBBY_LIST];
//    WillBeginResponseParser *will = [[WillBeginResponseParser alloc]init];
//    XLURLConnection *connection = [[XLURLConnection alloc]initWithUrlString:urlString paraMeter:[self createDictionary:@"2"] parser:will];
//    [self startConnection:connection XLDataStoreBlock:block];
//}
//
//- (void)getAwardListWithPage:(int)page andComplection:(XLDataStoreBlock)block
//{
//    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_GAMELOBBY_LIST];
//    AwardListResponseParser *will = [[AwardListResponseParser alloc]init];
//    XLURLConnection *connection = [[XLURLConnection alloc]initWithUrlString:urlString paraMeter:[self createDictionary:@"5"] parser:will];
//    [self startConnection:connection XLDataStoreBlock:block];
//}
//
//- (void)getWillBegainGamePacketListWithPage:(int)page andUserSelf:(BOOL)isUserSelf andUserID:(NSString*)userID andUserKey:(NSString*)key andComplection:(XLDataStoreBlock)block
//{
//    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_GAMELOBBY_LIST];
//    WillBeginGameResponseParser *game = [[WillBeginGameResponseParser alloc]init];
//    XLURLConnection *connection = [[XLURLConnection alloc]initWithUrlString:urlString paraMeter:[self createDictionary:@"3"] parser:game];
//    [self startConnection:connection XLDataStoreBlock:block];
//}

-(void)getCoachDetailListWithPageNum:(NSString*)page andPageSize:(NSString*)size andUserid:(NSString*)userid andKey:(NSString*)key andComplection:(XLDataStoreBlock)block;
{
    NSString *urlString =[NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_STARCOACH];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:4];
    [dic setObject:[NSString stringWithFormat:@"%@",userid]forKey:@"userid"];
    [dic setObject:[NSString stringWithFormat:@"%@",key] forKey:@"key"];
    [dic setObject:[NSString stringWithFormat:@"%@",page] forKey:@"pageNum"];
    [dic setObject:[NSString stringWithFormat:@"%@",size] forKey:@"pageSize"];
     NSLog(@"%@",dic);
    CoachDetailResponseParser *coach = [[CoachDetailResponseParser alloc]init];
    XLURLConnection *connection = [[XLURLConnection alloc]initWithUrlString:urlString paraMeter:dic parser:coach];
    [self startConnection:connection XLDataStoreBlock:block];
}

-(void)getAttentionListWithPageNum:(NSString*)page andPageSize:(NSString*)size andURL:(NSString*)and_url andUserid:(NSString*)userid andKey:(NSString*)key  andAttentionType:(NSString*)atype andComplection:(XLDataStoreBlock)block;
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:4];
    [dic setObject:[NSString stringWithFormat:@"%@",userid]forKey:@"userid"];
    [dic setObject:[NSString stringWithFormat:@"%@",key] forKey:@"key"];
    [dic setObject:[NSString stringWithFormat:@"%@",page] forKey:@"pageNum"];
    [dic setObject:[NSString stringWithFormat:@"%@",size] forKey:@"pageSize"];
    NSLog(@"%@",dic);
    MyAttentionResponseParser *coach = [[MyAttentionResponseParser alloc]init];
    coach.atype = atype;
    XLURLConnection *connection = [[XLURLConnection alloc]initWithUrlString:and_url paraMeter:dic parser:coach];
    [self startConnection:connection XLDataStoreBlock:block];
}

//-(void)getTeamMemberListWithPageNum:(NSString*)page andPageSize:(NSString*)size andUserid:(NSString*)userid andKey:(NSString*)key andGameid:(NSString*)gameid andComplection:(XLDataStoreBlock)block;
//{
//    NSString *urlString =[NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_PARTERGAME];
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:4];
//    [dic setObject:[NSString stringWithFormat:@"%@",userid]forKey:@"userid"];
//    [dic setObject:[NSString stringWithFormat:@"%@",key] forKey:@"key"];
//    [dic setObject:[NSString stringWithFormat:@"%@",page] forKey:@"pageNum"];
//    [dic setObject:[NSString stringWithFormat:@"%@",size] forKey:@"pageSize"];
//    [dic setObject:[NSString stringWithFormat:@"%@",gameid] forKey:@"gameid"];
//    NSLog(@"%@",dic);
//    TeamMemberResponseParser *team = [[TeamMemberResponseParser alloc]init];
//    XLURLConnection *connection = [[XLURLConnection alloc]initWithUrlString:urlString paraMeter:dic parser:team];
//    [self startConnection:connection XLDataStoreBlock:block];
//
//}

//-(void)getWillBeginDetailListWithPageNum:(NSInteger)page andPageSize:(NSInteger)size andUserid:(NSString*)userid andKey:(NSString*)key andComplection:(XLDataStoreBlock)block;
//{
//    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_UPCOMING];
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:4];
//    [dic setObject:[NSString stringWithFormat:@"%@",userid]forKey:@"userid"];
//    [dic setObject:[NSString stringWithFormat:@"%@",key] forKey:@"key"];
//    [dic setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"pageNum"];
//    [dic setObject:[NSString stringWithFormat:@"%ld",(long)size] forKey:@"pageSize"];
//    NSLog(@"%@",dic);
//    WillBeginDetailResponseParser *begin = [[WillBeginDetailResponseParser alloc]init];
//    XLURLConnection *connection = [[XLURLConnection alloc]initWithUrlString:urlString paraMeter:dic parser:begin];
//    [self startConnection:connection XLDataStoreBlock:block];
//}
//
//- (void)getWillHotGamePacketListWithPage:(int)page andUserSelf:(BOOL)isUserSelf andUserID:(NSString*)userID andUserKey:(NSString*)key andComplection:(XLDataStoreBlock)block;
//{
//    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_GAMELOBBY_LIST];
//    HotGameResponseParser *game = [[HotGameResponseParser alloc]init];
//    XLURLConnection *connection = [[XLURLConnection alloc]initWithUrlString:urlString paraMeter:[self createDictionary:@"4"] parser:game];
//    [self startConnection:connection XLDataStoreBlock:block];
//
//}

#pragma mark - 回调并开启解析器
-(void)startConnection:(XLURLConnection*)connection XLDataStoreBlock:(XLDataStoreBlock)block{
    [connection setConnectionBlock:block];
    [connection start];
}

@end
