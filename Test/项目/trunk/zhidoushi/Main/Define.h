//
//  Define.h
//  zhidoushi
//
//  Created by xinglei on 14-9-10.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <mach/mach.h>



//NSCoding 宏定义
//各尺寸

#define ZDS_WIDTH 15
//正式加密号
//#define ZDS_M_PI  @"3.141592653589793"
//测试加密号
#define ZDS_M_PI  @"wojiushimiyue"

// 个推号
//测试
#define kAppId           @"8EjTWgta7j6XfayagKFVv4"
#define kAppKey          @"gEZRynePeEAdp5nNBClTW"
#define kAppSecret       @"c8o6XU1FWL6sgFwewaMKR7"
//生产
//#define kAppId           @"4npy77NVId8STuavpcUQ53"
//#define kAppKey          @"MhlvpsPgLN84KRFATMM23"
//#define kAppSecret       @"MrtcFWocs970w970ePoAr8"

//..服务器请求地址..//
//正式地址
//#define ZDS_DEFAULT_HTTP_SERVER_HOST        @"http://sc.zhidoushi.com/zhidoushi/"
//测试地址
#define ZDS_DEFAULT_HTTP_SERVER_HOST        @"http://cao.zhidoushi.com/zhidoushi/"

//微信登录号
#define kWXAPP_ID  @"wx25d948f96299d7ee"
#define kWXAPP_SECRET @"186552e3de1e65549fd569a353d98336"
//新浪
#define Sina_AppKey @"688997104"
#define Sina_AppSecret @"8dded09b38d8f61152d9ccf8df5bfee1"

//消息推送身份标识
#define ZDS_DEVICETOKEN  @"zds_DEVICETOKEN"
#define ZDS_CLIENTID     @"zds_clientId"
#define kCLEARCOLOR [UIColor clearColor]
//无网络请求
#define ZDS_NONET_HUASHU @"网络不给力啊/(ㄒoㄒ)/~~"
#define ERRCODE @"errcode"
//包含敏感词
#define ZDS_HASSENSITIVE @"注意哦！内容中包含敏感词！"
//*缓存路径*//
//可读写的Documents文件夹
#define DocumentDirectory() [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
//可读写的Library文件夹
#define LibraryDirectory() [NSHomeDirectory() stringByAppendingPathComponent:@"Library"]
//电话簿路径
#define     DOCUMENT_USERPHONE_PLIST            @"LocalUserPhoneBook.plist"
#define MYINFORMATIN      @"myInformationDic"
//用户数据
#define     DOCUMENT_USER_PLIST            @"LocalUserPlist.plist"
//标识符
#define     DOCUMENT_USER_UUID             @"LocalUserUUID.plist"
//首页保存的数组集
#define     DOCUMENT_USER_GAMEARRAY             @"GameArray.plist"

//..机械判断..//
#define     iOS7                            ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) ? YES : NO
#define iOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) ? YES : NO
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)|| [[UIDevice currentDevice].model isEqualToString:@"iPad"]


#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define DEFAULTNAVIGATIONBARHEIGHT 64

#import "AppDelegate.h"
#import "UINavigationController+backButton.h"

//动态内容图文混排的属性
#define KFacialSizeWidth  20
#define KFacialSizeHeight 20
#define MAX_WIDTH 240
#define Font_Size   15
#define BEGIN_FLAG  @"[/"
#define END_FLAG    @"]"
#define     Cell_Row_Height  60

#import "ITTDebug.h"
#import "Constant.h"
#import "MBProgressHUD.h"
//#import "CSAnimationView.h"
//#import "CalendarDateUtil.h"
#import "MLSelectPhotoPickerViewController.h"
#import "BaseViewController.h"
//#import "UIViewController+MMDrawerController.h"

#define DLogMemoryUsed do{struct task_basic_info info;mach_msg_type_number_t size = sizeof(info);kern_return_t kerr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&info, &size);if( kerr == KERN_SUCCESS ){printf("-->YRDLogMemoryUsed (in M-bytes): %f m\n", info.resident_size /(1024.0*1024.0));}else{printf("->YRDLogMemoryUsed Error with task_info(): %s\n", mach_error_string(kerr));}}while(0)

//*-begin--  -fobjc-arc*//

#define XLAutorelease(__v)
#define XLReturnAutoreleased(__v) (__v)

#define XLRetain(__v)
#define XLReturnRetained(__v) (__v)

