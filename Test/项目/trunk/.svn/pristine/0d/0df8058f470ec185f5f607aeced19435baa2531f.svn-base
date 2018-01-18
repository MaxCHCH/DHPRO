//
//  GroupTalkTableViewCell.m
//  zhidoushi
//
//  Created by xinglei on 14/12/16.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "GroupTalkTableViewCell.h"

#import "WWTolls.h"
#import "UIViewExt.h"
#import "NSURL+MyImageURL.h"
#import "UIView+ViewController.h"
#import "UIImageView+AFNetworking.h"
//**图片放大**//
#import "XimageView.h"
#import "UIImageView+WebCache.h"
#import "MeViewController.h"
#import "MBProgressHUD+MJ.h"
#import "GroupViewController.h"
#import "UIView+ViewController.h"
#import "MCFireworksButton.h"
#import "NSString+NARSafeString.h"

#import "WWRequestOperationEngine.h"
#import "JSONKit.h"
#import "UITableViewCell+SSLSelect.h"
#import "DiscoverTypeViewController.h"
#import "GroupTalkDetailViewController.h"

@interface GroupTalkTableViewCell ()
{
    BOOL result;
    NSString *stopResult;
    NSString *talkidResult;
    NSString *imageString;
    NSString *userId;
    NSString *contentimage;
}

@property (weak, nonatomic) IBOutlet UIView *topBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consComGroupWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTopHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTopWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consToolTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consImageTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consImageWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consImageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consImageRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consContentTop;


@property(strong,nonatomic) GroupTalkModel* model;
@property(nonatomic,strong)DiscoverModel *showModel;
@property(nonatomic,strong)MyGroupDynModel *dynModel;
@property (weak, nonatomic) IBOutlet MCFireworksButton *goodButton;
@property (weak, nonatomic) IBOutlet UIButton *goodBigBtn;
@property (weak, nonatomic) IBOutlet UILabel *goodLbl;
@property (weak, nonatomic) IBOutlet UILabel *talkLbl;
@property (weak, nonatomic) IBOutlet UIButton *talkBigBtn;
@property(copy,nonatomic) NSString* talkid;
@property(copy,nonatomic) NSString* praisestatus;//当前消息的点赞状态
@property (weak, nonatomic) IBOutlet UIView *toolView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewLineViewHeight;
@property (weak, nonatomic) IBOutlet UIView *veFirstView;
@property (weak, nonatomic) IBOutlet UIView *veSecondView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *veFirstLineHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *veSecondLineHeight;
//tool 约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodbtnLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodLineLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *discussBtnLeft;
@property (weak, nonatomic) IBOutlet UIImageView *topImageTag;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreBtnLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreLineRight;
@end

@implementation GroupTalkTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImage.clipsToBounds = YES;
    self.headImage.layer.cornerRadius = 22;

    self.line.backgroundColor = ZDS_BACK_COLOR;
    //    UIView *smallLine = [[UIView alloc] initWithFrame:CGRectMake(0, 9.5, SCREEN_WIDTH, 0.5)];
    //    smallLine.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
    //    self.smallLine = smallLine;
    //    [self.line addSubview:smallLine];
    
    self.line.layer.borderColor = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;
    self.line.layer.borderWidth = 0.5;
    
    self.goodLineLeft.constant = 115 * SCREEN_WIDTH/320;
    self.goodbtnLeft.constant = 40 * SCREEN_WIDTH/320;
    self.discussBtnLeft.constant = 36 * SCREEN_WIDTH/320;
    self.moreLineRight.constant = 88 * SCREEN_WIDTH/320;
    self.moreBtnLeft.constant = 35 * SCREEN_WIDTH/320;
    //    self.line.layer.borderWidth = 0.5;
    //    self.line.layer.borderColor = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;
    //    self.toolView.layer.borderWidth = 0.5;
    UIView *toolTopLine = [[UIView alloc] init];
    toolTopLine.frame = CGRectMake(15, 0, SCREEN_WIDTH - 30, 0.5);
    toolTopLine.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
    [self.toolView addSubview:toolTopLine];
    
    //    self.toolView.layer.borderColor = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;
    for (UIView *view in self.toolView.subviews) {
        if (view.height == 1) {
            view.height = 0.5;
        }
    }
    
    self.talkLbl.textColor = [WWTolls colorWithHexString:@"959595"];
    
    self.topViewLineViewHeight.constant = 0.5;
    
    //    self.veFirstView.height = 0.5;
    //    self.veSecondView.height = 0.5;
    self.veFirstLineHeight.constant = 0.5;
    self.veSecondLineHeight.constant = 0.5;
    
    [self setSelectBackgroundColor:[WWTolls colorWithHexString:@"#eaeaea"] andNormalBackgroundColor:nil];
    self.topBgView.hidden = YES;
    self.topViewHeight.constant = 0;
    self.contentImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.contentImageView.clipsToBounds = YES;
}

