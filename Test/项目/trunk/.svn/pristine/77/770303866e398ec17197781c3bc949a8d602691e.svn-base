//
//  SearchResultsViewController.m
//  zhidoushi
//
//  Created by xinglei on 14-9-22.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "SearchResultsViewController.h"

#import "WWRequestOperationEngine.h"
#import "SearchResultTableViewCell.h"
#import "JSONKit.h"
#import "NSDictionary+NARSafeDictionary.h"
#import "NSArray+NARSafeArray.h"
#import "HomeGroupModel.h"
#import "NSString+NARSafeString.h"
#import "GroupViewController.h"
#import "MJRefresh.h"
#import "MobClick.h"
#import "PageScrollLine.h"
#import "OfficialInformTableViewCell.h"
#import "DiscoverListTableViewCell.h"
#import "NARShareView.h"
#import "DiscoverDetailViewController.h"
#import "MJExtension.h"
#import "intrestUserModel.h"
#import "UserListTableViewCell.h"
#import "SSLImageTool.h"
#import "MeViewController.h"
#import "HotTagView.h"
#import "GroupTalkTableViewCell.h"
#import "ArticleTableViewCell.h"
#import "UITableViewCell+SSLSelect.h"
#import "GroupTalkDetailViewController.h"
#import "DeleteBarModel.h"
#import "DeleteShowModel.h"

@interface SearchResultsViewController () <PageScrollLineDelegate,discoverReportDelegate,NARShareViewDelegate,UIActionSheetDelegate,HotTagViewDelegate> {
    UIActionSheet *myActionSheetView;//举报行为
    NSString *talkid;//乐活吧更多id
}

//查询条件
@property (nonatomic,strong) NSString *criteriaValue;

//当前indexPath
@property(nonatomic,strong)NSIndexPath *currentIndexPath;

@property (nonatomic,strong) NSString *placeString;

@property(nonatomic,strong) PageScrollLine *pageScrollLine;

#pragma mark 话题

@property (nonatomic,strong) UIView *leftView;//左边视图(话题视图)
@property (nonatomic,strong) UIView *hotTopicView;//热门话题view

@property (nonatomic,strong) NSMutableArray *tagListArray;//热门话题标签

@property (nonatomic,strong) UIView *topicView;//话题view
@property (nonatomic,strong) UIView *topicResultView;//话题结果view

//tableView 相关
@property (nonatomic,strong) NSMutableArray *topicDataArray;//话题数组
@property (nonatomic,strong) UITableView *topicTableView;//话题tableView

@property (nonatomic,strong) MJRefreshFooterView *topicFooter;//
@property (nonatomic,strong) MJRefreshHeaderView *topicHeader;//

@property (nonatomic,assign) int topicPageNum;
@property (nonatomic,copy) NSString *topicLastId;

@property (nonatomic,strong) UIView *topicMessageView;//

//请求成功的查询条件
@property (nonatomic,strong) NSString *topicCriteriaValue;

#pragma mark 用户
@property (nonatomic,strong) UIView *centerView;//中间视图

//tableView 相关
@property (nonatomic,strong) NSMutableArray *userDataArray;//用户数组
@property (nonatomic,strong) UITableView *userTableView;//用户tableView

@property (nonatomic,strong) MJRefreshFooterView *userFooter;//
@property (nonatomic,strong) MJRefreshHeaderView *userHeader;//

@property (nonatomic,assign) int userPageNum;
@property (nonatomic,copy) NSString *userLastId;

@property (nonatomic,strong) UILabel *userMessage;
/**
 *  0:感兴趣的人
 1:用户搜索
 */
@property (nonatomic,assign) int userType;

//请求成功的查询条件
@property (nonatomic,strong) NSString *userCriteriaValue;

#pragma mark 团组
@property (nonatomic,strong) UIView *rightView;//右边视图

@property (nonatomic,strong) NSMutableArray *starArray;
@property(nonatomic,strong)UITableView * table;

@property (nonatomic,weak) MJRefreshFooterView *footer;//下拉刷新
@property (nonatomic,weak) MJRefreshHeaderView *header;//下拉刷新

@property (nonatomic,assign) int pagenum;

@property (nonatomic,strong) UIView *groupMessageView;

@property (nonatomic,assign) BOOL showNoUser;

@property (nonatomic,assign) BOOL showKeyboard;

//请求成功的查询条件
@property (nonatomic,strong) NSString *groupCriteriaValue;

@end

@implementation SearchResultsViewController

#define selectColor OrangeColor

