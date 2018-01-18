//
//  ArticleTableViewCell.h
//  zhidoushi
//
//  Created by nick on 15/9/9.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupTalkModel.h"
#import "DiscoverModel.h"
#import "MyGroupDynModel.h"
#import "XimageView.h"

@interface ArticleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *separLine;
@property (weak, nonatomic) IBOutlet UIImageView *topTag;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consSeparLineHeight;
@property (weak, nonatomic) IBOutlet XimageView *showImageView;
@property(nonatomic,strong)GroupTalkModel *talkModel;//talkModel
/**
 *  初始化乐活吧内cell
 *
 */
-(void)setUpWithTalkModel:(GroupTalkModel*)model;

/**
 *  初始化搜索、撒欢广场cell
 *
 */
-(void)setUpWithDiscoverModel:(DiscoverModel*)model;

/**
 *  初始化撒欢动态cell
 *
 */
-(void)setUpWithGroupDynModel:(MyGroupDynModel*)model;

@end
