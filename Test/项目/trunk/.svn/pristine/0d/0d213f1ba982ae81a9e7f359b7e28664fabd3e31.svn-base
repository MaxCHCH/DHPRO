//
//  MyAttentionTableView.m
//  zhidoushi
//
//  Created by xinglei on 15/1/5.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "MyAttentionTableView.h"
#import "MeViewController.h"
#import "MyAttentionModel.h"
#import "NSString+NARSafeString.h"
#import "JSONKit.h"
#import "WWRequestOperationEngine.h"
#import "UIView+ViewController.h"
#import "MyFriendViewController.h"
#import "CoachModel.h"
//..刷新..//
#import "Define.h"
#import "MJRefresh.h"

@interface MyAttentionTableView ()
{
    MyAttentionTableViewCell*coachCell;
    NSString *indexString;
}

@property(nonatomic,strong)NSMutableSet * indexCellSet;//cell的状态集合
@property(weak,nonatomic) MJRefreshHeaderView* header;
@property(weak,nonatomic) MJRefreshFooterView* footer;

@property (nonatomic,strong) NSString *switchDirection;



@end

@implementation MyAttentionTableView
{
    CGPoint _startPoint;
}

-(void)initMyTableView:(NSString*)mytype myurl:(NSString*)my_url
{
    _cacheArray = [[NSMutableArray alloc]init];
    _dataArray = [[NSMutableArray alloc]init];
    _indexCellSet = [[NSMutableSet alloc]init];
    
    self.attentionType = mytype;
    self.attentionURL = my_url;
    self.dataSource = self;
    self.delegate = self;
    if (self.header == nil) {
        //..加载数据..//
        //刷新
        MJRefreshHeaderView *header = [MJRefreshHeaderView header];
        header.scrollView = self; // 或者tableView
        self.header = header;
        MJRefreshFooterView *footer = [MJRefreshFooterView footer];
        footer.scrollView = self; // 或者tableView
        self.footer = footer;
        header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
            [self doneLoadingTableViewData:nil];
        };
        footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
            [self loadMoreData:nil];
        };
    }
    _cacheArray = _dataArray;
    
    
    //    kenshin
    //    添加左滑动手势
    UISwipeGestureRecognizer *leftSwipGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swip:)];
    leftSwipGR.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:leftSwipGR];
    //
    ////    添加右滑动手势
    UISwipeGestureRecognizer *rightSwipGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swip:)];
    rightSwipGR.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:rightSwipGR];
    
    
    //    替换成pan手势测试
    //    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    //    [self addGestureRecognizer:panGR];
    
}

//pan手势方法
//-(void)pan:(UIPanGestureRecognizer *)panGR
//{
//    NSLog(@"Pan GR");
//    if (panGR.state == UIGestureRecognizerStateBegan)
//    {
//        NSLog(@"began");
//        _startPoint = [panGR locationInView:self];
//
//
//    }
//    else if (panGR.state == UIGestureRecognizerStateChanged)
//    {
//        NSLog(@"changed");
//        CGPoint changedPoint = [panGR locationInView:self];
//        CGFloat distance = changedPoint.x - _startPoint.x;
//        NSLog(@"移动距离%f ",distance);
//        if (distance < 0)
//        {
//            NSLog(@"右移");
//
//
//        }
//        else if (distance > 0)
//        {
//            NSLog(@"左移");
//        }
//
//        NSNumber *disNum = [NSNumber numberWithFloat:distance];
//        NSArray *arr = [NSArray arrayWithObjects:disNum,self.attentionType, nil];
//
////        代理方法
//        if ([self.attentionSwipDelegate respondsToSelector:@selector(switchView:)])
//        {
//            [self.attentionSwipDelegate performSelector:@selector(switchView:) withObject:arr];
//        }
//
//        NSLog(@"self.attentionType %@",self.attentionType);
//
//    }
//    else if (panGR.state == UIGestureRecognizerStateEnded)
//    {
//        NSLog(@"end");
//    }
//
//}