#pragma mark - Life Cycle
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.searchBar removeFromSuperview];
    [self.fanhuiBtn removeFromSuperview];
    [MobClick endLogPageView:@"搜索页面"];
    
    [self.userTableView deselectRowAtIndexPath:[self.userTableView indexPathForSelectedRow] animated:YES];
    [self.table deselectRowAtIndexPath:[self.table indexPathForSelectedRow] animated:YES];
    [self.topicTableView deselectRowAtIndexPath:[self.topicTableView indexPathForSelectedRow] animated:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"搜索页面"];
    
    //    self.findBtn.hidden = YES;
    
    self.searchBar.hidden = NO;
    //    [self.navigationController setNavigationBarHidden:YES];
    //    [self.rightButton setTitle:@"取消" forState:UIControlStateNormal];
    ////    [self.rightButton setTitleColor:ZDS_DHL_TITLE_COLOR forState:UIControlStateNormal];
    //    [self.rightButton setTitleColor:[WWTolls colorWithHexString:@"#959595"] forState:UIControlStateNormal];
    //    self.rightButton.titleLabel.font = MyFont(16);
    //    [self.rightButton addTarget:self action:@selector(backToLast) forControlEvents:UIControlEventTouchUpInside];
    //    self.rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    //    CGRect labelRectRight = self.rightButton.frame;
    //    
    ////    CGFloat width = [WWTolls WidthForString:@"取消" fontSize:16 andHeight:16];
    //    
    //    labelRectRight.size.width = 60;
    //    labelRectRight.size.height = 16;
    //    self.rightButton.frame = labelRectRight;
    
    //返
    UIButton *fanhui = [[UIButton alloc] initWithFrame:CGRectMake(10, 20.5, 13, 13)];
    self.fanhuiBtn = fanhui;
    [fanhui setBackgroundImage:[UIImage imageNamed:@"fh-36"] forState:UIControlStateNormal];
    [fanhui addTarget:self action:@selector(backToLast) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:fanhui];
    
    //搜索框
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(35, 5, SCREEN_WIDTH - 45, 30)];
    //    [_searchBar setTintColor:[WWTolls colorWithHexString:@"dedede"]];//修改光标颜色
    
    _searchBar.placeholder = @"输入话题内容";
    if (self.placeString.length > 0) {
        _searchBar.placeholder = self.placeString;
    }
    _searchBar.barTintColor = [UIColor whiteColor];
    _searchBar.layer.cornerRadius = 2.5;
    _searchBar.clipsToBounds = YES;
    UIView *searchTextField = [[[_searchBar.subviews firstObject] subviews] lastObject];
    searchTextField.backgroundColor = [WWTolls colorWithHexString:@"#F0EAEA"];
    searchTextField.layer.cornerRadius = 14;
    searchTextField.clipsToBounds = YES;
    //    _searchBar.backgroundColor = [UIColor redColor];
    _searchBar.barStyle = UIBarStyleDefault;
    _searchBar.delegate = self;
    
    UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
    // Change search bar text color
    searchField.textColor = [WWTolls colorWithHexString:@"#535353"];
    
    self.searchDispalyController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _searchDispalyController.delegate = self;
    
    [self.navigationController.navigationBar addSubview:_searchBar];
    if (self.showKeyboard) {
        [self.searchBar becomeFirstResponder];
        self.showKeyboard = NO;
    }
    
    if (self.criteriaValue.length > 0) {
        self.searchBar.text = self.criteriaValue;
    }
}   


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.showNoUser = NO;
    self.showKeyboard = YES;
    
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(concel)];
    //    [self.view addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userFocus:) name:@"meViewFocus" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteDiscover:) name:@"deleteDiscover" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(good:) name:@"goodReply" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(com:) name:@"comReply" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delteReply:) name:@"delteReply" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupTitleDelete:) name:@"grouptitletoggle" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupTitleDelete:) name:@"sendTitleSucess" object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *view1 = [[UIView alloc] init];
    self.leftView = view1;
    
    UIView *view2 = [[UIView alloc]init];
    self.centerView = view2;
    
    UIView *view3 = [[UIView alloc]init];
    self.rightView = view3;
    
    NSArray *viewArray = @[view1,view2,view3];
    NSArray *titleArray = @[@"话题",@"用户",@"团组"];
    
    PageScrollLine *pageScrollCustomButton = [[PageScrollLine alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight)];
    [self.view addSubview:pageScrollCustomButton];
    self.pageScrollLine = pageScrollCustomButton;
    [pageScrollCustomButton setTopViewWithHeight:42 topViewColor:[UIColor whiteColor] lineEdgeSpace:50 lineHeight:2.5 lineWidth:60 titleSelectColor:selectColor titleNormalColor:[ContentColor colorWithAlphaComponent:0.6] titleArray:titleArray titleFont:[UIFont systemFontOfSize:15.0]];
    
    [pageScrollCustomButton setBottomViewWithViewArray:viewArray];
    
    pageScrollCustomButton.delegate = self;
    
    [pageScrollCustomButton loadView];
    
    //话题
    [self setUpTopicNothing];
    [self setUpTopicResult];
    //    [self setUpTopic];
    [self requestWithHottags];
    
    //用户
    [self setUpUserNothing];
    [self setUpUserList];
    [self requestWithInterestuserIsLoadMore:NO];
    
    //团组
    [self setUpGroupNoNothing];
    [self setUpGroupListWithType:0];
    [self requestWithHotList];
    
    [self.searchBar becomeFirstResponder];
}

- (void)dealloc {
    
    NSLog(@"搜索页面释放");
    [self.footer free];
    [self.topicFooter free];
    [self.userFooter free];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}   

#pragma mark - UI
#pragma mark 话题初始UI
- (void)setUpTopic {
    
    UIView *topicView = [[UIView alloc] initWithFrame:self.leftView.bounds];
    topicView.backgroundColor = [UIColor whiteColor];
    [self.leftView addSubview:topicView];
    self.hotTopicView = topicView;
    
    UIView *tagView = [self tagViewWithFrame:CGRectZero content:@"热门话题"];
    [topicView addSubview:tagView];
    
    if (self.tagListArray.count == 0) {
        return;
    }
    
    //    self.tagListArray = [NSMutableArray arrayWithObjects:@"afdasdjfasjdfawjfafashdflasdhfkasdhflaskdhfaasdfa", nil];
    
    //标签UI
    HotTagView *hotTagView = [[HotTagView alloc] initWithFrame:CGRectMake(0, tagView.maxY, topicView.width, 100) tagArray:self.tagListArray];
    hotTagView.delegate = self;
    [topicView addSubview:hotTagView];
    hotTagView.backgroundColor = [UIColor whiteColor];
}

#pragma mark 话题结果列表
- (void)setUpTopicResult {
    
    //    if (self.leftView) {
    //        [self.leftView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //    }
    
    //话题列表
    UITableView *tableView = [[UITableView alloc] init];
    tableView.scrollsToTop = YES;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = ZDS_BACK_COLOR;
    //    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.frame = self.leftView.bounds;
    tableView.tag = 111;
    [self.leftView addSubview:tableView];
    self.topicTableView = tableView;
    
    WEAKSELF_SS
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    self.topicFooter = footer;
    footer.scrollView = tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [weakSelf loadTopicData];
    };
    
    tableView.hidden = YES;
}

#pragma mark 隐藏话题table
/**
 *  隐藏话题table
 *
 *  @param hiddenTopicTable 0:显示搜索到的话题 1:未搜索到内容UI
 */
- (void)hiddenTopicTable:(int)hiddenTopicTable {
    
    //删除人们标签view
    if (self.hotTopicView) {
        [self.hotTopicView removeFromSuperview];
        self.hotTopicView = nil;
    }
    
    if (hiddenTopicTable) {
        self.topicTableView.hidden = YES;
        self.topicMessageView.hidden = NO;
    } else {
        self.topicTableView.hidden = NO;
        self.topicMessageView.hidden = YES;
    }
}

#pragma mark 话题没搜到结果
- (void)setUpTopicNothing {
    
    //    if (self.leftView) {
    //        [self.leftView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //    }
    
    UIView *noResultView = [[UIView alloc] initWithFrame:self.leftView.bounds];
    [self.leftView addSubview:noResultView];
    
    UIImageView *tt = [[UIImageView alloc] init];
    tt.image = [UIImage imageNamed:@"kbicon-120"];
    tt.frame = CGRectMake(SCREEN_MIDDLE(60), 100, 60, 60);
    [noResultView addSubview:tt];
    UILabel *ll = [[UILabel alloc] initWithFrame:CGRectMake(0, tt.bottom + 20, SCREEN_WIDTH, 27)];
    ll.font = MyFont(13);
    ll.textColor = TimeColor;
    ll.textAlignment = NSTextAlignmentCenter;
    ll.text = @"没有找到该话题相关的内容";
    [noResultView addSubview:ll];
    
//    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 113, noResultView.width, 14)];
//    [noResultView addSubview:messageLabel];
//    messageLabel.textAlignment = NSTextAlignmentCenter;
//    messageLabel.text = @"没有找到该话题相关的内容";
//    messageLabel.font = MyFont(14.0);
//    messageLabel.textColor = [WWTolls colorWithHexString:@"#535353"];
//    
    noResultView.hidden = YES;
    
    self.topicMessageView = noResultView;
}

#pragma mark 用户结果列表
- (void)setUpUserList {
    
    //用户列表
    UITableView *tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.scrollsToTop = YES;
    tableView.dataSource = self;
    //    tableView.backgroundColor = [WWTolls colorWithHexString:@"#efefef"];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    //    tableView.separatorInset = UIEdgeInsetsMake(0, 12, 0, 12);
    tableView.frame = self.centerView.bounds;
    tableView.tag = 222;
    [self.centerView addSubview:tableView];
    self.centerView.backgroundColor = [UIColor whiteColor];
    self.userTableView = tableView;
    
    UIView *footerView = [[UIView alloc] init];
    self.userTableView.tableFooterView = footerView;
    
    WEAKSELF_SS
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    self.userFooter = footer;
    footer.scrollView = tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [weakSelf requestWithInterestuserIsLoadMore:YES];
        //        [self loadUserData];
    };  
    
    tableView.hidden = YES;
}