#define XLRelease(__v)
#define XLDealloc(__v)

// ø ø 脂斗士新增参数  ø ø //
//..苹果商店评论地址..//itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=963050782

//#define ZDS_APPSTOREURL @"http://itunes.apple.com/cn/app/id963050782"

//分享地址
#define ZDS_APPSTOREURL [NSString stringWithFormat:@"%@h5/share.html?gameid=%@",ZDS_DEFAULT_HTTP_SERVER_HOST,[NSUSER_Defaults objectForKey:@"fenxianggameid"]]

#define ZDS_APP_DOWNLOAD @"http://itunes.apple.com/app/id963050782"

//..分享，邀请话述..//
#define ZDS_GET_FENXIANG_HUASHU                    @"ineract/sharedesc.do"//获取分享链接
#define ZDS_FENXIANG_WEIXINHAOYOU     @"fenxiangweixinhaoyou"//分享微信好友话述
#define ZDS_FENXIANG_WEIXINFRIEND     @"fenxiangweixinpengyouquan"//分享微信朋友圈话述
#define ZDS_YAOQING_WEIXINHAOYOU      @"yaoqingweixinhaoyou"//邀请微信好友
#define ZDS_YAOQING_WEIXINFRIEND      @"yaoqingweixinpengyouquan"//邀请微信朋友圈

//....导航栏title颜色....//
#define ZDS_DHL_TITLE_COLOR [WWTolls colorWithHexString:@"#475564"]
#define ZDS_BACK_COLOR [WWTolls colorWithHexString:@"#f6f2f2"]





//..............................V2.0..........................//

//.......消息..........///
#define ZDS_MESSAGE_LIST @"/notice/letterlist.do"//私信列表
#define ZDS_NEW_MESSAGE_LIST @"ineract/newletters.do"//最新私信列表
#define ZDS_INFORMATION_LIST @"/notice/noticelist.do"//通知列表
#define ZDS_NEWFUNS_COUNT @"/notice/newfanscount.do"//新粉丝数量
#define ZDS_NEWFUNS_LIST @"/notice/newfanslist.do"//新粉丝列表
#define ZDS_NEWFUNS_NEW_LIST @"/notice/newfanslist2.do"//新粉丝列表
#define ZDS_DISCOVER_GOOD @"/ineract/praiseusers.do"//点赞列表
//....广场....//
#define ZDS_GROUP_COMING_LIST       @"/game/upcoming1.do"//获取广场即将开始列表
#define ZDS_GROUP_HOT_LIST          @"/game/hotlist.do"//获取广场热门团组列表
#define ZDS_GROUP_EDITOR          @"game/editgame.do"//获取广场热门团组列表
#define ZDS_GROUP_EDITOR_GONGGAO       @"/game/upgmslogan.do"//修改团组公告
#define ZDS_CREATE_TAGS             @"/game/loadtags.do"//加载标签
#define ZDS_HOME_ALLGROUP       @"/game/allgames.do"//获取所有团组
//..............................V2.2..........................//
#define ZDS_Group_Bubble @"/ineract/bubble.do"//发起冒泡
#define ZDS_Group_Pubact @"/ineract/pubact.do"//发起活动
#define ZDS_Group_Joinact @"/ineract/joinact.do"//参加活动
#define ZDS_Group_Actparters @"/ineract/actparters.do"//加载活动参与者列表
#define ZDS_Group_Actdetail @"/ineract/actdetail.do"//活动详情页面
#define ZDS_Group_Actcomments @"/ineract/actcomments.do"//加载活动评论列表
#define ZDS_Group_Playbar @"/ineract/playbar.do"//加载乐活吧
//#define ZDS_Group_Hello @"/ineract/hello.do"//发起打招呼

//..............................V2.3..........................//
#define ZDS_Get_Sharedeesc @"/ineract/sharedesc1.do"//获取分享话述
#define ZDS_Del_Bar @"/ineract/delbar.do"//乐活吧删除，被删除记录的发起者可删除团聊和活动。
#define ZDS_Del_Show @"/discover/delshow.do"//撒欢创建者可删除撒欢。
#define ZDS_HOME_GFTLIST             @"/game/gfgames.do"//加载官方团
#define ZDS_URGETASK @"/game/urgetask.do" //向团长发送催促发任务的通知
#define ZDS_PUBLISHTASK @"/game/publishtask.do" //团长发布团组任务
#define ZDS_FINISHTASK @"/game/finishtask.do" //完成团组任务
#define ZDS_Massmsg @"/game/massmsg.do" //团长向团员群发通知
#define ZDS_LOSEDETAIL @"/game/losedetail.do" //团员减重详细列表
#define ZDS_DISSOLVE @"game/dissolve.do" //解散团组申请

