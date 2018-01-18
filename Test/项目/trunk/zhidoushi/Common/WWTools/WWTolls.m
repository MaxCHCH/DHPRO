//
//  WWTolls.m
//  zhidoushi
//
//  Created by xinglei on 14/11/13.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <Security/Security.h>
#include <sys/sysctl.h>
#import <CommonCrypto/CommonDigest.h>
#include "sys/types.h"
#include "sys/sysctl.h"

#import "WWTolls.h"
#import "SSKeychain.h"
#import "KeychainItemWrapper.h"
#import "Define.h"
#import "NSDictionary+NARSafeDictionary.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/ImageIO.h>
#import "RegexKitLite.h"
#import "SensitiveTool.h"

static NSMutableDictionary *allRecodDic;
static NSMutableDictionary *allArrayDic;
static KeychainItemWrapper *wrapper;
static CGFloat yOffset = 0;//屏幕高度错位变量

@implementation WWTolls

//加密团组密码
+ (NSString *)encodePwd:(NSString *)pwd {
    long long oldPwd = pwd.longLongValue;
    long long newPwd = oldPwd * 9299L + 1126L + 0126L;
    return [NSString stringWithFormat:@"%lld",newPwd];
}

//解析团组密码
+ (NSString *)decodePwd:(NSString *)pwd {
    long long oldPwd = pwd.integerValue;
    long long newPwd = (oldPwd - 1126L - 0126L) / 9299L;
    return [NSString stringWithFormat:@"%lld",newPwd];
}

+ (BOOL)notiEnable {
    
    if (iOS8) {
        if ([[UIApplication sharedApplication] isRegisteredForRemoteNotifications]) {//通知已经开启
            return YES;
        }else{//通知已经关闭
            return NO;
        }
    }else{
        if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes]>0) {//通知已经开启
            return YES;
        }else{//通知已经关闭
            return NO;
        }
    }
}

+(UIColor *) colorWithHexString: (NSString *) stringToConvert  //@"#5a5a5a"
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    
    if ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    
    NSRange range;
    
    range.location = 0;
    
    range.length = 2;
    
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((CGFloat) r / 255.0f)
            
                           green:((CGFloat) g / 255.0f)
            
                            blue:((CGFloat) b / 255.0f)
            
                           alpha:1.0f];
    
}
+(UIColor *) colorWithHexString: (NSString *) stringToConvert AndAlpha:(CGFloat)alpha  //@"#5a5a5a"
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    
    if ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    
    NSRange range;
    
    range.location = 0;
    
    range.length = 2;
    
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((CGFloat) r / 255.0f)
            
                           green:((CGFloat) g / 255.0f)
            
                            blue:((CGFloat) b / 255.0f)
            
                           alpha:alpha];
    
}
+ (NSString*)getDeviceVersion
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

+(NSString*)writeUniversallyUniqueIdentifier;
{
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);

    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *userUUIDPath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",DOCUMENT_USER_UUID]];
    NSMutableDictionary *textDictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:userUUIDPath];
    if ( [NSString stringWithFormat:@"%@",[textDictionary objectForKey:@"UUID"]].length==0 || textDictionary==nil) {
            NSMutableDictionary *UUIDdictionary = [[NSMutableDictionary alloc]initWithCapacity:1];
            [UUIDdictionary setObject:result forKey:@"UUID"];
            [UUIDdictionary writeToFile:userUUIDPath atomically:YES];
        return [UUIDdictionary objectForKey:@"UUID"];
    };
    return [textDictionary objectForKey:@"UUID"];
   //     Team identifier == LME682U793.//keychain调用方法
//        wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"Account Number"
//                                                      accessGroup:@"YOUR_APP_ID_HERE.com.yourcompany.GenericKeychainSuite"];
//    if ([NSString stringWithFormat:@"%@",[wrapper objectForKey:(__bridge id)kSecValueData]].length==0) {
//        //保存数据
//        [wrapper setObject:result forKey:(__bridge id)kSecValueData];
//    }
}

+(NSString*)getUniversallUniqueIdentifier{
    NSString *universallUniqueIdentifier = [wrapper objectForKey:(__bridge id)kSecValueData];
    return universallUniqueIdentifier;
}

