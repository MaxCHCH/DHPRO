//
//  NARShareView.h
//  zhidoushi
//
//  Created by xinglei on 14/12/16.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareGameSubClassView.h"
#import "GroupHeaderModel.h"

@protocol NARShareViewDelegate <NSObject>

@optional

//邀请
-(void)clickInvitationButton;

//举报
- (void)shareViewDelegateReport;

//删除
- (void)shareViewDelegateDelete;

//收藏
- (void)shareViewDelegateCollect;

//置顶
- (void)shareViewDelegateSetTop;

//取消置顶
- (void)shareViewDelegateCancelTop;

@end

@interface NARShareView : UIView<ShareGameSubClassViewDelegate>

@property(nonatomic,strong)NSString * parterid;

@property(nonatomic,weak)id<NARShareViewDelegate> narDelegate;

//分享图片
- (void)setShareImage:(UIImage *)image;

-(void)createView:(ShareGameSubClassViewType)my_Type withModel:(NSObject *)model withGroupModel:(GroupHeaderModel *)groupModel;

-(void)cancelAction;

@end
