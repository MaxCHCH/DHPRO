//
//  ReplyViewController.h
//  zhidoushi
//
//  Created by nick on 15/7/22.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "BaseViewController.h"
@interface ReplyViewController : BaseViewController
@property(nonatomic,copy)NSString *ReplyType;//1.团聊 2.撒欢
@property(nonatomic,copy)NSString *ReplyId;//评论id
@property(nonatomic,copy)NSString *parentId;//内容id
@property(nonatomic,copy)NSString *byuserName;//回复姓名
@end
