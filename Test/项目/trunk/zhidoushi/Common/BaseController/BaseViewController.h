//
//  BaseViewController.h
//  zhidoushi
//
//  Created by xinglei on 14-9-10.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPRequestOperation.h"

@interface BaseViewController : UIViewController
@property(nonatomic,copy)NSString *lastId;//最后一条id
@property(nonatomic,strong)AFHTTPRequestOperation *httpOpt;//网络请求操作
//@property(nonatomic, strong)UIView *navView;
@property(nonatomic, strong)UIButton *leftButton;
@property(nonatomic, strong)UIButton *rightButton;
//@property(nonatomic, strong)UILabel *leftLabel;

@property(nonatomic, strong)UILabel *titleLabel;
//@property(nonatomic, strong)UITableView *baseTableView;
//
//@property(nonatomic, assign)BOOL isreloading;
//@property(nonatomic, strong)UIActivityIndicatorView *indicatorView;
//@property(nonatomic, strong)UIButton *addMoreBtn;
//
//@property(nonatomic,strong)UIButton *pushNextButton;

//@property(nonatomic ,strong)UIView *indicatorBackView;
//@property(nonatomic, strong)UIAlertView *baseAlertView;
//@property(nonatomic, strong)UISearchBar *searchBar;
//@property(nonatomic, strong)UISearchDisplayController * searchDispalyController;
//@property(nonatomic,strong)UIButton *findBtn;

//@property(nonatomic,assign)BOOL reloading;
//@property(nonatomic,assign)BOOL nomoreData;
//@property(nonatomic, strong)EGORefreshTableHeaderView *freshHeaderView;
//@property(nonatomic,strong)EGORefreshTableFooterView * freshFooterView;
//刷新
//- (void)loadMoreData:(UITableView*)myTableView;
////加载
//- (void)doneLoadingTableViewData:(UITableView*)myTableView;
////加载刷新模块
//-(void)initFreshView:(UIScrollView*)myScroll;
////赋予footer位置
//-(void)initFooterViewFrame:(CGRect)myRect;
////赋予header位置
//-(void)initHeaderViewFrame:(CGRect)myRect;
/**
 * 导航栏左 返回按钮事件
 */
-(UIButton *)leftButonWithImagename:(NSString *)name action:(SEL)selctor;
/**
 * 导航栏右 返回按钮事件
 */
-(UIButton *)rightButonWithTitle:(NSString *)title action:(SEL)selctor;
@end
