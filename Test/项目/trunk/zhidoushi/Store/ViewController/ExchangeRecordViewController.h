//
//  ExchangeRecordViewController.h
//  zhidoushi
//
//  Created by xinglei on 15/1/10.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//
//..兑换记录..//
#import "BaseViewController.h"

#import "ExchangeRecordTableViewCell.h"

@interface ExchangeRecordViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITableView *exchangeRecordTableView;
@property (weak, nonatomic) IBOutlet UILabel *maskLabel;

@end