//..............................V2.3.0..........................//
#define ZDS_HOTTAGS @"discover/hottags.do" //加载所有的热门标签，发布撒欢页面调用
#define ZDS_SHOWLIST1 @"discover/showlist1.do" //显示撒欢列表
#define ZDS_GET_TOTALPEOPLE @"/popupWeightInfo.do" //获取人数与总重

//..............................V2.3.2..........................//
#define ZDS_SASSTAiCS @"sasstaics.do" //app启动和停止时调用该接口
#define ZDS_SHOW @"/search/show.do" //搜索用户发布的撒欢
#define ZDS_SEARCH_HOTGAMES @"search/hotgames.do" //选择团组搜索时，默认展示在搜索结果列表中的团组集合
#define ZDS_MESSAGE_COMMENT @"/notice/commentlist.do" //我的评论列表接口
#define ZDS_LETTERSWH @"me/letterswh.do" //开启和关闭私信通知开关

//..............................V2.3.4..........................//
#define ZDS_DELCOMMENT @"/discover/delcomment.do" //删除撒欢评论，允许自己和撒欢创建者删除
#define ZDS_DELREPLY @"ineract/delreply.do" //删除团聊回复、允许自己和团聊创建者删除。

//..............................V2.3.6..........................//
#define ZDS_DELPARTER @"game/delparter.do" //剔除团员，支持批量
#define ZDS_SEARCHPARTER @"search/parter.do" //根据游戏名称、创建人名称模糊查询游戏信息
//..............................V2.3.10..........................//
#define ZDS_CREATEARTICLE @"ineract/publishtitle.do" //发布标题贴
#define ZDS_GROUP_TITLE @"/ineract/titledetail.do" //标题贴详情页
#define ZDS_GROUP_TITLE_LIST @"/ineract/showtitle.do" //标题贴列表
//..............................V2.3.12..........................//
#define ZDS_GROUP_TASKDETAIL @"/game/taskdetail.do"//任务详情页
#define ZDS_GROUP_TASKDONELIST @"/game/finishedlist.do"//任务完成人列表
#define ZDS_GROUP_SUBMITTASK @"/game/submittask.do"//提交任务
#define ZDS_GROUP_ENDTASK @"/game/endtask.do"//结束任务
//.........................V2.3.16.........................//
#define ZDS_GROUP_MESSAGE_LIST @"/game/massmsglist.do"//历史通知列表
#define ZDS_GROUP_PHOTOS @"user/photos.do"//加载我的相册
#define ZDS_WEEKLYLIST @"game/weeklylist.do"//周记
#define ZDS_GROUP_WEEKLYLIST @"/game/weeklylist.do"//周记详情

//........................V2.3.18.........................//
#define ZDS_GROUP_GET_CALENDAR @"/game/punchlist.do"//获取我的日历
#define ZDS_GROUP_PUSHCARD @"/game/todaypunch.do"//发布打卡
//....发现....///
//2.3.0废弃
#define ZDS_CREATE_SHOWTYPEDETAIL             @"/discover/showlist.do"//显示撒欢列表
#define ZDS_DISCOVER_DISCOVERDETAIL                   @"/discover/showdetail.do"//发现详情
#define ZDS_FABU_PINLUN             @"/discover/pubcomment.do"//加载标签
#define ZDS_DISCOVER_DATA                    @"/discover/lobby1.do"//发现主页
#define ZDS_DISCOVER_GROUPMESSAGE                    @"/discover/gamedyn.do"//发现主页团组动态
#define ZDS_DISCOVER_INTRESTUSER @"/discover/interestuser.do"//可能感兴趣的人列表
#define ZDS_DISCOVER_ADDDISCOVER @"/discover/pubshow.do"//发表发现
#define ZDS_DISCOVER_SEARCHMAN  @"/search/user.do"//搜索人
//....我.....//
#define ZDS_ME_MYALBUM                  @"/me/photos.do"//获取我的相册
#define ZDS_ME_MYMESSAGE                  @"/ineract/letterbox.do"//获取私信列表
#define ZDS_ME_SENDMESSAGE                   @"/ineract/sendletter.do"//发送信息
#define ZDS_ME_PINGBI                   @"/ineract/shield.do"//屏蔽信息
#define ZDS_ME_GROUP                   @"/user/footmark.do"//加载活动
#define ZDS_ME_JIFEN                   @"/user/achieve.do"//加载积分
#define ME_MYALBUM_COACHE @"myalbumcoachekey"//我的相册缓存key
//..获取即将开始详细页..//
#define ZDS_ME_SAYHELLO                               @"/ineract/hello.do"//打招呼
#define ZDS_LOAD_NOTIFY                   @"/me/broadcasts.do"//加载广播