#pragma mark - 点击头像
-(void)clickPhoto{
    MeViewController *single = [[MeViewController alloc]init];
    single.otherOrMe = 1;
    single.userID = userId;
    if(self.viewController.navigationController)[self.viewController.navigationController pushViewController:single animated:YES];
    else [((UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController).selectedViewController pushViewController:single animated:YES];
}
#pragma mark - 点击来自团组
-(void)clickGroup{
    GroupViewController *group = [[GroupViewController alloc] init];
    if (self.showModel != nil) {
        group.groupId = self.showModel.gameid;
        group.clickevent = 5;
        group.joinClickevent = @"5";
    }else{
        group.groupId = self.dynModel.gameid;
        group.clickevent = 10;
        group.joinClickevent = @"10";
    }
    [self.viewController.navigationController pushViewController:group animated:YES];
}

#pragma mark - 点赞
- (IBAction)goodButn:(id)sender {
    self.goodButton.userInteractionEnabled = NO;
    self.goodBigBtn.userInteractionEnabled = NO;
    [self.superview bringSubviewToFront:self];
    [self.goodButton popOutsideWithDuration:0.5];
    if ([self.praisestatus isEqualToString:@"1"]) {//如果用户未被赞
        
        [self clickGoodSender:@"0"];
    }else{
        
        [self clickGoodSender:@"1"];
        
    }
}
-(void)clickGoodSender:(NSString*)praisesta
{
    if ([self.praisestatus isEqualToString:@"0"]) {
        if (self.model != nil) {
            self.model.goodStatus = @"1";
            
            self.model.goodSum = [NSString stringWithFormat:@"%d",self.goodLbl.text.intValue-1];
            //点赞数
            if ([self.model.goodSum isEqualToString:@"0"]) {
                self.goodLbl.font = [UIFont fontWithName:@"Helvetica Neue" size:12.5];
                self.goodLbl.text = @"加油";
            } else {
                self.goodLbl.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
                self.goodLbl.text = self.model.goodSum;
            }
        }else if (self.showModel != nil) {
            self.showModel.praisestatus = @"1";
            self.showModel.praisecount = [NSString stringWithFormat:@"%d",self.goodLbl.text.intValue-1];
            //点赞数
            if ([self.showModel.praisecount isEqualToString:@"0"]) {
                self.goodLbl.font = [UIFont fontWithName:@"Helvetica Neue" size:12.5];
                self.goodLbl.text = @"加油";
            } else {
                self.goodLbl.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
                self.goodLbl.text = self.showModel.praisecount;
            }
        }else if (self.dynModel != nil) {
            self.dynModel.praisestatus = @"1";
            self.dynModel.praisecount = [NSString stringWithFormat:@"%d",self.goodLbl.text.intValue-1];
            //点赞数
            if ([self.dynModel.praisecount isEqualToString:@"0"]) {
                self.goodLbl.font = [UIFont fontWithName:@"Helvetica Neue" size:12.5];
                self.goodLbl.text = @"加油";
            } else {
                self.goodLbl.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
                self.goodLbl.text = self.dynModel.praisecount;
            }
        }
        
        
        self.goodLbl.textColor = [WWTolls colorWithHexString:@"#959595"];
        [self.goodButton setBackgroundImage:[UIImage imageNamed:@"jy-32"] forState:UIControlStateNormal];
        [self.goodButton popInsideWithDuration:0.4];
        self.praisestatus = @"1";
    }
    else{
        [self.goodButton setBackgroundImage:[UIImage imageNamed:@"jy-36-"] forState:UIControlStateNormal];
        [self.goodButton popOutsideWithDuration:0.5];
        [self.goodButton animate];
        self.praisestatus = @"0";
        if (self.model != nil) {
            self.model.goodStatus = @"0";
            self.model.goodSum = [NSString stringWithFormat:@"%d",self.model.goodSum.intValue+1];
        }else if (self.showModel != nil) {
            self.showModel.praisestatus = @"0";
            self.showModel.praisecount = [NSString stringWithFormat:@"%d",self.model.goodSum.intValue+1];
        }else if (self.dynModel != nil) {
            self.dynModel.praisestatus = @"0";
            self.dynModel.praisecount = [NSString stringWithFormat:@"%d",self.model.goodSum.intValue+1];
        }
        
        self.goodLbl.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
        self.goodLbl.textColor = [WWTolls colorWithHexString:@"#ff4d48"];
        
        self.goodLbl.text = [NSString stringWithFormat:@"%d",[self.goodLbl.text isEqualToString:@"加油"]?1:self.goodLbl.text.intValue+1];
    }
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setObject:self.talkid forKey:@"receiveid"];
    [dictionary setValue:praisesta forKey:@"praisestatus"];
    [dictionary setObject:@"2" forKey:@"praisetype"];//0 赞人/1 赞游戏/2赞团聊
    [WWRequestOperationEngine operationManagerRequest_Post:[NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_PRAISE_104] parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        self.goodButton.userInteractionEnabled = YES;
        self.goodBigBtn.userInteractionEnabled = YES;
        if ([dic[@"result"] isEqualToString:@"0"]) {
            
        }
    }];
    
}
#pragma mark - 举报
- (IBAction)juBao:(id)sender {
    
    if ([self.talkCellDelegate respondsToSelector:@selector(reportClick:andType:andIndexPath:)]) {
        [self.talkCellDelegate reportClick:self.model.barid andType:@"0" andIndexPath:self.indexPath];
    }
}

