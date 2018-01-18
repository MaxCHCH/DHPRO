//
//  UrgettaskModel.h
//  zhidoushi
//
//  Created by licy on 15/6/24.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UrgettaskModel : NSObject

//失败节点
/**
 *  发生错误时返回
    1、当前用户非团组参与者，返回GAM048 “当前用户无权限”
    2、任务已发布，返回GAM050 “已存在团组任务”
    3、参与者已发送过催促通知，返回GAM051 “重复发送催促团长发任务”
 */
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

//显示在提示框中的内容
@property (nonatomic,strong) NSString *content;//通知内容

@end