#define ZDS_LOAD_SAVEWEG                    @"me/uploadweight.do"//上传体重
#define ZDS_LOAD_MYWEIGHT                   @"me/myweight.do"
#define ZDS_LOAD_UPLOADHEIGHT               @"me/uploadheight.do"//上传身高



//..............................V1.0..........................//

//..本地保存的上次上传体重..//
#define ZDS_LAST_WEIGHT                            @"zdslastweigh"
//..默认图片地址..//
#define ZDS_DEFAULTIMAGEURL                        @"imgs/default/game.jpg?Fipo6KtAnjqcDp6yROS06R4HqbFU"
//.微信登陆判断.//
#define ZDS_WEIXINJUDGE                            @"weixinjudge"
//..上传用户信息参数..//
#define ZDS_URLREQUEST_USERCODE                    @"vcode"//验证码
#define ZDS_URLREQUEST_USERPHONENUMBER             @"pnum"//手机号
#define ZDS_URLREQUEST_NICKNAME                    @"usernic"//昵称
#define ZDS_URLREQUEST_TOKEN                       @"devicetoken"//标示符
#define ZDS_URLREQUEST_SEX                         @"usersex"//性别
#define ZDS_URLREQUSET_BIRTH                       @"userbirth"//生日
//..上传图片路径..//
#define ZDS_URLREQUEST_ARGV_POSTIMAGE              @"imgs/"
//**手机注册信息入库**//
#define ZDS_SAVEINFODO                             @"saveinfo1.do"
#define ZDS_URLREQUEST_ATGV_POSTUSERDICTIONARY     @"login.do"//上传用户信息
#define ZDS_URLREQUEST_GETCODE                     @"getcode1.do"//获取手机验证码

#define ZDS_URLREQUEST_WBLOGIN                     @"wblogin.do"//微博登陆
#define ZDS_URLREQUEST_GETWEIXINCODE               @"wxlogin.do"//获取微信验证码
//..保存微信用户信息..//
#define ZDS_WEIXIN_LOCAL_INFORMATION               @"weiXinUserInformation"//保存于本地的微信用户信息
//..获取游戏大厅列表..//
#define ZDS_GAMELOBBY_LIST                         @"game/lobby.do"//获取游戏大厅列表


