//
//  ZDSHealthDiaryTableViewCell.m
//  zhidoushi
//
//  Created by System Administrator on 15/10/19.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "ZDSHealthDiaryTableViewCell.h"

@implementation ZDSHealthDiaryTableViewCell

- (void)awakeFromNib {
    _m_imageView.layer.borderColor = [UIColor grayColor].CGColor;
    _m_imageView.layer.borderWidth = 0.3;
    // Initialization code
}
+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"ZDSHealthDiaryTableViewCell";
    ZDSHealthDiaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell =[[[NSBundle mainBundle] loadNibNamed:@"ZDSHealthDiaryTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
