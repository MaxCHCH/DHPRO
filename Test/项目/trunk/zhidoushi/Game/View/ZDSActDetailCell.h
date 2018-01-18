//
//  ZDSActDetailCell.h
//  zhidoushi
//
//  Created by nick on 15/4/27.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZDSActDetailModel.h"
#import "ZDSActCommentModel.h"

@interface ZDSActDetailCell : UITableViewCell

@property(nonatomic,strong)ZDSActCommentModel *model;//回复模型

@end
