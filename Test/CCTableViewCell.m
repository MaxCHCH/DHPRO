//
//  CCTableViewCell.m
//  Test
//
//  Created by Rillakkuma on 2016/12/2.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import "CCTableViewCell.h"

@implementation CCTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(instancetype)cellWithTableView:(UITableView *)tableView
{
	static NSString *ID =@"CCTableViewCell";
	CCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:@"CCTableViewCell" owner:nil options:nil] lastObject];
	}
	return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
