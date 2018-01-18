//
//  SearchUserViewController.m
//  zhidoushi
//
//  Created by nick on 15/4/23.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "SearchUserViewController.h"
#import "UserListTableViewCell.h"
#import "MeViewController.h"
#import "intrestUserModel.h"

@interface SearchUserViewController (){
    NSString *criteriaValue;//查询条件
    NSMutableArray *starArray;//查询结果
    NSString *pagenum;//当前页数

}
@property(nonatomic,weak)MJRefreshFooterView *footer;//下拉刷新
@end

@implementation SearchUserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.searchBar removeFromSuperview];
    [MobClick endLogPageView:@"搜索人页面"];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"搜索人页面"];
    self.searchBar.hidden = NO;
//    self.findBtn.hidden = YES;
    self.searchBar.tintColor = [UIColor blueColor];
    
    [self.rightButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:ZDS_DHL_TITLE_COLOR forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = MyFont(16);
    [self.rightButton addTarget:self action:@selector(backToLast) forControlEvents:UIControlEventTouchUpInside];
    self.rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    CGRect labelRectRight = self.rightButton.frame;
    labelRectRight.size.width = 60;
    labelRectRight.size.height = 16;
    self.rightButton.frame = labelRectRight;
    
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-65, 30)];
    _searchBar.placeholder = @"输入昵称或用户ID";
    _searchBar.barStyle = UIBarStyleDefault;
    _searchBar.barTintColor = [UIColor whiteColor];
    _searchBar.layer.cornerRadius = 2.5;
    _searchBar.clipsToBounds = YES;
    UIView *searchTextField = [[[_searchBar.subviews firstObject] subviews] lastObject];
    searchTextField.backgroundColor = RGBCOLOR(239, 239, 239);
    _searchBar.delegate = self;
    self.searchDispalyController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _searchDispalyController.delegate = self;
    [self.navigationController.navigationBar addSubview:self.searchBar];
    [self.searchBar becomeFirstResponder];
    self.navigationController.tabBarController.tabBar.hidden = YES;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    pagenum = @"1";
    
    starArray = [[NSMutableArray alloc]initWithCapacity:5];
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-15)];
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    MJRefreshFooterView *footer = [[MJRefreshFooterView alloc] init];
    footer.scrollView = self.table;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *view){
        [self reloadDataSearch:criteriaValue andPageNum:pagenum andPageSize:@"10"];
    };
    self.footer = footer;
    _table.delegate = self;
    _table.dataSource = self;
    [_table setAllowsSelection:YES];
    [self.view addSubview:self.table];
    [self.searchBar becomeFirstResponder];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y>1) {
        [self.searchBar resignFirstResponder];
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    intrestUserModel *model = [starArray objectAtIndex:indexPath.row];
    MeViewController *me = [[MeViewController alloc] init];
    me.otherOrMe = 1;
    me.userID = model.userid;
    [self.navigationController pushViewController:me animated:YES];
}

-(void)backToLast{
    self.searchBar.hidden = YES;
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return starArray.count > 0 ? starArray.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableSampleIdentifier = @"searchermancell";
    
    UserListTableViewCell *searchCell = [tableView dequeueReusableCellWithIdentifier:
                                             TableSampleIdentifier];
    if (searchCell == nil) {
        searchCell = [[[NSBundle mainBundle]loadNibNamed:@"UserListTableViewCell" owner:self options:nil]lastObject];
        searchCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSUInteger row = [indexPath row];
    searchCell.model = [starArray objectAtIndex:row];
    return searchCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90;
}

#pragma mark -searchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
{
    
    NSString *inputStr = searchText;
    if ([inputStr length] > 10)
    {
        [self.searchDisplayController.searchBar setText:[inputStr substringToIndex:10]];
        criteriaValue = [inputStr substringToIndex:10];
    }
    else criteriaValue = searchText;
    
}

#pragma mark - 点击搜索按钮
-(void)searchButtonClick{
    [self.searchBar resignFirstResponder];
    pagenum = @"1";
    [self reloadDataSearch:criteriaValue andPageNum:@"1" andPageSize:@"10"];
}
#pragma mark - 点击键盘上搜索按钮
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    [self searchButtonClick];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [self.searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)reloadDataSearch:(NSString*)criteria andPageNum:(NSString*)pageNum andPageSize:(NSString*)pageSize
{
    if (![pageNum isEqualToString:@"1"]) {
        if (starArray.count%10!=0||pageNum.intValue*pageSize.intValue-starArray.count>10) {
            [self.footer endRefreshing];
            [self showAlertMsg:@"没有更多了" andFrame:CGRectZero];
            return;
        }
    }
    pagenum = [NSString stringWithFormat:@"%d",pagenum.intValue+1];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_DISCOVER_SEARCHMAN];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:4];
    if (criteria.length!=0 && criteriaValue!=nil) {
        [dic setObject:criteria forKey:@"criteria"];
    }
    [dic setObject:pageNum forKey:@"pageNum"];
    [dic setObject:pageSize forKey:@"pageSize"];
    if(self.lastId!=nil) [dic setObject:self.lastId forKey:@"lastid"];
    
    __weak typeof(self)weakSelf = self;
    
    [WWRequestOperationEngine operationManagerRequest_Post:urlString parameters:dic requestOperationBlock:^(NSDictionary *jsonDictionary) {
        
        if (![jsonDictionary isKindOfClass:[NSDictionary class]] || jsonDictionary==nil) {
            
            [weakSelf showAlertMsg:ZDS_NONET_HUASHU andFrame:CGRectZero];
            [weakSelf.footer endRefreshing];
            
        }else{
            
            NSArray * starCoachListArray = [jsonDictionary objectForKey:@"uerlist"];
            
            if ([pageNum isEqualToString:@"1"]) {
                [starArray removeAllObjects];
                if(starCoachListArray.count==0){
                    [weakSelf showAlertMsg:@"没有匹配的人" andFrame:CGRectMake(70,100,200,60)];
                }
            }
            
            for (NSDictionary *dic in starCoachListArray) {
                [starArray addObject:[intrestUserModel modelWithDic:dic]];
                weakSelf.lastId = dic[@"userid"];
            }
            NSLog(@"搜索结果 =================%@",starArray);
            [weakSelf.table reloadData];
            [weakSelf.footer endRefreshing];
        }
    }];
}

-(void)dealloc{
    [_footer free];
}


@end