#pragma mark 没有搜到用户
- (void)setUpUserNothing {
    
    UIView *noResultView = [[UIView alloc] initWithFrame:self.rightView.bounds];
    [self.centerView addSubview:noResultView];
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 113, noResultView.width, 20)];
    [noResultView addSubview:messageLabel];
    self.userMessage = messageLabel;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.text = @"没有符合条件的用户";
    messageLabel.font = MyFont(15.0);
    messageLabel.textColor = [WWTolls colorWithHexString:@"#535353"];
    messageLabel.hidden = YES;
}

#pragma mark 隐藏用户tableView
- (void)hiddenUserTable:(BOOL)hiddenUserTable {
    
    if (hiddenUserTable) {
        self.userTableView.hidden = YES;
        self.userMessage.hidden = NO;
    } else {
        self.userTableView.hidden = NO;
        self.userMessage.hidden = YES;
    }
}

#pragma mark 切换用户
/**
 *  切换用户
 *
 *  @param type 0:感兴趣的人 1:搜索的到用户 2:未搜到用户
 */
- (void)changeUserType:(int)type {
    
    WEAKSELF_SS
    //感兴趣的人
    if (type == 0) {
        //        self.userFooter.hidden = YES;
        
        
        self.userFooter.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
            [weakSelf requestWithInterestuserIsLoadMore:YES];
        };
        
        if (self.showNoUser) {
            
            UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 140*SCREEN_WIDTH/320)];
            header.backgroundColor = ZDS_BACK_COLOR;
//            header.layer.borderWidth = 0.5;
//            header.layer.borderColor = [[WWTolls colorWithHexString:@"#dcdcdc"] CGColor];
            
            UILabel *label = [[UILabel alloc] initWithFrame:header.bounds];
            label.textAlignment = NSTextAlignmentCenter;
            [header addSubview:label];
            label.numberOfLines = 2;
            label.text = @"没有找到该用户\n可能感兴趣的用户";
            label.textColor = TimeColor;
            label.font = MyFont(14.0);
            
            //            UIView *headerView = [self tagViewWithFrame:CGRectZero content:@"您可能感兴趣的人"];
            //            headerView.layer.borderWidth = 0;
            //            [header addSubview:headerView];
            //            headerView.top = label.maxY + 22;
            
            self.userTableView.tableHeaderView = header;
            
        } else {
            UIView *headerView = [self tagViewWithFrame:CGRectZero content:@"可能感兴趣的人"];
            //            headerView.backgroundColor = [WWTolls colorWithHexString:@"#efefef"];
            self.userTableView.tableHeaderView = headerView;
        }
        
        
        
    } else {
        //        self.userFooter.hidden = NO;
        
        self.userFooter.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
            [weakSelf requestWithSearchUserIsLoadMore:YES];
        };
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.userTableView.width, 10)];
        
//        headerView.layer.borderWidth = 0.5;
//        headerView.layer.borderColor = [[WWTolls colorWithHexString:@"#dcdcdc"] CGColor];
        
        self.userTableView.tableHeaderView = headerView;
    }
}

#pragma mark 团组结果列表
/**
 *  团组结果列表
 *
 *  @param type 0:推荐团 1:搜索出来的团
 */
- (void)setUpGroupListWithType:(int)type {
    
    //用户列表
    UITableView *tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.frame = self.rightView.bounds;
    tableView.scrollsToTop = YES;
    tableView.tag = 333;
    [self.rightView addSubview:tableView];
//    self.rightView.backgroundColor = [WWTolls colorWithHexString:@"efefef"];
    self.table = tableView;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.table.width, 8)];
//    view.backgroundColor = [WWTolls colorWithHexString:@"#efefef"];
    self.table.tableFooterView = view;
    
    WEAKSELF_SS
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    self.footer = footer;
    footer.scrollView = tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [weakSelf loadGroupData];
    };
    
    tableView.hidden = YES;
}

//隐藏
- (void)hiddenGroupTable:(BOOL)hiddenGroupTable {
    
    if (hiddenGroupTable) {
        self.table.hidden = YES;
        self.groupMessageView.hidden = NO;
    } else {
        self.table.hidden = NO;
        self.groupMessageView.hidden = YES;
    }
}

#pragma mark 切换团组
/**
 *  切换团组
 *
 *  @param type 0:推荐团 1:搜索的到团组
 */
- (void)changeGroupType:(BOOL)type {
    
    //推荐团
    if (type == 0) {
        self.footer.hidden = YES;
        
        UIView *headerView = [self tagViewWithFrame:CGRectZero content:@"人气团组"];
        self.table.tableHeaderView = headerView;
        
    } else {
        self.footer.hidden = NO;
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.table.width, 10)];
//        headerView.backgroundColor = [WWTolls colorWithHexString:@"#efefef"];
        
//        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, headerView.width, 0.5)];
//        lineView.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
//        [headerView addSubview:lineView];
        
        self.table.tableHeaderView = headerView;
    }
}

#pragma mark 标签view （人气天团）
- (UIView *)tagViewWithFrame:(CGRect)frame content:(NSString *)content {
    
    UIView *tagView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 46)];
    UILabel *tag = [[UILabel alloc] init];
    tag.text = content;
    tag.textColor = selectColor;
    tag.font = MyFont(17);
    tag.frame = CGRectMake(15, 0, SCREEN_WIDTH - 15, 36);
    [tagView addSubview:tag];
    //    UIView *tagView = [[UIView alloc] initWithFrame:frame];
    //    UIView *tagView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 26)];
    //    tagView.layer.borderColor = [[WWTolls colorWithHexString:@"#dcdcdc"] CGColor];
    //    tagView.layer.borderWidth = 0.5;
    //    tagView.backgroundColor = [WWTolls colorWithHexString:@"#efefef"];
    //    
    //    NSString *hotTitle = content;
    //    CGFloat width = [WWTolls WidthForString:hotTitle fontSize:10 andHeight:10];
    //    
    //    UILabel *hotLabel = [[UILabel alloc] initWithFrame:CGRectMake((tagView.width - width) / 2, 8, width, 10)];
    //    hotLabel.font = MyFont(10.0);
    //    hotLabel.text = hotTitle;
    //    [tagView addSubview:hotLabel];
    //    hotLabel.textColor = [WWTolls colorWithHexString:@"#6b6b6b"];
    //    
    //    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(hotLabel.x - 5 - 40, hotLabel.midY - 0.4, 40, 0.8)];
    //    [tagView addSubview:leftLine];
    //    leftLine.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
    //    
    //    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(hotLabel.maxX + 5, leftLine.y, leftLine.width, leftLine.height)];
    //    [tagView addSubview:rightLine];
    //    rightLine.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
    
    return tagView;
}

