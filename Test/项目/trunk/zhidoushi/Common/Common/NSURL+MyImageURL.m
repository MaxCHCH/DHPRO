//
//  NSURL+MyImageURL.m
//  zhidoushi
//
//  Created by xinglei on 15/1/12.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "NSURL+MyImageURL.h"

#import "Define.h"

@implementation NSURL (MyImageURL)

+(NSURL*)URLWithImageString:(NSString*)Urlstring Size:(int)size
{
    if ([Urlstring isKindOfClass:[NSString class]] && Urlstring!=nil && Urlstring.length!=0) {
//        if ([Urlstring rangeOfString:@"http:"].length != 0) {//是微信头像
            return [NSURL URLWithString:Urlstring];
//        }
//        NSString *imageString = [ZDS_DEFAULT_HTTP_SERVER_HOST stringByAppendingString:Urlstring];
//        NSLog(@"ERROR 没有获取到图片噢噢噢噢噢噢噢噢哦哦哦！！！%@",imageString);
//        imageString =[imageString substringWithRange:NSMakeRange(0, imageString.length-1)];
//        imageString = [NSString stringWithFormat:@"%@%d",imageString,size];
//        NSURL *myurl = [NSURL URLWithString:imageString];
//        return myurl;
    }else{
        return nil;
    }

}
@end
