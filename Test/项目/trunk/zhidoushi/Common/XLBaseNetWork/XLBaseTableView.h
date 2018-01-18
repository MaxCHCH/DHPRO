//
//  XLBaseTableView.h
//  zhidoushi
//
//  Created by xinglei on 14-10-29.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XLBaseTableView;

//*根代理方法*//
@protocol XLBaseTableViewDelegate <NSObject>

@optional

@end
//*滑动代理*//
@protocol XLBaseTableViewScrollDelegate <NSObject>

@optional

@end
//*刷新系列代理*//
@protocol XLBaseTableViewRefreshDelegate <NSObject>

@optional
//*上拉*//
-(void)pullUp:(XLBaseTableView*)tableView;
//*下拉*//
-(void)pullDown:(XLBaseTableView*)tableView;

@end

@interface XLBaseTableView : UITableView

@property(nonatomic,weak) id <XLBaseTableViewDelegate> baseDelegate;
@property(nonatomic,weak)id <XLBaseTableViewRefreshDelegate> baseRefreshDelegate;

@end
