//
//  XLConnection.h
//  zhidoushi
//
//  Created by xinglei on 14-10-30.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

//  网络连接对象（用于发送相应的数据请求，每次使用都创建一个独立对象，每次使用结束对其释放）

#import <Foundation/Foundation.h>

#import "WWURLConnection.h"

typedef void (^XLUrlConnectionBlock) (id objct, NSString * error);

@interface XLURLConnection : NSObject<NARURLConnectionDelegate>

@property (nonatomic, strong) id request;   //储存请求类
@property(nonatomic,strong)NSDictionary * paraDictionary;//存储参数类
@property(nonatomic,strong)NARResponseParser* parser;//解析器类
@property(nonatomic,copy)XLUrlConnectionBlock connectionBlock; //用于传输数据对象

-(void)start;
-(instancetype)initWithUrlString:(id)req paraMeter:(NSDictionary*)para parser:(NARResponseParser*)parser_;

@end
