//
//  TimeChooseTableViewCell.m
//  LeBangProject
//
//  Created by Rillakkuma on 16/7/25.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import "TimeChooseTableViewCell.h"

@implementation TimeChooseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _labelTimetop.tag = 101;
    _labelTimebottom.tag = 102;
    _labelTimeEndtop.tag = 103;
    _labelTimeEndbottom.tag = 104;

    // Initialization code
}
+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID =@"TimeChooseTableViewCell";
    TimeChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TimeChooseTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