#pragma mark 团组详情
-(void)initMyCellWithModel:(GroupTalkModel*)model
{   
    self.model = model;
    self.smallLine.top = 9.5;
    self.consLineHeight.constant = 10;
    self.discovergroup.hidden = YES;
    self.goodButton.particleImage = [UIImage imageNamed:@"RedSparkle"];
    self.goodButton.particleScale = 0.05;
    self.goodButton.particleScaleRange = 0.02;
    
    
    //点赞数
    if ([model.goodSum isEqualToString:@"0"]) {
        self.goodLbl.font = [UIFont fontWithName:@"Helvetica Neue" size:12.5];
        self.goodLbl.text = @"加油";
        
    } else {
        self.goodLbl.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
        self.goodLbl.text = model.goodSum;
    }
    
    //未点赞
    if ([model.goodStatus isEqualToString:@"1"]) {
        self.goodLbl.textColor = [WWTolls colorWithHexString:@"#959595"];
        [self.goodButton setBackgroundImage:[UIImage imageNamed:@"jy-32"] forState:UIControlStateNormal];
    } else {
        [self.goodButton setBackgroundImage:[UIImage imageNamed:@"jy-36-"] forState:UIControlStateNormal];
        self.goodLbl.textColor = [WWTolls colorWithHexString:@"#ff4d48"];
    }
    
    
    self.praisestatus = model.goodStatus;
    
    self.talkid = model.barid;
    
    //头像
    imageString = model.userinfoimageurl;
    userId = model.userid;
    NSURL *url = [NSURL URLWithImageString:model.userinfoimageurl  Size:98];
    
    [self.headImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"mrtx_98_98"]];
    
    
    self.headImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPhoto)];
    [self.headImage addGestureRecognizer:tap];
    self.consImageHeight.constant = 200;
    self.consImageRight.constant = SCREEN_WIDTH - 15;
    self.consContentTop.constant = 15;
    if(model.imageurl == nil||model.imageurl.length==0){
        contentimage = nil;
        self.consContentTop.constant = 0;
        self.contentImageView.hidden = YES;
        self.consToolTop.constant = - 200;
        self.consImageTop.constant = 10;
    }else{
        self.consImageRight.constant = 15;
        if(model.content.length<1) self.consContentTop.constant = 0;
        else self.consImageTop.constant = 10;
        contentimage = model.imageurl;
        self.contentImageView.hidden = NO;
        self.consToolTop.constant = 15;
        self.contentImageView.backgroundColor = [WWTolls colorWithHexString:@"#efefef"];
        //        self.contentImageView.contentMode = UIViewContentModeScaleAspectFit;
        WEAKSELF_SS
        //        CGSize imageSize = [WWTolls sizeForQNURLStr:model.imageurl];
        //        self.consImageHeight.constant = imageSize.height;
        //        self.consImageWidth.constant = imageSize.width;
        [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:model.imageurl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            weakSelf.contentImageView.backgroundColor = [UIColor clearColor];
        }];
    }
    
    //名字
    self.nameLabel.text = [NSString stringWithFormat:@"%@",model.username];
    //时间
    self.timeLabel.text = [WWTolls configureTimeString:model.createtime andStringType:@"M-d HH:mm"];
    //内容
    //    self.contentLabel.text = [NSString stringWithFormat:@"%@",model.content];
    WEAKSELF_SS
    [self.contentLabel setContent:model.content WithTagClick:^(NSString *tag) {
        DiscoverTypeViewController *typeVC = [[DiscoverTypeViewController alloc] init];
        typeVC.showtag = tag;
        if (weakSelf.viewController.navigationController) {
            [weakSelf.viewController.navigationController pushViewController:typeVC animated:YES];
        }else{
            [(UINavigationController*)[(UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController selectedViewController] pushViewController:typeVC animated:YES];
        }
        
    } AndOtherClick:^{
        GroupTalkDetailViewController *dc = [[GroupTalkDetailViewController alloc] init];
        dc.talkid = model.barid;
        [weakSelf.viewController.navigationController pushViewController:dc animated:YES];
    }];
    //评论
    if ([model.commentcount isEqualToString:@"0"]) {
        self.talkLbl.font = [UIFont fontWithName:@"Helvetica Neue" size:12];
        self.talkLbl.text = @"评论";
        self.talkLbl.textColor = [WWTolls colorWithHexString:@"#959595"];
    } else {
        self.talkLbl.text = model.commentcount;
        self.talkLbl.textColor = [WWTolls colorWithHexString:@"#959595"];
        self.talkLbl.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
    }
    
    //置顶信息
    NSString *topString = [NSString stringWithFormat:@"%@",model.istop];
    
    NSLog(@"置顶次数*********%d",_topupper);
    
    talkidResult = model.barid;
    //已置顶
    if ([topString isEqualToString:@"1"]) {
        self.topImageTag.hidden = NO;
        
        
    } else {
        self.topImageTag.hidden = YES;
    }
    //团长发布的团聊 且为用户本身
    if (([model.logangle isEqualToString:@"0"] || [model.logangle isEqualToString:@"1"]) && [[NSUSER_Defaults objectForKey:ZDS_USERID] isEqualToString:model.userid]) {
        
        
    } else {
        self.topBgView.hidden = YES;
        self.topViewHeight.constant = 0;
    }
    if ([model.isparter isEqualToString:@"1"]) {//参与者 显示动作条
        self.toolView.hidden = YES;
    }else self.toolView.hidden = NO;
    if (([model.logangle isEqualToString:@"0"] || [model.logangle isEqualToString:@"1"]) && [model.userid isEqualToString:[NSUSER_Defaults objectForKey:ZDS_USERID]]) {//团长
        self.leaderTip.hidden = NO;
    }else self.leaderTip.hidden = YES;
}

