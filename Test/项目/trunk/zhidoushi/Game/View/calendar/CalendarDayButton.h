//
//  CalendarDayButton.h
//  sampleCalendar
//
//  Created by nick on 15/10/19.
//  Copyright © 2015年 Attinad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "singinModel.h"

@interface CalendarDayButton : UIButton
@property(nonatomic,strong)singinModel *model;//签到模型
@property(nonatomic,copy)NSString *today;//今天
@property(nonatomic,strong)UIImageView *backImage;//打卡图片

@end
