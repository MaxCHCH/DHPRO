//
//  NSObject+Date.h
//  zhidoushi
//
//  Created by licy on 15/5/25.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    SSL_HourDate,
    SSL_MinuteDate,
    SSL_HourAndMinute,
    SSL_DateAndTime,
    SSL_Date,
}SSLDateType;

@interface NSObject (Date)

//返回不同形式的date字符串
+ (NSString *)dateStringWithDate:(NSDate *)date withDateType:(SSLDateType)dateType;

//比较两个时间
+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;

@end
