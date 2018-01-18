//
//  MyFriendViewController.h
//  zhidoushi
//
//  Created by xinglei on 14/12/30.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//
//....我的联系人....//
#import "BaseViewController.h"


@interface MyFriendViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIView *redLineView;//指示用红线
@property (weak, nonatomic) IBOutlet UILabel *attentionLabel;//关注数
@property (weak, nonatomic) IBOutlet UILabel *fansLabel;//粉丝数
@property (weak, nonatomic) IBOutlet UILabel *friendLabel;//朋友数

@property (weak, nonatomic) IBOutlet UILabel *txtattention;
@property (weak, nonatomic) IBOutlet UILabel *txtFuns;
@property (weak, nonatomic) IBOutlet UILabel *txtFriends;




@property (weak, nonatomic) IBOutlet UIButton *attentionButton;//关注按钮
@property (weak, nonatomic) IBOutlet UIButton *fansButton;//粉丝按钮
@property (weak, nonatomic) IBOutlet UIButton *friendsButton;//朋友按钮
@property (weak, nonatomic) IBOutlet UIImageView *dianFansImageView;//粉丝上的红点
@property (weak, nonatomic) IBOutlet UIImageView *dianFriendsImageView;//新朋友上的红点

-(void)reloadViewData;
-(void)getAttentionData:(NSInteger)page pageSizeFor:(NSString*)pageSize andURL:(NSString*)and_url atype:(NSString*)a_type;

@end
