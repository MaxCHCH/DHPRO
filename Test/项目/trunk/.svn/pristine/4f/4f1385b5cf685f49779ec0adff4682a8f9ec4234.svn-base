//
//  AddressBook.h
//  zhidoushi
//
//  Created by xinglei on 14-11-5.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressBook : NSObject{
    NSInteger sectionNumber;
    NSInteger recordID;
    BOOL rowSelected;
    NSString *name;
    NSString *email;
    NSString *tel;
    UIImage *thumbnail;
}

@property NSInteger sectionNumber;
@property NSInteger recordID;
@property BOOL rowSelected;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *tel;
@property (nonatomic, retain) UIImage *thumbnail;
//@property (nonatomic,retain) NSMutableArray *phoneArray;
@property (nonatomic,copy) NSString* phoneNum;
@property (nonatomic,assign) NSInteger userID;//用户编号
@property (nonatomic,assign) NSInteger isCheck;//1，代表是好友2，没有注册，3，已经注册
@property (nonatomic,assign) NSInteger isAttented;//是否被邀请 0未被邀请 1已被邀请

@property (nonatomic,assign) NSInteger row;
@property (nonatomic,assign) NSInteger isGuKe;//是否被关注 0为未安装 1为已经安装股客


@end
