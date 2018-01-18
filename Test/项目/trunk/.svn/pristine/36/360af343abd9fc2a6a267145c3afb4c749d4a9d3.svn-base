//
//  GroupTeamViewController.m
//  zhidoushi
//
//  Created by nick on 15/5/4.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "GroupTeamViewController.h"
#import "MeViewController.h"
#import "intrestUserModel.h"
#import "GroupTeamCollectionViewCell.h"
#import "NSString+WPAttributedMarkup.h"
#import "WPAttributedStyleAction.h"
#import "WPHotspotLabel.h"
#import "UserListTableViewCell.h"
#import "UITableView+SSLSelect.h"
#import "UserSearchAlertView.h"
#import "RemoveAlert.h"

@interface GroupTeamViewController () <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UserSearchAlertViewDelegate,UserListTableViewCellDelegate,RemoveAlertDelegate>

//2.3.6废弃 三排
//@property(nonatomic,strong)UICollectionView* DisCoverTable;//tableView
@property(nonatomic,strong)NSMutableArray* data;//数据
@property(nonatomic,strong)MJRefreshHeaderView *header;//头部刷新
@property(nonatomic,strong)MJRefreshFooterView *footer;//底部刷新
@property(nonatomic,assign)int count;//总是
@property(nonatomic,assign)int timePageNum;//当前页数

@property(nonatomic,strong)UITableView *table;//当前页数
@property (nonatomic,strong) UISearchBar *searchBar;//
@property (nonatomic,strong) UIButton *removeButton;//移除按钮

//控制cell中选择按钮显示与隐藏
@property (nonatomic,assign) BOOL showSelectButtonTag;
//选择的数量
@property (nonatomic,assign) int selectCount;

@property (nonatomic,strong) UIView *topGgView;

//未找到团员信息提示
@property (nonatomic,strong) UILabel *messageLabel;

@property (nonatomic,copy) NSString  *searchText;

@property(nonatomic,strong)UIButton *concelBtn;//取消按钮
@end

@implementation GroupTeamViewController

#pragma mark - Life Cycle
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"团组成员列表页面"];
    [self.table ssl_deselectCurrenRow];
    [self.httpOpt cancel];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //友盟打点
    [MobClick beginLogPageView:@"团组成员列表页面"];
    //导航栏标题
    self.titleLabel.text = @"减脂伙伴";
    self.titleLabel.textColor = ZDS_DHL_TITLE_COLOR;
    self.titleLabel.font = MyFont(18);
    //导航栏返回
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"fh-36"] forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = MyFont(13);
    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width = 16;
    labelRect.size.height = 16;
    self.leftButton.frame = labelRect;
    
    //导航栏管理
    [self.rightButton setTitle:self.showSelectButtonTag?@"取消":@"管理" forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = MyFont(16);
    [self.rightButton setTitleColor:OrangeColor forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.rightButton.width = 40;
    self.rightButton.height = 16;
    self.rightButton.enabled = YES;
    
    //团长
    if(([self.gameangle isEqualToString:@"0"] || [self.gameangle isEqualToString:@"1"]) && self.data.count > 1){
        self.rightButton.hidden = NO;
    }else self.rightButton.hidden = YES;
    
    self.showSelectButtonTag = NO;
    
//    [self.searchBar becomeFirstResponder];
}

-(void)dealloc{
    [self.header free];
    [self.footer free];
    NSLog(@"减脂伙伴页面释放");
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.showSelectButtonTag = NO;
    self.view.backgroundColor = ZDS_BACK_COLOR;
    
    //初始化UI
    [self setupGUI];
    //刷新数据
    [self.header beginRefreshing];
}

#pragma mark - UI
#pragma mark 初始化UI
-(void)setupGUI {
    
    CGFloat maxY = 0;
    CGRect rect = CGRectZero;
    
    //团长
    if ([self.gameangle isEqualToString:@"0"] || [self.gameangle isEqualToString:@"1"] || [self.gameangle isEqualToString:@"2"]) {
        UIView *topGgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        [self.view addSubview:topGgView];
        self.topGgView = topGgView;
        topGgView.backgroundColor = ZDS_BACK_COLOR;
        
        UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(5, 10, SCREEN_WIDTH-10, 15)];
        //    [_searchBar setTintColor:[WWTolls colorWithHexString:@"dedede"]];//修改光标颜色
        
        searchBar.placeholder = @"输入团员昵称";
        
        searchBar.barTintColor = [UIColor whiteColor];
        searchBar.layer.cornerRadius = 2.5;
        searchBar.clipsToBounds = YES;
        UIView *searchTextField = [[[searchBar.subviews firstObject] subviews] lastObject];
        //    searchTextField.backgroundColor = RGBCOLOR(239, 239, 239);
        searchTextField.backgroundColor = [UIColor whiteColor];
        searchBar.barStyle = UIBarStyleDefault;
//        searchTextField.layer.cornerRadius = 
        
        searchBar.delegate = self;
        
        UITextField *searchField = [searchBar valueForKey:@"_searchField"];
        // Change search bar text color
        searchField.textColor = [WWTolls colorWithHexString:@"#535353"];
        self.searchBar = searchBar;
        
        for (UIView *subview in [searchBar.subviews[0] subviews]) {
            if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                [subview removeFromSuperview];
                break;
            }
        }   
        
        [topGgView addSubview:searchBar];
        UIButton *btn = [[UIButton alloc] init];
        btn.titleLabel.font = MyFont(15);
        self.concelBtn = btn;
//        btn.titleLabel.textColor = [WWTolls colorWithHexString:@"#959595"];
        [btn setTitleColor:[WWTolls colorWithHexString:@"#959595"] forState:UIControlStateNormal];
        btn.frame = CGRectMake(SCREEN_WIDTH - 42, 10, 40, 30);
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(cancelSearch) forControlEvents:UIControlEventTouchUpInside];
        btn.hidden = YES;
        [topGgView addSubview:btn];
