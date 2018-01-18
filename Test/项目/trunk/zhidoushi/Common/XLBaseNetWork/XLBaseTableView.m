//
//  XLBaseTableView.m
//  zhidoushi
//
//  Created by xinglei on 14-10-29.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "XLBaseTableView.h"

@interface XLBaseTableView()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,assign)BOOL reloading;
@property(nonatomic,assign)BOOL nomoreData;

@end

@implementation XLBaseTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{

    self = [super initWithFrame:frame style:style];
    if (self) {
        
        
        self.delegate = self;
        self.dataSource = self;
        
        //*监听用户登录状态*//
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isLoginNotification:) name:NOTIFICATION_NAME_LOGIN_STATUS_CHANGE object:nil];
    }
    return self;
}


#pragma mark - UITableView Delegate && UITableView DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
#pragma mark -加载
- (void)loadMoreData
{
    //*实现代理*//
    if (self.baseRefreshDelegate && [self.baseRefreshDelegate respondsToSelector:@selector(pullUp:)]) {
        [self.baseRefreshDelegate pullUp:self];
    }
}

- (void)reloadTableViewDataSource
{
    _reloading = YES;
}

#pragma mark - 刷新事件
- (void)doneLoadingTableViewData
{
    //*实现代理*//
    if (self.baseRefreshDelegate && [self.baseRefreshDelegate respondsToSelector:@selector(pullDown:)]) {
        [self.baseRefreshDelegate pullDown:self];
    }
}

- (void)removeRefreshView
{
    
}

- (void)refreshLastUpdatedDate
{
    
}

#pragma mark EGORefreshTableHeaderDelegate Methods
-(void)tableViewDidScroll:(UIScrollView*)scrollView//EGO自带的上拉加载
 {
     if (scrollView.contentOffset.y+(scrollView.frame.size.height) > scrollView.contentSize.height-64  && !_reloading && !_nomoreData)
     {
         _reloading = YES;
         [self loadMoreData];
     }

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    [_freshView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
//    [_freshView egoRefreshScrollViewDidEndDragging:scrollView];
    
}
//
//- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
//{
//    [self reloadTableViewDataSource];
//    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
//}

//- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
//{
//    return _reloading;
//}
//
//
//- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)vie
//{
//    
//    return [NSDate date]; // should return date data source was last change
//}


@end
