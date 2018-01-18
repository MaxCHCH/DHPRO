//
//  ExchangeRecordViewController.m
//  zhidoushi
//
//  Created by xinglei on 15/1/10.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "ExchangeRecordViewController.h"

#import "Define.h"
//..gateGory..//
#import "ExchangeRecordModel.h"
#import "NSArray+NARSafeArray.h"
#import "NSString+NARSafeString.h"
#import "NSDictionary+NARSafeDictionary.h"
//..netWork../
#import "JSONKit.h"
#import "WWRequestOperationEngine.h"
#import "WWTolls.h"
#import "StoreModel.h"
#import "StoreDetailViewController.h"
#import "MJRefresh.h"
#import "MobClick.h"

@interface ExchangeRecordViewController ()
{
    NSString *pageSizeNumber;//每页条数
    NSInteger arrayCount;//数组里有多少内容
    NSMutableArray *modelArray;//存放model的数组
}
@property(nonatomic,strong)ExchangeRecordTableViewCell * exchangeCell;
@property (weak, nonatomic) IBOutlet UILabel *noSource;
@property(weak,nonatomic) MJRefreshFooterView* footer;
@property(weak,nonatomic) MJRefreshHeaderView* header;
@end

static     NSInteger pageNumber;//页数

@implementation ExchangeRecordViewController
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"兑奖记录页面"];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"兑换记录页面"];
    self.titleLabel.text = [NSString stringWithFormat:@"兑换记录"];
    self.titleLabel.textColor = ZDS_DHL_TITLE_COLOR;
    self.titleLabel.font = MyFont(18);
    
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"BarBtn_goBack_32_32"] forState:UIControlStateNormal];
    //    [self.leftButton setTitle:@"返回" forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = MyFont(11);
    [self.leftButton addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width = 16;
    labelRect.size.height = 16;
    labelRect.origin.x = 0;
    self.leftButton.frame = labelRect;
}

-(void)backTo{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.exchangeRecordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
#pragma mark -- 刷新模块
    //刷新
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.exchangeRecordTableView; // 或者tableView
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.exchangeRecordTableView; // 或者tableView
    
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [self uploadData:1 pageSizeFor:@"10"];
        [refreshView endRefreshing];
    };
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [self loadMoreData];
        [refreshView endRefreshing];
    };
    
    pageNumber = 1;
    pageSizeNumber = [NSString stringWithFormat:@"%d",10];
    [self uploadData:pageNumber pageSizeFor:pageSizeNumber];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const identifier = @"exchangeCell";
    
    _exchangeCell = (ExchangeRecordTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!_exchangeCell) {
        _exchangeCell = [[[NSBundle mainBundle]loadNibNamed:@"ExchangeRecordTableViewCell" owner:self options:nil]lastObject];
    }
    
    [_exchangeCell initMyCellWithModel:[modelArray objectAtIndex:indexPath.row]];
    return _exchangeCell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //跳转到游戏详情页
    ExchangeRecordModel * storeModel;
    storeModel = [modelArray objectAtIndex:indexPath.row];
    StoreDetailViewController *storeDetail = [[StoreDetailViewController alloc]initWithNibName:@"StoreDetailViewController" bundle:nil];
    storeDetail.goodsid = storeModel.goodId;
    storeDetail.isJiLu = YES;
    [self.navigationController pushViewController:storeDetail animated:YES];
    
}

#pragma mark --加载
- (void)loadMoreData{
    NSLog(@"*******我加载了*********");
    if (arrayCount%10==0&&arrayCount>=pageNumber*10) {
        pageNumber++;
        NSLog(@"加载的序列号*******%ld",(long)pageNumber);
        [self uploadData:pageNumber pageSizeFor:pageSizeNumber];
    }
}

#pragma mark --刷新
- (void)doneLoadingTableViewData:(UITableView*)myTableView{
    NSLog(@"******我刷新了******");
    pageNumber = 1;
    
    [self uploadData:1 pageSizeFor:@"10"];
    
}


#pragma mark - 获取兑奖记录
-(void)uploadData:(NSInteger)page pageSizeFor:(NSString*)pageSize{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:3];

    [dictionary setObject:[NSString stringWithFormat:@"%ld",(long)page]forKey:@"pageNum"];
    [dictionary setObject:pageSize forKey:@"pageSize"];
    if(self.lastId!=nil) [dictionary setObject:self.lastId forKey:@"lastid"];
    
    WEAKSELF_SS
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_GETRECORDS parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (!dic[ERRCODE]) {
            weakSelf.maskLabel.hidden = NO;
        }else{
            
            NSArray *replayListArray = [dic objectForKey:@"orderlist"];
            if (page == 1) {
                [modelArray removeAllObjects];
            }
            if(modelArray == nil){
                modelArray = [NSMutableArray array];
            }
            for (int i=0; i<replayListArray.count; i++) {
                
                ExchangeRecordModel *myReplyModel = [[ExchangeRecordModel alloc]init];
                
                NSDictionary *myReplyDictionary = [replayListArray objectAtIndex:i];
                
                myReplyModel.goodId = [myReplyDictionary objectForKey:@"goodsid"];
                myReplyModel.orderid = [myReplyDictionary objectForKey:@"orderid"];
                myReplyModel.endtime = [myReplyDictionary objectForKey:@"endtime"];
                myReplyModel.isExpire = [myReplyDictionary objectForKeySafe:@"isExpire"];
                myReplyModel.gsname = [myReplyDictionary objectForKey:@"bizScoreGoodsModel"][@"gsname"];
                myReplyModel.exchscore = [myReplyDictionary objectForKey:@"bizScoreGoodsModel"][@"exchscore"];
                myReplyModel.imageurl = [myReplyDictionary objectForKey:@"bizScoreGoodsModel"][@"imageurl3"];
                myReplyModel.ticket =  [myReplyDictionary objectForKey:@"bizScoreGoodsdetailModel"][@"ticket"];
                weakSelf.lastId = myReplyModel.orderid;
                [modelArray addObjectSafe:myReplyModel];
                
            }
            NSLog(@"modelArray*******%@",modelArray);
            arrayCount = modelArray.count;
            if (arrayCount==0) {
                weakSelf.maskLabel.hidden = NO;
            }else{
                weakSelf.maskLabel.hidden = YES;
                [weakSelf.exchangeRecordTableView reloadData];
            }
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
//    [_header free];
//    [_footer free];
}

@end
