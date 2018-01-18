//
//  DiscoverListTableViewCell.h
//  zhidoushi
//
//  Created by nick on 15/4/20.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscoverModel.h"
#import "XimageView.h"
@class DiscoverListTableViewCell;

@protocol discoverReportDelegate<NSObject>

@optional

-(void)reportClick:(NSString*)discoverId;
-(void)discoverCell:(DiscoverListTableViewCell *)discoverCell reportClick:(NSString*)discoverId;

@end

@protocol DiscoverListTableViewCellDelegate <NSObject>

- (void)discoverListCell:(DiscoverListTableViewCell *)discoverListCell tagLabelActionWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface DiscoverListTableViewCell : UITableViewCell

@property(nonatomic,strong)NSIndexPath *indexPath;

@property (weak, nonatomic) IBOutlet XimageView *photoImage;//配图

@property(nonatomic,strong)DiscoverModel *model;//晒图模型

@property(nonatomic,weak)id<discoverReportDelegate> delegate;//举报代理

@property(nonatomic,weak)id <DiscoverListTableViewCellDelegate> cellDelegate;//本类cell代理

@end
