//
//  GroupTalkModel.h
//  zhidoushi
//
//  Created by xinglei on 14/12/24.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupTalkModel : NSObject

@property (nonatomic) long waittime;//冒泡等待时间（以秒为单位）
@property (nonatomic) int topcount;//当前置顶数
@property (nonatomic) int topupper;//置顶上限

@property(nonatomic,copy)NSString *talkid;//标题贴id
@property(nonatomic,copy)NSString * barid;//讨论Id / 冒泡Id / 活动Id
@property(nonatomic,copy)NSString * userid;//
@property(nonatomic,copy)NSString * username;//
@property(nonatomic,strong)NSString * userinfoimageurl;//用户头像
//活动和团聊中有 冒泡没有
@property(nonatomic,strong)NSString * createtime;//创建时间

/**
 *  0 否
 *  1 是
 */
@property(nonatomic,strong)NSString * istop;//是否置顶





/*
 0 : 团聊
 1 : 活动
 2 : 冒泡
 */  
@property(nonatomic,copy)NSString * bartype;//

//团聊特有
//@property(nonatomic,strong)NSString * talkcontent;//讨论内容
@property(nonatomic,strong)NSString * imageurl;//图像路径
@property(copy,nonatomic) NSString* logangle;//视角
@property(copy,nonatomic) NSString* goodSum;//点赞数量
@property(copy,nonatomic) NSString* goodStatus;//点赞状态


//活动特有
/*
 0：已参加
 1：为参加
 */
@property(copy,nonatomic) NSString* isjoin;//参与状态
//暂时弃用
@property(copy,nonatomic) NSString* acttime;//活动时间
@property(copy,nonatomic) NSString* place;//活动地点
@property(copy,nonatomic) NSString* content;//活动内容
@property(copy,nonatomic) NSString* partercount;//参与者人数
@property(copy,nonatomic) NSString* commentcount;//评论数
@property(copy,nonatomic) NSString* actdate;//活动日期
@property(copy,nonatomic) NSString* acttiming;//活动时间
//冒泡特有
@property(copy,nonatomic) NSString* usersign;//用户个性签名

//标题帖子
@property(nonatomic,copy)NSString *title;//标题贴标题
@property(nonatomic,copy)NSString *talkcontent;//标题帖内容
@property(nonatomic,copy)NSString *isparter;//是否为参与者
@property(nonatomic,copy)NSString *pageview;//游览量
@property(nonatomic,copy)NSString *praisecount;//精华帖点赞量
+(instancetype)modelWithDic:(NSDictionary*)dic;
-(instancetype)initWithDic:(NSDictionary*)dic;
@end












