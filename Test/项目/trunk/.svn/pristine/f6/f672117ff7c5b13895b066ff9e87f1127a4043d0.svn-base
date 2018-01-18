//
//  MessageInformTableViewCell.m
//  zhidoushi
//
//  Created by nick on 15/11/13.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import "MessageInformTableViewCell.h"

@interface MessageInformTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *MessageContentLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation MessageInformTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(InformationModel *)model{
    _model = model;
    if ([model.noticetype isEqualToString:@"8"]) {
        self.titleLabel.text = @"广播";
        self.timeLbl.text = [WWTolls date:model.pushtime];
        self.MessageContentLbl.text = model.content;
    }
}

@end
