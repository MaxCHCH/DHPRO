//
//  NSString+NARSafeString.m
//  zhidoushi
//
//  Created by xinglei on 14/12/19.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "NSString+NARSafeString.h"

#import <CommonCrypto/CommonDigest.h>  

#import "WWTolls.h"
#import "Define.h"

@implementation NSString (NARSafeString)

+(NSString*)getMyKey:(NSString*)userID{
    NSString *userid = [NSString stringWithFormat:@"%@",userID];
    NSString * keyString = [userid stringByAppendingString:ZDS_M_PI];
    NSString * keyStringMD5 = [WWTolls md5:keyString];
    return keyStringMD5;
}

+(BOOL)mySafeString:(NSString*)string
{
    BOOL stringResult = NO;

    if(string!=nil){

    if ([string isKindOfClass:[NSString class]])
    {
        stringResult = YES;
    }

    }

    return stringResult;
}

-(NSString *) md5HexDigest
{
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (unsigned)strlen(original_str), result); // This is the md5 call
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

-(NSString *) imageType
{
    //默认为空
    NSString * imageTypeStr = @"";
    //从url中获取图片类型
    NSMutableArray *arr = (NSMutableArray *)[self componentsSeparatedByString:@"."];
    if (arr) {
        imageTypeStr = [arr objectAtIndex:arr.count-1];
    }
    return imageTypeStr;
}

+(NSString*)takeoutString:(NSString*)myString
{
    NSString * newString = [myString stringByReplacingOccurrencesOfString:@" " withString:@""];
    return newString;
}

@end
