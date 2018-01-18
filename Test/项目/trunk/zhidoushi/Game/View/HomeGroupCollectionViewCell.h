//
//  HomeGroupCollectionViewCell.h
//  zhidoushi
//
//  Created by nick on 15/4/20.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeGroupModel.h"

@interface HomeGroupCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *joinBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UIImageView *pwdGroupTag;

@property(nonatomic,strong)HomeGroupModel *model;//团组模型
@end
