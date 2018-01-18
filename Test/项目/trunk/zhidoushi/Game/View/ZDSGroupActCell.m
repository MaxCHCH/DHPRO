//
//  ZDSGroupActCell.m
//  zhidoushi
//
//  Created by xinglei on 14/12/16.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "ZDSGroupActCell.h"

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

@interface ZDSGroupActCell ()
{
    BOOL result;
    NSString *stopResult;
    NSString *talkidResult;
    NSString *imageString;
    NSString *userId;
    NSString *contentimage;
}

@property(strong,nonatomic) GroupTalkModel* model;

@property (weak, nonatomic) IBOutlet MCFireworksButton *goodButton;
@property (weak, nonatomic) IBOutlet UIButton *goodBigBtn;
@property (weak, nonatomic) IBOutlet UILabel *goodLbl;
@property (weak, nonatomic) IBOutlet UILabel *talkLbl;
@property (weak, nonatomic) IBOutlet UIButton *talkBigBtn;
@property(copy,nonatomic) NSString* talkid;
@property(copy,nonatomic) NSString* praisestatus;//当前消息的点赞状态
@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (weak, nonatomic) IBOutlet UIView *line;

@property (weak, nonatomic) IBOutlet UIImageView *flagImageView;



@end

@implementation ZDSGroupActCell

#pragma mark Life Cycle

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.line.backgroundColor = ZDS_BACK_COLOR;
    self.toolView.layer.borderWidth = 0.5;
    self.toolView.layer.borderColor = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;
    for (UIView *view in self.toolView.subviews) {
        if (view.height == 1) {
            view.height = 0.5;
        }
    }
    
//    self.topButton.hidden = YES;
    
    
    [self setSelectBackgroundColor:[WWTolls colorWithHexString:@"#eaeaea"] andNormalBackgroundColor:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Event Responses
#pragma mark - 点击头像
-(void)clickPhoto{
    MeViewController *single = [[MeViewController alloc]init];
    single.otherOrMe = 1;
    single.userID = userId;
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[GroupViewController class]]) {
            [((GroupViewController*)nextResponder).navigationController pushViewController:single animated:YES];
            return;
        }
    }
}

#pragma mark - 举报
- (IBAction)juBao:(id)sender {
//    if ([self.delegate respondsToSelector:@selector(reportClick:AndType:)]) {
//        [self.delegate reportClick:self.model.barid AndType:@"3"];
//    }
    //extension
    if ([self.delegate respondsToSelector:@selector(reportClick:andType:andIndexPath:)]) {
        [self.delegate reportClick:self.model.barid andType:@"3" andIndexPath:self.indexPath];
    }
//    if ([self.delegate respondsToSelector:@selector(groupActCell:reportClick:andType:)]) {
//        [self.delegate groupActCell:self reportClick:self.model.barid andType:@"3"];
//    }   
}

#pragma mark - 加入
- (IBAction)joinButtonClick:(id)sender {
    
    self.joinButton.userInteractionEnabled = NO;
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    //活动ID
    [dictionary setObject:self.model.barid forKey:@"activityid"];
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:[NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_Group_Joinact] parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        weakSelf.joinButton.userInteractionEnabled = YES;
        if (![dic isKindOfClass:[NSDictionary class]] || dic==nil) {
            [weakSelf.viewController showAlertMsg:ZDS_NONET_HUASHU andFrame:CGRectZero];
        }else{
            if ([dic[@"result"] isEqualToString:@"0"]) {
                [NSUSER_Defaults setValue:@"YES" forKey:@"tuanzubianhua"];
                self.model.isjoin = @"0";
                self.model.partercount = [NSString stringWithFormat:@"%d",[self.model.partercount intValue]+1];
                NSLog(@"加入成功");
                
                [weakSelf.joinButton setImage:[UIImage imageNamed:@"yijiaru-80-44.png"] forState:UIControlStateNormal];
                weakSelf.joinButton.userInteractionEnabled = NO;
                weakSelf.goodLbl.text = [NSString stringWithFormat:@"%d",weakSelf.goodLbl.text.intValue + 1];
            } else {
                NSLog(@"加入失败");
            }
        }   
    }];
}