+(BOOL)setLocalArrayPlistInfo:(NSMutableArray *)postMutableArray pathString:(NSString*)pathStr Key:(NSString*)key
{
    NSArray *DocumentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [DocumentPaths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",pathStr]];
    NSLog(@"保存用户信息的路径=========%@",filePath);
    if (allArrayDic == nil) {
        allArrayDic = [[NSMutableDictionary alloc] initWithCapacity:1];
    }

    if (postMutableArray.count!=0) {
        [allArrayDic setObject:postMutableArray forKey:key];
    }

    //NSLog(@"打印用户信息*****%@",allArrayDic);
    //将字典写入plist文件中.
    BOOL result = false;
    if (allArrayDic==nil && (![allArrayDic isKindOfClass:[NSMutableDictionary class]])) {
        return false;
    }else{
//        [allArrayDic writeToFile:filePath atomically:YES];
    }
    return result;
}
//**************************************************************************************//
+(BOOL)setMyLocalPlistInfo:(id)postObject andFilePath:(NSString*)myFilePath
{
    NSArray *DocumentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [DocumentPaths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",myFilePath]];
    NSLog(@"保存用户信息的路径=========%@",filePath);
    NSLog(@"打印用户信息*****%@",postObject);
    //将字典写入plist文件中.
    BOOL result = false;
    result =[postObject writeToFile:filePath atomically:YES];
    return result;
}

+(id)getMyPostListFilePathString:(NSString*)pathString;
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",pathString]];
    NSLog(@"-myObject--------------%@",filePath);

    id myObject;

    myObject = [[NSMutableDictionary alloc]initWithContentsOfFile:filePath];

    if (myObject==nil || (![myObject isKindOfClass:[NSMutableDictionary class]])) {
        myObject = [[NSMutableArray alloc]initWithContentsOfFile:filePath];
    }
        NSLog(@"-myObject--------------%@",myObject);
    return myObject;
}
//**************************************************************************************//
+(BOOL)setLocalPlistInfo:(NSMutableDictionary *)postDictionary Key:(NSString*)key
{
    NSArray *DocumentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [DocumentPaths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",DOCUMENT_USER_PLIST]];
        NSLog(@"保存用户信息的路径=========%@",filePath);
    if (allRecodDic == nil) {
        allRecodDic = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    [allRecodDic setObject:postDictionary forKey:key];
           NSLog(@"打印用户信息*****%@",allRecodDic);
    //将字典写入plist文件中.
    BOOL result = false;
    result =[allRecodDic writeToFile:filePath atomically:YES];
    return result;
}

+(NSMutableDictionary *)getPostList:(NSString *)key andPathString:(NSString*)pathString;
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",pathString]];
//    DOCUMENT_USER_PLIST
//    NSLog(@"本地Dictionary=========%@",allRecodDic);
    allRecodDic = [[NSMutableDictionary alloc]initWithContentsOfFile:filePath];
    NSLog(@"allPostDic=========%@",filePath);
    NSMutableDictionary *Dictionary = [allRecodDic objectForKey:key];
//    NSLog(@"本地Dictionary=========%@",allRecodDic);
    return Dictionary;
}

+(NSMutableArray *)getArrayPostList:(NSString *)key andPathString:(NSString*)pathString;
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",pathString]];
    //    DOCUMENT_USER_PLIST
    //    NSLog(@"本地Dictionary=========%@",allRecodDic);
    NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:filePath];
    NSLog(@"allPostDic=========%@",myDictionary);
    NSMutableArray *myArray = [myDictionary objectForKey:key];
        NSLog(@"本地myArray=========%@",myArray);
    return myArray;
}

+(void)removePostList:(NSString*)key{

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",DOCUMENT_USER_PLIST]];

    allRecodDic = [[NSMutableDictionary alloc]initWithContentsOfFile:filePath];

    NSMutableDictionary *Dictionary = [allRecodDic objectForKey:key];

    [Dictionary removeAllObjects];

    [Dictionary writeToFile:filePath atomically:YES];
}

