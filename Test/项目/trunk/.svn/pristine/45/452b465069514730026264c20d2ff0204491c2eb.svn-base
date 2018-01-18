//
//  DiscoverReplyModel.h
//  zhidoushi
//
//  Created by nick on 15/4/27.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DiscoverReplyModel;
@protocol DiscoverReplyModelDelegate <NSObject>

- (void)tapImage:(id)sender;

@end

@interface DiscoverReplyModel : NSObject
@property (nonatomic,retain) id<DiscoverReplyModelDelegate>delegate;
@property(nonatomic,copy)NSString *commentid;//评论ID
@property(nonatomic,copy)NSString *showid;//展示ID
@property(nonatomic,copy)NSString *userid;//用户ID
@property(nonatomic,copy)NSString *username;//用户昵称
@property(nonatomic,copy)NSString *userimage;//用户头像
@property(nonatomic,copy)NSString *content;//评论内容
@property(nonatomic,copy)NSString *commentlevel;//评论级别
@property(nonatomic,copy)NSString *byuserid;//被评论人ID
@property(nonatomic,copy)NSString *byusername;//被评论人名称
@property(nonatomic,copy)NSString *createtime;//创建时间
@property(nonatomic,copy)NSString *showimage;//评论配图
@property(nonatomic,copy)NSString *floorcount;//楼层，精华帖特有
+(instancetype)modelWithDic:(NSDictionary*)dic;
-(instancetype)initWithDic:(NSDictionary*)dic;
-(CGFloat)getCellHeight;
@end