#pragma mark 团组没结果
- (void)setUpGroupNoNothing {
    
    UIView *noResultView = [[UIView alloc] initWithFrame:self.rightView.bounds];
    [self.rightView addSubview:noResultView];
    
    UIImageView *tt = [[UIImageView alloc] init];
    tt.image = [UIImage imageNamed:@"kbicon-120"];
    tt.frame = CGRectMake(SCREEN_MIDDLE(60), 100, 60, 60);
    [noResultView addSubview:tt];
    UILabel *ll = [[UILabel alloc] initWithFrame:CGRectMake(0, tt.bottom + 20, SCREEN_WIDTH, 27)];
    ll.font = MyFont(13);
    ll.textColor = TimeColor;
    ll.textAlignment = NSTextAlignmentCenter;
    ll.text = @"没有找到该团";
    [noResultView addSubview:ll];
    
//    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 113, noResultView.width, 20)];
//    [noResultView addSubview:messageLabel];
//    messageLabel.textAlignment = NSTextAlignmentCenter;
//    messageLabel.text = @"没有符合条件的团组";
//    messageLabel.font = MyFont(15.0);
//    messageLabel.textColor = [WWTolls colorWithHexString:@"#535353"];
//    
    noResultView.hidden = YES;
    self.groupMessageView = noResultView;
}

#pragma mark - Delegate

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 999) {
        //        //弹出的菜单按钮点击后的响应
        //        switch (buttonIndex)//相机
        //        {
        //            case 0:  //打开照相机拍照
        //                
        //                [self takePhoto:YES];
        //                break;
        //                
        //            case 1:  //打开本地相册
        //                
        //                [self LocalPhoto:YES];
        //                break;
        //            case 2: //打开默认图
        //                break;
        //        }
        
    }else{
        switch (buttonIndex) {//举报
            case 0:
                [self postReport:@"0"];
                break;
            case 1:
                [self postReport:@"1"];
                break;
            case 2:
                [self postReport:@"2"];
                break;
            case 3:
                [self postReport:@"3"];
                break;
            case 4:
                [self postReport:@"99"];
                break;
            default:
                break;
        }
    }
}

#pragma mark HotTagViewDelegate
#pragma mark 热门标签点击回调
- (void)hotTagView:(HotTagView *)hotTagView selectButtonWithTitle:(NSString *)title  {
    
    [self.searchBar resignFirstResponder];
    
    if (title.length > 10) {
        title = [title substringToIndex:10];
    }
    
    self.searchBar.text = title;
    self.criteriaValue = title;
    [self requestWithShowIsLoadMore:NO];
}

#pragma mark NARShareViewDelegate
//举报
- (void)shareViewDelegateReport {
    [self reportButtonSender];
}

//删除
- (void)shareViewDelegateDelete {
    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"是否确认删除？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    view.tag = 777;
    [view show];
}

#pragma mark discoverReportDelegate
#pragma mark - 举报
-(void)reportClick:(NSString*)discoverId{
    self.disCoverId = discoverId;
    [self shareImageAndText];
}

-(void)discoverCell:(DiscoverListTableViewCell *)discoverCell reportClick:(NSString*)discoverId {
    self.disCoverId = discoverId;
    self.currentIndexPath = discoverCell.indexPath;
    [self shareImageAndText];
}   

