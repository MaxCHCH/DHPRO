//
//  ArticleCommentViewController.h
//  zhidoushi
//
//  Created by nick on 15/9/16.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "BaseViewController.h"

@interface ArticleCommentViewController : BaseViewController

@property(nonatomic,copy)NSString *talkId;//帖子id
@property(nonatomic,copy)NSString *byComendId;//被回复id
@property(nonatomic,copy)NSString *byComendName;//被回复人姓名
@end
