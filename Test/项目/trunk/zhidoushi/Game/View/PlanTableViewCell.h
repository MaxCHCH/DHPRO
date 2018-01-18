//
//  PlanTableViewCell.h
//  zhidoushi
//
//  Created by xinglei on 14/12/16.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PlanModel.h"
#import "ITProgressBar.h"

@interface PlanTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *goalLabel;
@property (weak, nonatomic) IBOutlet UILabel *stageLabel;
@property(nonatomic,strong)ITProgressBar * progressBar;
@property(nonatomic,strong)UIView * progressView;

@property(nonatomic,strong)PlanModel * planModel;

-(void)initCell:(UIColor*)color;

@end