#pragma mark PageScrollLineDelegate
- (void)scrollDidSelected:(PageScrollLine *)PageScrollSegment withIndex:(NSInteger)index {
    
    if (index == 0) {
        self.searchBar.placeholder = @"输入话题内容";
    } else if (index == 1) {
        self.searchBar.placeholder = @"输入用户昵称或ID";
    } else if (index == 2) {
        self.searchBar.placeholder = @"输入团组名称或团长昵称";
    }
    
    self.placeString = self.searchBar.placeholder;
    
    if (self.criteriaValue.length != 0) {
        
        //话题
        if (index == 0) {
            
            
            if (![self.topicCriteriaValue isEqualToString:self.criteriaValue]) {
                //话题
                [self requestWithShowIsLoadMore:NO];
            }
            
        } else if (index == 1) {
            
            
            if (![self.userCriteriaValue isEqualToString:self.criteriaValue]) {
                [self requestWithSearchUserIsLoadMore:NO];
            }
            
        } else {
            
            
            if (![self.groupCriteriaValue isEqualToString:self.criteriaValue]) {
                [self requestWithGameSearchIsLoadMore:NO];
            }
        }
    }
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //    if (scrollView.contentOffset.y > 1) {
    [self.searchBar resignFirstResponder];
    //    }
}

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchBar resignFirstResponder];
    
    //话题
    if (tableView.tag == 111) {
        
        if (self.topicDataArray.count > 0) {
            DiscoverModel *model = self.topicDataArray[indexPath.row];
            if ([model.type isEqualToString:@"0"]) {
                if(model.title && model.title.length>0){
                    GroupTalkDetailViewController *dd = [[GroupTalkDetailViewController alloc] init];
                    dd.talkid = model.showid;
                    model.pageview = [NSString stringWithFormat:@"%d",model.pageview.intValue+1];
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    dd.talktype = GroupTitleTalkType;
                    dd.clickevent = 3;
                    dd.groupId = model.gameid;
                    [self.navigationController pushViewController:dd animated:YES];
                }else{
                    GroupTalkDetailViewController *dd = [[GroupTalkDetailViewController alloc] init];
                    dd.talkid = model.showid;
                    dd.talktype = GroupSimpleTalkType;
                    dd.groupId = model.gameid;
                    [self.navigationController pushViewController:dd animated:YES];
                }
                
            }else{
                DiscoverDetailViewController *dd = [[DiscoverDetailViewController alloc] init];
                dd.discoverId = model.showid;
                [self.navigationController pushViewController:dd animated:YES];
            }
        }
        
        //用户
    } else if (tableView.tag == 222) {
        
        if (self.userDataArray.count > 0) {
            MeViewController *user = [[MeViewController alloc] init];
            intrestUserModel *model = self.userDataArray[indexPath.row];
            user.userID = model.userid;
            user.otherOrMe = 1;
            [self.navigationController pushViewController:user animated:YES];
        }
        
        //团组
    } else {
        
        if (self.starArray.count > 0) {
            HomeGroupModel *myReplyModel = self.starArray[indexPath.row];
            GroupViewController *gameDetail = [[GroupViewController alloc]init];
            gameDetail.clickevent = 4;
            gameDetail.joinClickevent = @"4";
            gameDetail.groupId = myReplyModel.gameid;
            gameDetail.ispwd = myReplyModel.ispwd;
            self.searchBar.hidden = YES;
            [self.searchBar resignFirstResponder];
            [self.navigationController pushViewController:gameDetail animated:YES];
        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //话题
    if (tableView.tag == 111) {
        DiscoverModel *model = self.topicDataArray[indexPath.row];
        if ([model.type isEqualToString:@"0"]) {
            if(model.title && model.title.length>0){
                if (!model.talkimage || model.talkimage.length<1) {
                    NSString *content = [[model.content stringByReplacingOccurrencesOfString:@"\r" withString:@" "] stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
                    CGFloat heigh = [WWTolls heightForString:content fontSize:13 andWidth:SCREEN_WIDTH - 30];
                    if (heigh<55) {
                        return 97 + heigh;
                    }else return 147;
                }
                return 147;
            }
            
            CGFloat h = [GroupTalkTableViewCell getShowCellHeight:model]+6;
            h+=2;
            return h;
        }
        return [model getDiscoverHeight];
        
    } else if (tableView.tag == 222) {
        
        return 70;
    } else {
        return 111;
    }
    
    return 0;
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //话题
    if (tableView.tag == 111) {
        return self.topicDataArray.count;
    } else if (tableView.tag == 222) {
        return self.userDataArray.count;
    } else {
        return self.starArray.count > 0 ? self.starArray.count : 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //话题
    if (tableView.tag == 111) {
        
        DiscoverModel *model = self.topicDataArray[indexPath.row];
        
        if ([model.type isEqualToString:@"0"]){
            if(model.title && model.title.length>0){
                NSString *CellIdentifier = @"ZDSGroupActicalCell";
                
                ArticleTableViewCell *groupCell = [tableView dequeueReusableCellWithIdentifier:
                                                   CellIdentifier];
                
                if (groupCell==nil) {
                    groupCell = [[[NSBundle mainBundle]loadNibNamed:@"ArticleTableViewCell" owner:self options:nil]lastObject];
                    groupCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                [groupCell setUpWithDiscoverModel:model];
                groupCell.consSeparLineHeight.constant = 0;
                return groupCell;
                
            }else{
                NSString *CellIdentifier = @"cellGroup";
                
                GroupTalkTableViewCell *groupCell = [tableView dequeueReusableCellWithIdentifier:
                                                     CellIdentifier];
                
                if (groupCell==nil) {
                    groupCell = [[[NSBundle mainBundle]loadNibNamed:@"GroupTalkTableViewCell" owner:self options:nil]lastObject];
                    groupCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    groupCell.talkCellDelegate = self;
                }
                groupCell.indexPath = indexPath;
                [groupCell initMyCellWithShowModel:model];
                return groupCell;
            }
            
            
        }
        DiscoverListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DiscoverListTableViewCell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"DiscoverListTableViewCell" owner:self options:nil]lastObject];
            //            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            [cell setSelectBackgroundColor:[WWTolls colorWithHexString:@"#eaeaea"] andNormalBackgroundColor:nil];
        }
        
        cell.userInteractionEnabled = YES;
        
        cell.delegate = self;
        cell.indexPath = indexPath;
        cell.model = model;
        return cell;
        
        //用户
    } else if (tableView.tag == 222) {
        
        static NSString *TableSampleIdentifier = @"searchermancell";
        
        UserListTableViewCell *searchCell = [tableView dequeueReusableCellWithIdentifier:
                                             TableSampleIdentifier];
        if (searchCell == nil) {
            searchCell = [[[NSBundle mainBundle]loadNibNamed:@"UserListTableViewCell" owner:self options:nil]lastObject];
        }
        
        NSUInteger row = [indexPath row];
        if (row >= self.userDataArray.count) {
            return searchCell;
        }
        searchCell.model = [self.userDataArray objectAtIndex:row];
        NSString *intertype = searchCell.model.intertype;
        NSLog(@"searchCell.model.intertype:%@",searchCell.model.intertype);
    
        //用户搜索
        if ([WWTolls isNull:searchCell.model.fanscount]) {
            if ([intertype isEqualToString:@"0"]) {//城市
                searchCell.msgLbl.text = [NSString stringWithFormat:@"你们都在：%@",searchCell.model.city];
            }else if ([intertype isEqualToString:@"1"]) {//朋友关注
                searchCell.msgLbl.text= [NSString stringWithFormat:@"%@也关注了他",searchCell.model.flwusername];
            }else if([intertype isEqualToString:@"2"]){
                searchCell.msgLbl.text = @"你可能感兴趣的人";
            }
            //感兴趣的人
        } else {
            searchCell.msgLbl.text = [NSString stringWithFormat:@"有%@人关注了他",searchCell.model.fanscount];
        }
        
        return searchCell;
        
    } else {
        
        static NSString *TableSampleIdentifier = @"groupcell";
        
        SearchResultTableViewCell *searchCell = [tableView dequeueReusableCellWithIdentifier:
                                                 TableSampleIdentifier];
        if (searchCell == nil) {
            searchCell = [[[NSBundle mainBundle]loadNibNamed:@"SearchResultTableViewCell" owner:self options:nil]lastObject];
            //            searchCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSUInteger row = [indexPath row];
        searchCell.searchModel = [self.starArray objectAtIndex:row];
        
        return searchCell;
    }   
    
    return nil;
}

#pragma mark UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    //    [self searchBar:self.searchBar textDidChange:nil];
    [self.searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
{
    NSString *inputStr = searchText;
    
    if ([inputStr length] > 10)
    {
        [self.searchDisplayController.searchBar setText:[inputStr substringToIndex:10]];
        self.criteriaValue = [inputStr substringToIndex:10];
    } else {
        self.criteriaValue = searchText;
    }
    
    if([inputStr length] == 0){
        self.showNoUser = NO;
        [self setUpTopic];
        [self changeUserType:0];
        [self hiddenGroupTable:NO];
        [self changeGroupType:0];
    }
    NSLog(@"输入的搜索字符%@",self.criteriaValue);
    
    //    NSLog(@"%lu",(unsigned long)[_dataList count]);
    //    if (searchText!=nil && searchText.length>0) {//输入的搜索字符
    //        self.showData= [NSMutableArray array];
    //        for (NSString *tempStr in _dataList) {
    //            if ([tempStr rangeOfString:searchText options:NSCaseInsensitiveSearch].length >0 ) {
    //                [_showData addObject:tempStr];
    //                NSLog(@"%lu",(unsigned long)[_showData count]);
    //            }
    //        }
    //        [_table reloadData];
    //    }
    //    else
    //    {
    ////        self.showData = [NSMutableArray arrayWithArray:_dataList];
    ////        [_table reloadData];
    //    }
}

#pragma mark 点击键盘上搜索按钮
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //    [self searchBar:self.searchBar textDidChange:nil];
    
    [self.searchBar resignFirstResponder];
    
    [self searchButtonClick];
    
}

#pragma mark - Event Response

#pragma mark 屏幕点击事件
-(void)concel{
    [self.searchBar resignFirstResponder];
}

#pragma mark 取消点击
-(void)backToLast{
    
    self.searchBar.hidden = YES;
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 点击搜索按钮
-(void)searchButtonClick{
    [self.searchBar resignFirstResponder];
    
    //话题
    [self showWaitView];
    if (self.pageScrollLine.selectIndex == 0) {
        [self requestWithShowIsLoadMore:NO];
    } else if (self.pageScrollLine.selectIndex == 1) {
        [self requestWithSearchUserIsLoadMore:NO];
    } else {
        [self requestWithGameSearchIsLoadMore:NO];
    }
    
    //    [self requestWithShowIsLoadMore:NO];
    //    [self requestWithSearchUserIsLoadMore:NO];
    //    [self requestWithGameSearchIsLoadMore:NO];
}

#pragma mark - Private Methods
#pragma mark 刷新话题列表
- (void)refreshTopicData {
    [self requestWithShowIsLoadMore:NO];
}

#pragma mark 加载话题列表
- (void)loadTopicData {
    [self requestWithShowIsLoadMore:YES];
    
}

#pragma mark 刷新用户列表
- (void)refreshUserData {
    [self requestWithSearchUserIsLoadMore:NO];
}

#pragma mark 加载用户列表
- (void)loadUserData {
    [self requestWithSearchUserIsLoadMore:YES];
}

#pragma mark 刷新团组列表
- (void)refreshGroupData {
    
}

#pragma mark 加载团组列表
- (void)loadGroupData {
    [self requestWithGameSearchIsLoadMore:YES];
}

#pragma mark 分享图文
- (void)shareImageAndText {
    
    NARShareView *myshareView = [[NARShareView alloc]initWithFrame:self.view.bounds];
    myshareView.narDelegate = self;
    
    DiscoverModel *tempModel = nil;
    int i = 0;
    for (; i < self.topicDataArray.count; i++) {
        DiscoverModel *model = self.topicDataArray[i];
        if ([model.showid isEqualToString:self.disCoverId]) {
            tempModel = model;
            break;
        }
    }
    
    [myshareView createView:DiscoverShareType withModel:tempModel withGroupModel:nil];
    DiscoverListTableViewCell *cell = (DiscoverListTableViewCell *)[self.topicTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    
    if (cell.photoImage.image) {
        UIImage *tempImage = [SSLImageTool scaleToSize:CGSizeMake(120, 120) withImage:cell.photoImage.image];
        NSData *data = [SSLImageTool compressImage:tempImage withMaxKb:32];
        
        [myshareView setShareImage:[UIImage imageWithData:data]];
    } else {
        [myshareView setShareImage:nil];
    }
    
}   

- (void)reportButtonSender
{
    NSLog(@"-------------点击了举报");
    myActionSheetView = [[UIActionSheet alloc] initWithTitle:@"选择举报类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"垃圾营销",@"淫秽信息",@"不实信息",@"敏感信息",@"其他", nil];
    [myActionSheetView showInView:self.view];
    
}

#pragma mark - Request

#pragma mark 举报接口
-(void)postReport:(NSString*)ifmtype{
    DiscoverModel *model = [self.topicDataArray objectAtIndex:self.currentIndexPath.row];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:5];
    [dictionary setObject:model.showid forKey:@"receiveid"];
    [dictionary setObject:ifmtype forKey:@"ifmtype"];
    [dictionary setObject:[model.type isEqualToString:@"0"]?@"0":@"2" forKey:@"ifmkind"];//0 讨论举报1 回复举报
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_TALKINFORM parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        if ([[dic objectForKey:@"result"] isEqualToString:@"0"]) [weakSelf showAlertMsg:@"举报成功" andFrame:CGRectMake(70,100,200,60)];
        
    }];
}

#pragma mark 加载广场标签
- (void)requestWithHottags {
    
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    /**
     *  0 热门标签
     *  1 广场展示标签
     */
    [dictionary setObject:@"1" forKey:@"tagtype"];
    
    //发送请求即将开团
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_HOTTAGS parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (!dic[ERRCODE]) {
            NSArray *arr = dic[@"taglist"];
            [weakSelf.tagListArray removeAllObjects];
            [weakSelf.tagListArray addObjectsFromArray:arr];
        }
        [weakSelf setUpTopic];
        weakSelf.rightButton.enabled = YES;
    }];
}

