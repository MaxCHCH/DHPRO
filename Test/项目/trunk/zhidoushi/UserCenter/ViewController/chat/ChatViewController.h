//
//  ChatViewController.h
//  zhidoushi
//
//  Created by nick on 15/4/24.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "BaseViewController.h"

@interface ChatViewController : BaseViewController
@property (strong, nonatomic)  UITableView *tableView;

@property (strong, nonatomic)  UITextField *messageField;

@property(nonatomic,copy)NSString *title;//标题

@property(nonatomic,copy)NSString *userId;//私信对象
@end
