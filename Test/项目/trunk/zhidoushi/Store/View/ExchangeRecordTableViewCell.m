//
//  ExchangeRecordTableViewCell.m
//  zhidoushi
//
//  Created by xinglei on 15/1/10.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "ExchangeRecordTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "NSURL+MyImageURL.h"
#import "WWTolls.h"

@implementation ExchangeRecordTableViewCell

-(void)initMyCellWithModel:(ExchangeRecordModel*)model
{
    //选中样式
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSURL *imageUrlleft = [NSURL URLWithImageString:model.imageurl Size:148];
    [self.headImageView sd_setImageWithURL:imageUrlleft];
    self.storeNameLabel.text = [NSString stringWithFormat:@"%@",model.gsname];
    self.goalLabel.text = [NSString stringWithFormat:@"%@",model.exchscore];
    self.numberLabel.text = [NSString stringWithFormat:@"券码:%@",model.ticket];
    NSString *regStr = [WWTolls timeString3:model.endtime];
    self.timeLabel.text =  [NSString stringWithFormat:@"%@后过期",regStr];


}

@end
