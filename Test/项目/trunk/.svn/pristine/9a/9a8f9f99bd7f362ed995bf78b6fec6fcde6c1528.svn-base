//
//  XLConnectionStore.h
//  zhidoushi
//
//  Created by xinglei on 14-10-29.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

//#import "UserModel.h"
//#import "GameModel.h"

@class UserModel;
@class GameModel;

typedef void (^XLDataStoreBlock) (id data, NSString *error);

@interface XLConnectionStore : NSObject

@property(nonatomic,copy)XLDataStoreBlock xlDataStoreBlock;

/*!
 *	@brief	单例，用于管理各个页面网络连接
 *
 *	@return	返回当前类单利
 */
+(XLConnectionStore *)shareConnectionStore;
/*!
 *	@brief	获取 教练信息列表
 *
 *	@param 	page 	用于刷新 或 加载
 *	@param 	block 	列表数据
 */
- (void)getCoachListWithPage:(int)page andComplection:(XLDataStoreBlock)block;
/*!
 *	@brief	获取（即将开始游戏）列表数据
 *
 *	@param 	page 	用于上拉加载和下拉刷新使用
 *	@param 	userID 	用户的id
 *  @param 	key 	用户的id+pi的MD5加密号
 *	@param 	block 	用于返回数据或错误类型
 */
- (void)getWillBegainGamePacketListWithPage:(int)page andUserSelf:(BOOL)isUserSelf andUserID:(NSString*)userID andUserKey:(NSString*)key andComplection:(XLDataStoreBlock)block;
/**
 *  Description   获取详细明星教练数据
 *
 *  @param page   page description
 *  @param size   size description
 *  @param userid userid description
 *  @param key    key description
 *  @param block  block description
 */
-(void)getCoachDetailListWithPageNum:(NSString*)page andPageSize:(NSString*)size andUserid:(NSString*)userid andKey:(NSString*)key andComplection:(XLDataStoreBlock)block;
/**
 *  Description   即将开始详细页
 *
 *  @param page   page description
 *  @param size   size description
 *  @param userid userid description
 *  @param key    key description
 *  @param block  block description
 */
-(void)getWillBeginDetailListWithPageNum:(NSInteger)page andPageSize:(NSInteger)size andUserid:(NSString*)userid andKey:(NSString*)key andComplection:(XLDataStoreBlock)block;
/**
 *  Description   首页获取热门游戏
 *
 *  @param page   page description
 *  @param size   size description
 *  @param userid userid description
 *  @param key    key description
 *  @param block  block description
 */
- (void)getWillHotGamePacketListWithPage:(int)page andUserSelf:(BOOL)isUserSelf andUserID:(NSString*)userID andUserKey:(NSString*)key andComplection:(XLDataStoreBlock)block;
/**
 *  Description  首页获取礼品
 *
 *  @param page  page description
 *  @param block block description
 */
- (void)getAwardListWithPage:(int)page andComplection:(XLDataStoreBlock)block;
/**
 *  Description 获取团组成员详细列表
 *
 *  @param page
 *  @param size
 *  @param userid
 *  @param key
 *  @param block
 */
-(void)getTeamMemberListWithPageNum:(NSString*)page andPageSize:(NSString*)size andUserid:(NSString*)userid andKey:(NSString*)key andGameid:(NSString*)gameid andComplection:(XLDataStoreBlock)block;
/**
 *  Description   获取我的关注信息
 *
 *  @param page
 *  @param size
 *  @param userid
 *  @param key
 *  @param block
 */
-(void)getAttentionListWithPageNum:(NSString*)page andPageSize:(NSString*)size andURL:(NSString*)and_url andUserid:(NSString*)userid andKey:(NSString*)key  andAttentionType:(NSString*)atype andComplection:(XLDataStoreBlock)block;
/*!
 *	@brief	获取 当前楼层的评论列表
 *
 *	@param 	elementM 	当前楼层
 *	@param 	startID 	把当前列表的 最上边那条数据的时间给服务器以请求 大于那个时间按的数据（新数据）上拉加载默认为零
 *	@param 	endID 	    把当前列表的 最下边的条数据的时间给服务器以请求 小于那个时间按的数据（新数据）刷新数据默认为零
 *	@param 	block       返回需要的评论列表
 */
//- (void)getCommentListDataWithElementM:(ElementModel *)elementM andStartID:(int)startID andEndID:(int)endID andComplection:(XLDataStoreBlock)block;
@end
