//
//  AutlayoutTableViewCell.m
//  Test
//
//  Created by Rillakkuma on 2016/10/27.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import "AutlayoutTableViewCell.h"

@implementation AutlayoutTableViewCell
@synthesize buttonAddImage;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
	
//		buttonAddImage = [UIButton buttonWithType:UIButtonTypeCustom];
//		
//		[self.contentView sd_addSubviews:@[buttonAddImage]];
//		buttonAddImage.sd_layout
//		.heightIs(60)
//		.widthEqualToHeight(1)
//		.centerXEqualToView(self.contentView)
//		.topSpaceToView(self.contentView,5);
		
		
		
		
	}
	return self;
}

- (UICollectionView *)collectionView{
	if (!_collectionView) {
		_layout = [[LxGridViewFlowLayout alloc] init];
		_margin = 12;
		_itemWH = (self.tz_width - 2 * _margin - 4) / 4 - _margin;
		_layout.itemSize = CGSizeMake(_itemWH, _itemWH);
		_layout.minimumInteritemSpacing = _margin;
		_layout.minimumLineSpacing = _margin;
		_collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(_margin, 64, (self.tz_width-2*_margin)/4*3, _itemWH) collectionViewLayout:_layout];
		//        CGFloat rgb = 244 / 255.0;、
//		self.automaticallyAdjustsScrollViewInsets = NO;
		_collectionView.backgroundColor = [UIColor whiteColor];
		_collectionView.layer.borderColor = [UIColor redColor].CGColor;
		_collectionView.layer.borderWidth = 1;
		_collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
		//        _collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
		_collectionView.dataSource = self;
		_collectionView.delegate = self;
		[_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
		[self addSubview:_collectionView];
	}
	
	return _collectionView;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
