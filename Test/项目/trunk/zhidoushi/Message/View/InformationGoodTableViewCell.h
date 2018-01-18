//
//  InformationGoodTableViewCell.h
//  zhidoushi
//
//  Created by nick on 15/4/28.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InformationModel.h"

@interface InformationGoodTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *goodIcon;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *bycontentlbl;
@property (weak, nonatomic) IBOutlet UIImageView *showImage;
@property(nonatomic,strong)InformationModel *model;//模型
@end
