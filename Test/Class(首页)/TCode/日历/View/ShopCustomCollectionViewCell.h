//
//  ShopCustomCollectionViewCell.h
//  Test
//
//  Created by Rillakkuma on 2017/1/20.
//  Copyright © 2017年 Rillakkuma. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ShopCustomCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic)UIImageView *iconImageView;
@property (strong, nonatomic)UILabel *nameLabel;
@property (strong, nonatomic)UIButton *chooseBtn;
-(instancetype)initWithFrame:(CGRect)frame;

@end
