//
//  DiscoverListTableViewCell.m
//  zhidoushi
//
//  Created by nick on 15/4/20.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "DiscoverListTableViewCell.h"
#import "MCFireworksButton.h"
#import "MeViewController.h"
#import "XimageView.h"
#import "ZDStagLabel.h"
#import "UIView+ViewController.h"
#import "NSString+WPAttributedMarkup.h"
#import "DiscoverTypeViewController.h"
#import "DiscoverDetailViewController.h"
#import "WPAttributedStyleAction.h"
#import <CoreText/CoreText.h>


@interface DiscoverListTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *speraLine;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;//头像
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;//昵称
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;//发布时间
@property (weak, nonatomic) IBOutlet ZDStagLabel *msgLbl;//内容

@property (weak, nonatomic) IBOutlet MCFireworksButton *goodButton;
@property (weak, nonatomic) IBOutlet UILabel *goodLbl;
@property (weak, nonatomic) IBOutlet UILabel *talkLbl;
@property (copy, nonatomic) NSString* praisestatus;//当前消息的点赞状态
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showimgHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showimgeWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showimgeRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contenttop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgetop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consLineHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *veFirstLineWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *veSecondLineWidth;
//tool 约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodbtnLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodLineLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreBtnLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreLineLeft;

@end

@implementation DiscoverListTableViewCell

#pragma mark - Life Cycle
-(void)awakeFromNib{
    [super awakeFromNib];
    self.goodLineLeft.constant = 103 * SCREEN_WIDTH/320;
    self.goodbtnLeft.constant = 40 * SCREEN_WIDTH/320;
    self.moreLineLeft.constant = 115 * SCREEN_WIDTH/320;
    self.moreBtnLeft.constant = 35 * SCREEN_WIDTH/320;
    //    CALayer *layer = self.line.layer;
    //    layer.borderColor = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;
    self.clipsToBounds = YES;
    self.consLineHeight.constant = 0.5;
    //    UIView *line = [[UIView alloc] init];
    //    self.line.backgroundColor = [UIColor whiteColor];
    //    line.frame = CGRectMake(0, 0, 320, 0.5);
    //    line.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
    //    [self.line addSubview:line];
    //    
    //    line = [[UIView alloc] init];
    //    line.frame = CGRectMake(0, 0, 320, 0.5);
    //    line.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
    //    [self.contentView addSubview:line];
    //    line.height = (1.0 / [UIScreen mainScreen].scale / 2);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.goodButton.particleImage = [UIImage imageNamed:@"RedSparkle"];
    self.goodButton.particleScale = 0.05;
    self.goodButton.particleScaleRange = 0.02;
    
    self.headImage.userInteractionEnabled = YES;
    self.headImage.layer.cornerRadius = 22;
    self.headImage.clipsToBounds = YES;
    
    self.photoImage.backgroundColor = [WWTolls colorWithHexString:@"#e5e5e5"];
    self.photoImage.contentMode = UIViewContentModeScaleAspectFill;
    self.photoImage.clipsToBounds = YES;
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHead)];
    [self.headImage addGestureRecognizer:tap];
    self.speraLine.layer.borderColor = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;
    self.speraLine.layer.borderWidth = 0.5;
    
    self.veFirstLineWidth.constant = 0.5;
    self.veSecondLineWidth.constant = 0.5;
    self.talkLbl.textColor = [WWTolls colorWithHexString:@"#959595"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

#pragma mark - Public Methods
-(void)setModel:(DiscoverModel *)model{
    
    //    model.content = [NSString stringWithFormat:@"#标签#%@",model.content];
    
    _model = model;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.userimage] placeholderImage:[UIImage imageNamed:@"mrtx_98_98"]];
    self.nameLbl.text = model.username;
    self.timeLbl.text = [WWTolls configureTimeString:model.createtime andStringType:@"M-d HH:mm"];
    
    WEAKSELF_SS
    [self.msgLbl setContent:model.content WithTagClick:^(NSString *tag) {
        DiscoverTypeViewController *typeVC = [[DiscoverTypeViewController alloc] init];
        typeVC.showtag = tag;
        [weakSelf.viewController.navigationController pushViewController:typeVC animated:YES];
    } AndOtherClick:^{
        DiscoverDetailViewController *dc = [[DiscoverDetailViewController alloc] init];
        dc.discoverId = self.model.showid;
        [weakSelf.viewController.navigationController pushViewController:dc animated:YES];
    }];
    
    //点赞数
    if ([model.praisecount isEqualToString:@"0"]) {
        self.goodLbl.font = [UIFont fontWithName:@"Helvetica Neue" size:12.5];
        self.goodLbl.text = @"加油";
        
    } else {
        self.goodLbl.font = [UIFont fontWithName:@"Helvetica Neue" size:14.5];
        self.goodLbl.text = model.praisecount;
    }
    
    //未点赞
    if ([model.praisestatus isEqualToString:@"1"]) {
        [self.goodButton setBackgroundImage:[UIImage imageNamed:@"jy-32"] forState:UIControlStateNormal];
        self.goodLbl.textColor = [WWTolls colorWithHexString:@"#959595"];
    } else {
        [self.goodButton setBackgroundImage:[UIImage imageNamed:@"jy-36-"] forState:UIControlStateNormal];
        self.goodLbl.textColor = [WWTolls colorWithHexString:@"#ff4d48"];
    }
    
    self.praisestatus = model.praisestatus;
    
    //评论
    if ([model.commentcount isEqualToString:@"0"]) {
        self.talkLbl.textColor = [WWTolls colorWithHexString:@"#959595"];
        self.talkLbl.font = [UIFont fontWithName:@"Helvetica Neue" size:12.0];
        self.talkLbl.text = @"评论";
    } else {
        self.talkLbl.textColor = [WWTolls colorWithHexString:@"#959595"];
        self.talkLbl.text = model.commentcount;
        self.talkLbl.font = [UIFont fontWithName:@"Helvetica Neue" size:14.0];
    }
    
    //    self.showimgHeight.constant = 150;
    self.showimgeRight.constant = 15;
    self.contenttop.constant = 15;
    if ([WWTolls isNull:model.showimage]) {
        self.photoImage.hidden = YES;
        //        self.showimgHeight.constant = -0;
        self.showimgeRight.constant = SCREEN_WIDTH - 15;
        self.contenttop.constant = 0;
        //        self.bottomViewTopConstraint.constant = -150;
        //        self.contenttop.constant = 10;
        //        self.imgetop.constant = 10;
    }else {
        if (model.content.length<1) {
            self.contenttop.constant = 0;
            self.imgetop.constant = -5;
        }else{
            self.contenttop.constant = 15;
            self.imgetop.constant = 10;
        }
        self.photoImage.hidden = NO;
        self.bottomViewTopConstraint.constant = 15;
        //        self.photoImage.contentMode = UIViewContentModeScaleAspectFit;
        self.photoImage.backgroundColor = [WWTolls colorWithHexString:@"#efefef"];
        WEAKSELF_SS
        //        CGSize imageSize = [WWTolls sizeForQNURLStr:model.showimage];
        //        self.showimgHeight.constant = imageSize.height;
        //        self.showimgeWidth.constant = imageSize.width;
        [self.photoImage sd_setImageWithURL:[NSURL URLWithString:model.showimage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            weakSelf.photoImage.backgroundColor = [UIColor clearColor];
        }];
    }
}   