#pragma mark 团组搜索
- (void)requestWithGameSearchIsLoadMore:(BOOL)loadMore {
    
    if (loadMore) {
        if (self.starArray.count == 0 || self.starArray.count % 10 != 0 || self.starArray.count < self.pagenum * 10) {
            
            [self showAlertMsg:@"没有更多了" andFrame:CGRectZero];
            [self.footer endRefreshing];
            return;
        }
    }
    
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setObject:@"10" forKey:@"pageSize"];
    if (self.criteriaValue && self.criteriaValue.length != 0) {
        [dictionary setObject:self.criteriaValue forKey:@"criteria"];
    }
    
    if (loadMore) {
        
        [dictionary setObject:[NSString stringWithFormat:@"%d",self.pagenum + 1] forKey:@"pageNum"];
        [dictionary setObject:self.lastId forKey:@"lastid"];
    } else {
        [dictionary setObject:[NSString stringWithFormat:@"%d",1] forKey:@"pageNum"];
    }
    
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_SEARCH parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (dic[ERRCODE]) {
            [weakSelf hiddenGroupTable:YES];
            [weakSelf setUpGroupNoNothing];
            [weakSelf removeWaitView];
        }else{
            if (loadMore) {
                weakSelf.pagenum = weakSelf.pagenum + 1;
            } else {
                weakSelf.pagenum = 1;
                [weakSelf.starArray removeAllObjects];
            }
            
            NSArray *parterList = dic[@"gamelist"];
            
            for (NSDictionary *dict in parterList) {
                HomeGroupModel *model = [HomeGroupModel objectWithKeyValues:dict];
                [weakSelf.starArray addObject:model];
                weakSelf.lastId = model.gameid;
            }
            
            weakSelf.groupCriteriaValue = weakSelf.criteriaValue;
            
            if (weakSelf.starArray.count > 0) {
                
                [weakSelf hiddenGroupTable:NO];
                [weakSelf changeGroupType:1];
                [weakSelf.table reloadData];
                
                
                
            } else  if (!loadMore){
                [weakSelf hiddenGroupTable:YES];
            }
            [weakSelf removeWaitView];
        }
        
        if (loadMore) {
            [weakSelf.footer endRefreshing];
        } else {
            [weakSelf.header endRefreshing];
        }
        
    }];
}

#pragma mark 团组热门团组
- (void)requestWithHotList {
    
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:@"3" forKey:@"gamesNum"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_SEARCH_HOTGAMES];
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:urlString parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (dic[ERRCODE]) {
            [weakSelf hiddenGroupTable:YES];
            [weakSelf setUpGroupNoNothing];
        }else{
            NSArray *parterList = dic[@"hotgamelist"];
            
            for (NSDictionary *dict in parterList) {
                HomeGroupModel *model = [HomeGroupModel objectWithKeyValues:dict];
                [weakSelf.starArray addObject:model];
                weakSelf.lastId = model.gameid;
            }
            
            if (weakSelf.starArray.count > 0) {
                [weakSelf hiddenGroupTable:NO];
                [weakSelf changeGroupType:0];
                [weakSelf.table reloadData];
            } else {
                [weakSelf hiddenGroupTable:YES];
            }
        }
        
    }];
}

