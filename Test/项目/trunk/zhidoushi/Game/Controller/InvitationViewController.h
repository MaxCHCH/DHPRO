//
//  InvitationViewController.h
//  zhidoushi
//
//  Created by xinglei on 14/12/16.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//
//**邀请朋友**//
#import "BaseViewController.h"

#import "InvitationTableViewCell.h"

@interface InvitationViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITableView *invitationTableView;

@property(nonatomic,strong)InvitationTableViewCell * invitationCell;

@property(nonatomic,strong)NSString * userid;
@property(nonatomic,strong)NSString * gameid;

@end
