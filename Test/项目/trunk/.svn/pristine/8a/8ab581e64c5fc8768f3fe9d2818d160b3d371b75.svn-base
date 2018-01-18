//
//  MyAttentionTableViewCell.h
//  zhidoushi
//
//  Created by xinglei on 15/1/5.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol attentionTabeleDelegate <NSObject>

@optional

-(void)clickAttentionButton;
-(void)rcvuseridValue:(NSString*)rcvuserValue flwstatus:(NSString*)flw cellIndexString:(NSString*)string;
@end

@interface MyAttentionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *sexIcon;

@property (weak, nonatomic) IBOutlet UILabel *moreLabel;//简介
@property (weak, nonatomic) IBOutlet UILabel *descripeLabel;//名称
@property (weak, nonatomic) IBOutlet UIImageView *headImage;//头像
@property (weak, nonatomic) IBOutlet UIButton *attentionButton_1;//关注按钮
@property(nonatomic,assign)NSInteger  cellIndex;
@property(nonatomic,strong)NSString * rcvuserid;//接收者ID
@property(nonatomic,strong)NSString * flwstatus;//关注状态

@property(nonatomic,weak) id <attentionTabeleDelegate> atttionDelegate;

-(void)initWithCellAtIndex:(NSMutableSet*)indexArray;

@end
