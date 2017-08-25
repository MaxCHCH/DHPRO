//
//  THomeCollectionViewCell.m
//  Test
//
//  Created by Rillakkuma on 2017/7/8.
//  Copyright © 2017年 Rillakkuma. All rights reserved.
//

#import "THomeCollectionViewCell.h"

@implementation THomeCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		UIImageView *coverImage = [[UIImageView alloc]init];
		coverImage.backgroundColor = [UIColor clearColor];
		coverImage.layer.cornerRadius = 15;
		_imageCover = coverImage;
		[self.contentView addSubview:_imageCover];
//		[_imageCover setContentScaleFactor:[[UIScreen mainScreen] scale]];
//		_imageCover.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//		_imageCover.contentMode = UIViewContentModeScaleAspectFill;
//		_imageCover.clipsToBounds = YES;
		
		UILabel *namelabel = [[UILabel alloc]init];
		namelabel.textAlignment = NSTextAlignmentCenter;
		namelabel.textColor = [UIColor blackColor];
		namelabel.font = DH_FontSize(12);
		_labelName = namelabel;
		[self.contentView addSubview:_labelName];
		
		
		
//		[self.contentView sd_addSubviews:@[_imageCover,_labelName]];
//		_imageCover.sd_layout
//		.heightIs(30)
//		.widthEqualToHeight(1)
//		.centerXEqualToView(self.contentView)
//		.centerYEqualToView(self.contentView);
//
//		[_labelName setSingleLineAutoResizeWithMaxWidth:DH_DeviceWidth];
//		_labelName.sd_layout
//		.heightIs(14)
//		.topSpaceToView(_imageCover, 5);
//		.autoHeightRatio(0)
//		.centerXEqualToView(self.contentView);
		
		_imageCover.sd_layout
		.heightIs(30)
		.widthEqualToHeight(1)
		.centerYEqualToView(self.contentView).offset(10)
		.topSpaceToView(self.contentView,4);

		
		[_labelName setSingleLineAutoResizeWithMaxWidth:DH_DeviceWidth];
//		float height=CGRectGetMaxY(_labelName.frame);//得到的为仅能名称的坐标的最大值
		_labelName.sd_layout
		.heightIs(14)
		.widthIs(70)
//		.centerYEqualToView(_imageCover)
//		.centerXEqualToView(_imageCover)
		.bottomSpaceToView(self.contentView, 5);
//		namelabel.frame = CGRectMake(0, coverImage.bottom, 60, 20);
		
	}
	return self;
}

@end