//        btn.frame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
        
        maxY = topGgView.maxY;
        
        rect = CGRectMake(0, topGgView.maxY, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight - topGgView.maxY);
    } else {
        rect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 13);
    }
    
    //用户列表
    UITableView *tableView = [[UITableView alloc] initWithFrame:rect];
    tableView.backgroundColor = [WWTolls colorWithHexString:@"#efefef"];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tag = 222;
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableView];
    
    self.table = tableView;
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 111, SCREEN_WIDTH, 14)];
    messageLabel.text = @"未找到该团员";
    messageLabel.font = MyFont(14.0);
    messageLabel.textColor = [WWTolls colorWithHexString:@"#535353"];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    [tableView addSubview:messageLabel];
    messageLabel.hidden = YES;
    self.messageLabel = messageLabel;
    
    //初始化刷新
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    self.header = header;
    header.scrollView = tableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        
        if (self.searchText.length > 0) {
            [self refreshWithSearchParter];
        } else {
            [self loadDataWithIsMore:NO];
        }
    };
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    self.footer = footer;
    footer.scrollView = tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        if (self.searchText.length > 0) {
            [self reloadWithSearchParter];
        } else {
            [self loadDataWithIsMore:YES];
        }
    };

    NSLog(@"self.view.frame:%@",[NSValue valueWithCGRect:self.view.frame]);
    
    //移除按钮
    UIButton *removeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - NavHeight - 50, SCREEN_WIDTH, 50)];
    removeButton.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
    [removeButton setTitle:@"移除0/10" forState:UIControlStateNormal];
    [removeButton setTitleColor:[WWTolls colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    removeButton.titleLabel.font = MyFont(16);
    [removeButton addTarget:self action:@selector(removeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    removeButton.hidden = YES;
    self.removeButton = removeButton;
    [self.view addSubview:removeButton];

}

#pragma mark - Delegate

#pragma mark RemoveAlertDelegate
#pragma mark 删除团员确认回调
- (void)removeAlertConfirmClick:(RemoveAlert *)removeAlert {
    [self requestWithDelparter];
    
}

#pragma mark UserListTableViewCellDelegate
- (BOOL)userListTableViewCell:(UserListTableViewCell *)userListTableViewCell isSelectWithIndexPath:(NSIndexPath *)indexPath {
    
    //如果选择按钮当前是选中状态
    if (userListTableViewCell.selectButton.selected) {
        
        [self.removeButton setTitle:[NSString stringWithFormat:@"移除%d/10",--self.selectCount] forState:UIControlStateNormal];
        self.removeButton.backgroundColor = [WWTolls colorWithHexString:self.selectCount>0?@"#ff4d48":@"#dcdcdc"];
        return YES;
    } else {
        if (self.selectCount == 10) {
            [self showAlertMsg:@"最多只能删除10个用户" andFrame:CGRectZero];
            return NO;
        } else {
            [self.removeButton setTitle:[NSString stringWithFormat:@"移除%d/10",++self.selectCount] forState:UIControlStateNormal];
            self.removeButton.backgroundColor = [WWTolls colorWithHexString:self.selectCount>0?@"#ff4d48":@"#dcdcdc"];
            return YES;
        }
    }
    self.removeButton.backgroundColor = [WWTolls colorWithHexString:self.selectCount>0?@"#ff4d48":@"#dcdcdc"];
    return NO;
}

#pragma mark UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    UserSearchAlertView *view = [[UserSearchAlertView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [view setDelegate:self andSearchText:self.searchBar.text];
    [self.view.window addSubview:view];
    [view ssl_show];
    return NO;
}

#pragma mark UserSearchAlertViewDelegate
#pragma mark 搜索回调
- (void)userSearchAlertView:(UserSearchAlertView *)userSearchAlertView searchWithText:(NSString *)searchText {
    
    self.searchBar.text = searchText;
    [self requestWithSearchUser];
}

#pragma mark 输入值改变回调
- (void)userSearchAlertView:(UserSearchAlertView *)userSearchAlertView textDidChange:(NSString *)searchText {
    self.searchBar.text = searchText;
}   

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UserListTableViewCell *cell = (UserListTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell headerButtonClick:nil];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   
    static NSString *TableSampleIdentifier = @"UserListTableViewCell";
    
    UserListTableViewCell *searchCell = [tableView dequeueReusableCellWithIdentifier:
                                         TableSampleIdentifier];
    if (searchCell == nil) {
        searchCell = [[[NSBundle mainBundle]loadNibNamed:@"UserListTableViewCell" owner:self options:nil]lastObject];
    }
    
    searchCell.delegate = self;
    searchCell.model = [self.data objectAtIndex:indexPath.row];
    searchCell.guanzhuBtn.hidden = YES;//隐藏关注按钮
    [searchCell groupTeamSetWithShowSelectButton:self.showSelectButtonTag];
    if ([self.creatorId isEqualToString:searchCell.model.userid]) {
        searchCell.tuanzhangImage.hidden = NO;
    }else searchCell.tuanzhangImage.hidden = YES;
    return searchCell;
}   

#pragma mark - Event Responses
#pragma mark 搜索用户
- (void)requestWithSearchUser {
    
    [self refreshWithSearchParter];
}

#pragma mark 返回上一级
-(void)popButton{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 右边按钮点击 管理
- (void)rightButtonClick:(UIButton *)button {
    
    if ([button.titleLabel.text isEqualToString:@"管理"]) {
        
        [self.data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            intrestUserModel *model = (intrestUserModel *)obj;
            if ([model.userid isEqualToString:[NSUSER_Defaults objectForKey:ZDS_USERID]]) {
                return ;
            }
        }];
        
        [button setTitle:@"取消" forState:UIControlStateNormal];
        self.removeButton.hidden = NO;
        self.showSelectButtonTag = YES;
        
        [UIView animateWithDuration:0.5 animations:^{
            self.topGgView.top = - 50;
            self.topGgView.hidden = YES;
            
            self.table.top = 0;
            self.table.height = SCREEN_HEIGHT - NavHeight;
        } completion:^(BOOL finished) {
            [self.table reloadData];
        }];     
        
        [self.data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            intrestUserModel *model = (intrestUserModel *)obj;
            model.isSelect = NO;
        }];
        
    } else {
        
        if (self.data.count == 0) {
            return;
        }
        if(self.data.count < 2) self.rightButton.hidden = YES;
        [button setTitle:@"管理" forState:UIControlStateNormal];
        self.selectCount = 0;
        self.removeButton.hidden = YES;
        self.showSelectButtonTag = NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.topGgView.top = 0;
            self.topGgView.hidden = NO;
            self.table.top = 50;
            self.table.height = SCREEN_HEIGHT - NavHeight - 50;
        } completion:^(BOOL finished) {
            [self.table reloadData];
        }];
        
    }
}

