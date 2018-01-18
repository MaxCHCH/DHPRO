//
//  NewTaskTableViewCell.m
//  zhidoushi
//
//  Created by nick on 15/11/16.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import "NewTaskTableViewCell.h"

@implementation NewTaskTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.image.clipsToBounds = YES;
    self.image.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)setModel:(MyGroupDynModel *)model{
    _model = model;
    self.content.text = model.content;
    [self.image sd_setImageWithURL:[NSURL URLWithString:model.contimage]];
}

@end