-(void)initMyCellWithShowModel:(DiscoverModel*)model{
    self.consLineHeight.constant = 10;
    self.smallLine.top = 9.5;
    
    self.topBgView.hidden = YES;
    self.topViewHeight.constant = 0;
    self.consLineHeight.constant = 10;
    self.smallLine.top = 9.5;
    self.topBgView.hidden = YES;
    self.topViewHeight.constant = 0;
    
    self.showModel = model;
    self.discovergroup.hidden = NO;
    self.topImageTag.hidden = YES;
    CGFloat Namewidth = [WWTolls WidthForString:model.username fontSize:15];
    CGFloat comewidth = [WWTolls WidthForString:[NSString stringWithFormat:@"%@",model.gamename] fontSize:10];
    if (Namewidth + comewidth > SCREEN_WIDTH-101) {
        self.consComGroupWidth.constant = SCREEN_WIDTH - Namewidth - 85 - 8;
    }else {
        self.consComGroupWidth.constant = 200;
    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"来自%@",model.gamename]];
    [str addAttribute:NSForegroundColorAttributeName value:OrangeColor range:NSMakeRange(2,model.gamename.length)];
    self.discovergroup.attributedText = str;
    UITapGestureRecognizer *grouptap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickGroup)];
    self.discovergroup.userInteractionEnabled = YES;
    [self.discovergroup addGestureRecognizer:grouptap];
    //    [self.discovergroup setSelectableRange:NSMakeRange(0,model.gamename.length) hightlightedBackgroundColor:[WWTolls colorWithHexString:@"#eaeaea"]];
    //    self.discovergroup.textAlignment = NSTextAlignmentRight;
    
    self.goodButton.particleImage = [UIImage imageNamed:@"RedSparkle"];
    self.goodButton.particleScale = 0.05;
    self.goodButton.particleScaleRange = 0.02;
    
    //点赞数
    if ([model.praisecount isEqualToString:@"0"]) {
        self.goodLbl.font = [UIFont fontWithName:@"Helvetica Neue" size:12.5];
        self.goodLbl.text = @"加油";
        
    } else {
        self.goodLbl.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
        self.goodLbl.text = model.praisecount;
    }
    
    //未点赞
    if ([model.praisestatus isEqualToString:@"1"]) {
        self.goodLbl.textColor = [WWTolls colorWithHexString:@"#959595"];
        [self.goodButton setBackgroundImage:[UIImage imageNamed:@"jy-32"] forState:UIControlStateNormal];
    } else {
        self.goodLbl.textColor = [WWTolls colorWithHexString:@"#ff4d48"];
        [self.goodButton setBackgroundImage:[UIImage imageNamed:@"jy-36-"] forState:UIControlStateNormal];
    }
    
    self.praisestatus = model.praisestatus;
    
    self.talkid = model.showid;
    
    talkidResult = model.showid;
    //头像
    imageString = model.userimage;
    userId = model.userid;
    NSURL *url = [NSURL URLWithImageString:model.userimage  Size:98];
    
    [self.headImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"mrtx_98_98"]];
    
    //    self.headImage.clipsToBounds = YES;
    //    self.headImage.layer.cornerRadius = 20;
    self.headImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPhoto)];
    [self.headImage addGestureRecognizer:tap];
    //    self.consImageHeight.constant = 200;
    self.consImageRight.constant = SCREEN_WIDTH - 15;
    self.consContentTop.constant = 15;
    if(model.talkimage == nil||model.talkimage.length==0){
        contentimage = nil;
        self.contentImageView.hidden = YES;
        self.consToolTop.constant = -200;
        self.consImageTop.constant = 10;
        self.consContentTop.constant = 0;
    }else{
        self.consImageRight.constant = 15;
        if(model.content.length<1)     self.consContentTop.constant = 0;
        else self.consImageTop.constant = 10;
        contentimage = model.talkimage;
        self.contentImageView.hidden = NO;
        self.consToolTop.constant = 15;
        self.contentImageView.backgroundColor = [WWTolls colorWithHexString:@"#efefef"];
        WEAKSELF_SS
        //        CGSize imageSize = [WWTolls sizeForQNURLStr:model.talkimage];
        //        self.consImageHeight.constant = imageSize.height;
        //        self.consImageWidth.constant = imageSize.width;
        [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:model.talkimage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            weakSelf.contentImageView.backgroundColor = [UIColor clearColor];
        }];
        
    }
    
    //名字
    self.nameLabel.text = [NSString stringWithFormat:@"%@",model.username];
    //时间
    self.timeLabel.text = [WWTolls configureTimeString:model.createtime andStringType:@"M-d HH:mm"];
    //内容
    //    self.contentLabel.text = [NSString stringWithFormat:@"%@",model.content];
    WEAKSELF_SS
    [self.contentLabel setContent:model.content WithTagClick:^(NSString *tag) {
        DiscoverTypeViewController *typeVC = [[DiscoverTypeViewController alloc] init];
        typeVC.showtag = tag;
        [weakSelf.viewController.navigationController pushViewController:typeVC animated:YES];
    } AndOtherClick:^{
        GroupTalkDetailViewController *dc = [[GroupTalkDetailViewController alloc] init];
        dc.talkid = model.showid;
        [weakSelf.viewController.navigationController pushViewController:dc animated:YES];
    }];
    self.contentLabel.userInteractionEnabled = YES;
    //回复按钮
    if ([model.commentcount isEqualToString:@"0"]) {
        self.talkLbl.textColor = [WWTolls colorWithHexString:@"#959595"];
        self.talkLbl.font = [UIFont fontWithName:@"Helvetica Neue" size:12];
        self.talkLbl.text = @"评论";
    } else {
        self.talkLbl.textColor = [WWTolls colorWithHexString:@"#959595"];
        self.talkLbl.text = model.commentcount;
        self.talkLbl.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
    }
    
    talkidResult = model.showid;
    self.topButton.hidden = YES;
    if ([model.isparter isEqualToString:@"0"]) {//参与者 显示动作条
        self.toolView.hidden = NO;
    }else self.toolView.hidden = YES;
    self.leaderTip.hidden = YES;
}