#pragma mark 移除点击事件
- (void)removeButtonClick:(UIButton *)removeButton {
    
    if (self.selectCount > 0) {
        RemoveAlert *removeAlert = [[RemoveAlert alloc] initWithFrame:self.view.window.bounds delegate:self];
        [removeAlert createViewWithNumber:self.selectCount];
        [self.view.window addSubview:removeAlert];
        [removeAlert ssl_show];
    } else {
        [self showAlertMsg:@"请选择要删除的团员" andFrame:CGRectZero];
    }
}   

#pragma mark - Private Methods
#pragma mark 加载
-(void)loadDataWithIsMore:(BOOL)isMore{
    
    if (isMore) {
        if (self.data.count%12!=0||self.data.count<self.timePageNum*12) {
            [self showAlertMsg:@"没有更多了" andFrame:CGRectZero];
            [self.footer endRefreshing];
            return;
        }
    }else{
        self.concelBtn.hidden = YES;
        self.searchBar.width = SCREEN_WIDTH - 10;
    }
    if (self.httpOpt && !self.httpOpt.finished) {
        [self.footer endRefreshing];
        [self.header endRefreshing];
        return;
    }
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:3];
    if (isMore) {
        [dictionary setObject:[NSString stringWithFormat:@"%d",self.timePageNum+1] forKey:@"pageNum"];
    }else{
        [dictionary setObject:[NSString stringWithFormat:@"%d",1] forKey:@"pageNum"];
    }
    [dictionary setObject:@"12" forKey:@"pageSize"];
    [dictionary setObject:[NSString stringWithFormat:@"%@",self.groupId] forKey:@"gameid"];
    if(isMore && self.lastId!=nil) [dictionary setObject:self.lastId forKey:@"lastid"];
    //发送请求
    __weak typeof(self)weakSelf = self;
    self.httpOpt = [WWRequestOperationEngine operationManagerRequest_Post:ZDS_PARTERGAME parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (!dic[ERRCODE]) {
            NSArray *tempArray = dic[@"parterList"];
            if (isMore) {
                weakSelf.timePageNum++;
            }else{
                weakSelf.searchText = @"";
                weakSelf.timePageNum=1;
                [weakSelf.data removeAllObjects];
                if(([self.gameangle isEqualToString:@"0"] || [self.gameangle isEqualToString:@"1"]) && tempArray.count > 1){
                    weakSelf.rightButton.hidden = NO;
                }else weakSelf.rightButton.hidden = YES;

            }
            for (NSDictionary *dic in tempArray) {
                [weakSelf.data addObject:[intrestUserModel modelWithDic:dic[@"userinfo"]]];
                weakSelf.lastId = dic[@"userinfo"][@"userid"];
            }
            [weakSelf.table reloadData];
        }
        [weakSelf.footer endRefreshing];
        [weakSelf.header endRefreshing];
    }];
}