//..保存用户电话号码..//
//#define ZDS_USERPHONENUMBER                        @"userPhoneNumber"//本地保存的电话号码
//..保存的通知状态..//
#define ZDS_INFORMATIONSTAGE                       @"informationStage"
//..本地保存的userID..//
#define ZDS_USERID                                 @"userid"
//..本地保存的userName..//
#define ZDS_USERNAME                               @"kusernickname"
//..保存的openid..//
#define ZDS_OPENID                                 @"openid"
//..注销登录..//
#define ZDS_USER_LOGOUT                            @"logout.do"//注销登录
//..创建游戏..//
#define ZDS_CIRCLE                                 @"game/circle.do"//供减脂吧和创建团组时加载减脂圈子使用
//..获取明星教练数据..//
#define ZDS_STARCOACH                              @"game/starcoach.do"//明星教练数据
//..获取即将开始详细页..//
#define ZDS_UPCOMING                               @"game/upcoming.do"//即将开始详细页
//..创建游戏状态校验..//
#define ZDS_CREATECHK                              @"game/createchk1.do"//校验游戏状态
//..创建游戏..//
#define ZDS_CREATEDO                               @"game/create.do"
//..创建普通游戏..//
#define ZDS_CREATEPTDO                             @"game/creatept.do"
//..游戏详情页接口..//
#define ZDS_GAMEDETAIL                             @"game/detail1.do"
//..团组介绍接口..//
#define ZDS_GAMEMESSAGE                            @"/game/introduce.do"
//..获取选择游戏页面按钮状态，并根据状态跳转页面..//
#define ZDS_GAMESELGAME                            @"game/selgame.do"
//..检索上传体重..//
#define ZDS_UPLWEISTS                              @"game/uplweists.do"
//..上传体重..//
#define ZDS_SAVEWEG                                @"game/saveweg.do"
//..置顶..//
#define ZDS_TOP_BAR                               @"ineract/topbar.do"
//..搜索游戏..//
#define ZDS_SEARCH                                 @"search/game.do"
//..上传图片..//
#define ZDS_UPLOAD                                 @"upload.do?"
//..获取上传图片凭证..//
#define ZDS_UPLOADTOKEN                            @"uptoken.do"
//..获取原图..//
#define ZDS_GETBIGIMAGE                            @"oglimage.do"
//..关注..//
#define ZDS_INERACTUPFLWSTS                        @"ineract/upflwsts.do"
//..游戏完成度详细数据..//
#define ZDS_COMPLETE                               @"game/complete.do"
//..点赞..//
#define ZDS_PRAISE                                 @"ineract/praise.do"
//..点赞..1.0.4之后//
#define ZDS_PRAISE_104                             @"ineract/praise1.do"
//..加载用户动态信息，包括用户记录、他人动态..//
#define ZDS_USER_LOGDO                             @"user/log.do"
//..用户我的目标和记录页面中，加载我的阶段目标..//
#define ZDS_GAME_PHASEGOAL                         @"game/phasegoal.do"
//..加载讨论详细页..//
#define ZDS_TALKDETAIL                             @"/ineract/playbar.do"
//..讨论置顶功能，置顶次数参数配置在config.properties..//
#define ZDS_TALKTOP                                @"ineract/talktop.do"
//..发起讨论..//
#define ZDS_PUBLISHTALK                            @"ineract/publishtalk.do"
//..发起回复..//
#define ZDS_PUBLISHRPY                             @"ineract/publishrpy.do"
//..加载回复详细页..//
#define ZDS_RPYDETAIL                              @"ineract/rpydetail.do"
//..邀请列表..//
#define ZDS_INVITELIST                             @"ineract/invitelist.do"
//..对自己的好友发出邀请..//
#define ZDS_INVITEPEOPLE                           @"ineract/invite.do"
//..加载游戏参与者列表详细页面..//
#define ZDS_PARTERGAME                             @"game/parter.do"
//..加载光荣榜..//
#define ZDS_GROUP_GRB                             @"game/honorlist.do"

//..加载用户的主页，包含个人信息和个人记录(他人视角)..//
#define ZDS_PROFILE                                @"user/profile.do"
//..加载我的主页信息(我的视角)..//
//#define ZDS_LOADME                                 @"user/profile1.do" // /user/basicinfo.do
#define ZDS_LOADME                                 @"/user/basicinfo.do" // /user/basicinfo.do


//..修改我的个人资料..//
#define ZDS_UPDATEMYINFO                           @"/me/updatemyinfo1.do"
//...获取我的个人信息...//
#define ZDS_GETMYINFO                              @"me/myinfo.do"
//..获取我的联系人个数..//
#define ZDS_GETCOUNT                               @"me/getcount.do"
//..获取我的关注列表..//
#define ZDS_GETFLWLIST                             @"me/getflwlist.do"
//..获取我粉丝列表..//
#define ZDS_GETFNSLIST                             @"me/getfnslist.do"

//..获取他人关注列表..//
#define ZDS_GET_OTHER_FLWLIST                      @"user/getflwlist.do"
//..获取他人粉丝列表..//
#define ZDS_GET_OTHER_FNSLIST                      @"user/getfnslist.do"

