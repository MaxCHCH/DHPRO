//
//  TalkAboutViewController.h
//  zhidoushi
//
//  Created by xinglei on 14/12/17.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "BaseViewController.h"
#import "GroupViewController.h"
#import "QEDTextView.h"

@interface TalkAboutViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIView *backGround_View;
@property (strong, nonatomic) QEDTextView *backTextView;
@property(weak,nonatomic) id<sendMessageDelegate> delegate;
@property(nonatomic,strong)NSString * userid;
@property(nonatomic,strong)NSString * gameid;
@property(nonatomic,strong)NSString * talkcontent;
@property(nonatomic,strong)NSString * imageurl;
@property (nonatomic, assign) UIViewController *controller;


//隐藏同步
@property(nonatomic,assign) BOOL hiddenSynch;

/**
 *  1 28天4%团
 *  2 欢乐
 *  3 普通团
 */
//团组类型
@property(nonatomic,copy) NSString * gameModel;

//团组密码
@property (nonatomic,copy) NSString *gmpassword;

@end
