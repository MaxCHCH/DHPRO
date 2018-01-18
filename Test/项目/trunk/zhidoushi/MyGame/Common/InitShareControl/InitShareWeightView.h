//
//  InitShareWeightView.h
//  zhidoushi
//
//  Created by xinglei on 14/12/9.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "postWeightView.h"

typedef enum
{
    myWeightType = 43,
    otherWeightType = 44
}InitShareType;

@protocol InitShareDelegate <NSObject>

@optional

-(void)confirmShare;

@end

@interface InitShareWeightView : UIView<postWeightViewDelegate>

@property(nonatomic,strong)UIView *shareView;
@property (nonatomic,strong) postWeightView *weightView;
@property(nonatomic,strong)NSString * parterid;
@property(nonatomic,strong)NSString * gameModel;

@property(nonatomic,weak) id<InitShareDelegate> initShareDelegate;

@property(nonatomic,assign)InitShareType initShareType;

@property(nonatomic,assign) int weightHeight;

@property(nonatomic,assign) CGFloat scroY;


-(void)createView;
-(void)cancelAction;

@end
