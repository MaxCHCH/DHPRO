//
//  MyAttentionTableView.h
//  zhidoushi
//
//  Created by xinglei on 15/1/5.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MyAttentionTableViewCell.h"

@protocol MyAttentionTableViewDelegate <NSObject>

@optional
-(void)refreshMyData;
-(void)uploadMyData;
@end

@protocol MyattentionSwipDelegate <NSObject>

-(void)switchView:(NSString *)direction;

@end

@interface MyAttentionTableView : UITableView <attentionTabeleDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray * cacheArray;
@property(nonatomic,strong)NSString * rcvuserid;//接收者ID
@property(nonatomic,strong)NSString * flwstatus;//关注状态
@property(nonatomic,strong)NSMutableArray * indexCellArray;//cell的状态集合

@property(nonatomic,strong)NSString * attentionURL;
@property(nonatomic,strong)NSString * attentionType;
@property(nonatomic,weak) id <MyAttentionTableViewDelegate>  attentionTableViewDelegate;


-(void)initMyTableView:(NSString*)mytype myurl:(NSString*)my_url;
-(void)endRefresh;
@property(nonatomic,weak) id<MyattentionSwipDelegate> attentionSwipDelegate;

@end