+(NSString *) fileSizeAtPath:(NSString*) filePath{

    NSFileManager* manager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *file_Path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",DOCUMENT_USER_PLIST]];
     NSLog(@"**********%f",[[manager attributesOfItemAtPath:file_Path error:nil] fileSize]/(1024.0*1024.0));
    if ([manager fileExistsAtPath:file_Path]){

        if (([[manager attributesOfItemAtPath:file_Path error:nil] fileSize]/(1024.0*1024.0))>1) {
            return [NSString stringWithFormat:@"%.1fM",[[manager attributesOfItemAtPath:file_Path error:nil] fileSize]/(1024.0*1024.0)];
        }else{
            return [NSString stringWithFormat:@"%.1fKB",[[manager attributesOfItemAtPath:file_Path error:nil] fileSize]/(1024.0)];
        }
    }
    return [NSString stringWithFormat:@"0KB"];
}

+(NSString*)getkeyChain{
    NSBundle *bundle = [NSBundle mainBundle];
    NSDictionary *info = [bundle infoDictionary];
    NSString *bundleId = [info objectForKey:@"CFBundleIdentifier"];
    /** 初始化一个保存用户帐号的KeychainItemWrapper **/
    NSString *UUID = [SSKeychain passwordForService:bundleId account:bundleId];
    if (UUID == nil || UUID.length == 0) {
        UUID = [[NSUUID UUID] UUIDString];
        [SSKeychain setPassword:UUID forService:bundleId account:bundleId];
        return UUID;
    }
    return UUID;
}

+(NSMutableData*)getJsonData:(NSMutableDictionary*)dictionary{
    NSData *stringData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    NSMutableData *stringMutableData = [NSMutableData dataWithData:stringData];
    return stringMutableData;
}

+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (unsigned)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+(BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189,177
     */
    NSString * MOBILE = @"^1(3[0-9]|7[0-9]|5[0-9]|8[0-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[0-9])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,177
     22         */
    NSString * CT = @"^1((33|47|79|76|45|70|77|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";

    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];

    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//压缩图片
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);

    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];

    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();

    // End the context
    UIGraphicsEndImageContext();

    // Return the new image.
    return newImage;
}

+(NSString*)timeString:(NSString*)inputTime{

    NSString* timeString = [NSString stringWithFormat:@"%@",inputTime];

    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];

    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    NSDate* inputDate = [inputFormatter dateFromString:timeString];

    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];

    [outputFormatter setDateFormat:@"MM月dd日"];

    NSString *str = [outputFormatter stringFromDate:inputDate];

    return str;
}

+(NSString*)timeString2:(NSString*)inputTime;
{

    NSString* timeString = [NSString stringWithFormat:@"%@",inputTime];
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];

    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    NSDate* inputDate = [inputFormatter dateFromString:timeString];

    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    
    [outputFormatter setDateFormat:@"MM月dd日 HH:mm"];

    NSString *str = [outputFormatter stringFromDate:inputDate];
    
    return str;
    
}

+ (NSString*)timeString22:(NSString*)inputTime;
{
    return [WWTolls configureTimeString:inputTime andStringType:@"M-d HH:mm"];
}

+ (NSString*)timeString3:(NSString*)inputTime;
{
    
    NSString* timeString = [NSString stringWithFormat:@"%@",inputTime];

    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];

    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    NSDate* inputDate = [inputFormatter dateFromString:timeString];

    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];

    [outputFormatter setDateFormat:@"yyyy-MM-dd"];

    NSString *str = [outputFormatter stringFromDate:inputDate];
    
    return str;

}

+(NSString*)timeString4:(NSString*)inputTime{
    
    NSString* timeString = [NSString stringWithFormat:@"%@",inputTime];
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate* inputDate = [inputFormatter dateFromString:timeString];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    
    [outputFormatter setDateFormat:@"yy.MM.dd"];
    
    NSString *str = [outputFormatter stringFromDate:inputDate];
    if ([[str substringToIndex:2] isEqualToString:@"15"]) {
        str = [str substringFromIndex:3];
    }
    return str;
}

