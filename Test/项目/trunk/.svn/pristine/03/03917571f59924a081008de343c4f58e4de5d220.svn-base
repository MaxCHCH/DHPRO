//
//  GroupTalkDetailViewController.h
//  zhidoushi
//
//  Created by nick on 15/5/14.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "BaseViewController.h"
typedef enum {
    GroupSimpleTalkType,//简单帖子
    GroupTitleTalkType//标题帖
} GroupTalkType;

@interface GroupTalkDetailViewController : BaseViewController
{
    UIControl *contro;
}
@property(nonatomic,strong)NSString * talkid;//讨论ID
@property(nonatomic,assign)GroupTalkType talktype;//帖子类型
@property(nonatomic,copy)NSString *gamename;//团组名称

@property(nonatomic,copy)NSString *groupId;//团组id
/**
 1撒欢广场
 2动态
 3搜索
 4团组
 5动静
 **/
@property(nonatomic,assign)int clickevent;//数据来源

@property(nonatomic,assign)BOOL isShowTopBtn;//是否显示置顶
@end
