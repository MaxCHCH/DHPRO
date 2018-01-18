//
//  GroupMsgListTableViewCell.m
//  zhidoushi
//
//  Created by nick on 15/10/12.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import "GroupMsgListTableViewCell.h"

@implementation GroupMsgListTableViewCell

-(void)awakeFromNib{
    [super awakeFromNib];
    self.contentLbl.numberOfLines = 0;
}

-(void)setMsg:(NSString *)msg{
    _msg = msg;
    self.contentLbl.text = msg;
}

-(void)setTime:(NSString *)time{
    _time = time;
    self.timeLbl.text = [WWTolls timeString22:time];
}

@end
