//
//  AchieveTableViewCell.m
//  zhidoushi
//
//  Created by nick on 15/11/16.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import "AchieveTableViewCell.h"

@implementation AchieveTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.bgImageView.clipsToBounds = YES;
    self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(MyGroupDynModel *)model{
    _model = model;
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.gameimage]];
    self.groupNameLbl.text = model.gamename;
//    self.kgLabel.text 
}

@end
