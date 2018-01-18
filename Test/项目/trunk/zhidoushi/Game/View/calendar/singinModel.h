//
//  singinModel.h
//  sampleCalendar
//
//  Created by nick on 15/10/19.
//  Copyright © 2015年 Attinad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface singinModel : NSObject
@property(nonatomic,copy)NSString *punchdate;//时间
@property(nonatomic,copy)NSString *weekday;//周几
@property(nonatomic,copy)NSString *imageurl;//图片地址
@property(nonatomic,copy)NSString *ispunch;//是否打卡
@property(nonatomic,copy)NSString *punchcontent;//打卡内容
+(instancetype)modelWithDic:(NSDictionary*)dic;
-(instancetype)initWithDic:(NSDictionary*)dic;
@end