+(NSString*)timeString5:(NSString*)inputTime{
    
    long long ms = [inputTime longLongValue];
    long long days = ms/(1000*60*60*24);
    
    NSString *srt;
    if (days>=2) {
        srt = [NSString stringWithFormat:@"%ld天后",(long)days];
    }else{
        long long hours = ms/(1000*60*60);
        long long minite = ms/(1000*60) - 60*hours;
        long long secends = ms/1000 - 60*60*hours - minite*60;
        srt = [NSString stringWithFormat:@"%ld:%ld:%ld",(long)hours,(long)minite,(long)secends];
    }
    //
    //    if (months==0&&days==0&&hour==0&&minute==0) {
    //
    //        srt=[NSString stringWithFormat:@"1分钟前"];
    //
    //    }
    //    if (months==0&&days==0&&hour==0) {
    //        if (minute==0) {
    //            srt=[NSString stringWithFormat:@"刚刚发布"];
    //        }else{
    //            srt=[NSString stringWithFormat:@"%ld分钟前",(long)minute];
    //        }
    //    }else if(months==0&&days==0){
    //
    //        srt=[NSString stringWithFormat:@"%ld小时前",(long)hour];
    //    }
    //    else if (months==0&&days<31)
    //    {
    //        srt=[NSString stringWithFormat:@"%ld天前",(long)days];
    //    }
    //    else if(year==0&&months<12){
    //        srt = [NSString stringWithFormat:@"%ld月前",(long)months];
    //    }
    //    else{
    //        srt=@"1年前";
    //    }
    return srt;
}
#pragma mark - Date and Time -
+(NSString*)date:(NSString*)dateStr
{

    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *fromdate=[format dateFromString:dateStr];
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
    NSDate *fromDate = [fromdate  dateByAddingTimeInterval: frominterval];
    //    NSLog(@"fromdate=%@",fromDate);
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    //    NSLog(@"enddate=%@",localeDate);
    NSDateComponents *components = [gregorian components:unitFlags fromDate:fromDate toDate:localeDate options:0];

    NSInteger minute = [components minute];
    NSInteger hour = [components hour];
    NSInteger months = [components month];
    NSInteger days = [components day];

    NSString *srt;

    if (months==0&&days==0&&hour==0) {
        if (minute==0) {
            srt=[NSString stringWithFormat:@"刚刚"];
        }else{
            srt=[NSString stringWithFormat:@"%ld分钟前",(long)minute];
        }
    }else if(months==0&&days==0){

        srt=[NSString stringWithFormat:@"%ld小时前",(long)hour];
    }else{
        srt = [WWTolls configureTimeString:dateStr andStringType:@"M-d HH:mm"];
    }
    return srt;
}

+(NSString*)configureTimeString:(NSString*)inputTime andStringType:(NSString*)myType{

    NSString* timeString = [NSString stringWithFormat:@"%@",inputTime];

    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];

    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    NSDate* inputDate = [inputFormatter dateFromString:timeString];

    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];

    [outputFormatter setDateFormat:myType];

    NSString *str = [outputFormatter stringFromDate:inputDate];
    
    return str;
}

-(void)dealloc
{
    allArrayDic = nil;
}

+ (BOOL)isNull:(id)obj {
    if ([obj isKindOfClass:[NSNull class]] || !obj) {
        return YES;
    }
    
    if ([obj isKindOfClass:[NSString class]]) {
        if ([obj length] == 0) {
            return YES;
        }
    }
    return NO;
}



+ (CGFloat)zdsHeigthForString:(NSString *)value fontSize:(CGFloat)fontSize andWidth:(CGFloat)width {
    
    CGFloat height = [WWTolls heightForString:value fontSize:fontSize andWidth:width];
    
    if ((height > 18) && !iPhone4) {
        height += 5;
    }
    
    return height;
}

+ (CGFloat) heightForString:(NSString *)value fontSize:(CGFloat)fontSize
{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(CGFLOAT_MAX, 20) lineBreakMode:UILineBreakModeWordWrap];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.height;
}

