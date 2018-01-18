//
//  MessageGroupTableViewCell.m
//  zhidoushi
//
//  Created by nick on 15/11/13.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import "MessageGroupTableViewCell.h"

@interface MessageGroupTableViewCell()


@end

@implementation MessageGroupTableViewCell

- (void)awakeFromNib {
    self.groupImageViwe.clipsToBounds = YES;
    self.groupImageViwe.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setModel:(InformationModel *)model{
    _model = model;
    /*
     1 建团失败
     2 团组开始
     3 上传体重照片提示
     4 创建者通关
     5 团组中途结束
     6 创建者阶段过关
     7 参与者团组失败
     8 体重照片审核通过
     9 体重照片审核未通过
     10 参与者阶段过关
     11 参与者通关
     12 参与者加入团组失败
     13 欢乐模式通关
     14 欢乐模式团组结束
     15 发布团组任务
     16 催团长发任务
     17 团长群发通知
     18 剔除团员通知
     19 团组解散驳回通知
     20 团组解散通知-团长
     21 团组解散通知-团员
     */
    self.messageTypeLbl.text = @"团组通知";
    switch (model.msgkind.intValue) {
        case 15:
            self.messageTypeLbl.text = @"新任务";
            break;
        case 16:
            self.messageTypeLbl.text = @"催任务";
            break;
        case 17:
            self.messageTypeLbl.text = @"群发通知";
            break;
        default:
            break;
    }
    [self.groupImageViwe sd_setImageWithURL:[NSURL URLWithString:model.imageurl]];
    self.groupNameLbl.text = model.gamename;
    self.messageContentLbl.text = model.content;
    self.timeLbl.text = [WWTolls date:model.pushtime];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
