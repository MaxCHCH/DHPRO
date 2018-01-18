//
//  WWTolls.h
//  zhidoushi
//
//  Created by xinglei on 14/11/13.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSLImageTool.h"

@interface WWTolls : NSObject

//加密团组密码
+ (NSString *)encodePwd:(NSString *)pwd;

//解析团组密码
+ (NSString *)decodePwd:(NSString *)pwd;

// 通知是否开启
+ (BOOL)notiEnable;

/**
 *  Description 字符串转换称颜色
 *
 *  @param stringToConvert 输入转换字符参数
 *
 *  @return 返回预定颜色
 */
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;
+(UIColor *) colorWithHexString: (NSString *) stringToConvert AndAlpha:(CGFloat)alpha;
/**
 *  Description 获取当前设备的信息
 *
 *  @return 返回设备信息
 */
+ (NSString*)getDeviceVersion;
/**
 *  Description 获取机器标识方法
 *
 *  @return 返回标识
 */
+(NSString*)writeUniversallyUniqueIdentifier;
+(NSString*)getUniversallUniqueIdentifier;
/**
 *  Description 用户信息写入本地文件(数组)
 *
 *  @param postMutableArray
 *  @param key
 *
 *  @return
 */
+(BOOL)setLocalArrayPlistInfo:(NSMutableArray *)postMutableArray pathString:(NSString*)pathStr Key:(NSString*)key;
/**
 *  Description 用户信息写入本地文件
 *
 *  @param postDictionary 用户信息
 *  @param key            保存用户信息的key名
 */
+(BOOL)setLocalPlistInfo:(NSMutableDictionary *)postDictionary Key:(NSString*)key;
/**
 *  Description 获取本地用户信息
 *
 *  @param NSMutableDictionary 用户信息
 *
 *  @return 返回用户信息
 */
+(NSMutableDictionary *)getPostList:(NSString *)key;
/**
 *  Description 清除指定的plist文件
 *
 *  @param key 字典的key用于判定是哪个缓存
 */
+(void)removePostList:(NSString*)key;
//+(void)removeDocumentsFiles;
/**
 *  Description 计算文件大小
 *
 *  @param filePath 文件路径
 *
 *  @return 长度
 */
+(NSString *) fileSizeAtPath:(NSString*) filePath;

+(NSString*)getkeyChain;
/**
 *  Description 返回json格式的data数据
 *
 *  @param dictionary 输入要转化的字典
 *
 *  @return return 返回一个MutableData
 */
+(NSMutableData*)getJsonData:(NSMutableDictionary*)dictionary;
/**
 *  Description 返回一个MD5加密的字符串
 *
 *  @param str 输入要转化的字符串
 *
 *  @return 返回的字符串
 */
+ (NSString *)md5:(NSString *)str;//md5转化
/**
 *  Description 返回一个判断是否为手机号
 *
 *  @param mobileNum 输入的手机号
 *
 *  @return 返回一个判断
 */
+(BOOL)isMobileNumber:(NSString *)mobileNum;
/**
 *  Description  压缩图片
 *
 *  @param image    传入要压缩的图片
 *  @param newSize  赋予新值
 *
 *  @return   返回被压缩的图片
 */
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;
/**
 *  Description 输入一个时间字符串，将其返回一个特定的时间字符串
 *
 *  @param inputTime 输入的时间串
 *
 *  @return  返回的字符串
 */
+(NSString*)timeString:(NSString*)inputTime;
/**
 *  Description 输入一个时间字符串，将其返回一个特定的时间字符串2
 *
 *  @param inputTime 输入的时间串
 *
 *  @return  返回的字符串
 */
+(NSString*)timeString2:(NSString*)inputTime;
/**
 *  Description 输入一个时间字符串，将其返回一个特定的时间字符串3
 *
 *  @param inputTime 输入的时间串
 *
 *  @return  返回的字符串
 */
+(NSString*)timeString22:(NSString*)inputTime;
+(NSString*)timeString3:(NSString*)inputTime;
/**
 *  Description 输入一个时间字符串，将其返回一个特定的时间字符串4
 *
 *  @param inputTime 输入的时间串
 *
 *  @return  返回的字符串
 */
