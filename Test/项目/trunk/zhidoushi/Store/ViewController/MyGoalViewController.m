//
//  MyGoalViewController.m
//  zhidoushi
//
//  Created by xinglei on 15/1/10.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "MyGoalViewController.h"

#import "Define.h"
#import "GoalIntroduceViewController.h"
//..gateGory..//
#import "NSArray+NARSafeArray.h"
#import "NSString+NARSafeString.h"
#import "NSDictionary+NARSafeDictionary.h"
//..netWork../
#import "JSONKit.h"
#import "WWRequestOperationEngine.h"
#import "WWTolls.h"
#import "MJRefresh.h"
#import "MobClick.h"

@interface MyGoalViewController ()
{
    NSString *pageSizeNumber;//每页条数
    NSInteger arrayCount;//数组里有多少内容
    NSMutableArray *modelArray;//存放model的数组

}
@property(weak,nonatomic) MJRefreshFooterView* footer;
@property(weak,nonatomic) MJRefreshHeaderView* header;
@end

static NSInteger pageNumber;//页数

@implementation MyGoalViewController
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"我的积分页面"];
}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"我的积分页面"];
    self.titleLabel.text = [NSString stringWithFormat:@"我的斗币"];
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
    modelArray = [[NSMutableArray array]init];
    CGRect myrect  =  self.MyGoalTableView.frame;
    myrect.size.height = SCREEN_HEIGHT - 240;
    self.MyGoalTableView.frame = myrect;
#pragma mark -- 刷新模块
    //刷新
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.MyGoalTableView; // 或者tableView
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.MyGoalTableView; // 或者tableView
    
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

#pragma mark - 积分说明
- (IBAction)goalIntroduceButton:(id)sender {

    GoalIntroduceViewController * goalIntroduce = [[GoalIntroduceViewController alloc]initWithNibName:@"GoalIntroduceViewController" bundle:nil];
    [self.navigationController pushViewController:goalIntroduce animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString * const identifier = @"myreplyCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.textLabel.font = MyFont(16);
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.font = MyFont(12);
        cell.detailTextLabel.textColor = [WWTolls colorWithHexString:@"#959595"];
    }
    NSDictionary * modelDictionary = [modelArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[modelDictionary objectForKey:@"getway"]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[modelDictionary objectForKey:@"createtime"]];
    
    UILabel* CountdownLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-72, 15, 70, 20)];
    CountdownLabel.textColor = [WWTolls colorWithHexString:@"#ea5b57"];
    cell.accessoryView = CountdownLabel;
    CountdownLabel.font = [UIFont systemFontOfSize:16];
    CountdownLabel.numberOfLines = 0;
    CountdownLabel.textAlignment = NSTextAlignmentCenter;
    CountdownLabel.text = [NSString stringWithFormat:@"%@",[modelDictionary objectForKey:@"score"]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark - 获取积分明细
-(void)uploadData:(NSInteger)page pageSizeFor:(NSString*)pageSize{

    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:3];
    [dictionary setObject:[NSString stringWithFormat:@"%ld",(long)page]forKey:@"pageNum"];
    [dictionary setObject:pageSize forKey:@"pageSize"];


    WEAKSELF_SS
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_GETMYSCORE parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {

        if (dic[ERRCODE]) {
            NSLog(@"获取积分明细");
        }else{
            if (pageNumber == 1) {
                modelArray = [NSMutableArray array];
            }
            NSArray *replayListArray = [dic objectForKey:@"myscorelist"];
            NSString *score = [dic objectForKey:@"mytotalscore"];
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.myscore.text = score;
            });
            for (int i=0; i<replayListArray.count; i++) {

                NSDictionary *myReplyDictionary = [replayListArray objectAtIndex:i];

                [modelArray addObject:myReplyDictionary];

            }
            [weakSelf.MyGoalTableView reloadData];
            
            NSLog(@"获取积分明细数据%@",dic);
        }
    }];
    
}

#pragma mark -加载
- (void)loadMoreData
{
    if (modelArray.count%10!=0) {
        return;
    }
    pageNumber = pageNumber+1;
    NSLog(@"加载的序列号*******%ld",(long)pageNumber);
    [self uploadData:pageNumber pageSizeFor:pageSizeNumber];
}

#pragma mark - 刷新事件
- (void)doneLoadingTableViewData:(UITableView*)myTableView
{
    [self uploadData:1 pageSizeFor:@"10"];
}
-(void)dealloc{
//    [_header free];
//    [_footer free];
}
@end
