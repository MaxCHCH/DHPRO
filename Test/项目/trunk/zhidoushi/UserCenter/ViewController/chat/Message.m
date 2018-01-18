//
//  Message.m
//  15-QQ聊天布局
//
//  Created by Liu Feng on 13-12-3.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "Message.h"

@implementation Message

- (void)setDict:(NSDictionary *)dict{
    
    _dict = dict;
    self.time =  dict[@"createtime"];
    self.content = dict[@"content"];
    self.isOK = dict[@"rowsts"];
    if ([dict[@"snduserid"] isEqualToString:[NSUSER_Defaults objectForKey:ZDS_USERID]]) {//自己发的
        self.type = MessageTypeMe;
        self.icon = dict[@"sndimageurl"];
    }else{//别人发的
        self.type = MessageTypeOther;
        self.icon = dict[@"rcvimageurl"];
    }
}



@end
