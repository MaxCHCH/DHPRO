//
//  PushCardViewController.h
//  zhidoushi
//
//  Created by nick on 15/10/27.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import "BaseViewController.h"

@interface PushCardViewController : BaseViewController
@property(nonatomic,copy)NSString *gameid;//团组id
@property(nonatomic,strong)UIImage *image;//配图
@property(nonatomic,copy)NSString *Photohash;//图片hash
@property(nonatomic,copy)NSString *Photokey;//图片key
@property(nonatomic,assign)CGSize PhotoSize;//尺寸
@property(nonatomic,assign)long long PhotoBig;//大小

@end
