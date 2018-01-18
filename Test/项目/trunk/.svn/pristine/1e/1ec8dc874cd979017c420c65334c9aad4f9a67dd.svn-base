//
//  XLResponseError.h
//  zhidoushi
//
//  Created by xinglei on 14-10-30.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#ifndef zhidoushi_XLResponseError_h
#define zhidoushi_XLResponseError_h

typedef enum {
    XLResponseError_None=1,//无错误
    XLResponseError_NoNetwork,//无网络
    XLResponseError_Failed,//请求失败(无法连接到服务器)
    XLResponseError_TimeOut,//请求超时
    XLResponseError_ParseFailed,//解析失败
    
    XLResponseError_OperationFailed=16,//操作失败
    XLResponseError_UnLogin=200,//尚未登录
    XLResponseError_PassError=201,//密码错误
    XLResponseError_AccountError=202,//用户名错误
    XLResponseError_LoginError=203,//服务器端登录操作失败
    XLResponseError_ThridBindError=300,//第三方绑定失败
    XLResponseError_UserNameExsit=301,//用户名已被使用
    XLResponseError_EmailExsit=302,//邮箱已被使用
    XLResponseError_UserNameIllegal=303,//用户名不合法
    XLResponseError_TokenExpire=400,//Token已经过期

}XLResponseErrorType;

#endif
