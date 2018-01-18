//
//  PlanViewController.h
//  zhidoushi
//
//  Created by xinglei on 14/12/16.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "BaseViewController.h"

#import "PlanTableViewCell.h"
@interface PlanViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITableView *planTableView;

@property(nonatomic,strong)NSString * gameid;
@property(nonatomic,strong)NSString * logangle;//游戏视角
@property(nonatomic,strong)NSString * grpcompleteString;//全团目标
@property(nonatomic,strong)NSString * mecompleteString;//个人目标

@end
