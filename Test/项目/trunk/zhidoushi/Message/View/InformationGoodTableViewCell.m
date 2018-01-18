//
//  InformationGoodTableViewCell.m
//  zhidoushi
//
//  Created by nick on 15/4/28.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "InformationGoodTableViewCell.h"
#import "MeViewController.h"

@implementation InformationGoodTableViewCell

-(void)setModel:(InformationModel *)model{
    _model = model;
    self.goodIcon.hidden = YES;
    self.showImage.hidden = YES;
    self.bycontentlbl.hidden = YES;
    self.timeLbl.text = [WWTolls configureTimeString:model.pushtime andStringType:@"M-d HH:mm"];
    self.nameLbl.text = model.username;
    [self.headerView sd_setImageWithURL:[NSURL URLWithString:model.userimage] placeholderImage:[UIImage imageNamed:@"mrtx_98_98"]];
    //164 156   253 67  184 136
    self.showImage.backgroundColor = [UIColor whiteColor];
    if ([model.noticetype isEqualToString:@"0"]) {//0回复
        self.contentLbl.text = [NSString stringWithFormat:@"回复：%@",model.content];
        CGFloat h = [WWTolls heightForString:self.contentLbl.text fontSize:14 andWidth:SCREEN_WIDTH-136];
        self.contentLbl.frame = CGRectMake(59, 35, SCREEN_WIDTH-136, h+6);
        self.timeLbl.frame = CGRectMake(59, 42+h, 184, 13);
        if ([model.imageurl rangeOfString:@"http://"].length>0&&[model.imageurl rangeOfString:@"http://"].location == 0) {//有图片
            self.showImage.hidden = NO;
            [self.showImage sd_setImageWithURL:[NSURL URLWithString:model.imageurl]];
        }else{
            self.bycontentlbl.hidden = NO;
            self.bycontentlbl.text = model.talkcontent;
        }
    }else if ([model.noticetype isEqualToString:@"1"]) {//1赞
        self.goodIcon.hidden = NO;
        self.goodIcon.image = [UIImage imageNamed:@"DisCover_goodSum_22_22"];
        self.contentLbl.frame = CGRectMake(76, 40, 180, 14);
        self.timeLbl.frame = CGRectMake(59, 53, 119, 21);
        if ([model.praisetype isEqualToString:@"0"]) {//人
            self.contentLbl.text = @"给你加油";
        }else if ([model.praisetype isEqualToString:@"1"]) {//游戏
            self.contentLbl.text = @"赞了你的团";
            self.showImage.hidden = NO;
            [self.showImage sd_setImageWithURL:[NSURL URLWithString:model.imageurl]];
        }else if ([model.praisetype isEqualToString:@"2"]) {//图聊
            if ([model.imageurl rangeOfString:@"http://"].length>0&&[model.imageurl rangeOfString:@"http://"].location == 0) {//有图片
                self.showImage.hidden = NO;
                [self.showImage sd_setImageWithURL:[NSURL URLWithString:model.imageurl]];
            }else{
                self.bycontentlbl.hidden = NO;
                self.bycontentlbl.text = model.content;
            }
            self.contentLbl.text = @"";
        }else if ([model.praisetype isEqualToString:@"3"]) {//展示
            if ([model.imageurl rangeOfString:@"http://"].length>0&&[model.imageurl rangeOfString:@"http://"].location == 0) {//有图片
                self.showImage.hidden = NO;
                [self.showImage sd_setImageWithURL:[NSURL URLWithString:model.imageurl]];
            }else{
                self.bycontentlbl.hidden = NO;
                self.bycontentlbl.text = model.content;
            }
            self.contentLbl.text = @"";
        }
        
    }else if ([model.noticetype isEqualToString:@"3"]) {//3邀请
        self.contentLbl.width = SCREEN_WIDTH-67;
        self.contentLbl.text = [NSString stringWithFormat:@"%@",model.content];
        CGFloat h = [WWTolls heightForString:self.contentLbl.text fontSize:14 andWidth:SCREEN_WIDTH-67];
        self.contentLbl.frame = CGRectMake(59, 35, SCREEN_WIDTH-67, h+6);
        self.timeLbl.frame = CGRectMake(59, 42+h+3, 184, 13);
    }else if ([model.noticetype isEqualToString:@"4"]) {//4评论
        
        self.contentLbl.text = [NSString stringWithFormat:@"回复：%@",model.content];
        CGFloat h = [WWTolls heightForString:self.contentLbl.text fontSize:14 andWidth:SCREEN_WIDTH-136];
        self.contentLbl.frame = CGRectMake(59, 35, SCREEN_WIDTH-136, h+6);
        self.timeLbl.frame = CGRectMake(59, 42+h, 184, 13);
        if ([model.imageurl rangeOfString:@"http://"].length>0&&[model.imageurl rangeOfString:@"http://"].location == 0) {//有图片
            self.showImage.hidden = NO;
            [self.showImage sd_setImageWithURL:[NSURL URLWithString:model.imageurl]];
        }else{
            self.bycontentlbl.hidden = NO;
            self.bycontentlbl.text = model.showcontent;
        }
        
    }else if([model.noticetype isEqualToString:@"5"]){//打招呼
        model.content = @"捏了一下你的小肉肉";
        self.contentLbl.text = model.content;
        CGFloat h = [WWTolls heightForString:self.contentLbl.text fontSize:14 andWidth:SCREEN_WIDTH-67];
        self.contentLbl.frame = CGRectMake(59, 55, SCREEN_WIDTH-67, h+6);
        self.timeLbl.frame = CGRectMake(59, 42+h+23, 184, 13);
        self.showImage.hidden = YES;
        self.goodIcon.image = [UIImage imageNamed:@"nieyixia-24-26"];
        self.goodIcon.hidden = NO;
    }else if ([model.noticetype isEqualToString:@"6"]) {//6回复活动
        self.contentLbl.text = [NSString stringWithFormat:@"回复：%@",model.content];
        CGFloat h = [WWTolls heightForString:self.contentLbl.text fontSize:14 andWidth:SCREEN_WIDTH-156];
        self.contentLbl.frame = CGRectMake(59, 35, SCREEN_WIDTH-156, h+6);
        self.timeLbl.frame = CGRectMake(59, 42+h, 184, 13);
        self.bycontentlbl.hidden = NO;
        self.bycontentlbl.text = model.actcontent;
    }else if ([model.noticetype isEqualToString:@"7"]) {//7加入活动
        self.contentLbl.text = [NSString stringWithFormat:@"加入了你的活动"];
        self.contentLbl.frame = CGRectMake(59, 35, SCREEN_WIDTH-156, 20);
        self.timeLbl.frame = CGRectMake(59, 56, 184, 13);
        self.bycontentlbl.hidden = NO;
        self.bycontentlbl.text = model.actcontent;
    }

}

-(void)awakeFromNib {
    self.headerView.layer.cornerRadius = 20;
    self.headerView.clipsToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.headerView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHead)];
    [self.headerView addGestureRecognizer:tap];
    self.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.showImage.left = SCREEN_WIDTH - 60;
    self.showImage.contentMode = UIViewContentModeScaleAspectFill;
    self.showImage.clipsToBounds = YES;
    self.bycontentlbl.left =SCREEN_WIDTH - 65;
}

-(void)clickHead{
    MeViewController *single = [[MeViewController alloc]init];
    single.userID = self.model.snduserid;
    single.otherOrMe = 1;
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            [((UIViewController*)nextResponder).navigationController pushViewController:single animated:YES];
            return;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
