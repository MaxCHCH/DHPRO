//
//  InvitationTableViewCell.m
//  zhidoushi
//
//  Created by xinglei on 14/12/16.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "InvitationTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "NSURL+MyImageURL.h"

@interface InvitationTableViewCell ()

@property(nonatomic,strong)NSString * rcvuserid;

@end

@implementation InvitationTableViewCell

- (void)awakeFromNib {
    self.bottomLineView.height = 0.5;
    // Initialization code
}

-(void)initWithMyCell:(invitationModel*)model;
{
    self.nameLabel.text = model.username;
    self.ocntentLabel.text = model.usersign;
    //头像
    self.headImageView.clipsToBounds = YES;
    self.headImageView.layer.cornerRadius = 24;
    NSURL *imageUrl = [NSURL URLWithImageString:model.imageurl Size:98];
    [self.headImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"mrtx_98_98"]];
    self.rcvuserid = model.userid;

    if ([model.invitests isEqualToString:@"1"]) {//未邀请
        self.invitationButton.tag = 100;
        [self.invitationButton setBackgroundImage:[UIImage imageNamed:@"group_yaoqing-58-58"] forState:UIControlStateNormal];
    }else{
        
        [self.invitationButton setBackgroundImage:[UIImage imageNamed:@"group_yiyaoqing-32-32"] forState:UIControlStateNormal];
    }

}

- (IBAction)clickInvitationButton:(id)sender{

    if ([self.InvitationDelegate respondsToSelector:@selector(clickInvitatinButton:rcvuserID:buttonTag:)]) {
        [self.InvitationDelegate clickInvitatinButton:self.nameLabel.text rcvuserID:self.rcvuserid buttonTag:self.invitationButton.tag];
        [self.invitationButton setBackgroundImage:[UIImage imageNamed:@"group_yiyaoqing-32-32"] forState:UIControlStateNormal];
        self.invitationButton.userInteractionEnabled = NO;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
