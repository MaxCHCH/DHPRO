//
//  ShareGameSubClassView.h
//  zhidoushi
//
//  Created by xinglei on 14/12/16.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupTalkModel.h"
#import "DiscoverModel.h"
#import "GroupHeaderModel.h"

typedef enum {
    outType,//分享减脂团
    GeneralGroupShareType,//普通团邀请减脂团
    GeneralGroupOutShareType,//普通团分享
    inType,//邀请减脂团
    ActiveShareType,//减脂团活动分享
    GrouptTalkShareType,//减脂团团聊分享
    DiscoverShareType,//撒欢分享
    SquareAndDynamicTalkShareType,//广场/动态 乐活吧分享
    NotifyHTMLShareType//广播活动网页分享
} ShareGameSubClassViewType;

@protocol ShareGameSubClassViewDelegate <NSObject>

@optional

//取消
-(void)cancelButtonSender;

//邀请
-(void)invitationButton;

//举报
- (void)shareGameSubClassViewDelegateReport;

//收藏
- (void)shareGameSubClassViewDelegateCollect;

//删除
- (void)shareGameSubClassViewDelegateDelete;

//置顶
- (void)shareGameSubClassViewDelegateTop;

//取消置顶
- (void)shareGameSubClassViewDelegateCancelTop;


@end

@interface ShareGameSubClassView : UIView

@property(nonatomic,weak)id<ShareGameSubClassViewDelegate> shareGameDelegate;

@property(nonatomic,assign)ShareGameSubClassViewType shareGameSubClassViewType;

@property (nonatomic,strong) GroupTalkModel *groupTalkModel;
@property (nonatomic,strong) DiscoverModel *discoverModel;
@property (nonatomic,strong) GroupHeaderModel *groupModel;

//团聊展示图片
@property (nonatomic,strong) UIImage *image;

+ (ShareGameSubClassView *)initViewWithShareGameSubClassViewType:(ShareGameSubClassViewType)type andModel:(NSObject *)groupTalkModel;

- (CGFloat)createView;
- (void)cancelAnimal;
@end



