//
//  UserModel.h
//  zhidoushi
//
//  Created by xinglei on 14-10-29.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "BaseModel.h"

typedef enum {
    UserSexType_Sercert=0,//保密
    UserSexType_Male=1,//男
    UserSexType_Female=2,//女
}UserSexType;

typedef enum {
    UserAttentionedType_None=0,//无状态，未关注
    UserAttentionedType_Attentioned=1,//已关注
    UserAttentionedType_Mutual=2,//互相关注
    UserAttentionedType_Blacklist=3,//拉黑，（预留的）
}UserAttentionedType;

typedef enum {
    UserLevelType_None=0,//无等级
    UserLevelType_Authentication=1,//已认证过
}UserLevelType;

typedef enum {
    UserIdentity_builder = 0,//创建者
    UserIdentity_member = 1//成员
} UserIdentity;

@interface UserModel : BaseModel

//*所有用户的通用属性即所有用户都拥有的属性*//
@property (strong,nonatomic) NSString * userID;//用户id
@property (retain,nonatomic) NSString *nickName;//用户昵称（必须）
@property (retain,nonatomic) NSString *headUrl;//用户头像地址
@property (assign,nonatomic) UserSexType sex;//用户性别，（0是保密，处理成女）1是男，2是女
@property(nonatomic,strong)NSString * birthDay;//用户生日
//*用户自己的属性即只用户个人拥有的属性*//
@property(nonatomic,assign)UserIdentity userIdentity;//用户的身份（0,创建者；1,参与者）
@property (retain,nonatomic) NSString *userToken;//用户token
@property (retain,nonatomic) NSString *userName;//用户名
@property (retain,nonatomic) NSString *userCenterCover;//用户个人中的顶部封图
//*微信用户属性*//
@property(nonatomic,strong)NSString * city;
@property(nonatomic,strong)NSString * country;
@property(nonatomic,strong)NSString * province;
@property(nonatomic,strong)NSString * unionid;
//*用户的关注状态*//
@property (assign,nonatomic) UserAttentionedType attentionedType;//被自己关注的状态（登录用户才有效）

//手机用户位置信息
//@property(nonatomic,strong)NSString *userArea;
@property (strong,nonatomic) NSString *userCountry;//国家
@property (strong,nonatomic) NSString *userProvince;//省市
@property (strong,nonatomic) NSString *userCity;//市区
@property (nonatomic,strong) NSString *userLongitudeStr;//经度
@property (nonatomic,strong) NSString *userLatitudeStr;//纬度

@property (nonatomic,strong) NSString *userAge;

@end
