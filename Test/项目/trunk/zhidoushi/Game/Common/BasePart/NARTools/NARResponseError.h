//
//  NARResponseError.h
//  zhidoushi
//
//  Created by xinglei on 14-10-30.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#ifndef zhidoushi_NARResponseError_h
#define zhidoushi_NARResponseError_h

typedef enum {
    NARResponseError_None=1,//无错误
    NARResponseError_NoNetwork,//无网络
    NARResponseError_Failed,//请求失败(无法连接到服务器)
    NARRResponseError_TimeOut,//请求超时
    NARResponseError_ParseFailed,//解析失败
    
    NARResponseError_OperationFailed=16,//操作失败
    NARResponseError_UnLogin=200,//尚未登录
    NARResponseError_PassError=201,//密码错误
    NARResponseError_AccountError=202,//用户名错误
    NARResponseError_LoginError=203,//服务器端登录操作失败
    NARResponseError_ThridBindError=300,//第三方绑定失败
    NARResponseError_UserNameExsit=301,//用户名已被使用
    NARResponseError_EmailExsit=302,//邮箱已被使用
    NARResponseError_UserNameIllegal=303,//用户名不合法
    NARResponseError_TokenExpire=400,//Token已经过期
}NARResponseErrorType;

#endif