- (IBAction)topButton:(id)sender {
    
    NSLog(@"置顶次数*********%d",_topupper);
    talkidResult = self.model.barid;
    if (_topupper<1 && [self.topButton.titleLabel.text isEqualToString:@"置顶"]) {//如果置顶次数小于3才可以置顶
        [self.topButton setTitle:@"取消置顶" forState:UIControlStateNormal];
        stopResult = @"1";
        _topupper++;
        [self topClickEvent];
    }else if([self.topButton.titleLabel.text isEqualToString:@"置顶"]){
        [self.viewController showAlertMsg:@"只能置顶一条消息" andFrame:CGRectZero];
    }
    
    if([self.topButton.titleLabel.text isEqualToString:@"取消置顶"]){
        //topupper=3;
        [self.topButton setTitle:@"置顶" forState:UIControlStateNormal];
        stopResult = @"0";
        if (_topupper>0) {
            _topupper--;
        }
        [self topClickEvent];
    }
    
}

#pragma mark - Private Methods
-(void)initMyCellWithModel:(GroupTalkModel*)model
{
    
    self.model = model;
    
    //头像
    imageString = model.userinfoimageurl;
    userId = model.userid;
    NSURL *url = [NSURL URLWithImageString:model.userinfoimageurl  Size:98];
    [self.headImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"mrtx_98_98.png"]];
    self.headImage.clipsToBounds = YES;
    self.headImage.layer.cornerRadius = 20;
    self.headImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPhoto)];
    [self.headImage addGestureRecognizer:tap];
    
    //名字
    self.nameLabel.text = model.username;
    
    //时间
    self.timeLabel.text = [WWTolls timeString22:[NSString stringWithFormat:@"%@",model.createtime]];
    
    //内容
//    self.contentLabel.backgroundColor = [UIColor redColor];
    self.contentLabel.text = [NSString stringWithFormat:@"      %@",self.model.content];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.height = [[self class] getContentHeight:self.model];
    
    if (self.contentLabel.height > 18) {
        self.joinButton.top = self.contentLabel.maxY;
    } else {
        self.joinButton.top = 81;
    }
    
    self.toolView.top = [[self class] getToolViewMaxYWithModel:self.model];
    
    //参与者人数label
    self.goodLbl.text = [model.partercount isEqualToString:@"0"]? @"人数" :model.partercount;
    
    //评论数label
    self.talkLbl.text = [model.commentcount isEqualToString:@"0"]? @"评论" :model.commentcount;
    
    
    
//    //置顶信息
//    NSString *topString = [NSString stringWithFormat:@"%@",model.istop];
//    
//    //
//    if ([topString isEqualToString:@"0"]) {
//        self.topButton.hidden = NO;
//        [self.topButton setBackgroundImage:[UIImage imageNamed:@"zhiding-62-20.png"] forState:UIControlStateNormal];
//    } else {
//        self.topButton.hidden = YES;
//    }
    
    
    
