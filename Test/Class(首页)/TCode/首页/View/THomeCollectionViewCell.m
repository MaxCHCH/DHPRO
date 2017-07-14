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
		[_imageCover setContentScaleFactor:[[UIScreen mainScreen] scale]];
		_imageCover.autoresizingMask = UIViewAutoresizingFlexibleHeight;
		_imageCover.contentMode = UIViewContentModeScaleAspectFill;
		_imageCover.clipsToBounds = YES;
		
		UILabel *namelabel = [[UILabel alloc]init];
		namelabel.textAlignment = NSTextAlignmentCenter;
		namelabel.textColor = [UIColor blackColor];
		namelabel.font = [UIFont systemFontOfSize:14];
		_labelName = namelabel;
		[self.contentView sd_addSubviews:@[coverImage,namelabel]];
		
		_imageCover.sd_layout
		.heightIs(30)
		.widthEqualToHeight(1)
		.centerXEqualToView(self.contentView)
		.topSpaceToView(self.contentView,4);
		
		[_labelName setSingleLineAutoResizeWithMaxWidth:DeviceWidth];
		_labelName.sd_layout
		.heightIs(14)
		.topSpaceToView(_imageCover, 5)
		.autoHeightRatio(0)
		.centerXEqualToView(self.contentView);
		
	}
	return self;
}

@end
