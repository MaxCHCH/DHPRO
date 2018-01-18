//
//  GroupEditorViewController.h
//  zhidoushi
//
//  Created by nick on 15/5/4.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "BaseViewController.h"
#import "GroupHeaderModel.h"

@interface GroupEditorViewController : BaseViewController
@property(nonatomic,copy)NSString *msg;//团组宣言
@property(nonatomic,copy)NSString *groupId;//团组id
@property(nonatomic,strong)GroupHeaderModel *model;//
@end
