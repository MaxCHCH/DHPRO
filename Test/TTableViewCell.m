//
//  TTableViewCell.m
//  Test
//
//  Created by Rillakkuma on 16/7/4.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import "TTableViewCell.h"

@implementation TTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(instancetype)cellWithTableView:(UITableView *)tableView
{
//    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"TTableViewCell" owner:nil options:nil];
//    return [nibView objectAtIndex:0];
    
    static NSString *ID =@"TTableViewCell";
    TTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
