//
//  CalendarDetailViewController.h
//  zhidoushi
//
//  Created by nick on 15/10/22.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import "BaseViewController.h"

@interface CalendarDetailViewController : BaseViewController
// 所有的图片对象
@property (nonatomic, strong) NSArray *photos;
// 当前展示的图片索引
@property (nonatomic, assign) NSUInteger currentPhotoIndex;
@property(nonatomic,copy)NSString *dakaId;//打卡id
@property(nonatomic,copy)NSString *today;//今天日期
@property(nonatomic,copy)NSString *gameId;//id
@end
