//
//  MessageCell.m
//  15-QQ聊天布局
//
//  Created by Liu Feng on 13-12-3.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "MessageCell.h"
#import "Message.h"
#import "MessageFrame.h"
#import "UIView+ViewController.h"
#import "MeViewController.h"
#import "UIViewExt.h"
#import "HTCopyableButton.h"
@interface MessageCell ()
{
    UIButton     *_timeBtn;
    UIImageView *_iconView;
    HTCopyableButton    *_contentBtn;
    UIImageView *_timeImage;
    UILabel *_pingbi;
    UIImageView *_gantanhao;
}

@end

@implementation MessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
#warning 必须先设置为clearColor，否则tableView的背景会被遮住
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // 1、创建时间按钮
        _timeBtn = [[UIButton alloc] init];
        [_timeBtn setTitleColor:[WWTolls colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        _timeBtn.titleLabel.font = kTimeFont;
        _timeBtn.enabled = NO;
        _timeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_time-24-24"]];
        [self.contentView addSubview:_timeImage];
        [self.contentView addSubview:_timeBtn];
        
        // 2、创建头像
        _iconView = [[UIImageView alloc] init];
        _iconView.layer.cornerRadius = 22;
        _iconView.clipsToBounds = YES;
        [self.contentView addSubview:_iconView];
        _iconView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHead)];
        [_iconView addGestureRecognizer:tap];
        // 3、创建内容
        _contentBtn = [HTCopyableButton buttonWithType:UIButtonTypeCustom];
        [_contentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _contentBtn.titleLabel.font = kContentFont;
        _contentBtn.titleLabel.numberOfLines = 0;
        
        [self.contentView addSubview:_contentBtn];
        //4.屏蔽
        _pingbi = [[UILabel alloc] init];
        _pingbi.font = MyFont(10);
        _pingbi.textColor = [WWTolls colorWithHexString:@"#999999"];
        _pingbi.textAlignment = NSTextAlignmentCenter;
        _pingbi.text = @"由于对方的设置，你无法发送消息";
        [self.contentView addSubview:_pingbi];
        _gantanhao = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_pingbi"]];
        [self.contentView addSubview:_gantanhao];
    }
    return self;
}
#pragma mark - 头像点击
-(void)clickHead{
    MeViewController *me = [[MeViewController alloc] init];
    me.otherOrMe = 1;
    me.userID = self.messageFrame.message.dict[@"snduserid"];
    [self.viewController.view endEditing:YES];
    [self.viewController.navigationController pushViewController:me animated:YES];
}

- (void)setMessageFrame:(MessageFrame *)messageFrame{
    
    _messageFrame = messageFrame;
    Message *message = _messageFrame.message;
    
    //设置时间
    [_timeBtn setTitle:[WWTolls date:message.time] forState:UIControlStateNormal];
    _timeBtn.frame = _messageFrame.timeF;
    _timeImage.frame = CGRectMake(_timeBtn.left-2, _timeBtn.top+5, 12, 12);
    
    //设置头像
    [_iconView sd_setImageWithURL:[NSURL URLWithString:message.icon] placeholderImage:[UIImage imageNamed:@"mrtx_98_98"]];
    _iconView.frame = _messageFrame.iconF;
    
    //设置内容
    [_contentBtn setTitle:message.content forState:UIControlStateNormal];
    _contentBtn.contentEdgeInsets = UIEdgeInsetsMake(kContentTop, kContentLeft, kContentBottom, kContentRight);
    _contentBtn.frame = _messageFrame.contentF;
    //屏蔽状态
    if (message.type == MessageTypeMe) {
        _contentBtn.contentEdgeInsets = UIEdgeInsetsMake(kContentTop, kContentRight, kContentBottom, kContentLeft);
    }
    if ([message.isOK isEqualToString:@"1"]) {//已屏蔽
        _pingbi.hidden = NO;
        _gantanhao.hidden = NO;
        _pingbi.frame = CGRectMake(0, _contentBtn.bottom-2, SCREEN_WIDTH, 14);
        if (message.type == MessageTypeMe){
        _gantanhao.frame = CGRectMake(_contentBtn.left-19, _iconView.top+15, 13, 13);
        }
        else{ _gantanhao.frame = CGRectMake(_contentBtn.right+5, _iconView.top+15, 13, 13);
        }
    }else {
        _pingbi.hidden = YES;
        _gantanhao.hidden = YES;
    }
    //气泡背景图片
    UIImage *normal;
    UIImage *highlited;
    UIColor *c = [WWTolls colorWithHexString:@"#738289"];
    _contentBtn.clipsToBounds = YES;
    _contentBtn.layer.cornerRadius = 4;
    if (message.type == MessageTypeMe) {
        [_contentBtn setTitleColor:c forState:UIControlStateNormal];
        [_contentBtn setTitleColor:c forState:UIControlStateHighlighted];
//        normal = [UIImage imageNamed:@"chat_other_bk_normal"];
//        highlited = [UIImage imageNamed:@"chat_other_bk_highlighted"];
        normal = [WWTolls imageWithColor:[WWTolls colorWithHexString:@"#f6f6f6"]];
        
    }else{
        [_contentBtn setTitleColor:c forState:UIControlStateNormal];
        [_contentBtn setTitleColor:c forState:UIControlStateHighlighted];
        normal = [WWTolls imageWithColor:[WWTolls colorWithHexString:@"#EFF7FF"]];

//        normal = [UIImage imageNamed:@"chat_me_bk_normal"];
//        highlited = [UIImage imageNamed:@"chat_me_bk_highlighted"];
    }
    
    [_contentBtn setBackgroundImage:[self getBackImage: normal] forState:UIControlStateNormal];
//    [_contentBtn setBackgroundImage:[self getBackImage: highlited] forState:UIControlStateHighlighted];
    
}

/**
 *  获取背景tup
 *
 *  @param normal 原图
 *
 *  @return 返回不失真背景图片
 */
- (UIImage*)getBackImage:(UIImage*)normal{
    CGSize size;
    size = CGSizeMake(normal.size.width / 2.0f, normal.size.height / 2.0f);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    if (1.0 == [[UIScreen mainScreen] scale])
        [normal drawInRect:CGRectIntegral((CGRect){0.0f, 0.0f, size})];
    else
        [normal drawInRect:(CGRect){0.0f, 0.0f, size}];
    normal = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5 topCapHeight:normal.size.height * 0.7];
    return normal;
}

@end
