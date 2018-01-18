//
//  OfficialInformTableViewCell.m
//  zhidoushi
//
//  Created by nick on 15/7/6.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "OfficialInformTableViewCell.h"
#import "UIView+ViewController.h"
#import "MeViewController.h"
#import "NSString+WPAttributedMarkup.h"
#import "DiscoverTypeViewController.h"
#import "WPAttributedStyleAction.h"
#import "GroupViewController.h"
#import <CoreText/CoreText.h>

@implementation OfficialInformTableViewCell

- (void)awakeFromNib {
    self.headerImageView.clipsToBounds = YES;
    self.headerImageView.layer.cornerRadius = 20;
    self.speraLine.layer.borderColor = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;
    self.speraLine.layer.borderWidth = 0.5;

}

-(void)setModel:(DiscoverModel *)model{
    _model = model;
    self.tipguan.hidden = NO;
    self.name.text = model.username;
    self.time.text = [WWTolls configureTimeString:model.createtime andStringType:@"M-d HH:mm"];
    self.name.textColor = ZDS_DHL_TITLE_COLOR;
    if ([model.gamemode isEqualToString:@"3"]) {//普通团
        self.tagName.text = @"欢乐团";
        self.tagImage.image = [UIImage imageNamed:@"discover_tag_normal"];
    }else{//闯关团
        self.tagName.text = @"28天瘦4%";
        self.tagImage.image = [UIImage imageNamed:@"discover_tag_28"];
    }
    self.headerImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHeader)];
    [self.headerImageView addGestureRecognizer:tap];
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.userimage] placeholderImage:[UIImage imageNamed:@"mrtx_98_98"]];
    [self.groupImage sd_setImageWithURL:[NSURL URLWithString:model.gameimage]];
//    self.content.text = model.content;
    WEAKSELF_SS
    [self.content setContent:model.content WithTagClick:^(NSString *tag) {
        [weakSelf tagLabelAction];
    } AndOtherClick:^{
        [weakSelf gotoGroup];
    }];
//    NSRange range = [model.content rangeOfString:@"(^#([^#]+?)#)" options:NSRegularExpressionSearch];
//    if (range.location != NSNotFound) {
//        self.content.userInteractionEnabled = YES;
//        NSDictionary* style3 = @{@"body":@[[UIFont fontWithName:@"HelveticaNeue" size:15.0],[WWTolls colorWithHexString:@"#535353"]],
//                                 @"help":[WPAttributedStyleAction styledActionWithAction:^{
//                                     [weakSelf tagLabelAction];
//                                 }],@"other":[WPAttributedStyleAction styledActionWithAction:^{
//                                     [weakSelf gotoGroup];
//                                 }],
//                                 @"ll": [WWTolls colorWithHexString:@"#ff8a01"]};
//        
//        NSString *tagString = [model.content substringWithRange:range];
//        NSString *afterStirng = [model.content substringWithRange:NSMakeRange(range.location + range.length, model.content.length - range.length)];
//        
//        self.content.attributedText = [[NSString stringWithFormat:@"<help><ll>%@</ll></help><other>%@</other>",tagString,afterStirng] attributedStringWithStyleBook:style3];
//        [self.content.selectableRanges removeAllObjects];
//        [self.content setSelectableRange:NSMakeRange(0, tagString.length) hightlightedBackgroundColor:[WWTolls colorWithHexString:@"#eaeaea"]];
//    } else {
//        self.content.userInteractionEnabled = NO;
//        self.content.text = model.content;
//    }
}
-(void)setDynModel:(MyGroupDynModel *)model{
    _dynModel = model;
    self.tipguan.hidden = YES;
    self.content.userInteractionEnabled = NO;
    self.name.text = model.gamename;
    self.time.text = [WWTolls configureTimeString:model.createtime andStringType:@"M-d HH:mm"];
    self.name.textColor = [WWTolls colorWithHexString:@"#6b6b6b"];
    if ([model.gamemode isEqualToString:@"3"]) {//普通团
        self.tagName.text = @"欢乐团";
        self.tagImage.image = [UIImage imageNamed:@"discover_tag_normal"];
    }else{//闯关团
        self.tagName.text = @"28天瘦4%";
        self.tagImage.image = [UIImage imageNamed:@"discover_tag_28"];
    }
    self.headerImageView.userInteractionEnabled = NO;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.gameimage] placeholderImage:[UIImage imageNamed:@"mrtx_98_98"]];
    [self.groupImage sd_setImageWithURL:[NSURL URLWithString:model.contimage]];
    self.content.text = model.content;
    if ([model.dynkind isEqualToString:@"2"]) {
        self.content.font = MyFont(12);
        self.content.textColor = [WWTolls colorWithHexString:@"#959595"];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"新任务\n \n%@",model.content]];
        [str addAttribute:NSForegroundColorAttributeName value:[WWTolls colorWithHexString:@"#535353"] range:NSMakeRange(0,3)];
        [str addAttribute:NSForegroundColorAttributeName value:[WWTolls colorWithHexString:@"#959595"] range:NSMakeRange(6,model.content.length)];
        [str addAttribute:NSFontAttributeName value:MyFont(7) range:NSMakeRange(3,3)];

        [str addAttribute:NSFontAttributeName value:MyFont(15) range:NSMakeRange(0, 3)];
        self.content.attributedText = str;
    }else{
        self.content.font = MyFont(15);
        self.content.textColor = [WWTolls colorWithHexString:@"#535353"];
        self.content.text = model.content;
    }

}
#pragma mark - 头像点击事件
-(void)clickHeader{
    if (self.model.userid.length>0) {
        MeViewController *me = [[MeViewController alloc] init];
        me.userID = self.model.userid;
        me.otherOrMe = 1;
        [self.viewController.navigationController pushViewController:me animated:YES];
    }
}
#pragma mark 标签列表触发事件
- (void)tagLabelAction {
    DiscoverTypeViewController *typeVC = [[DiscoverTypeViewController alloc] init];
    typeVC.showtag = self.model.showtag;
    [self.viewController.navigationController pushViewController:typeVC animated:YES];
}
-(void)gotoGroup{
    GroupViewController *typeVC = [[GroupViewController alloc] init];
    typeVC.groupId = self.model.gameid;
    typeVC.clickevent = 7;
    typeVC.joinClickevent = @"7";
    [self.viewController.navigationController pushViewController:typeVC animated:YES];
}
@end