#pragma mark 剔除团员，支持批量
- (void)requestWithDelparter {
    
    NSMutableArray *muArray = [NSMutableArray array];
    NSDictionary *dic = nil;
    
    [self.data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        intrestUserModel *model = (intrestUserModel *)obj;
        if (model.isSelect) {
            NSDictionary *dict = [NSDictionary dictionaryWithObject:model.userid forKey:@"userid"];
            [muArray addObject:dict];
        }
    }];
    
    dic = [NSDictionary dictionaryWithObject:muArray forKey:@"parterlist"];
    
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:[NSString stringWithFormat:@"%@",self.groupId] forKey:@"gameid"];
    [dictionary setObject:[NSString stringWithFormat:@"%@",[self JsonObjectToString:dic]] forKey:@"parters"];
    
    //发送请求感兴趣的人
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_DELPARTER parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        weakSelf.rightButton.userInteractionEnabled = YES;
        
        if ([dic[@"result"] isEqualToString:@"0"]) {
            [weakSelf showAlertMsg:@"移除成功" andFrame:CGRectZero];
            [weakSelf.removeButton setTitle:@"移除0/10" forState:UIControlStateNormal];
            weakSelf.removeButton.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
            NSMutableArray *muA = [NSMutableArray array];
            
            [weakSelf.data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                intrestUserModel *model = (intrestUserModel *)obj;
                if (model.isSelect) {
                    [muA addObject:model];
                }
            }];
            
            [weakSelf.data removeObjectsInArray:[muA copy]];
            
            weakSelf.selectCount = 0;
            [weakSelf.table reloadData];
            NSLog(@"移除成功");
        }

    }];
}