//    self.topButton.hidden = YES;
//    
//    
//    if ([model.logangle isEqualToString:@"0"]&&[[NSUSER_Defaults objectForKey:ZDS_USERID] isEqualToString:model.userid]) {
//        if ([topString isEqualToString:@"0"]) {
//            [self.topButton setTitle:@"置顶" forState:UIControlStateNormal];
//            self.topButton.titleLabel.text = @"置顶";
//            [self.topButton setBackgroundImage:[UIImage imageNamed:@"group_top-110-44"] forState:UIControlStateNormal];
//            if(self.topupper > 0)
//                self.topButton.hidden = YES;
//            else self.topButton.hidden = NO;
//        }else{
//            [self.topButton setBackgroundImage:[UIImage imageNamed:@"group_concelTop"] forState:UIControlStateNormal];
//            [self.topButton setTitle:@"取消置顶" forState:UIControlStateNormal];
//            self.topButton.titleLabel.text = @"取消置顶";
//            self.topButton.hidden = NO;
//        }   
//        
//        self.topButton.userInteractionEnabled = YES;
//    }else if ([model.logangle isEqualToString:@"1"]&&[[NSUSER_Defaults objectForKey:ZDS_USERID] isEqualToString:model.userid]) {
//        if ([topString isEqualToString:@"0"]) {
//            [self.topButton setTitle:@"置顶" forState:UIControlStateNormal];
//            self.topButton.titleLabel.text = @"置顶";
//            [self.topButton setBackgroundImage:[UIImage imageNamed:@"group_top-110-44"] forState:UIControlStateNormal];
//            if(self.topupper > 0)
//                self.topButton.hidden = YES;
//            else self.topButton.hidden = NO;
//        }else{
//            [self.topButton setTitle:@"取消置顶" forState:UIControlStateNormal];
//            self.topButton.titleLabel.text = @"取消置顶";
//            [self.topButton setBackgroundImage:[UIImage imageNamed:@"group_concelTop"] forState:UIControlStateNormal];
//            self.topButton.hidden = NO;
//        }
//        
//        self.topButton.userInteractionEnabled = YES;
//    }
//    
//    if ([model.logangle isEqualToString:@"2"] && ![topString isEqualToString:@"0"]) {
//        [self.topButton setTitle:@"置顶" forState:UIControlStateNormal];
//        self.topButton.hidden = NO;
//        self.topButton.userInteractionEnabled = NO;
//    }if ([model.logangle isEqualToString:@"3"] && ![topString isEqualToString:@"0"]) {
//        [self.topButton setTitle:@"置顶" forState:UIControlStateNormal];
//        self.topButton.hidden = NO;
//        self.topButton.userInteractionEnabled = NO;
//    }
    
    //已参加
    if ([self.model.isjoin isEqualToString:@"0"]) {
        [self.joinButton setImage:[UIImage imageNamed:@"yijiaru-80-44.png"] forState:UIControlStateNormal];
        self.joinButton.userInteractionEnabled = NO;
    } else {
        [self.joinButton setImage:[UIImage imageNamed:@"jiaru-80-44.png"] forState:UIControlStateNormal];
        self.joinButton.userInteractionEnabled = YES;
    }
    
    
    //加入按钮的隐藏
    NSString *userid = [NSUSER_Defaults objectForKey:ZDS_USERID];
    self.joinButton.hidden = [self.model.userid isEqualToString:userid];
    if ([self.model.logangle isEqualToString:@"3"]) {
        self.joinButton.hidden = YES;
    }
    
//    if (self.topButton.userInteractionEnabled) {
//        self.topButton.frame = CGRectMake(250, 13, 55, 22);
//        if ([topString isEqualToString:@"0"]) {
//            [self.topButton setBackgroundImage:[UIImage imageNamed:@"group_top-110-44"] forState:UIControlStateNormal];
//            
//        }else{
//            [self.topButton setBackgroundImage:[UIImage imageNamed:@"group_concelTop"] forState:UIControlStateNormal];
//        }
//    } else {
//        self.topButton.frame = CGRectMake(270, 13, 31, 10);
//        [self.topButton setBackgroundImage:[UIImage imageNamed:@"zhiding-62-20.png"] forState:UIControlStateNormal];
//    }
}

#pragma mark - 置顶事件
-(void)topClickEvent
{
    if ([self.delegate respondsToSelector:@selector(clickTopButton)]) {
        [self.delegate talkidString:talkidResult andType:@"1"];
        [self.delegate topString:stopResult];
        [self.delegate clickTopButton];
    }
    
}

#pragma mark Static Methods
+ (CGFloat)getMyCellHeightWithModel:(GroupTalkModel*)model {
    return (int)[self getToolViewMaxYWithModel:model]  + 35;
}   

//toolView的y值
+ (CGFloat)getToolViewMaxYWithModel:(GroupTalkModel *)model {
    
    CGFloat afterHeight = 60;
    CGFloat muHeight = 0;
    //活动图标高度
    CGFloat flagHeight = 21;
    
    CGFloat temp = 9 + 22 + 5;
    
    //减去加入按钮的高度
    NSString *userid = [NSUSER_Defaults objectForKey:ZDS_USERID];
    if ([model.userid isEqualToString:userid] || [model.logangle isEqualToString:@"3"]) {
        temp -= 22;
    }   
    
    if ([[self class] getContentHeight:model] > 18) {
        muHeight = [[self class] getContentHeight:model];
    } else {
        muHeight = flagHeight;
    }
    
    return afterHeight + muHeight + temp;
}

//文字的高度
+ (CGFloat)getContentHeight:(GroupTalkModel *)model {
    
    NSString *string = [NSString stringWithFormat:@"      %@",model.content];
    CGFloat height = [WWTolls heightForString:string fontSize:14.0 andWidth:299];
    NSLog(@"height:%f",height);
    
    if ((height > 18) && !iPhone4) {
        height += 5;
    }
    
    return height;
}   

@end