-(void)initMyCellWithDynModel:(MyGroupDynModel*)model{
    self.consLineHeight.constant = 10;
    self.smallLine.top = 9.5;
    self.topBgView.hidden = YES;
    self.topViewHeight.constant = 0;
    
    self.dynModel = model;
    self.discovergroup.hidden = NO;
    self.topImageTag.hidden = YES;
    
    CGFloat Namewidth = [WWTolls WidthForString:model.username fontSize:15];
    CGFloat comewidth = [WWTolls WidthForString:[NSString stringWithFormat:@"来自%@",model.gamename] fontSize:10];
    if (Namewidth + comewidth > SCREEN_WIDTH-101) {
        self.consComGroupWidth.constant = SCREEN_WIDTH - Namewidth - 85 - 8;
    }else {
        self.consComGroupWidth.constant = 200;
    }
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"来自%@",model.gamename]];
    [str addAttribute:NSForegroundColorAttributeName value:OrangeColor range:NSMakeRange(2,model.gamename.length)];
    self.discovergroup.attributedText = str;
    UITapGestureRecognizer *grouptap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickGroup)];
    self.discovergroup.userInteractionEnabled = YES;
    [self.discovergroup addGestureRecognizer:grouptap];
    self.goodButton.particleImage = [UIImage imageNamed:@"RedSparkle"];
    self.goodButton.particleScale = 0.05;
    self.goodButton.particleScaleRange = 0.02;
    
    //点赞数
    if ([model.praisecount isEqualToString:@"0"]) {
        self.goodLbl.font = [UIFont fontWithName:@"Helvetica Neue" size:12.5];
        self.goodLbl.text = @"加油";
    } else {
        self.goodLbl.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
        self.goodLbl.text = model.praisecount;
    }
    
    //未点赞
    if ([model.praisestatus isEqualToString:@"1"]) {
        self.goodLbl.textColor = [WWTolls colorWithHexString:@"#959595"];
        [self.goodButton setBackgroundImage:[UIImage imageNamed:@"jy-32"] forState:UIControlStateNormal];
    } else {
        self.goodLbl.textColor = [WWTolls colorWithHexString:@"#ff4d48"];
        [self.goodButton setBackgroundImage:[UIImage imageNamed:@"jy-36-"] forState:UIControlStateNormal];
    }
    
    self.praisestatus = model.praisestatus;
    
    self.talkid = model.dynid;
    //头像
    imageString = model.userimage;
    userId = model.userid;
    NSURL *url = [NSURL URLWithImageString:imageString  Size:98];
    
    [self.headImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"mrtx_98_98"]];
    
    //    self.headImage.clipsToBounds = YES;
    //    self.headImage.layer.cornerRadius = 20;
    self.headImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPhoto)];
    [self.headImage addGestureRecognizer:tap];