#pragma mark 团员搜索
- (void)refreshWithSearchParter {
    
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:5];
    [dictionary setObject:@"1" forKey:@"pageNum"];
    [dictionary setObject:@"12" forKey:@"pageSize"];
    [dictionary setObject:[NSString stringWithFormat:@"%@",self.groupId] forKey:@"gameid"];
    [dictionary setObject:[NSString stringWithFormat:@"%@",self.searchBar.text] forKey:@"criteria"];
    
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_SEARCHPARTER parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (!dic[ERRCODE]) {
            weakSelf.concelBtn.hidden = NO;
            weakSelf.searchBar.width = SCREEN_WIDTH - 40;
            weakSelf.timePageNum=1;
            
            [weakSelf.data removeAllObjects];
            
            weakSelf.searchText = weakSelf.searchBar.text;
            
            NSArray *tempArray = dic[@"parterList"];
            if(([self.gameangle isEqualToString:@"0"] || [self.gameangle isEqualToString:@"1"]) && tempArray.count > 0){
                weakSelf.rightButton.hidden = NO;
                if (tempArray.count == 1 && [tempArray[0][@"userid"] isEqualToString:[NSUSER_Defaults objectForKey:ZDS_USERID]]) {
                    weakSelf.rightButton.hidden = YES;
                }
            }else weakSelf.rightButton.hidden = YES;
            if (tempArray.count > 0) {
                for (NSDictionary *dic in tempArray) {
                    intrestUserModel *model = [intrestUserModel modelWithDic:dic];
                    [weakSelf.data addObject:model];
                    weakSelf.lastId = model.userid;
                }
                weakSelf.messageLabel.hidden = YES;
                [weakSelf.table reloadData];
            } else {
                weakSelf.messageLabel.hidden = NO;
                [weakSelf.table reloadData];
            }
        }
        [weakSelf.header endRefreshing];
        [weakSelf.footer endRefreshing];
    }];
}

#pragma mark 团员搜索加载更多
- (void)reloadWithSearchParter {
    
//    if (self.data.count%12!=0||self.data.count<self.timePageNum*12) {
//        [self showAlertMsg:@"没有更多了" andFrame:CGRectZero];
//        [self.footer endRefreshing];
//        return;
//    }
//    
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:3];
    [dictionary setObject:[NSString stringWithFormat:@"%d",self.timePageNum+1] forKey:@"pageNum"];
    [dictionary setObject:@"12" forKey:@"pageSize"];
    [dictionary setObject:[NSString stringWithFormat:@"%@",self.groupId] forKey:@"gameid"];
    if(self.lastId!=nil) [dictionary setObject:self.lastId forKey:@"lastid"];
    //发送请求
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_SEARCHPARTER parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (!dic[ERRCODE]) {
            weakSelf.timePageNum++;
            NSArray *tempArray = dic[@"parterList"];
            if(tempArray.count == 0){
                [self showAlertMsg:@"没有更多了" andFrame:CGRectZero];
            }
            for (NSDictionary *dic in tempArray) {
                [weakSelf.data addObject:[intrestUserModel modelWithDic:dic]];
                weakSelf.lastId = dic[@"userid"];
            }
            [weakSelf.table reloadData];
        }
        [weakSelf.footer endRefreshing];
        [weakSelf.header endRefreshing];
    }];
}


- (void)cancelSearch{
    self.searchText = @"";
    self.searchBar.text = @"";
    [self loadDataWithIsMore:NO];
}

- (NSString *)JsonObjectToString:(id)obj
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:0 error:nil];
    NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return string;
}

#pragma mark - Getters And Setters
-(NSMutableArray *)data{
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}

//#pragma mark - UICollectionViewDelegate
//-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//    return 1;
//}
//
//-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//{
//    long i = self.data.count;
//    return i;
//}
//
//-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    GroupTeamCollectionViewCell *hsc =[collectionView dequeueReusableCellWithReuseIdentifier:@"teamusercell" forIndexPath:indexPath];
//    hsc.model = self.data[indexPath.row];
//    if (indexPath.row == 0) {
//        NSDictionary* style = @{
//                                 @"thumb":[UIImage imageNamed:@"tz"] };
////        CGFloat h = [WWTolls heightForString:[NSString stringWithFormat:@"头%@",hsc.model.username] fontSize:14 andWidth:91] + 1;
//        hsc.nameLbl.attributedText = [[NSString stringWithFormat:@"<thumb> </thumb>%@",hsc.model.username] attributedStringWithStyleBook:style];
////        hsc.nameLbl.height = h;
//    }else hsc.nameLbl.height = 46;
//    return hsc;
//}   
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    CGSize retval = CGSizeMake(106, 130);
//    return retval;
//    
//}







@end
