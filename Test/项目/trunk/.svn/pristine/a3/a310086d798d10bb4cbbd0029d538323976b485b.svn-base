//
//  ZDSGroupBubbleCell.m
//  zhidoushi
//
//  Created by xinglei on 14/12/16.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "ZDSGroupBubbleCell.h"

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
#import "ChatViewController.h"

#import "WWRequestOperationEngine.h"
#import "JSONKit.h"
#import "UITableViewCell+SSLSelect.h"

@interface ZDSGroupBubbleCell ()
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
@property (weak, nonatomic) IBOutlet UIImageView *bubbleImageView;


@end

@implementation ZDSGroupBubbleCell

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
    
    [self setSelectBackgroundColor:[WWTolls colorWithHexString:@"#eaeaea"] andNormalBackgroundColor:nil];
}

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

#pragma mark - 戳它
- (IBAction)thrustHim:(id)sender {
    
    ChatViewController *chat = [[ChatViewController alloc] init];
    chat.userId = self.model.userid;
    chat.title = self.model.username;
    
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[GroupViewController class]]) {
            [((GroupViewController*)nextResponder).navigationController pushViewController:chat animated:YES];
            return;
        }
    }
}

#pragma mark - 举报
- (IBAction)juBao:(id)sender {
    if ([self.delegate respondsToSelector:@selector(reportClick:)]) {
        [self.delegate reportClick:self.model.barid];
    }
}

-(void)initMyCellWithModel:(GroupTalkModel*)model {
    
    self.model = model;
    
    //戳它按钮
     NSString *userid = [NSUSER_Defaults objectForKey:ZDS_USERID];
    self.thurstHimButton.hidden = [self.model.userid isEqualToString:userid];
    
    //头像
    imageString = model.userinfoimageurl;
    userId = model.userid;
    NSLog(@"model.userinfoimageurl:%@",model.userinfoimageurl);
    NSURL *url = [NSURL URLWithImageString:model.userinfoimageurl  Size:98];
    [self.headImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"mrtx_98_98"]];
    self.headImage.clipsToBounds = YES;
    self.headImage.layer.cornerRadius = 20;
    self.headImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPhoto)];
    [self.headImage addGestureRecognizer:tap];
    
    NSMutableArray *arr = [NSMutableArray array];
    //                imageView.backgroundColor = [UIColor yellowColor];
    for (int i = 1; i < 26; i++) {
        [arr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%d@2x.png",i]]];
    }
    
    self.bubbleImageView.animationDuration = 1.35;
    self.bubbleImageView.animationImages = arr;
    [self.bubbleImageView startAnimating];
    
//    //名字
    self.nameLabel.text = [NSString stringWithFormat:@"%@",model.username];
//    //时间
    self.timeLabel.text = [WWTolls timeString22:[NSString stringWithFormat:@"%@",model.createtime]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(CGFloat)getMyCellHeight:(GroupTalkModel*)model
{
    CGFloat h = 49;
    
    h += [self getStringRect:model.content].height;
        
        if (model.imageurl==nil||model.imageurl.length == 0) {
            h += 10;
        }
        else{
            h += 214;
            if (model.content.length == 0 || model.content == nil) {
                h -= 15;
            }
        }
    
    h+=14;
    h+=27;
        return h;

}

//..测算字符串高度..//
- (CGSize)getStringRect:(NSString*)aString
{
    
    CGSize size;

    size.height = [WWTolls heightForString:aString fontSize:14 andWidth:306];//100 100 28 28
    if (aString.length>18) {
        size.height +=6;
    }

    if(iPhone4){
    
        size.height = [WWTolls heightForString:aString fontSize:14 andWidth:306];
    
    }


    return  size;
    
}

@end
