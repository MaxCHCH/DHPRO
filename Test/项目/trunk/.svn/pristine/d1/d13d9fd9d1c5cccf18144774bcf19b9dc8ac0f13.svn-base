//
//  GroupTalkTableViewCell.h
//  zhidoushi
//
//  Created by xinglei on 14/12/16.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GroupTalkModel.h"
#import "DiscoverModel.h"
#import "HTCopyableLabel.h"
#import "MyGroupDynModel.h"
#import "XimageView.h"
#import "ZDStagLabel.h"
@class GroupTalkTableViewCell;

@protocol groupTalkCellDelegate <NSObject>

@optional
-(void)clickTopButton;
-(void)clickReplyButton:(NSString*)nameString timeString:(NSString*)time contentString:(NSString*)content imageUrlString:(NSString*)imageString contentImage:(NSString*)contentImage;

-(void)topString:(NSString*)top;
-(void)talkidString:(NSString*)talk andType:(NSString *)type;
-(void)myImageClick:(UIImage*)myImage;

-(void)reportClick:(NSString*)talkid AndType:(NSString*)type;
//举报 extension
- (void)reportClick:(NSString *)talkId andType:(NSString *)type andIndexPath:(NSIndexPath *)indexPath;
@end

@interface GroupTalkTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIImageView *leaderTip;
@property (weak, nonatomic) IBOutlet UILabel *discovergroup;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;//头像
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//名字
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;//时间
@property (weak, nonatomic) IBOutlet ZDStagLabel *contentLabel;//内容
@property (weak, nonatomic) IBOutlet XimageView *contentImageView;//内容图片
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UIButton *topButton;//置顶按钮
@property (weak, nonatomic) IBOutlet UIButton *replyButton;//回复按钮

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consLineHeight;
@property(nonatomic,strong)UIView *smallLine;//细线

@property(nonatomic,strong) NSIndexPath* indexPath;
@property(copy,nonatomic) NSString* gameangle;
@property(assign,nonatomic) int topupper;
@property(nonatomic,weak)id<groupTalkCellDelegate> talkCellDelegate;
-(CGFloat)getMyCellHeight:(GroupTalkModel*)model;
+(CGFloat)getShowCellHeight:(DiscoverModel*)model;
+(CGFloat)getDynCellHeight:(MyGroupDynModel*)model;
-(void)initMyCellWithShowModel:(DiscoverModel*)model;
-(void)initMyCellWithDynModel:(MyGroupDynModel*)model;
-(void)initMyCellWithModel:(GroupTalkModel*)model;
@end
