//
//  ZDSGroupBubbleCell.h
//  zhidoushi
//
//  Created by xinglei on 14/12/16.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GroupTalkModel.h"
#import "HTCopyableLabel.h"

@protocol ZDSGroupBubbleCellDelegate <NSObject>

@optional


-(void)reportClick:(NSString*)talkid;

@end

@interface ZDSGroupBubbleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImage;//头像
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//名字
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;//时间
@property (weak, nonatomic) IBOutlet HTCopyableLabel *contentLabel;//内容
@property (weak, nonatomic) IBOutlet UIButton *replyButton;//回复按钮
@property (weak, nonatomic) IBOutlet UIButton *thurstHimButton;

@property(copy,nonatomic) NSString* gameangle;
@property(assign,nonatomic) int topupper;
@property(nonatomic,weak)id<ZDSGroupBubbleCellDelegate> delegate;

-(void)initMyCellWithModel:(GroupTalkModel*)model;

-(CGFloat)getMyCellHeight:(GroupTalkModel*)model;

@end