+ (CGFloat) heightForString:(NSString *)value fontSize:(CGFloat)fontSize andWidth:(CGFloat)width
{
//    UILabel *lbl = [[UILabel alloc] init];
//    lbl.text = value;
//    lbl.font = MyFont(fontSize);
//    return [lbl sizeThatFits:CGSizeMake(width-16, MAXFLOAT)].height;
    return [value boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size.height;
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.height;
}   
+ (CGFloat) WidthForString:(NSString *)value fontSize:(CGFloat)fontSize
{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(CGFLOAT_MAX, 20) lineBreakMode:UILineBreakModeWordWrap];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    
    return sizeToFit.width;
}


+ (CGFloat) WidthForString:(NSString *)value fontSize:(CGFloat)fontSize andHeight:(CGFloat)height {
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(CGFLOAT_MAX, height) lineBreakMode:UILineBreakModeWordWrap];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.width;
}


static size_t getAssetBytesCallback(void *info, void *buffer, off_t position, size_t count) {
    ALAssetRepresentation *rep = (__bridge id)info;
    
    NSError *error = nil;
    size_t countRead = [rep getBytes:(uint8_t *)buffer fromOffset:position length:count error:&error];
    
    if (countRead == 0 && error) {
        // We have no way of passing this info back to the caller, so we log it, at least.
//        NDDebug(@"thumbnailForAsset:maxPixelSize: got an error reading an asset: %@", error);
    }
    
    return countRead;
}

static void releaseAssetCallback(void *info) {
    // The info here is an ALAssetRepresentation which we CFRetain in thumbnailForAsset:maxPixelSize:.
    // This release balances that retain.
    CFRelease(info);
}

// Returns a UIImage for the given asset, with size length at most the passed size.
// The resulting UIImage will be already rotated to UIImageOrientationUp, so its CGImageRef
// can be used directly without additional rotation handling.
// This is done synchronously, so you should call this method on a background queue/thread.
+(UIImage *)thumbnailForAsset:(ALAsset *)asset maxPixelSize:(NSUInteger)size {
    NSParameterAssert(asset != nil);
    NSParameterAssert(size > 0);
    
    ALAssetRepresentation *rep = [asset defaultRepresentation];
    
    CGDataProviderDirectCallbacks callbacks = {
        .version = 0,
        .getBytePointer = NULL,
        .releaseBytePointer = NULL,
        .getBytesAtPosition = getAssetBytesCallback,
        .releaseInfo = releaseAssetCallback,
    };
    
    CGDataProviderRef provider = CGDataProviderCreateDirect((void *)CFBridgingRetain(rep), [rep size], &callbacks);
    CGImageSourceRef source = CGImageSourceCreateWithDataProvider(provider, NULL);
    
    CGImageRef imageRef = CGImageSourceCreateThumbnailAtIndex(source, 0, (__bridge CFDictionaryRef) @{
                                                                                                      (NSString *)kCGImageSourceCreateThumbnailFromImageAlways : @YES,
                                                                                                      (NSString *)kCGImageSourceThumbnailMaxPixelSize : [NSNumber numberWithInt:size],
                                                                                                      (NSString *)kCGImageSourceCreateThumbnailWithTransform : @YES,
                                                                                                      });
    CFRelease(source);
    CFRelease(provider);
    
    if (!imageRef) {
        return nil;
    }
    
    UIImage *toReturn = [UIImage imageWithCGImage:imageRef];
    
    CFRelease(imageRef);
    
    return toReturn;
}