#pragma mark - Event Response
#pragma mark 点赞
- (IBAction)goodButn:(id)sender {
    self.goodButton.userInteractionEnabled = NO;
    [self.superview bringSubviewToFront:self];
    [self.goodButton popOutsideWithDuration:0.5];
    if ([self.praisestatus isEqualToString:@"1"]) {//如果用户未被赞
        [self clickGoodSender:@"0"];
    }else{
        [self clickGoodSender:@"1"];
    }
}

#pragma mark 点击头像
-(void)clickHead{
    MeViewController *single = [[MeViewController alloc]init];
    single.userID = self.model.userid;
    single.otherOrMe = 1;
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            [((UIViewController*)nextResponder).navigationController pushViewController:single animated:YES];
            return;
        }
    }
}

#pragma mark 举报
- (IBAction)juBao:(id)sender {
    if ([self.delegate respondsToSelector:@selector(discoverCell:reportClick:)]) {
        [self.delegate discoverCell:self reportClick:self.model.showid];
    }
}   

#pragma mark - Private Methods
#pragma mark 点赞网络请求
-(void)clickGoodSender:(NSString*)praisesta
{
    if ([self.praisestatus isEqualToString:@"0"]) {
        self.model.praisecount = [NSString stringWithFormat:@"%d",self.model.praisecount.intValue-1];
        [self.goodButton popInsideWithDuration:0.4];
        self.praisestatus = @"1";
        self.model.praisestatus = @"1";
        self.goodLbl.textColor = [WWTolls colorWithHexString:@"#959595"];
        [self.goodButton setBackgroundImage:[UIImage imageNamed:@"jy-32"] forState:UIControlStateNormal];
        //点赞数
        if ([self.model.praisecount isEqualToString:@"0"]) {
            self.goodLbl.font = [UIFont fontWithName:@"Helvetica Neue" size:12.5];
            self.goodLbl.text = @"加油";
        } else {
            self.goodLbl.font = [UIFont fontWithName:@"Helvetica Neue" size:14.5];
            self.goodLbl.text = self.model.praisecount;
        }
    }
    else{
        self.model.praisecount = [NSString stringWithFormat:@"%d",self.model.praisecount.intValue+1];
        self.praisestatus = @"0";
        self.model.praisestatus = @"0";
        [self.goodButton popOutsideWithDuration:0.5];
        [self.goodButton animate];
        [self.goodButton setBackgroundImage:[UIImage imageNamed:@"jy-36-"] forState:UIControlStateNormal];
        self.goodLbl.textColor = [WWTolls colorWithHexString:@"#ff4d48"];
        //点赞数
        if ([self.model.praisecount isEqualToString:@"0"]) {
            self.goodLbl.font = [UIFont fontWithName:@"Helvetica Neue" size:12.5];
            self.goodLbl.text = @"加油";
            
        } else {
            self.goodLbl.font = [UIFont fontWithName:@"Helvetica Neue" size:14.5];
            self.goodLbl.text = self.model.praisecount;
        }
    }
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setObject:self.model.showid forKey:@"receiveid"];
    [dictionary setValue:praisesta forKey:@"praisestatus"];
    [dictionary setObject:@"3" forKey:@"praisetype"];//0 赞人/1 赞游戏/2赞团聊
    
    WEAKSELF_SS
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_PRAISE_104 parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        weakSelf.goodButton.userInteractionEnabled = YES;
        if ([dic[@"result"] isEqualToString:@"0"]) {
            
        }
        
    }];
}



@end






