//
//  PlanViewController.m
//  zhidoushi
//
//  Created by xinglei on 14/12/16.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "PlanViewController.h"

#import "WWTolls.h"
#import "JSONKit.h"
#import "PlanModel.h"
#import "NSString+NARSafeString.h"
#import "WWRequestOperationEngine.h"
#import "NSDictionary+NARSafeDictionary.h"
//..刷新..//
#import "Define.h"
#import "MJRefresh.h"
#import "MobClick.h"

@interface PlanViewController ()
{
//    float grpcomplete;//全组目标完成度
//    float mecomplete;//我的目标完成度
//    float completeList;//参与者目标完成度
//    NSString *mec;//我的目标完成状况
    NSString *username;//用户名
    NSMutableArray * modelArray;//保存数据的数组
    NSString *pageSizeNumber;//每页条数
    NSInteger arrayCount;//数组里有多少内容
}
@property(nonatomic,strong)PlanTableViewCell * planCell;
@property(nonatomic,strong)MJRefreshFooterView *footer;//底部刷新
@property(nonatomic,strong)MJRefreshHeaderView *header;//头部刷新
@end

static NSInteger pageNumber;//页数

@implementation PlanViewController
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"团组完成度页面"];
}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"团组完成度页面"];
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"BarBtn_goBack_32_32"] forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = MyFont(13);
    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width = 16;
    labelRect.size.height = 16;
    self.leftButton.frame = labelRect;

    self.titleLabel.text = @"进度";
    self.titleLabel.font = MyFont(18);
    self.titleLabel.textColor = ZDS_DHL_TITLE_COLOR;

}

-(void)popButton{

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {

    [super viewDidLoad];

    modelArray = [[NSMutableArray alloc]init];
    //刷新
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.planTableView; // 或者tableView
    self.header = header;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.planTableView; // 或者tableView
    self.footer = footer;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [self doneLoadingTableViewData:nil];
    };
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [self loadMoreData];
    };

    //..加载数据..//
    pageNumber = 1;
    pageSizeNumber = [NSString stringWithFormat:@"%d",10];
    [self reloadView:pageNumber pageSize:@"10"];

    if ([NSString mySafeString:self.mecompleteString]) {
         NSLog(@"self.mecompleteString***********%@",self.mecompleteString);
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger result;
    if (self.mecompleteString) {
       result = modelArray.count+2;
    }else{
        result = modelArray.count+1;
    }
    return  result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"cellPlan";

    self.planCell = [tableView dequeueReusableCellWithIdentifier:
                     CellIdentifier];

    if (!self.planCell) {
        self.planCell = [[[NSBundle mainBundle]loadNibNamed:@"PlanTableViewCell" owner:self options:nil]lastObject];
        self.planCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    if(indexPath.row==0){

        [self.planCell initCell:[WWTolls colorWithHexString:@"#565bd9"]];
        self.planCell.progressBar.progress = self.grpcompleteString.floatValue/100;
        if (self.grpcompleteString.floatValue==0) {

            self.planCell.stageLabel.text = @"0%";
        }else{

            self.planCell.stageLabel.text = [NSString stringWithFormat:@"%.0f%%",self.grpcompleteString.floatValue];
        }
        NSLog(@"************%f",self.grpcompleteString.floatValue/100);

    }

    if (indexPath.row>0) {

        if (self.mecompleteString)
        {
            if (indexPath.row==1){

                [self.planCell initCell:[WWTolls colorWithHexString:@"#ee3977"]];
                self.planCell.goalLabel.text = @"我";
                if (self.mecompleteString.floatValue==0) {
                    self.planCell.stageLabel.text = @"0%";
                }else{
                    self.planCell.stageLabel.text = [NSString stringWithFormat:@"%.0f%%",self.mecompleteString.floatValue];
                }
                self.planCell.progressBar.progress = self.mecompleteString.floatValue/100;
                NSLog(@"floatValue************%f",self.mecompleteString.floatValue/100);
            }
            if (indexPath.row>1) {

                [self.planCell initCell:[WWTolls colorWithHexString:@"#36bef8"]];
                if (modelArray.count>0) {
                    self.planCell.planModel = [modelArray objectAtIndex:indexPath.row-2];
                }
            }
        }
        else{
            if (modelArray.count>0) {
                [self.planCell initCell:[WWTolls colorWithHexString:@"#36bef8"]];
                self.planCell.planModel = [modelArray objectAtIndex:indexPath.row-1];
            }
                }
        }

    return self.planCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void)reloadView:(NSInteger)page pageSize:(NSString*)pSize{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:2];
    [dictionary setObject:self.gameid forKey:@"gameid"];
    [dictionary setObject:[NSString stringWithFormat:@"%ld",page] forKey:@"pageNum"];
    [dictionary setObject:pSize forKey:@"pageSize"];
    NSLog(@"——————————————%@",dictionary);
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_COMPLETE parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (!dic[ERRCODE]) {
            if (pageNumber == 1) {
                //..刷新时清除cell保存数据..//
                if (modelArray.count!=0) {
                    //..首先移除数组中数据..//
                    [modelArray removeAllObjects];
                    
                }
            }
            weakSelf.grpcompleteString = dic[@"grpcomplete"];
            NSArray * completeListArray = [dic objectForKey:@"completeList"];
//            NSString *grp = [dic objectForKey:@"grpcomplete"];//全组目标完成度(固定一个)
            if ([dic objectForKeySafe:@"mecomplete"]) {
                weakSelf.mecompleteString = [dic objectForKey:@"mecomplete"];//我的目标完成度(固定一个)
                NSLog(@"self.mecompleteString*****%@",weakSelf.mecompleteString);
            }else{
                 weakSelf.mecompleteString =nil;//我的目标完成度(固定一个)
            }
//            grpcomplete = grp.floatValue;
//            mecomplete = mec.floatValue;

            for (int i = 0; i<completeListArray.count; i++) {
                NSDictionary *completeListDictionary = [completeListArray objectAtIndex:i];
                NSDictionary *userinfoDictionary = [completeListDictionary objectForKey:@"userinfo"];
                PlanModel * planModel = [[PlanModel alloc]init];
                planModel.username = [userinfoDictionary objectForKey:@"username"];//名字
                NSString * completeString = [completeListDictionary objectForKey:@"complete"];
                planModel.complete = completeString.floatValue;
                [modelArray addObject:planModel];
            }

            NSLog(@"1111111111%@,%@",dic,[dic objectForKey:@"errinfo"]);
             NSLog(@"modelArray*******%@",modelArray);
            arrayCount = modelArray.count;
//            if (completeListArray.count>0) {
                [weakSelf.planTableView reloadData];
//            }
            
        }
        [weakSelf.footer endRefreshing];
        [weakSelf.header endRefreshing];
    }];
}

#pragma mark --加载
- (void)loadMoreData{

    if (arrayCount%10==0&&arrayCount>=pageNumber*10) {
        pageNumber++;
        [self reloadView:pageNumber pageSize:@"10"];
    }else{
        [self showAlertMsg:@"没有更多了" yOffset:0];
        [self.footer endRefreshing];
    }
}

#pragma mark --刷新
- (void)doneLoadingTableViewData:(UITableView*)myTableView{
    NSLog(@"******我刷新了******");
    pageNumber = 1;
    
    [self reloadView:pageNumber pageSize:@"10"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)dealloc{
    [self.header free];
    [self.footer free];
}
@end
