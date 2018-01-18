//
//  InitShareView.h
//  zhidoushi
//
//  Created by xinglei on 14-10-8.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InitShareButton.h"

typedef enum
{
    shareInType = 10,
    shareOutType
}InitShareViewType;

@protocol InitShareViewDelegate <NSObject>

@optional

-(void)initShareViewconfirmShare;

@end

@interface InitShareView : UIView

@property(nonatomic,strong)UIView *maskView;
@property(nonatomic,strong)UIView *shareView;
@property(nonatomic,assign)shareViewType  shareType;
@property(nonatomic,strong)NSString * parterid;
@property(nonatomic,strong)NSString * phgoalweg;
@property(nonatomic,weak)id<InitShareViewDelegate> initShareView;
@property(nonatomic,assign) InitShareViewType shareMyType;
-(void)createView:(shareViewType)type;

@end
