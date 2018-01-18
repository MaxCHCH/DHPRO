//
//  TalkBarViewController.h
//  zhidoushi
//
//  Created by nick on 15/6/16.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "BaseViewController.h"
#import "GroupTalkTableViewCell.h"
#import "GroupHeaderModel.h"
@protocol sendMessageDelegate <NSObject>

-(void)sendSuccess;

@end
@interface TalkBarViewController : BaseViewController

@property(nonatomic,copy)NSString *groupId;//团组id
@property(nonatomic,strong)GroupTalkTableViewCell * groupCell;
@property(nonatomic,strong)GroupHeaderModel *model;//团组头部模型
@property(nonatomic,copy)NSString *gameangle;//团组视角
@property(nonatomic,weak)UIViewController *happyCtl;
//团组密码
@property (nonatomic,copy) NSString *gmpassword;
-(void)refresh;
@end