+(NSString *)getAstroWithMonth:(int)m day:(int)d{
    //计算星座
    
    NSString *retStr=@"";
    int i_month=0;
    NSString *theMonth = [NSString stringWithFormat:@"%d",m];
    if([[theMonth substringToIndex:0] isEqualToString:@"0"]){
        i_month = [[theMonth substringFromIndex:1] intValue];
    }else{
        i_month = [theMonth intValue];
    }
    int i_day=0;
    NSString *theDay = [NSString stringWithFormat:@"%d",d];
    if([[theDay substringToIndex:0] isEqualToString:@"0"]){
        i_day = [[theDay substringFromIndex:1] intValue];
    }else{
        i_day = [theDay intValue];
    }
    /*
     摩羯座 12月22日------1月19日
     水瓶座 1月20日-------2月18日
     双鱼座 2月19日-------3月20日
     白羊座 3月21日-------4月19日
     金牛座 4月20日-------5月20日
     双子座 5月21日-------6月21日
     巨蟹座 6月22日-------7月22日
     狮子座 7月23日-------8月22日
     处女座 8月23日-------9月22日
     天秤座 9月23日------10月23日
     天蝎座 10月24日-----11月21日
     射手座 11月22日-----12月21日
     */
    switch (i_month) {
        case 1:
            if(i_day>=20 && i_day<=31){
                retStr=@"水瓶座";
            }
            if(i_day>=1 && i_day<=19){
                retStr=@"摩羯座";
            }
            break;
        case 2:
            if(i_day>=1 && i_day<=18){
                retStr=@"水瓶座";
            }
            if(i_day>=19 && i_day<=31){
                retStr=@"双鱼座";
            }
            break;
        case 3:
            if(i_day>=1 && i_day<=20){
                retStr=@"双鱼座";
            }
            if(i_day>=21 && i_day<=31){
                retStr=@"白羊座";
            }
            break;
        case 4:
            if(i_day>=1 && i_day<=19){
                retStr=@"白羊座";
            }
            if(i_day>=20 && i_day<=31){
                retStr=@"金牛座";
            }
            break;
        case 5:
            if(i_day>=1 && i_day<=20){
                retStr=@"金牛座";
            }
            if(i_day>=21 && i_day<=31){
                retStr=@"双子座";
            }
            break;
        case 6:
            if(i_day>=1 && i_day<=21){
                retStr=@"双子座";
            }
            if(i_day>=22 && i_day<=31){
                retStr=@"巨蟹座";
            }
            break;
        case 7:
            if(i_day>=1 && i_day<=22){
                retStr=@"巨蟹座";
            }
            if(i_day>=23 && i_day<=31){
                retStr=@"狮子座";
            }
            break;
        case 8:
            if(i_day>=1 && i_day<=22){
                retStr=@"狮子座";
            }
            if(i_day>=23 && i_day<=31){
                retStr=@"处女座";
            }
            break;
        case 9:
            if(i_day>=1 && i_day<=22){
                retStr=@"处女座";
            }
            if(i_day>=23 && i_day<=31){
                retStr=@"天秤座";
            }
            break;
        case 10:
            if(i_day>=1 && i_day<=23){
                retStr=@"天秤座";
            }
            if(i_day>=24 && i_day<=31){
                retStr=@"天蝎座";
            }
            break;
        case 11:
            if(i_day>=1 && i_day<=21){
                retStr=@"天蝎座";
            }
            if(i_day>=22 && i_day<=31){
                retStr=@"射手座";
            }
            break;
        case 12:
            if(i_day>=1 && i_day<=21){
                retStr=@"射手座";
            }
            if(i_day>=21 && i_day<=31){
                retStr=@"摩羯座";
            }
            break;
    }
    return retStr;
}

