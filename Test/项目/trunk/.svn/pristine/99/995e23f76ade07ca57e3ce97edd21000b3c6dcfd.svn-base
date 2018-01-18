//
//  PublicTaskViewController.h
//  zhidoushi
//
//  Created by licy on 15/6/18.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "BaseViewController.h"
@class PublicTaskViewController;

@protocol PublicTaskViewControllerDelegate <NSObject>

@optional
- (void)pubTaskSuccess:(NSString*)taskid;

@end

@interface PublicTaskViewController : BaseViewController

@property (nonatomic,weak) id <PublicTaskViewControllerDelegate> delegate;

@property (nonatomic,strong) NSString *gameId;
@property(nonatomic,copy)NSString *taskMonth;//月份
@property(nonatomic,copy)NSString *taskNum;//第几个任务
@property (nonatomic,strong) NSString *gameName;
@property(nonatomic,copy)NSString *password;//团组密码
@property(nonatomic,assign)BOOL isFromGroup;//是否来自团组
@end
