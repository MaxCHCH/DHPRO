//
//  LBLabel&TextFieldCell.m
//  LeBangProject
//
//  Created by Rillakkuma on 2017/2/6.
//  Copyright © 2017年 北京中科华博有限科技公司. All rights reserved.
//

#import "LBLabel&TextFieldCell.h"

@implementation LBLabel_TextFieldCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self)
	{
		// cell页面布局
		[self setupView];
//		self.contentView.backgroundColor = [UIColor redColor];
	}
	return self;
}
- (void)setupView{
	_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0 ,5 ,60,14.0)];
	_titleLabel.backgroundColor = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:0.00];       //背景颜色
	_titleLabel.textColor = [UIColor blackColor];             //字体颜色 默认为RGB 0,0,0
	_titleLabel.numberOfLines = 0;
	_titleLabel.text = @"我的";//行数 0为无限 默认为1
	_titleLabel.textAlignment = NSTextAlignmentLeft;        //对齐方式 默认为左对齐
	_titleLabel.font = [UIFont systemFontOfSize:14];          //设置字体及字体大小
	[self.contentView addSubview:_titleLabel];
	
	
	_detailTextfield = [[UITextField alloc]init];
	_detailTextfield.textColor = [UIColor blackColor];       //背景颜色
	_detailTextfield.placeholder = @"输入";
//	_detailTextfield.borderStyle = UITextBorderStyleRoundedRect;
	[self.contentView addSubview:_detailTextfield];
	
	_detailTextfield.frame = CGRectMake((_titleLabel.frame.origin.x+_titleLabel.frame.size.width) + _titleLabel.frame.origin.x + 8 ,5 ,DeviceWidth-(_titleLabel.frame.size.width + _titleLabel.frame.origin.x + 8),14.0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:NO];

    // Configure the view for the selected state
}

@end
