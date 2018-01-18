//
//  CreateGroupOneViewController.h
//  zhidoushi
//
//  Created by nick on 15/5/15.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "BaseViewController.h"

@interface CreateGroupOneViewController : BaseViewController

//创建最早开始时间--上级页面传值
@property(strong,nonatomic) NSDate* theBeginDate;
//可选时间增加天数--上级页面传值
@property(assign,nonatomic) int days;
//游戏持续天数--上级页面传值
@property(assign,nonatomic) int gamedays;
@property(nonatomic,copy)NSString *Wheretag;//瘦哪里标签
@property (strong, nonatomic) UILabel *begintime;
@property (strong, nonatomic) UITextField *nameTextField;//名字输入框
@property(nonatomic,assign)BOOL isPassWordGrouper;//是否为密码团创建者
@end