//..获取我的新朋友列表..//
#define ZDS_GETNEWFRIEND                           @"me/getnewfriendlist.do"
//..获取我的新浪微博朋友列表..//
#define ZDS_GETNEWSINAFRIEND                           @"me/wbfriends.do"
//..保存用户通讯录..//
#define ZDS_CPBOOKDO                               @"cpbook.do"
//..保存用户新浪好友..//
#define ZDS_CPSINAFRIENDDO                               @"cpwbflws.do"
//..缓存的用户电话簿..//
#define ZDS_USERPHONEBOOK                          @"zds_userPhoneBook"
//..获取回复的列表..//
#define ZDS_MEGETREPLYLIST                         @"me/getreplylist.do"
//..获取赞列表..//
#define ZDS_GETPRAISELIST                          @"me/getpraiselist.do"
//..获取赞列表..//
#define ZDS_GETPRAISELIST_104                          @"me/getpraiselist1.do"
//..加载我的减脂团页面，同时支持加载当前游戏和历史游戏..//
#define ZDS_MYGAMEDO                               @"game/mygame.do"
//..获取每日提醒列表..//
#define ZDS_GETEVERYPUSHLIST                       @"me/geteverypushlist.do"
//..获取邀请的列表..//
#define ZDS_GETINVITELIST                          @"me/getinvitelist.do"
//..获取游戏通知的列表..//
#define ZDS_GETMSGLIST                             @"me/getmsglist.do"
//..加载兑奖模块主页..//
#define ZDS_LOADSORE                               @"score/loadscore.do"
//..兑奖主页加载可兑奖品的列表(缓冲加载调用)..//
#define ZDS_GETGOODSLIST                           @"score/getgoodslist.do"
//..积分兑换（点击兑换奖品按钮）..//
#define ZDS_EXCHANGE                               @"score/exchange.do"
//..获取我的积分详细信息..//
#define ZDS_GETMYSCORE                             @"score/getmyscore.do"
//..获取一个商品详情..//
#define ZDS_GETGOODSINFO                           @"score/getgoodsinfo.do"
//..兑取兑换记录列表..//
#define ZDS_GETRECORDS                             @"score/getrecords.do"
//..讨论举报功能，支持对讨论内容、回复内容的举报..//
#define ZDS_TALKINFORM                             @"ineract/inform.do"
//..游戏创建者向组员发起每日提示..//
#define ZDS_REMINDDO                               @"ineract/remind.do"
//..加入游戏..//
#define ZDS_JOINDO                                 @"game/join.do"
//..退出游戏..//
#define ZDS_EXITDO                                 @"game/exit.do"
//..校验每日提示状态，判断当天是否已经发送过每日提醒..//
#define ZDS_INERACTREMINDCHK                       @"ineract/remindchk.do"
//..更新deviceid与clientid..//
#define ZDS_UPDATEDEVICEIDCLIENTID                       @"user/updateid.do"
//..用户反馈..//
#define ZDS_FEEDBACK                       @"me/feedback.do"
//..同步敏感词..//
#define ZDS_SENSITIVEWORD                       @"/synmgc.do"


//橘红色
#define  OrangeColor [WWTolls colorWithHexString:@"#ff5304"]
//名字色 标题色
#define  NameColor [WWTolls colorWithHexString:@"#475564"]
//时间色
#define  TimeColor [WWTolls colorWithHexString:@"#a7a7a7"]
//内容色
#define  ContentColor [WWTolls colorWithHexString:@"#4e777f"]

//title色
#define  TitleColor [WWTolls colorWithHexString:@"#475564"]

//..........缓存地址...............//
#define MESSAGE_COACHE_LIST @"messagelistcoche"
//发现缓存
#define DISCOVER_COACHE_UESR @"discoverintruser"
#define DISCOVER_COACHE_ACTIVE @"discoveractive"
#define DISCOVER_COACHE_SHOWS @"discoverdiss"
//我缓存
#define ME_COACHE_MESSAGE @"megerenxinxi"
#define ME_COACHE_GROUP @"megroupoo"
#define ME_COACHE_SCORE @"mescoreoo"
#define GROUP_COACHE_CALENDAR @"mycalendarcoache"

//广告缓存地址
#define STORE_AD_CACHE_PATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0] stringByAppendingPathComponent:@"recordAd.data"]
//奖品缓存地址
#define STORE_GOODS_CACHE_PATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0] stringByAppendingPathComponent:@"recordGoods.data"]
//个人信息缓存地址
#define USERINFO_CACHE_PATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0] stringByAppendingPathComponent:@"MyUserInfo.data"]
//教练缓存地址
#define GAME_COACH_CACHE_PATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0] stringByAppendingPathComponent:@"coach.data"]
//首页奖品缓存地址
#define GAME_RECORD_CACHE_PATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0] stringByAppendingPathComponent:@"record.data"]
//即将开团缓存地址
#define GAME_RIGHTNOW_CACHE_PATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0] stringByAppendingPathComponent:@"JiJiangKaiTuan.data"]
//热门游戏缓存地址
#define GAME_HOTGAME_CACHE_PATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0] stringByAppendingPathComponent:@"hotgame.data"]
//我的减脂团缓存地址
#define MYGAME_CACHE_PATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0] stringByAppendingPathComponent:@"mygame.data"]
#define MYGAME_GM_CACHE_PATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0] stringByAppendingPathComponent:@"gmgame.data"]