//    self.consImageHeight.constant = 200;
    self.consImageRight.constant = SCREEN_WIDTH - 15;
    self.consContentTop.constant = 15;
    if(model.talkimage == nil||model.talkimage.length==0){
        contentimage = nil;
        self.consContentTop.constant = 0;
        self.contentImageView.hidden = YES;
        self.consToolTop.constant = -200;
        self.consImageTop.constant = 10;
    }else{
        self.consImageRight.constant = 15;
        if(model.content.length<1) self.consContentTop.constant = 0;
        else self.consImageTop.constant = 10;
        contentimage = model.talkimage;
        self.contentImageView.hidden = NO;
        self.consToolTop.constant = 15;
        self.contentImageView.backgroundColor = [WWTolls colorWithHexString:@"#efefef"];
        //        self.contentImageView.contentMode = UIViewContentModeScaleAspectFit;
        WEAKSELF_SS
        //        CGSize imageSize = [WWTolls sizeForQNURLStr:model.talkimage];
        //        self.consImageHeight.constant = imageSize.height;
        //        self.consImageWidth.constant = imageSize.width;
        [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:model.talkimage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            weakSelf.contentImageView.backgroundColor = [UIColor clearColor];
        }];
        
    }
    //名字
    self.nameLabel.text = [NSString stringWithFormat:@"%@",model.username];
    //时间
    self.timeLabel.text = [WWTolls configureTimeString:model.createtime andStringType:@"M-d HH:mm"];
    //内容
    //    self.contentLabel.text = [NSString stringWithFormat:@"%@",model.content];
    WEAKSELF_SS
    [self.contentLabel setContent:model.content WithTagClick:^(NSString *tag) {
        DiscoverTypeViewController *typeVC = [[DiscoverTypeViewController alloc] init];
        typeVC.showtag = tag;
        [weakSelf.viewController.navigationController pushViewController:typeVC animated:YES];
    } AndOtherClick:^{
        GroupTalkDetailViewController *dc = [[GroupTalkDetailViewController alloc] init];
        dc.talkid = model.dynid;
        [weakSelf.viewController.navigationController pushViewController:dc animated:YES];
    }];
    //评论
    if ([model.commentcount isEqualToString:@"0"]) {
        self.talkLbl.textColor = [WWTolls colorWithHexString:@"#959595"];
        self.talkLbl.font = [UIFont fontWithName:@"Helvetica Neue" size:12];
        self.talkLbl.text = @"评论";
    } else {
        self.talkLbl.textColor = [WWTolls colorWithHexString:@"#959595"];
        self.talkLbl.text = model.commentcount;
        self.talkLbl.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
    }
    
    talkidResult = model.dynid;
    self.topButton.hidden = YES;
    self.toolView.hidden = NO;
    if ([model.userid isEqualToString:model.gamecrtor]) {//团长
        self.leaderTip.hidden = NO;
    }else self.leaderTip.hidden = YES;
    if ([model.isparter isEqualToString:@"0"]) {//参与者 显示动作条
        self.toolView.hidden = NO;
    }else self.toolView.hidden = YES;
}

