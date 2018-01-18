//
//  PublishTaskModel.h
//  zhidoushi
//
//  Created by licy on 15/6/24.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublishTaskModel : NSObject

//失败节点
@property (nonatomic,strong) NSString *errcode;//错误码
@property (nonatomic,strong) NSString *errinfo;//错误信息

//成功节点
/**
 *  0 处理成功
 1 处理失败
 */
@property (nonatomic,strong) NSString *result;//处理结果
@property (nonatomic,strong) NSString *pushtype;//推送类型
@property (nonatomic,strong) NSString *msgid;//通知ID
@property (nonatomic,strong) NSString *taskid;//任务ID

//显示在提示框中的内容
@property (nonatomic,strong) NSString *content;//通知内容

@end
