//
//  InvitationTableViewCell.h
//  zhidoushi
//
//  Created by xinglei on 14/12/16.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "invitationModel.h"

@protocol InvitationTabeleDelegate <NSObject>

@optional
-(void)clickInvitatinButton:(NSString*)rcvuser_name rcvuserID:(NSString*)rcvuser_id buttonTag:(NSInteger)tag;
@end

@interface InvitationTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ocntentLabel;
@property (weak, nonatomic) IBOutlet UIButton *invitationButton;

@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@property(nonatomic,weak)id<InvitationTabeleDelegate> InvitationDelegate;

-(void)initWithMyCell:(invitationModel*)model;

@end
