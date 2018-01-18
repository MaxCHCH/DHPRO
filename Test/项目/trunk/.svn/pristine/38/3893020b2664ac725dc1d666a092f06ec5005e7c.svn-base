//
//  MessageFrame.h
//  15-QQ聊天布局
//
//  Created by Liu Feng on 13-12-3.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#define kMargin 15 //间隔
#define kIconWH 44 //头像宽高
#define kContentW SCREEN_WIDTH-105 //内容宽度

#define kTimeMarginW 25 //时间文本与边框间隔宽度方向
#define kTimeMarginH 10 //时间文本与边框间隔高度方向

#define kContentTop 14 //文本内容与按钮上边缘间隔
#define kContentLeft 15 //文本内容与按钮左边缘间隔
#define kContentBottom 14 //文本内容与按钮下边缘间隔
#define kContentRight 15 //文本内容与按钮右边缘间隔

#define kTimeFont [UIFont systemFontOfSize:10] //时间字体
#define kContentFont [UIFont systemFontOfSize:14] //内容字体

#import <Foundation/Foundation.h>

@class Message;

@interface MessageFrame : NSObject

@property (nonatomic, assign, readonly) CGRect iconF;
@property (nonatomic, assign, readonly) CGRect timeF;
@property (nonatomic, assign, readonly) CGRect contentF;

@property (nonatomic, assign, readonly) CGFloat cellHeight; //cell高度

@property (nonatomic, strong) Message *message;

@property (nonatomic, assign) BOOL showTime;

@end
