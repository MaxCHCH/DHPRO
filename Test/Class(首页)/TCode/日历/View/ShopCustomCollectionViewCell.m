//
//  ShopCustomCollectionViewCell.m
//  Test
//
//  Created by Rillakkuma on 2017/1/20.
//  Copyright © 2017年 Rillakkuma. All rights reserved.
//

#import "ShopCustomCollectionViewCell.h"

@implementation ShopCustomCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if (self)
	{
		// cell页面布局
		[self setUpUI];
		
	}
	return self;

}
- (void)setUpUI{
	self.nameLabel = [[UILabel alloc]init];
	self.nameLabel.frame = CGRectMake(0, self.contentView.height-20, self.contentView.width, 20);
	self.nameLabel.font = [UIFont systemFontOfSize:14];
	self.nameLabel.textColor = [UIColor orangeColor];
	self.nameLabel.textAlignment = NSTextAlignmentCenter;
	self.nameLabel.numberOfLines = 1;
	[self addSubview:self.nameLabel];
	//每一个cell的宽减去cell中的imageview的宽除以2 得到中心点
	self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.contentView.width-(self.contentView.height-35))/2, 5, self.contentView.width-35, self.contentView.height-35)];
	[self addSubview:self.iconImageView];

}
@end
