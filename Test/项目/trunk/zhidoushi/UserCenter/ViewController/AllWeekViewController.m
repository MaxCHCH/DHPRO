//
//  AllWeekViewController.m
//  zhidoushi
//
//  Created by nick on 15/11/16.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import "AllWeekViewController.h"
#import "WebViewController.h"
#import "WeekTableViewCell.h"

@interface AllWeekViewController ()
{
    BOOL isMore;
    NSMutableArray *mutableArr;
    NSMutableArray *m_DataArr;
    NSMutableDictionary*mutableDic;
    int timePageNum;//页数加载
    
}
@property(nonatomic,strong)MJRefreshHeaderView *header;//头部刷新
@property(nonatomic,strong)MJRefreshFooterView *footer;//底部刷新
@property(nonatomic,strong)UITableView *table;//表
@end

@implementation AllWeekViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIView *titleViews = [[UIView alloc] init];
    [titleViews addSubview:self.leftButton];
    [titleViews addSubview:self.rightButton];
    self.navigationItem.titleView = titleViews;
    //导航栏标题
    UILabel *title = [[UILabel alloc] init];
    title.text = @"周记";
    title.textColor = ZDS_DHL_TITLE_COLOR;
    //    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    title.font = MyFont(18);
    title.textAlignment = NSTextAlignmentCenter;
    title.frame = CGRectMake(0, 0, 320, 44);
    title.center = titleViews.center;
    [titleViews addSubview:title];
    //导航栏返回
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"fh-36"] forState:UIControlStateNormal];
    self.leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.leftButton.bounds = CGRectMake(0, 0, 18, 18);
    self.leftButton.titleLabel.font = MyFont(13);
    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor =[UIColor whiteColor];
    
    //周记表
    self.table = [[UITableView alloc] init];
    self.table.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    self.table.scrollsToTop = YES;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *foot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
    self.table.tableFooterView = foot;
    self.table.dataSource = self;
    self.table.delegate = self;
    [self.view addSubview:self.table];
    
    __weak typeof(self) weakSlef = self;
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    self.header = header;
    header.scrollView = self.table;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [self loadPhotoDataWithIsMore:NO];
    };
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    self.footer = footer;
    footer.scrollView = self.table;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [self loadPhotoDataWithIsMore:YES];
    };
    [NSUSER_Defaults setObject:@"NO" forKey:@"weekreddian"];
    [self.header beginRefreshing];
}


-(void)loadPhotoDataWithIsMore:(BOOL)more{
    if (more) {
        if ([self mutableArr].count == 0 ||[self mutableArr].count%10!=0||[self mutableArr].count<timePageNum*10) {
            [self showAlertMsg:@"没有更多了" andFrame:CGRectZero];
            [self.footer endRefreshing];
            return;
        }
        
    }
    //构造请求参数
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    if (more) {
        [dictionary setObject:[NSString stringWithFormat:@"%d",timePageNum+1] forKey:@"pageNum"];
    }else{
        [dictionary setObject:[NSString stringWithFormat:@"%d",1] forKey:@"pageNum"];
        
    }
    [dictionary setObject:[NSUSER_Defaults objectForKey:ZDS_USERID] forKey:@"seeuserid"];
    if(more && self.lastId) [dictionary setObject:self.lastId forKey:@"lastid"];
    
    [dictionary setObject:@"10" forKey:@"pageSize"];
    //    if(isMore && self.lastId!=nil)
    //        [dictionary setObject:self.lastId forKey:@"lastid"];
    __weak typeof(self)weakSelf = self;
    
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_WEEKLYLIST parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        //成功
        
        if (!more) {
            [[self mutableArr] removeAllObjects];
            timePageNum = 1;
        }else{
            timePageNum ++;
        }
        [weakSelf reloadDataArr:dic[@"weeklylist"]];
        self.lastId = [dic[@"weeklylist"] lastObject][@"reportid"];
        
        //        if ([dic[@"haswegphotos"] isEqualToString:@"1"])
        
        [self.table reloadData];
        [weakSelf.header endRefreshing];
        [weakSelf.footer endRefreshing];
        
        
    }];
}
-(void)reloadDataArr:(NSArray *)Arr{
    for (int i = 0 ;i<Arr.count;i++){
        [[self mutableArr] addObject:Arr[i]];
    }
    
}
-(NSMutableArray *)mutableArr{
    if (mutableArr == nil) {
        mutableArr = [NSMutableArray array];
    }
    return mutableArr;
}
-(NSMutableArray *)m_DataArr{
    if (m_DataArr == nil){
        m_DataArr = [NSMutableArray array];
        
    }
    return m_DataArr;
}
-(void)popButton{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - tableviewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WebViewController *web = [[WebViewController alloc] init];
    web.URL = [NSString stringWithFormat:@"%@h5/lb/index.html?reportid=%@&appflg=0",ZDS_DEFAULT_HTTP_SERVER_HOST,mutableArr[indexPath.row][@"reportid"]];
    [self.navigationController pushViewController:web animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return mutableArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableSampleIdentifier = @"weekCell";
    
    WeekTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                         TableSampleIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"WeekTableViewCell" owner:self options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *model = mutableArr[indexPath.row];
    [cell.backImage sd_setImageWithURL:[NSURL URLWithString:model[@"imageurl"]]];
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate* inputDate = [inputFormatter dateFromString:model[@"date"]];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    
    [outputFormatter setDateFormat:@"yyyy.MM.dd"];
    
    NSString *str = [outputFormatter stringFromDate:inputDate];
    cell.time.text = str;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 165;
}



@end
