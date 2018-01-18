//
//  SelectTagsViewController.h
//  zhidoushi
//
//  Created by nick on 15/4/24.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "BaseViewController.h"

@interface SelectTagsViewController : BaseViewController
@property(nonatomic,copy)NSString *Wheretag;//已选标签
@property(nonatomic,copy)NSString *Howtag;//已选标签
@property(nonatomic,copy)NSString *shenfen;//团组身份
@property(nonatomic,copy)NSString *type;//团组类型
@property(nonatomic,copy)NSString *groupname;//团组名称
@property(nonatomic,copy)NSString *imageurl;//团组封面
@property(nonatomic,copy)NSString *begindate;//开始时间

@end
