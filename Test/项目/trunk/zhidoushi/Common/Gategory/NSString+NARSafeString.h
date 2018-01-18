//
//  NSString+NARSafeString.h
//  zhidoushi
//
//  Created by xinglei on 14/12/19.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NARSafeString)

+(NSString*)getMyKey:(NSString*)userID;

+(BOOL)mySafeString:(NSString*)string;

+(NSString*)takeoutString:(NSString*)myString;

-(NSString *) md5HexDigest;
//获取url中图片后缀
-(NSString *) imageType;

@end
