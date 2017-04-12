//
//  XSTableViewCell.m
//  LeBangProject
//
//  Created by Rillakkuma on 16/8/10.
//  Copyright © 2016年 zhongkehuabo. All rights reserved.
//

#import "XSTableViewCell.h"

@implementation XSTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _chooseButton.layer.cornerRadius = _chooseSubButton.layer.cornerRadius = 10;
    _chooseButton.layer.borderColor = _chooseSubButton.layer.borderColor = [UIColor colorWithRed:0.075 green:0.702 blue:0.659 alpha:1.000].CGColor;
    _chooseButton.layer.borderWidth = _chooseSubButton.layer.borderWidth = 1;
   
    
}
+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID =@"XSTableViewCell";
    XSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XSTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
