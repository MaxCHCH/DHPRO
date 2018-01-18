//
//  NSObject+Date.m
//  zhidoushi
//
//  Created by licy on 15/5/25.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "NSObject+Date.h"



@implementation NSObject (Date)

+ (NSString *)dateStringWithDate:(NSDate *)date withDateType:(SSLDateType)dateType {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    if (dateType == SSL_HourDate) {
        
        [dateFormatter setDateFormat:@"HH"];
        return [dateFormatter stringFromDate:date];
    } else if (dateType == SSL_MinuteDate) {
        [dateFormatter setDateFormat:@"mm"];
        return [dateFormatter stringFromDate:date];
    } else if (dateType == SSL_HourAndMinute) {
        [dateFormatter setDateFormat:@"HH:mm"];
        return [dateFormatter stringFromDate:date];
    } else if (dateType == SSL_DateAndTime) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        return [dateFormatter stringFromDate:date];
    } else if (dateType == SSL_Date) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        return [dateFormatter stringFromDate:date];
    }   
        
    return nil;
}

+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{   
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
    
}


@end




