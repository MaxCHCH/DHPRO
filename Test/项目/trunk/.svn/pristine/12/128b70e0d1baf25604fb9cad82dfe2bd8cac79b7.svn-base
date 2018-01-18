//
//  MessageTableViewCell.m
//  zhidoushi
//
//  Created by nick on 15/4/28.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

- (void)awakeFromNib {
    self.headerImage.layer.cornerRadius = 22;
    self.headerImage.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    self.contentView.layer.borderColor = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;
    _redDian.backgroundColor = [WWTolls colorWithHexString:@"#FF723E"];
    _redDian.layer.cornerRadius = 7.5;
    _redDian.clipsToBounds = YES;
//    self.separatorInset = UIEdgeInsetsMake(0, 11, 0, 11);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)setHighlighted:(BOOL)highlighted{
    if (highlighted) {
        self.contentView.backgroundColor = ZDS_BACK_COLOR;
//        self.contentView.layer.borderWidth = 0.5;
    }else{
        self.contentView.backgroundColor = [UIColor whiteColor];
//        self.contentView.layer.borderWidth = 0;
    }
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    [self setHighlighted:highlighted];
    [self setNeedsDisplay];
}
@end
