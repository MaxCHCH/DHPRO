//
//  TabTableViewCell.m
//  Test
//
//  Created by Rillakkuma on 2016/10/20.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import "TabTableViewCell.h"

@implementation TabTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    _chooseButton.layer.cornerRadius = _chooseSubButton.layer.cornerRadius = 10;
//    _chooseButton.layer.borderColor = _chooseSubButton.layer.borderColor = [UIColor colorWithRed:0.075 green:0.702 blue:0.659 alpha:1.000].CGColor;
//    _chooseButton.layer.borderWidth = _chooseSubButton.layer.borderWidth = 1;
    
    
    // Initialization code
}
+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID =@"TabTableViewCell";
    TabTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TabTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
