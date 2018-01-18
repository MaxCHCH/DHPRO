//
//  MessageWeekTableViewCell.m
//  zhidoushi
//
//  Created by nick on 15/11/16.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import "MessageWeekTableViewCell.h"

@interface MessageWeekTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UIImageView *imgeView;
@property (weak, nonatomic) IBOutlet UILabel *weekTime;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;

@end

@implementation MessageWeekTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.imgeView.contentMode = UIViewContentModeScaleAspectFill;
    self.imgeView.clipsToBounds = YES;
}

- (void)setModel:(InformationModel *)model{
    _model = model;
    self.timeLbl.text = [WWTolls date:model.pushtime];
    [self.imgeView sd_setImageWithURL:[NSURL URLWithString:model.imageurl]];
    self.weekTime.text = model.createdate;
    self.contentLbl.text = model.message;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