+ (CGSize)sizeForQNURLStr:(NSString*)urlStr{
    CGSize size = CGSizeZero;
    if(urlStr.length<10) return size;
    
    //匹配高度
    NSError *error;
    NSString *regHeight=[[NSString alloc] initWithFormat:@"(^|&|\\?)+%@=+([^&]*)(&|$)",@"width"];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regHeight
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (error != nil) {
        return size;
    }
    NSArray *matches = [regex matchesInString:urlStr
                                      options:0
                                        range:NSMakeRange(0, [urlStr length])];
    for (NSTextCheckingResult *match in matches) {
        NSString *widthValue = [urlStr substringWithRange:[match rangeAtIndex:0]];
        widthValue = [widthValue substringWithRange:NSMakeRange(7, widthValue.length-8)];
        size.width = widthValue.floatValue;
    }
    //匹配宽度
    NSString *regWidth=[[NSString alloc] initWithFormat:@"(^|&|\\?)+%@=+([^&]*)(&|$)",@"height"];
    regex = [NSRegularExpression regularExpressionWithPattern:regWidth
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (error != nil) {
        return size;
    }
    matches = [regex matchesInString:urlStr
                                      options:0
                                        range:NSMakeRange(0, [urlStr length])];
    for (NSTextCheckingResult *match in matches) {
        NSString *heightValue = [urlStr substringWithRange:[match rangeAtIndex:0]];  // 分组1所对应的宽度
        heightValue = [heightValue substringWithRange:NSMakeRange(8, heightValue.length-9)];
        size.height = heightValue.floatValue;
    }
    CGSize sclSize = CGSizeZero;
    if (size.height>size.width) {
        sclSize.height = 195;
        sclSize.width = 195 * size.width/size.height;
    }else if(size.height<size.width){
        sclSize.width = 195;
        sclSize.height = 195*size.height/size.width;
    }else{
        sclSize.width = 195;
        sclSize.height = 195;
    }
    return sclSize;
}

+ (BOOL)isHasSensitiveWord:(NSString*)text{

    BOOL isHave = NO;
    if(text.length<1) return isHave;
    NSSet *sensitiveWordsArray = [SensitiveTool getWordsSet];
    //遍历敏感词
    for (NSString *sensitiveWord in sensitiveWordsArray) {
        if(sensitiveWord.length < 2) continue;//一个字的敏感词跳过
        //拼接正则表达式
        NSString *resStr = @"";
        NSUInteger count = [sensitiveWord length];
        for(int i =0; i < count; i++){
            NSString *c = [sensitiveWord substringWithRange:NSMakeRange(i, 1)];
            resStr = [resStr stringByAppendingString:c];
            resStr = [resStr stringByAppendingString:@"[^A-Za-z0-9\u4e00-\u9fa5]*"];
        }
        isHave = [text isMatchedByRegex:resStr];
        if (isHave) {
            break;
        }
    }
    return isHave;
}

+ (BOOL)isNameValidate:(NSString *)text{
    BOOL isCan = NO;
    //名称规则：只能包含汉子字母数字
    NSString *resStr = @"[A-Za-z0-9\u4e00-\u9fa5]+";
    isCan = [text isMatchedByRegex:resStr];
    return isCan;
}

+ (BOOL)isTagValidate:(NSString *)text{
    BOOL isCan = NO;
    //名称规则：只能包含汉子字母数字
    NSString *resStr = @"^[0-9a-zA-Z\u4e00-\u9fa5\\s?]+$";
    isCan = [text isMatchedByRegex:resStr];
    return isCan;
}

+ (BOOL)isTitleValidate:(NSString *)text{
    BOOL isCan = NO;
    //名称规则：只能包含汉子字母数字
    NSString *resStr = @"^[A-Za-z\\d\\u4E00-\\u9FA5\\p{P}‘’“”]+$";
    isCan = [text isMatchedByRegex:resStr];
    return isCan;
}

+ (void)setScreenHeightOffset:(CGFloat)height{
    yOffset = height;
}

+ (CGFloat)getScreenHeight{
    return [UIScreen mainScreen].bounds.size.height - yOffset;
}

+ (NSString *)getCurrentDeviceModel
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}

+ (NSString*)newtworkType {
    
    NSArray *subviews = [[[[UIApplication sharedApplication] valueForKey:@"statusBar"] valueForKey:@"foregroundView"]subviews];
    NSNumber *dataNetworkItemView = nil;
    
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }
    NSString *s = [NSString stringWithFormat:@"%@",[dataNetworkItemView valueForKey:@"dataNetworkType"]];
    if ([dataNetworkItemView valueForKey:@"dataNetworkType"] == nil || s == nil || s.length<1) {
        s = @"6";
    }
    return s;
    
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return theImage;
}

+ (void)zdsClick:(NSString*)str{
    NSString *tjkey = [NSString stringWithFormat:@"tj_%@",str];
    NSString *jznum = [NSUSER_Defaults objectForKey:tjkey]?[NSUSER_Defaults objectForKey:tjkey]:@"0";
    int newSum = jznum.intValue + 1;
    [NSUSER_Defaults setObject:[NSString stringWithFormat:@"%d",newSum] forKey:tjkey];
}

+ (int)getCharLength:(NSString*)str{
    return (int)[str lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
}

@end
