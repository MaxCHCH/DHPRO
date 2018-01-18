//
//  NARCollectionViewCell.h
//  自定义Layout
//
//  Created by xinglei on 14/11/27.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WillBeginCollectionModel.h"

@interface NARCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)WillBeginCollectionModel * beginModel;

@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, strong) UIView* bottomView;
@property(nonatomic,strong)UILabel * peopleNumberLabel;
@property(nonatomic,strong)UILabel * discussionLabel;
@property(nonatomic,strong)UILabel * gameNameLabel;

@end
