//
//  MessagePersonalTableViewCell.m
//  zhidoushi
//
//  Created by nick on 15/11/13.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import "MessagePersonalTableViewCell.h"

@implementation MessagePersonalTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setModel:(InformationModel *)model{
    _model = model;
    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:model.userimage]];
    self.userNameLbl.text = model.username;
    self.timeLbl.text = [WWTolls date:model.pushtime];
    self.contentLbl.text = model.content;
    if(model.gamename.length>0){
        NSRange rang = [model.content rangeOfString:model.gamename];
        if (rang.length>0) {
            if ([[model.content substringFromIndex:rang.location+1] rangeOfString:model.gamename].length<1) {
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:model.content];
                [str addAttribute:NSForegroundColorAttributeName value:OrangeColor range:rang];
                self.contentLbl.attributedText = str;
            }
        }
    }
    [self.groupImageView sd_setImageWithURL:[NSURL URLWithString:model.imageurl]];
    self.groupNameLbl.text = model.gamename;
    self.groupPerson.text = model.totalnumpeo;
    NSArray *tagLabels = [model.taglist componentsSeparatedByString:@","];
    /// 标签
    //    [self.tagsView createTagLabels:tagLabels completed:^{
    //
    //        if (self.tagsView.tagsCol == 1) {
    //            self.tagsViewMarginY.constant = 7.5;
    //        } else{
    //            self.tagsViewMarginY.constant = 10;
    //        }
    //    }];
    self.groupTagView.tagMargin = 5;
    [self.groupTagView createTagLables:tagLabels withTagColor:[WWTolls colorWithHexString:@"ff5340"] tagFont:12 completed:^{
        if (self.groupTagView.tagsCol == 1) {
            self.tagsViewMarginY.constant = 7.5;
        } else{
            self.tagsViewMarginY.constant = 10;
        }
    }];
//    self.groupTagView.tag = model.taglist;
}

@end
