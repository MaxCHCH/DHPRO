//
//  taskDetailViewController.h
//  zhidoushi
//
//  Created by nick on 15/9/21.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import "BaseViewController.h"

@interface taskDetailViewController : BaseViewController
@property(nonatomic,copy)NSString *gameId;//团组id
@property(nonatomic,copy)NSString *password;//密码
@property(nonatomic,copy)NSString *taskId;//任务id
@property(nonatomic,copy)NSString *taskMonth;//这个任务月份
@property(nonatomic,copy)NSString *taskNum;//这个任务
@property(nonatomic,copy)NSString *nextMonth;//月份
@property(nonatomic,copy)NSString *nextNum;//下个任务
@property(nonatomic,copy)NSString *gameAngle;//访客
@property(nonatomic,copy)NSString *gameName;//名称

@end