//替换成pan手势
-(void)swip:(UISwipeGestureRecognizer *)swipGR
{
    NSLog(@"SWIP");
    
    NSLog(@"%f ",[swipGR locationInView:self].x);
    //    识别左划
    if (swipGR.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        NSLog(@"Left swip");
        _switchDirection = @"Left";
        CGPoint startLocation ;
        if (swipGR.state == UIGestureRecognizerStateBegan)
        {
            NSLog(@"begin");
            startLocation = [swipGR locationInView:self];
        }
        else if (swipGR.state == UIGestureRecognizerStateChanged)
        {
            NSLog(@"change");
            CGPoint stopLocation = [swipGR locationInView:self];
            
            CGFloat dx = stopLocation.x - startLocation.x;
            
            NSLog(@"Distance: %f", dx);
        }
        else if (swipGR.state == UIGestureRecognizerStateEnded)
        {
            NSLog(@"end");
            CGPoint endLocation = [swipGR locationInView:self];
            CGFloat dx = endLocation.x - startLocation.x;
            NSLog(@"end dis %f",dx);
        }
        else if (swipGR.state == UIGestureRecognizerStateCancelled)
        {
            NSLog(@"cancel");
            
        }
        else if (swipGR.state == UIGestureRecognizerStateFailed)
        {
            NSLog(@"fail");
            
        }
        
    }
    else if (swipGR.direction == UISwipeGestureRecognizerDirectionRight)
    {
        _switchDirection = @"Right";
        NSLog(@"Right Swip");
        
    }
    
    if ([self.attentionSwipDelegate respondsToSelector:@selector(switchView:)])
    {
        
        [self.attentionSwipDelegate performSelector:@selector(switchView:) withObject:self.switchDirection];
    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *userId = ((CoachModel*)self.dataArray[indexPath.row]).userid;
    if ([userId isEqualToString:[NSUSER_Defaults valueForKey:ZDS_USERID]]) {
        self.viewController.tabBarController.selectedIndex = 3;
    }else{
        MeViewController *user = [[MeViewController alloc] init];
        user.userID = userId;
        user.otherOrMe = 1;
        [self.viewController.navigationController pushViewController:user animated:YES];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cacheArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const identifier = @"attentionCell";
    
    coachCell = (MyAttentionTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!coachCell) {
        coachCell = [[[NSBundle mainBundle]loadNibNamed:@"MyAttentionTableViewCell" owner:self options:nil]lastObject];
        coachCell.atttionDelegate = self;
        coachCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (_cacheArray.count>0) {
        
        [MyAttentionModel initWithCoachCell:coachCell index:indexPath.row dataArray:_cacheArray judgeIndexArray:self.indexCellSet];
        
    }
    return coachCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

#pragma 代理关注事件
-(void)rcvuseridValue:(NSString *)rcvuserValue flwstatus:(NSString *)flw cellIndexString:(NSString *)string
{
    self.rcvuserid = rcvuserValue;
    self.flwstatus = flw;
    indexString = string;
    [self.indexCellSet addObject:string];
    _cacheArray =  [MyAttentionModel changesThisCoachModel:_cacheArray andIndex:string.integerValue adnSet:self.indexCellSet andFlwstatus:flw];
}

-(void)clickAttentionButton{
    NSLog(@"点击了关注");
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:2];
    [dictionary setObject:self.rcvuserid forKey:@"rcvuserid"];
    [dictionary setObject:self.flwstatus forKey:@"flwstatus"];
    NSLog(@"——————————————%@",dictionary);
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_INERACTUPFLWSTS parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {

        if (!dic[ERRCODE]) {
            [((MyFriendViewController*)self.attentionTableViewDelegate) reloadViewData];
            NSLog(@"------------------%@",dic);
        }
    }];
}

-(void)setMyCacheArray
{
    
    
}

#pragma mark --加载
- (void)loadMoreData:(UITableView*)myTableView{
    if ([self.attentionTableViewDelegate respondsToSelector:@selector(uploadMyData)]) {
        [self.attentionTableViewDelegate uploadMyData];
    }
    NSLog(@"*******我加载了*********");
    
}

#pragma mark --刷新
- (void)doneLoadingTableViewData:(UITableView*)myTableView{
    if ([self.attentionTableViewDelegate respondsToSelector:@selector(refreshMyData)]) {
        [self.attentionTableViewDelegate refreshMyData];
        //..刷新时清除cell保存数据..//
        if (self.indexCellSet.count>0) {
            [self.indexCellSet removeAllObjects];
        }
    }
}

-(void)endRefresh{
    [self.header endRefreshing];
    [self.footer endRefreshing];
}
-(void)dealloc{
    [_header free];
    [_footer free];
}
@end