#pragma mark 点击了回复按钮
- (IBAction)replyButton:(id)sender {
    NSLog(@"点击了回复按钮");
    GroupTalkDetailViewController *talk = [[GroupTalkDetailViewController alloc] init];
    talk.talktype = GroupSimpleTalkType;
    talk.talkid = self.talkid;
    talk.clickevent = 1;
    //    [((UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController).selectedViewController pushViewController:talk animated:YES];
}

- (CGFloat)getTopHeightWithModel:(GroupTalkModel *)model {
    
    //置顶信息
    NSString *topString = [NSString stringWithFormat:@"%@",model.istop];
    
    //团长发布的团聊 且为用户本身
    if (([model.logangle isEqualToString:@"0"] || [model.logangle isEqualToString:@"1"]) && [[NSUSER_Defaults objectForKey:ZDS_USERID] isEqualToString:model.userid]) {
        
        //
        if ([topString isEqualToString:@"1"]) {
            
            return 0;
        } else {
            return 0;
        }
    }
    
    return 0;
}

-(CGFloat)getMyCellHeight:(GroupTalkModel*)model
{   
    CGFloat h = 148;
    
    h += [self getStringRect:model.content].height;
    if (model.imageurl==nil||model.imageurl.length == 0) {
        h -= 15;
    }
    else{
        h += SCREEN_WIDTH - 30;
        
        if (model.content.length == 0 || model.content == nil) {
            h -= 15;
        }
    }
    if ([model.isparter isEqualToString:@"1"]) {//不是该减脂团成员隐藏工具栏
        h-=44;
    }
    return h;
}

