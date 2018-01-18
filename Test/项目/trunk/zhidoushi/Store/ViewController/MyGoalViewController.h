//
//  MyGoalViewController.h
//  zhidoushi
//
//  Created by xinglei on 15/1/10.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//
//..我的积分..//
#import "BaseViewController.h"

@interface MyGoalViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *myscore;

@property (weak, nonatomic) IBOutlet UITableView *MyGoalTableView;

@property (weak, nonatomic) IBOutlet UIButton *goalButton;

@end
