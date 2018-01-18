//
//  Constant.h
//  zhidoushi
//
//  Created by xinglei on 14-10-28.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#ifndef zhidoushi_Constant_h

#define zhidoushi_Constant_h

#endif

#define DATABASE_NAME @"lodatabase.db" //缓存的数据库名称,此数据库包含各种表

#define NORMAL_TITLE_VIEW_HEIGHT    (IOS7_OR_LATER?64:44)//通用的顶部bar高度
#define NORMAL_MAIN_TAB_VIEW_HEIGHT (45)//主页的tab高度

#define COLOR_NORMAL_BG [UIColor colorWithPatternImage:[GlobalUse backgroundImage]]//应用的通用背景颜色
#define COLOR_NORMAL_CELL_BG [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1]//应用的通用背景颜色

#define COLOR_NORMAL_LINE_BG [UIColor colorWithWhite:1 alpha:0.2]//线的通用背景颜色


//******************//

#define USERDEFAULT_SYSTEM_SETTING_KEY_USER_NAME  @"username"//用户名
#define USERDEFAULT_SYSTEM_SETTING_KEY_LOGIN_TYPE  @"loginType"//登录类型
#define USERDEFAULT_SYSTEM_SETTING_KEY_LOGIN_RANDOM  @"loginrandom"//登录返回的随机数
#define USERDEFAULT_SYSTEM_SETTING_KEY_USER_MODEL_INFO  @"usermodel"//登录用户的数据

#define USERDEFAULT_SYSTEM_SETTING_KEY_RECENT_TIPS  @"recenttips"//正在晒顶部的tips
#define USERDEFAULT_SYSTEM_SETTING_KEY_HTTP_SERVER  @"httpserver"//服务器的最新地址

#define USERDEFAULT_SYSTEM_SETTING_KEY_VERSION_RECOMMAND_USER  @"cachevperson"
#define USERDEFAULT_SYSTEM_SETTING_KEY_VERSION_RECOMMAND_CITY  @"cachevcity"
#define USERDEFAULT_SYSTEM_SETTING_KEY_VERSION_RECOMMAND_BRAND  @"cachevbrand"
#define USERDEFAULT_SYSTEM_SETTING_KEY_VERSION_RECOMMAND_CLASSIFY  @"cachevclassify"
//#define USERDEFAULT_SYSTEM_SETTING_KEY_LAUNCH_IMAGE_ALT  @"launchimagealt"
#define USERDEFAULT_SYSTEM_SETTING_KEY_NEWVERSION       @"newversioninfo"

#define USERDEFAULT_SYSTEM_SETTING_KEY_VERSION_ALL_BRAND        @"vallbrand"//全部品牌的版本号记录
#define USERDEFAULT_SYSTEM_SETTING_KEY_VERSION_SEARCH_BRAND     @"vsearchbrand"//供搜索的品牌的版本号记录
#define USERDEFAULT_SYSTEM_SETTING_KEY_VERSION_SEARCH_CITY      @"vsearchcity"//供搜索的城市的版本号记录
#define USERDEFAULT_SYSTEM_SETTING_KEY_VERSION_ALL_BRAND_TAG        @"vallbrandtag"//全部品牌标签的版本号记录

#define USERDEFAULT_SYSTEM_SETTING_KEY_STATIS_INFO      @"statisinfo"//上传统计的记录
#define USERDEFAULT_SYSTEM_SETTING_KEY_LAST_UPLOAD_STATIS_TIME      @"statisuploadtime"//上传统计的记录时间
#define USERDEFAULT_SYSTEM_SETTING_KEY_FIRST_TIME_SHOW      @"firsttime"//第一次

#define NOTIFICATION_NAME_VERSION_CHECKFINISHED @"ntfvcheckdone"//版本更新检测完成
#define NOTIFICATION_NAME_SINA_NAMECHANGE       @"ntfsinanamec"//新浪名称绑定改变
//#define NOTIFICATION_NAME_TXWEIBO_NAMECHANGE @"ntftxweibonamec"//腾讯微博绑定名称改变
#define NOTIFICATION_NAME_QQZONE_NAMECHANGE     @"ntfqqzonenamec"//qq空间绑定名称改变

#define NOTIFICATION_NAME_ALBUMS_EXTRACT        @"ntfalbums"//相册数据读取
#define NOTIFICATION_NAME_USER_INFO_CHANGED     @"ntfuserinfochange"//个人资料发送变化

#define NOTIFICATION_NAME_CACHE_LIST_CHANGED    @"ntfcachelistchange"//缓存的列表数据发生了变化

#define NOTIFICATION_NAME_PHOTOGRAPHY_FINISH @"ntphotographyfinish"//拍照完成通知主线程
#define NOTIFICATION_NAME_COLSEKEYBOARD @"ntclosekeyboard"//收起键盘

#define NOTIFICATION_NAME_UPLOAD_FINISHED    @"ntfuploadfinished"//有内容上传成功了
#define NOTIFICATION_NAME_LOGIN_STATUS_CHANGE    @"ntfloginstatuschange"//用户的登录状态发生了变化

#define NOTIFICATION_NAME_MESSAGE_CLEAR         @"messageclear"//消息都被读完了

#define NOTIFICATION_NAME_TAKEPICTURE           @"tackpicture"//拍完的照片已经被完整的存入到相册中


#define UPLOAD_IMAGE_SCALE_VALUE  0.8//图片上传时的压缩比例

#define TOPBAR_TITLELABEL_FONT_SIZE 20//导航栏字体大小

#define NARReturnAutoreleased(__v) (__v)

/**
 *  新版本宏定义**********************************************************************************
 */

#define ZDS_NORMAL_MAIN_TAB_VIEW_HEIGHT (45)//主页的tab高度

#define NSUSERDEFAULT_WEIXINCODE  @"weiXinCode"
#define ZDS_USERDEFAULT_SYSTEM_SETTING_KEY_USER_MODEL_INFO  @"usermodel"//登录用户的数据
#define ZDS_NOTIFICATION_NAME_LOGIN_STATUS_CHANGE    @"ntfloginstatuschange"//用户的登录状态发生了变化

#define ZDS_FISTPAGE_IMAGEFRAME_WIDTH      45//首页图片集图片宽度
#define ZDS_FISTPAGE_BEGINMODLE_WIDTH      84//首页即将开始图片宽度
#define ZDS_FISTPAGE_BEGINMODLE_LABEL_WIDTH  40//首页即将开始图片下部高度