+(CGFloat)getShowCellHeight:(DiscoverModel*)model
{
    CGFloat h = 148;
    
    h += [self getStringRect:model.content].height;
    
    if (model.talkimage==nil||model.talkimage.length == 0) {
        h -= 15;
    }
    else{
        //        h += 10+[WWTolls sizeForQNURLStr:model.talkimage].height;
        h += SCREEN_WIDTH - 30;
        
        if (model.content.length == 0 || model.content == nil) {
            h -= 15;
        }
    }
    if (![model.isparter isEqualToString:@"0"]) {//不是该减脂团成员隐藏工具栏
        h-=44;
    }
    return h;
}

+(CGFloat)getDynCellHeight:(MyGroupDynModel*)model
{
    CGFloat h = 148;
    
    h += [self getStringRect:model.content].height;
    
    if (model.talkimage==nil||model.talkimage.length == 0) {
        h -= 15;
    }
    else{
        h += SCREEN_WIDTH - 30;
        if (model.content.length == 0 || model.content == nil) {
            h -= 15;
        }
    }
    if (![model.isparter isEqualToString:@"0"]) {//不是该减脂团成员隐藏工具栏
        h-=44;
    }
    return h;
}

//..测算字符串高度..//
+ (CGSize)getStringRect:(NSString*)aString
{
    
    CGSize size;
    
    size.height = [WWTolls heightForString:aString fontSize:15 andWidth:SCREEN_WIDTH-30];//100 100 28 28
    
    return  size;
    
}
-(CGSize)getStringRect:(NSString*)aString
{
    
    CGSize size;
    
    size.height = [WWTolls heightForString:aString fontSize:15 andWidth:SCREEN_WIDTH-30];//100 100 28 28
    
    
    return  size;
    
}


#pragma mark - 置顶事件
-(void)topClickEvent
{
    if ([self.talkCellDelegate respondsToSelector:@selector(clickTopButton)]) {
        [self.talkCellDelegate talkidString:talkidResult andType:@"0"];
        [self.talkCellDelegate topString:stopResult];
        [self.talkCellDelegate clickTopButton];
    }
    
}

@end