#pragma mark 话题搜索
- (void)requestWithShowIsLoadMore:(BOOL)loadMore {
    
    if (loadMore) {
        if (self.topicDataArray.count == 0 || self.topicDataArray.count % 10 != 0 || self.topicDataArray.count < self.topicPageNum * 10) {
            
            [self showAlertMsg:@"没有更多了" andFrame:CGRectZero];
            [self.topicFooter endRefreshing];
            return;
        }
    }
    
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:@"10" forKey:@"pageSize"];
    if (self.criteriaValue) {
        [dictionary setObject:self.criteriaValue forKey:@"criteria"];
    }
    
    if (loadMore) {
        
        [dictionary setObject:[NSString stringWithFormat:@"%d",self.topicPageNum + 1] forKey:@"pageNum"];
        [dictionary setObject:self.topicLastId forKey:@"lastid"];
    } else {
        [dictionary setObject:[NSString stringWithFormat:@"%d",1] forKey:@"pageNum"];
    }
    
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_SHOW parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (dic[ERRCODE]) {
            [weakSelf setUpTopicNothing];
            [weakSelf hiddenTopicTable:YES];
            [weakSelf removeWaitView];
        }else{
            
            if (loadMore) {
                weakSelf.topicPageNum++;
            } else {
                weakSelf.topicPageNum = 1;
                [weakSelf.topicDataArray removeAllObjects];
            }
            
            NSArray *parterList = dic[@"showlist"];
            
            weakSelf.topicCriteriaValue = weakSelf.criteriaValue;
            
            if (parterList.count > 0) {
                
                for (NSDictionary *dict in parterList) {
                    DiscoverModel *model = [DiscoverModel objectWithKeyValues:dict];
                    model.talkimage = model.showimage;
                    [weakSelf.topicDataArray addObject:model];
                    weakSelf.topicLastId = model.userid;
                }
                
                [weakSelf hiddenTopicTable:NO];
                [weakSelf.topicTableView reloadData];
                
                
                
            } else if (!loadMore){
                [weakSelf hiddenTopicTable:YES];
            }
            [weakSelf removeWaitView];
        }
        
        if (loadMore) {
            [weakSelf.topicFooter endRefreshing];
        } else {
            [weakSelf.topicHeader endRefreshing];
        }
        
    }];
}

#pragma mark 用户搜索
- (void)requestWithSearchUserIsLoadMore:(BOOL)loadMore {
    
    if (loadMore) {
        if (self.userDataArray.count == 0 || self.userDataArray.count % 10 != 0 || self.userDataArray.count < self.userPageNum * 10) {
            [self showAlertMsg:@"没有更多了" andFrame:CGRectZero];
            [self.userFooter endRefreshing];
            return;
        }
    }
    
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:self.criteriaValue forKey:@"criteria"];
    [dictionary setObject:@"1" forKey:@"loadtype"];
    [dictionary setObject:@"10" forKey:@"pageSize"];
    
    if (loadMore) {
        [dictionary setObject:[NSString stringWithFormat:@"%d",self.userPageNum + 1] forKey:@"pageNum"];
        [dictionary setObject:self.userLastId forKey:@"lastid"];
    } else {
        [dictionary setObject:[NSString stringWithFormat:@"%d",1] forKey:@"pageNum"];
    }   
    
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_DISCOVER_SEARCHMAN parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (dic[ERRCODE]) {
            [weakSelf hiddenUserTable:YES];
            [weakSelf removeWaitView];
        }else{
            
            if (loadMore) {
                weakSelf.userPageNum++;
            } else {
                weakSelf.userPageNum = 1;
                [weakSelf.userDataArray removeAllObjects];
            }   
            
            NSArray *parterList = dic[@"uerlist"];
            
            if (parterList.count > 0) {
                for (NSDictionary *dict in parterList) {
                    intrestUserModel *model = [intrestUserModel objectWithKeyValues:dict];
                    [weakSelf.userDataArray addObject:model];
                    weakSelf.userLastId = model.userid;
                }
                
                [weakSelf hiddenUserTable:NO];
                [weakSelf changeUserType:1];
                [weakSelf.userTableView reloadData];
                weakSelf.userType = 1;
            } else  if (!loadMore){
                weakSelf.showNoUser = YES;
                [weakSelf requestWithInterestuserIsLoadMore:NO];
            }
            [weakSelf removeWaitView];
        }
        
        if (loadMore) {
            [weakSelf.userFooter endRefreshing];
        } else {
            [weakSelf.userHeader endRefreshing];
        }
    }];
}

#pragma mark 用户可能感兴趣的人列表
- (void)requestWithInterestuserIsLoadMore:(BOOL)loadMore {
    
    if (loadMore) {
        if (self.userDataArray.count == 0 || self.userDataArray.count % 10 != 0 || self.userDataArray.count < self.userPageNum * 10) {
            [self showAlertMsg:@"没有更多了" andFrame:CGRectZero];
            [self.userFooter endRefreshing];
            return;
        }
    }
    
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setObject:@"10" forKey:@"pageSize"];
    /**
     *  是否重新加载
     *  默认为1，读取缓存
     *  0:是
     *  1:否
     *  这里传0
     */
    if (!loadMore) {
        [dictionary setObject:@"0" forKey:@"isreload"];
    }
    
    if (loadMore) {
        [dictionary setObject:[NSString stringWithFormat:@"%d",self.userPageNum + 1] forKey:@"pageNum"];
        [dictionary setObject:self.userLastId forKey:@"lastid"];
    } else {
        [dictionary setObject:[NSString stringWithFormat:@"%d",1] forKey:@"pageNum"];
    }
    
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_DISCOVER_INTRESTUSER parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (dic[ERRCODE]) {
            if (!loadMore) {
                [weakSelf hiddenUserTable:YES];
            }
            
        }else{
            //加载更多时 如果没有数据返回空字典
            if (![WWTolls isNull:dic]) {
                
                if (loadMore) {
                    weakSelf.userPageNum++;
                } else {
                    weakSelf.userPageNum = 1;
                    [weakSelf.userDataArray removeAllObjects];
                }
                
                NSArray *parterList = dic[@"userlist"];
                
                if (parterList.count > 0) {
                    
                    for (NSDictionary *dict in parterList) {
                        intrestUserModel *model = [intrestUserModel objectWithKeyValues:dict];
                        //关注状态 写死未1
                        model.flwstatus = @"1";
                        [weakSelf.userDataArray addObject:model];
                        weakSelf.userLastId = model.userid;
                    }
                    
                    [weakSelf hiddenUserTable:NO];
                    [weakSelf changeUserType:0];
                    [weakSelf.userTableView reloadData];
                    weakSelf.userType = 0;
                    if (!loadMore) {
                        [weakSelf.userTableView setContentOffset:CGPointMake(0,0) animated:NO];
                    }
                } else {
                    [weakSelf hiddenUserTable:YES];
                }
            }
        }
        
        if (loadMore) {
            [weakSelf.userFooter endRefreshing];
        } else {
            [weakSelf.userHeader endRefreshing];
        }
    }];
}

