//
//  InformationTableViewCell.m
//  zhidoushi
//
//  Created by nick on 15/4/28.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "InformationTableViewCell.h"

@implementation InformationTableViewCell
-(void)setModel:(InformationModel *)model{
    _model = model;
    self.tip.hidden = YES;
    self.headerImage.layer.cornerRadius = 0;
    if ([model.noticetype isEqualToString:@"9"]) {//周记
        self.timelbl.text = [WWTolls configureTimeString:model.pushtime andStringType:@"M-d HH:mm"];
        self.content.text = model.message;
//        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n \n%@",model.message,model.content]];
//        [str addAttribute:NSForegroundColorAttributeName value:[WWTolls colorWithHexString:@"#959595"] range:NSMakeRange(model.message.length,str.length-model.message.length)];
//        [str addAttribute:NSForegroundColorAttributeName value:[WWTolls colorWithHexString:@"#4ea7f2"] range:NSMakeRange(0,model.message.length)];
//        [str addAttribute:NSFontAttributeName value:MyFont(15) range:NSMakeRange(0,model.message.length)];
//        [str addAttribute:NSFontAttributeName value:MyFont(14) range:NSMakeRange(model.message.length+3,model.content.length)];
//        [str addAttribute:NSFontAttributeName value:MyFont(7) range:NSMakeRange(model.message.length,3)];
//        
//        self.content.attributedText = str;
        self.headerImage.image = [UIImage imageNamed:@"tbrj-120.jpg"];
    }else if ([model.noticetype isEqualToString:@"8"]) {//广播
        self.timelbl.text = [WWTolls configureTimeString:model.pushtime andStringType:@"M-d HH:mm"];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n \n%@",model.message,model.content]];
        [str addAttribute:NSForegroundColorAttributeName value:[WWTolls colorWithHexString:@"#959595"] range:NSMakeRange(model.message.length,str.length-model.message.length)];
        [str addAttribute:NSForegroundColorAttributeName value:[WWTolls colorWithHexString:@"#4ea7f2"] range:NSMakeRange(0,model.message.length)];
        [str addAttribute:NSFontAttributeName value:MyFont(15) range:NSMakeRange(0,model.message.length)];
        [str addAttribute:NSFontAttributeName value:MyFont(14) range:NSMakeRange(model.message.length+3,model.content.length)];
        [str addAttribute:NSFontAttributeName value:MyFont(7) range:NSMakeRange(model.message.length,3)];
        
        self.content.attributedText = str;
        self.headerImage.image = [UIImage imageNamed:@"soung-noti"];
    }else{
        if (_model.message.length>0) {
            self.timelbl.text = [WWTolls configureTimeString:model.pushtime andStringType:@"M-d HH:mm"];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n \n%@",model.message,model.content]];
            [str addAttribute:NSForegroundColorAttributeName value:[WWTolls colorWithHexString:@"#959595"] range:NSMakeRange(model.message.length,str.length-model.message.length)];
            [str addAttribute:NSFontAttributeName value:MyFont(15) range:NSMakeRange(0,model.message.length)];
            [str addAttribute:NSFontAttributeName value:MyFont(14) range:NSMakeRange(model.message.length+3,model.content.length)];
            [str addAttribute:NSFontAttributeName value:MyFont(7) range:NSMakeRange(model.message.length,3)];
            
            if(model.gamename.length>0){
                if ([model.msgkind isEqualToString:@"18"]||[model.msgkind isEqualToString:@"19"]||[model.msgkind isEqualToString:@"20"]||[model.msgkind isEqualToString:@"21"]) {
                    NSRange rang = [model.content rangeOfString:model.gamename];
                    if (rang.length>0) {
                        if ([[model.content substringFromIndex:rang.location+1] rangeOfString:model.gamename].length<1) {
                            [str addAttribute:NSForegroundColorAttributeName value:[WWTolls colorWithHexString:@"#69bffe"] range:NSMakeRange(model.message.length+3+rang.location,rang.length)];
                        }
                    }
                }else{
                    NSRange rang = [model.message rangeOfString:model.gamename];
                    if (rang.length>0) {
                        if ([[model.message substringFromIndex:rang.location+1] rangeOfString:model.gamename].length<1) {
                            [str addAttribute:NSForegroundColorAttributeName value:[WWTolls colorWithHexString:@"#69bffe"] range:rang];
                        }
                    }
                }
            }
            
            self.content.attributedText = str;
            if([model.msgkind isEqualToString:@"17"]){//群长群发通知
                [self.headerImage sd_setImageWithURL:[NSURL URLWithString:model.userimage]];
                self.headerImage.layer.cornerRadius = 20;
                self.headerImage.clipsToBounds = YES;
                self.tip.hidden = NO;
            }else [self.headerImage sd_setImageWithURL:[NSURL URLWithString:model.imageurl]];
        }else{
            [self.headerImage sd_setImageWithURL:[NSURL URLWithString:model.imageurl]];
            self.timelbl.text = [WWTolls configureTimeString:model.pushtime andStringType:@"M-d HH:mm"];
            self.content.text = model.content;
            if(model.gamename.length>0){
                NSRange rang = [model.content rangeOfString:model.gamename];
                if (rang.length>0) {
                    if ([[model.content substringFromIndex:rang.location+1] rangeOfString:model.gamename].length<1) {
                        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:model.content];
                        [str addAttribute:NSForegroundColorAttributeName value:[WWTolls colorWithHexString:@"#69bffe"] range:rang];
                        self.content.attributedText = str;
                    }
                }
            }
        }
    }
    
}
- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.headerImage.backgroundColor = [WWTolls colorWithHexString:@"#e5e5e5"];
    self.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