+(NSString*)timeString4:(NSString*)inputTime;
/**
 *  Description 输入一个时间字符串，将其返回一个特定的时间字符串5
 *
 *  @param inputTime 输入的时间串
 *
 *  @return  返回的字符串
 */
+(NSString*)timeString5:(NSString*)inputTime;
/**
 *  Description   将时间转化为距离当前时间的时间
 *
 *  @param dateStr
 *
 *  @return
 */
+(NSString*)date:(NSString*)dateStr;
/**
 *  Description 返回特定时间的字符串
 *
 *  @param inputTime    输入字符串
 *  @param myType       转化格式
 *
 *  @return
 */
+(NSString*)configureTimeString:(NSString*)inputTime andStringType:(NSString*)myType;
+(NSMutableDictionary *)getPostList:(NSString *)key andPathString:(NSString*)pathString;
+(NSMutableArray *)getArrayPostList:(NSString *)key andPathString:(NSString*)pathString;
/**
 *  Description 订制单个写入对象
 *
 *  @param postDictionary
 *  @param myFilePath
 *
 *  @return
 */
+(BOOL)setMyLocalPlistInfo:(id)postObject andFilePath:(NSString*)myFilePath;
/**
 *  Description 获取某个类型的id对象
 *
 *  @param pathString
 *
 *  @return
 */
+(id)getMyPostListFilePathString:(NSString*)pathString;
/**
 @method 获取指定宽度情况ixa，字符串value的高度
 @param value 待计算的字符串
 @param fontSize 字体的大小
 @param andWidth 限制字符串显示区域的宽度
 @result float 返回的高度
 */

+ (BOOL)isNull:(id)obj;

+ (CGFloat)zdsHeigthForString:(NSString *)value fontSize:(CGFloat)fontSize andWidth:(CGFloat)width;
+ (CGFloat) heightForString:(NSString *)value fontSize:(CGFloat)fontSize;
+ (CGFloat) heightForString:(NSString *)value fontSize:(CGFloat)fontSize andWidth:(CGFloat)width;
+ (CGFloat) WidthForString:(NSString *)value fontSize:(CGFloat)fontSize;
+ (CGFloat) WidthForString:(NSString *)value fontSize:(CGFloat)fontSize andHeight:(CGFloat)height;

+(NSString *)getAstroWithMonth:(int)m day:(int)d;
/**
 *  获取图片尺寸
 *
 *  @param urlStr 七牛图片路径
 *
 *  @return 图片尺寸
 */
+ (CGSize)sizeForQNURLStr:(NSString*)urlStr;
/**
 *  是否包含敏感词
 *
 *  @param text 文本
 *
 *  @return 是否包含
 */
+ (BOOL)isHasSensitiveWord:(NSString*)text;
/**
 *  是否符合命名规则
 *
 *  @param text 文本
 *
 *  @return 是否符合
 */
+ (BOOL)isNameValidate:(NSString*)text;

/**
 *  是否符合标题命名规则
 *
 *  @param text 文本
 *
 *  @return 是否符合
 */
+ (BOOL)isTitleValidate:(NSString *)text;


+ (void)setScreenHeightOffset:(CGFloat)height;

/**
 *  获取屏幕高度
 *
 *  @return 屏幕高度
 */
+ (CGFloat)getScreenHeight;

/**
 *  获取机型
 */
+ (NSString *)getCurrentDeviceModel;
/**
 *  获取网络状态
 */
+ (NSString*)newtworkType;
/**
 *  通过色号获取图片
 *
 *  @param color 颜色
 *  @param size  大小
 *
 *  @return 图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;


+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  统计点击次数
 *
 *  @param str 统计key
 */
+ (void)zdsClick:(NSString*)str;

/**
 *  计算字节数
 *
 *  @param str 字符串
 */
+ (int)getCharLength:(NSString*)str;

/**
 *  是否符合标签命名
 *
 */
+ (BOOL)isTagValidate:(NSString *)text;
@end
