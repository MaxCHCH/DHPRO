//
//  ZDSGroupActCell.h
//  zhidoushi
//
//  Created by xinglei on 14/12/16.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GroupTalkModel.h"
#import "HTCopyableLabel.h"
@class ZDSGroupActCell;

@protocol ZDSGroupActCellDelegate <NSObject>

@optional


//举报
-(void)reportClick:(NSString*)talkid AndType:(NSString*)type;
//举报 extension
- (void)reportClick:(NSString *)talkId andType:(NSString *)type andIndexPath:(NSIndexPath *)indexPath;

-(void)clickTopButton;
-(void)topString:(NSString*)top;
-(void)talkidString:(NSString*)talk andType:(NSString *)type;
-(void)myImageClick:(UIImage*)myImage;

@end

@interface ZDSGroupActCell : UITableViewCell

@property (nonatomic,strong) NSIndexPath *indexPath;

@property (weak, nonatomic) IBOutlet UIImageView *headImage;//头像
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//名字
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;//时间
@property (weak, nonatomic) IBOutlet HTCopyableLabel *contentLabel;//内容
@property (weak, nonatomic) IBOutlet UIButton *replyButton;//回复按钮

@property (weak, nonatomic) IBOutlet UIButton *topButton;//置顶按钮

@property (weak, nonatomic) IBOutlet UIButton *joinButton;

@property(copy,nonatomic) NSString* gameangle;
@property(assign,nonatomic) int topupper;
@property(nonatomic,weak)id<ZDSGroupActCellDelegate> delegate;


-(void)initMyCellWithModel:(GroupTalkModel*)model;

//获得cell的高度
+ (CGFloat)getMyCellHeightWithModel:(GroupTalkModel*)model;



@end




