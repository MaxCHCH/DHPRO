//
//  PlanTableViewCell.m
//  zhidoushi
//
//  Created by xinglei on 14/12/16.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "PlanTableViewCell.h"

@implementation PlanTableViewCell

-(void)initCell:(UIColor*)color{

    self.progressView = [[UIView alloc]initWithFrame:CGRectMake(self.goalLabel.left,self.goalLabel.bottom+15,290, 5)];
    self.progressView.backgroundColor = [WWTolls colorWithHexString:@"#e5e9ec"];
    [self.contentView addSubview:self.progressView];
    _progressBar = [[ITProgressBar alloc]initWithFrame:CGRectMake(0, 0, self.progressView.width, self.progressView.height)];
    _progressBar.animates = YES;
    _progressBar.tintColor = color;
    [self.progressView addSubview:_progressBar];

}

-(void)setPlanModel:(PlanModel *)planModel
{
    NSLog(@"planModel**********%@",planModel.username);

    self.goalLabel.text = [NSString stringWithFormat:@"%@",planModel.username];//名字

    if (planModel.complete==0) {

        self.stageLabel.text = @"0%";
    }else{

        self.stageLabel.text = [NSString stringWithFormat:@"%.0f%%",planModel.complete];//进度
    }

    self.progressBar.progress = planModel.complete/100;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