//******数据统计key*********//
/**底部导航栏点击
 1减脂
 2撒欢
 3自我
 4动静
 **/
#define TJ_TABBAR_JZ @"jznum"
#define TJ_TABBAR_SH @"shnum"
#define TJ_TABBAR_ZW @"zwnum"
#define TJ_TABBAR_DJ @"djnum"

/**标题贴点击
 1撒欢广场－标题帖阅读量	shgcbttnum
 2撒欢动态－标题帖阅读量	shdtbttnum
 3话题搜索－标题帖阅读量	htssbttnum
 4乐活吧－标题帖阅读量	lhbbttnum
 5评论列表－标题帖阅读量	pllbbttnum
 **/
#define TJ_TITLE_SHGC @"shgcbttnum"
#define TJ_TITLE_SHDT @"shdtbttnum"
#define TJ_TITLE_HTCS @"htssbttnum"
#define TJ_TITLE_LHB @"lhbbttnum"
#define TJ_TITLE_DJPL @"pllbbttnum"

/**团组详情页点击进入
 1减脂吧
 2全部团组
 3官方团
 4团组搜索
 5撒欢广场－团聊
 6撒欢广场－标题贴
 7撒欢广场－团组动态
 8足迹
 9通知列表
 10我的动态－团聊
 11我的动态－团组任务
 12我的动态－标题贴
 13我的动态－团组动态
 
 减脂吧推荐－团组详情阅读量	jzbtzxqnum
 全部团组－团组详情阅读量	qbtztzxqnum
 官方团－团组详情阅读量	gfttzxqnum
 团组搜索－团组详情阅读量	tzsstzxqnum
 撒欢列表－团聊－团组详情阅读量	shlbtltzxqnum
 撒欢列表－标题帖－团组详情阅读量	shbtttzxqnum
 撒欢列表－团组动态－团组详情阅读量	shtzdttzxqnum
 足迹－团组详情阅读量	zjtzxqnum
 通知列表－团组详情阅读量	tzlbtzxqnum
 撒欢动态－团聊－团组详情	shdttltzxqnum
 撒欢动态－团组任务－团组详情阅读量	shdttzrwtzxqnum
 撒欢动态－标题帖－团组详情阅读量	shdtbtttzxqnum
 撒欢动态－团组动态－团组详情阅读量	shdttzdttzxqnum
 
 发布新任务-取消 fbxrwqxnum
 团组详情-提交成绩	tzxqtjcjnum
 任务详情-提交成绩	rwxqtjcjnum
 提交成绩-取消	tjcjqxnum
 团组详情-返回	tzxqfhnum
 团组详情-编辑标签-取消	tzxqbjbqqxnum
 创建团组-返回	cjtzfhnum
 添加标签-取消	cjtztjbqqxnum
 **/
#define TJ_PUSHTASK_QX @"fbxrwqxnum"
#define TJ_GROUPDETAIL_TJCJ @"tzxqtjcjnum"
#define TJ_TASKDETAIL_TJCJ @"rwxqtjcjnum"
#define TJ_SUBMITTASK_QX @"tjcjqxnum"
#define TJ_GROUPDETAIL_QX @"tzxqfhnum"
#define TJ_GROUPDETAIL_EDITORTAG_QX @"tzxqbjbqqxnum"
#define TJ_CREATEGROUP_QX @"cjtzfhnum"
#define TJ_CREATEGROUP_EDITOR_QX @"cjtztjbqqxnum"


#define TJ_TJSZ @[TJ_TABBAR_DJ,TJ_TABBAR_JZ,TJ_TABBAR_SH,TJ_TABBAR_ZW,TJ_PUSHTASK_QX,TJ_GROUPDETAIL_TJCJ,TJ_TASKDETAIL_TJCJ,TJ_SUBMITTASK_QX,TJ_GROUPDETAIL_QX,TJ_GROUPDETAIL_EDITORTAG_QX,TJ_CREATEGROUP_QX,TJ_CREATEGROUP_EDITOR_QX]