#pragma mark - NSNotification
#pragma mark 关注回调
- (void)userFocus:(NSNotification *)noti {
    
    NSDictionary *dic = noti.object;
    
    NSLog(@"关注回调:%@",dic);
    
    for (int i = 0;i<self.userDataArray.count;i++) {
        intrestUserModel *model  = self.userDataArray[i];
        if ([model.userid isEqualToString:dic[@"userid"]]) {
            model.flwstatus = dic[@"flwstatus"];
            [self.userTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

#pragma mark 删除回调
- (void)deleteDiscover:(NSNotification *)object {
    
    NSDictionary *dic = object.object;
    for (int i = 0;i<self.topicDataArray.count;i++) {
        DiscoverModel *model  = self.topicDataArray[i];
        if ([model.showid isEqualToString:dic[@"showid"]]) {
            model.commentcount =[NSString stringWithFormat:@"%d",model.commentcount.intValue-1];
            [self.topicTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

#pragma mark Getters And Setters

- (NSMutableArray *)topicDataArray {
    if (!_topicDataArray) {
        _topicDataArray = [NSMutableArray array];
    }
    return _topicDataArray;
}

- (NSMutableArray *)userDataArray {
    if (!_userDataArray) {
        _userDataArray = [NSMutableArray array];
    }
    return _userDataArray;
}

- (NSMutableArray *)starArray {
    if (!_starArray) {
        _starArray = [NSMutableArray array];
    }
    return _starArray;
}

- (NSMutableArray *)tagListArray {
    if (!_tagListArray) {
        _tagListArray = [NSMutableArray array];
    }
    return _tagListArray;
}


#pragma mark - 通知监听
//标题帖删除
-(void)groupTitleDelete:(NSNotification*)object{
    [self refreshTopicData];
}
//团聊点赞
-(void)good:(NSNotification*)object{
    NSDictionary *dic = object.object;
    for (int i = 0;i<self.topicDataArray.count;i++) {
        DiscoverModel *model  = self.topicDataArray[i];
        if ([model.type isEqualToString:@"0"]&&[model.showid isEqualToString:dic[@"receiveid"]]) {
            model.praisestatus = dic[@"praisestatus"];
            model.praisecount =[NSString stringWithFormat:@"%d",[model.praisestatus isEqualToString:@"0"]?model.praisecount.intValue+1:model.praisecount.intValue-1];
            [self.topicTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
    }
}
//团聊评论
-(void)com:(NSNotification*)object{
    NSDictionary *dic = object.object;
    for (int i = 0;i<self.topicDataArray.count;i++) {
        DiscoverModel *model  = self.topicDataArray[i];
        if ([model.type isEqualToString:@"0"]&&[model.showid isEqualToString:dic[@"talkid"]]) {
            model.commentcount =[NSString stringWithFormat:@"%d",model.commentcount.intValue+1];
            [self.topicTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
    }
}
//团聊删除
-(void)delteReply:(NSNotification*)object{
    NSDictionary *dic = object.object;
    for (int i = 0;i<self.topicDataArray.count;i++) {
        DiscoverModel *model  = self.topicDataArray[i];
        if ([model.type isEqualToString:@"0"]&&[model.showid isEqualToString:dic[@"talkid"]]) {
            model.commentcount =[NSString stringWithFormat:@"%d",model.commentcount.intValue-1];
            [self.topicTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
    }
}


#pragma mark - 乐活吧更多
-(void)reportClick:(NSString*)discoverId AndType:(NSString*)type{
    talkid = discoverId;
    [self jubaoShare];
}

- (void)reportClick:(NSString *)talkId andType:(NSString *)type andIndexPath:(NSIndexPath *)indexPath {
    talkid = talkId;
    self.currentIndexPath = indexPath;
    [self jubaoShare];
}
#pragma mark 乐活吧分享
- (void)jubaoShare {
    
    NARShareView *myshareView = [[NARShareView alloc]initWithFrame:self.view.bounds];
    myshareView.narDelegate = self;
    GroupTalkModel *tempModel = [[GroupTalkModel alloc] init];
    GroupTalkTableViewCell *cell;
    DiscoverModel*model = self.topicDataArray[self.currentIndexPath.row];
    tempModel.content = model.content;
    tempModel.imageurl = model.talkimage;
    tempModel.userid = model.userid;
    tempModel.barid = model.showid;
    cell = (GroupTalkTableViewCell *)[self.topicTableView cellForRowAtIndexPath:self.currentIndexPath];
    
    //团聊
    
    UIImage *tempImage = [SSLImageTool scaleToSize:CGSizeMake(120, 120) withImage:cell.contentImageView.image];
    NSData *data = [SSLImageTool compressImage:tempImage withMaxKb:32];
    UIImage *image = [UIImage imageWithData:data];
    GroupHeaderModel *mm = [[GroupHeaderModel alloc] init];
    [myshareView createView:SquareAndDynamicTalkShareType withModel:tempModel withGroupModel:mm];
    [myshareView setShareImage:image];
}
#pragma mark 乐活吧删除

/**
 *  删除乐活吧请求
 *
 *  @param deleteid 团组ID、活动ID
 *  @param deltype  1 删除团聊 2 删除活动
 *
 *  @return void
 */
- (void)requestWithDeleteBarWithDeleteid:(NSString *)deleteid andDelType:(NSString *)deltype {
    
    [self showWaitView];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:deleteid forKey:@"deleteid"];
    [dictionary setObject:@"1" forKey:@"deltype"];
    WEAKSELF_SS
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_Del_Bar parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        [weakSelf removeWaitView];
        
        if (!dic[ERRCODE]) {
            DeleteBarModel *model = [DeleteBarModel objectWithKeyValues:dic];
            //处理成功
            if ([model.result isEqualToString:@"0"]) {
                [weakSelf refreshTopicData];
                [weakSelf showAlertMsg:@"删除成功" andFrame:CGRectZero];
            }
        }
    }];
}
//- (void)requestWithDeleteDynBarWithDeleteid:(NSString *)deleteid andDelType:(NSString *)deltype {
//    
//    [self showWaitView];
//    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
//    [dictionary setObject:deleteid forKey:@"deleteid"];
//    [dictionary setObject:@"1" forKey:@"deltype"];
//    WEAKSELF_SS
//    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_Del_Bar parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
//        [weakSelf removeWaitView];
//        DeleteBarModel *model = [DeleteBarModel objectWithKeyValues:dic];
//        //处理成功
//        if ([model.result isEqualToString:@"0"]) {
//            [weakSelf loadMessageWithIsMore:NO];
//            [weakSelf showAlertMsg:@"删除成功" andFrame:CGRectZero];
//        }
//    }];
//}


#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 777) {//删除撒欢
        if (buttonIndex == 1) {
            if (self.currentIndexPath.section == 0) {
                DiscoverModel *model = self.topicDataArray[self.currentIndexPath.row];
                if ([model.type isEqualToString:@"1"]) {
                    [self requestWithDelShowWithDeleteid:model.showid];
                }else
                    [self requestWithDeleteBarWithDeleteid:model.showid andDelType:@""];
            }
        }
    }
}

/**
 *  删除撒欢
 *
 *  @param deleteid 撒欢ID
 *
 *  @return void
 */
#pragma mark 删除撒欢
- (void)requestWithDelShowWithDeleteid:(NSString *)deleteid {
    
    [self showWaitView];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:deleteid forKey:@"deleteid"];
    
    WEAKSELF_SS
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_Del_Show parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        [weakSelf removeWaitView];
        if (!dic[ERRCODE]) {
            DeleteShowModel *model = [DeleteShowModel objectWithKeyValues:dic];
            //处理成功
            if ([model.result isEqualToString:@"0"]) {
                [weakSelf refreshTopicData];
                [weakSelf showAlertMsg:@"删除成功" andFrame:CGRectZero];
            }
        }
    }];
}
@end




