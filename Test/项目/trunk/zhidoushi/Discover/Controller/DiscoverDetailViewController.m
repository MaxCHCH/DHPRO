//
//  DiscoverDetailViewController.m
//  zhidoushi
//
//  Created by nick on 15/4/22.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "DiscoverDetailViewController.h"
#import "DiscoverReplyModel.h"
#import "DisReplyTableViewCell.h"
#import "IQKeyboardManager.h"
#import "XimageView.h"
#import "MCFireworksButton.h"
#import "GoodListViewController.h"
#import "UIButton+WebCache.h"
#import "MeViewController.h"
#import "UITextField+LimitLength.h"
#import "FaceToolBar.h"
#import "HTCopyableLabel.h"
#import "UIView+ViewController.h"
#import "DiscoverTypeViewController.h"
#import <CoreText/CoreText.h>

@interface DiscoverDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UITextFieldDelegate,FaceToolBarDelegate>

@property(nonatomic,strong)UITableView* table;//tableView
@property(nonatomic,strong)NSMutableArray* data;//数据
@property(nonatomic,strong)MJRefreshHeaderView *header;//头部刷新
@property(nonatomic,strong)MJRefreshFooterView *footer;//底部刷新
@property(nonatomic,assign)int timePageNum;//当前页数
@property(nonatomic,copy)NSString *headimage;//头像
@property(nonatomic,copy)NSString *name;//姓名
@property(nonatomic,copy)NSString *userId;//发表人id
@property(nonatomic,copy)NSString *content;//内容
@property(nonatomic,copy)NSString *time;//时间
@property(nonatomic,copy)NSString *showimage;//配图
@property(nonatomic,copy)NSString *goodsum;//点赞数量
@property(nonatomic,copy)NSMutableArray *goodImages;//点赞头像数组
@property(nonatomic,copy)NSString *bycommentid;//被评论id
@property (weak, nonatomic) MCFireworksButton *goodButton;
@property (weak, nonatomic) UILabel *goodLbl;
@property(copy,nonatomic) NSString* praisestatus;//当前消息的点赞状态
@property(nonatomic,strong)UIView *goodListView;//点赞视图
@property(nonatomic,strong)FaceToolBar *tool;//输入框
@property(nonatomic,assign)BOOL isCanPingLun;//评论
//输入框使用高度
@property(nonatomic,assign)CGFloat headerViewHEIGH;//视图头部高度

//当前选择indexPath
@property (nonatomic,strong) NSIndexPath *currentIndexPath;

@end

@implementation DiscoverDetailViewController

#pragma mark - Life Cycle
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [self.httpOpt cancel];
    [MobClick endLogPageView:@"发现详情页面"];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
    //友盟打点
    [MobClick beginLogPageView:@"发现详情页面"];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    //导航栏标题
    self.titleLabel.text = [NSString stringWithFormat:@"评论"];
    self.titleLabel.textColor = ZDS_DHL_TITLE_COLOR;
    self.titleLabel.font = MyFont(18);
    //导航栏返回
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"fh-36"] forState:UIControlStateNormal];
    [self.leftButton setTitleColor:ZDS_DHL_TITLE_COLOR forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = MyFont(13);
    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width = 16;
    labelRect.size.height = 16;
    self.leftButton.frame = labelRect;
    [self.table reloadData];
}

-(void)dealloc{
    [self.header free];
    [self.footer free];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"撒欢评论详情页面释放");
}

-(void)viewDidAppear:(BOOL)animated{
    [self.view endEditing:YES];
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    [_tool disFaceKeyboard];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.isCanPingLun = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupGUI];
    //初始化回复级别
    self.bycommentid = self.discoverId;
    [self.header beginRefreshing];
}

#pragma mark - 返回上一级
-(void)popButton{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 初始化UI
-(void)setupGUI{
       //初始化tableview
    self.table = [[UITableView alloc] init];
    self.table.dataSource = self;
    self.table.delegate = self;
    self.table.allowsSelection = YES;
    self.table.scrollsToTop = YES;
//    self.table.separatorColor =  [WWTolls colorWithHexString:@"#dcdcdc"];
    self.table.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-114);
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 10)];
    self.view.backgroundColor = [UIColor whiteColor];
    self.table.backgroundColor = [UIColor whiteColor];
    self.table.tableHeaderView = headerView;
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 15)];
    self.table.tableFooterView = headerView;
    [self.view addSubview:self.table];
    
    //初始化刷新
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    self.header = header;
    header.scrollView = self.table;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [self LoadDataWithIsMore:NO];
    };
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    self.footer = footer;
    footer.scrollView = self.table;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [self LoadDataWithIsMore:YES];
    };
    
    //点击手势收起键盘
//    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRActive:)];
//    [self.view addGestureRecognizer:tapGR];
    //键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    //底部输入视图
    FaceToolBar *tool = [[FaceToolBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-48, self.view.frame.size.width, 47) superView:self.view withBarType:UserFeedBackToolBar];
    tool.myTextView.placeholder = @"添加评论";
    tool.faceToolBardelegate = self;
    tool.backgroundColor = [UIColor whiteColor];
    tool.toolBar.backgroundColor = [UIColor whiteColor];
    self.tool = tool;
}


#pragma mark - 加载数据
-(void)LoadDataWithIsMore:(BOOL)isLoadMore{
    
    if(isLoadMore){
        if (self.data.count == 0 ||self.data.count%10!=0||self.data.count<self.timePageNum*10) {
            [self showAlertMsg:@"没有更多了" andFrame:CGRectZero];
            [self.footer endRefreshing];
            return;
        }
    }
    
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:6];
    [dictionary setObject:@"8" forKey:@"praimgcount"];//点赞列表显示数量
    [dictionary setObject:self.discoverId forKey:@"showid"];
    if (isLoadMore) {
        [dictionary setObject:[NSString stringWithFormat:@"%d",self.timePageNum+1] forKey:@"pageNum"];
    }else{
        [dictionary setObject:[NSString stringWithFormat:@"%d",1] forKey:@"pageNum"];
    }
    [dictionary setObject:@"10" forKey:@"pageSize"];
    if(self.lastId!=nil) [dictionary setObject:self.lastId forKey:@"lastid"];
    //发送请求即将开团
    __weak typeof(self)weakSelf = self;
    if (self.httpOpt && ![self.httpOpt isFinished]) {
        if (isLoadMore) {
            [weakSelf.footer endRefreshing];
        }else{
            [weakSelf.header endRefreshing];
        }
        return;
    }
    self.httpOpt = [WWRequestOperationEngine operationManagerRequest_Post:ZDS_DISCOVER_DISCOVERDETAIL parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (dic[ERRCODE]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
            weakSelf.table.hidden = YES;
            weakSelf.tool.toolBar.hidden = YES;
        }else{
            if (isLoadMore) {
                weakSelf.timePageNum++;
            }else{
                weakSelf.timePageNum = 1;
                [weakSelf.data removeAllObjects];
                weakSelf.headimage = dic[@"userimage"];
                weakSelf.name = dic[@"username"];
                weakSelf.content = dic[@"content"];
                weakSelf.time = dic[@"createtime"];
                weakSelf.showimage = dic[@"showimage"];
                weakSelf.goodsum = dic[@"praisecount"];
                weakSelf.praisestatus = dic[@"praisestatus"];
                weakSelf.userId = dic[@"userid"];
                //点赞列表
                NSArray *tempArray = dic[@"userlist"];
                [weakSelf.goodImages removeAllObjects];
                for (NSDictionary *dic in tempArray) {
                    [weakSelf.goodImages addObject:dic];
                }
            }
            NSArray *tempArray = dic[@"commentlist"];
            for (NSDictionary *dic in tempArray) {
                [weakSelf.data addObject:[DiscoverReplyModel modelWithDic:dic]];
                weakSelf.lastId = dic[@"commentid"];
            }
            [weakSelf.table reloadData];
        }
        if (isLoadMore) {
            [weakSelf.footer endRefreshing];
        }else{
            [weakSelf.header endRefreshing];
        }
    }];
}


-(NSMutableArray *)data{
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}
-(NSMutableArray *)goodImages{
    if (_goodImages == nil) {
        _goodImages = [NSMutableArray array];
    }
    return _goodImages;
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return self.data.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DiscoverReplyModel *model = self.data[indexPath.row];
    return [model getCellHeight];
}
#pragma mark - 头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return nil;
    }
    if (self.name.length < 1) {
        return nil;
    }
    //背景视图
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = [UIColor whiteColor];
    
    //头像
    UIImageView *headerView = [[UIImageView alloc] init];
    [headView addSubview:headerView];
    [headerView sd_setImageWithURL:[NSURL URLWithString:self.headimage] placeholderImage:[UIImage imageNamed:@"mrtx_98_98"]];
    headerView.frame = CGRectMake(15, 15, 40, 40);
    headerView.layer.cornerRadius = 20;
    headerView.clipsToBounds = YES;
    headerView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHead)];
    [headerView addGestureRecognizer:tap];
    
    //昵称
    UILabel *lbl = [[UILabel alloc] init];
    lbl.frame = CGRectMake(headerView.maxX + 5, 21, 200, 18);
    lbl.font = MyFont(17);
    lbl.textAlignment = NSTextAlignmentLeft;
    lbl.textColor = TitleColor;
    lbl.text = self.name;
    [headView addSubview:lbl];
    
    //时间
    UILabel *lbltime = [[UILabel alloc] init];
    lbltime.frame = CGRectMake(lbl.left, lbl.maxY + 1, 200, 14);
    lbltime.font = MyFont(12);
    lbltime.textColor = TimeColor;
    lbltime.text = [WWTolls configureTimeString:self.time andStringType:@"M-d HH:mm"];
    [headView addSubview:lbltime];
    
    //配图
    XimageView *showImage = [[XimageView alloc] init];
    [headView addSubview:showImage];
    showImage.backgroundColor = [WWTolls colorWithHexString:@"#e5e5e5"];
    showImage.frame = CGRectMake(0, 55, 0, 0);
    if (self.showimage.length>0) {
        showImage.frame = CGRectMake(15, 70,SCREEN_WIDTH-30 , (SCREEN_WIDTH - 30)*[WWTolls sizeForQNURLStr:self.showimage].height/[WWTolls sizeForQNURLStr:self.showimage].width);
        [showImage sd_setImageWithURL:[NSURL URLWithString:self.showimage]];
    }
//    showImage.contentMode = UIViewContentModeScaleAspectFit;
//    [showImage sd_setImageWithURL:[NSURL URLWithString:self.showimage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        showImage.backgroundColor = [UIColor clearColor];
//    }];
//    if ([WWTolls isNull:self.showimage]) {
//        showImage.frame = CGRectZero;
//    }
    
    CGFloat contentH = [WWTolls heightForString:self.content fontSize:15 andWidth:SCREEN_WIDTH-30]+1;
    //内容
    HTCopyableLabel *lblcontent = [[HTCopyableLabel alloc] init];
    lblcontent.numberOfLines = 0;
    lblcontent.frame = CGRectMake(15, showImage.bottom + 15,SCREEN_WIDTH-30, contentH);
    lblcontent.font = MyFont(15);
    lblcontent.textColor = ContentColor;
    WEAKSELF_SS
    [lblcontent setContent:self.content WithTagClick:^(NSString *tag) {
        DiscoverTypeViewController *typeVC = [[DiscoverTypeViewController alloc] init];
        typeVC.showtag = tag;
        [weakSelf.navigationController pushViewController:typeVC animated:YES];
    } AndOtherClick:^{
        NSLog(@"哈哈哈");
    }];
//    NSRange range = [self.content rangeOfString:@"(^#([^#]+?)#)" options:NSRegularExpressionSearch];
//    if (range.location != NSNotFound && self.content.length>0) {
//        lblcontent.userInteractionEnabled = YES;
//        NSDictionary* style3 = @{@"body":@[[WWTolls colorWithHexString:@"#535353"],[UIFont fontWithName:@"HelveticaNeue" size:14.0] ],
//                                 @"help":[WPAttributedStyleAction styledActionWithAction:^{
//                                     [weakSelf tagLabelAction];
//                                 }],
//                                 @"link": [WWTolls colorWithHexString:@"#ff8a01"]};
//                            
//        NSString *tagString = [self.content substringWithRange:range];
//        NSString *afterStirng = [self.content substringWithRange:NSMakeRange(range.location + range.length, self.content.length - range.length)];
//        
//        lblcontent.attributedText = [[NSString stringWithFormat:@"<help>%@</help>%@",tagString,afterStirng] attributedStringWithStyleBook:style3];
//        [lblcontent setSelectableRange:range hightlightedBackgroundColor:[WWTolls colorWithHexString:@"#eaeaea"]];
//    } else {
//        lblcontent.userInteractionEnabled = NO;
//        lblcontent.text = self.content;
//    }
    
    [headView addSubview:lblcontent];
    
//    headerView.backgroundColor = [UIColor yellowColor];
    
    //点赞
    MCFireworksButton *redXin = [[MCFireworksButton alloc] initWithFrame:CGRectMake(15, (self.content.length>0?lblcontent.bottom:showImage.bottom) + 23, 19, 19)];
    self.goodButton = redXin;
    self.goodButton.particleImage = [UIImage imageNamed:@"RedSparkle"];
    self.goodButton.particleScale = 0.05;
    self.goodButton.particleScaleRange = 0.02;
    
    if ([self.praisestatus isEqualToString:@"1"]) {
        [redXin setBackgroundImage:[UIImage imageNamed:@"jy-32.png"] forState:UIControlStateNormal];
    }else if ([self.praisestatus isEqualToString:@"0"]){
        [redXin setBackgroundImage:[UIImage imageNamed:@"jy-36-.png"] forState:UIControlStateNormal];
    }
    
    [redXin addTarget:self action:@selector(goodBtn:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:redXin];

    //点赞人头像
    CGFloat margin = 5;
    CGFloat width = 34;
    
    UIView *goodlistView = [[UIView alloc] initWithFrame:CGRectMake(self.goodButton.maxX + 7, self.goodButton.top - 8, SCREEN_WIDTH - self.goodButton.right - 7, width)];
    [headView addSubview:goodlistView];
    self.goodListView = goodlistView;
    
    CGFloat x = 0;
    for (int i = 0; i<self.goodImages.count; i++) {
        
        UIButton *head = [[UIButton alloc] init];
        head.frame = CGRectMake(x, 0, width, width);
        [head makeCorner:width / 2];
        [head sd_setBackgroundImageWithURL:[NSURL URLWithString:self.goodImages[i][@"imageurl"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"mrtx_98_98"]];
        head.titleLabel.text = self.goodImages[i][@"userid"];
        [head addTarget:self action:@selector(clickGoodMan:) forControlEvents:UIControlEventTouchUpInside];
        [goodlistView addSubview:head];
        
        x += margin + width;
        if (x + width*2 > goodlistView.width) {
            break;
        }
    }
    
    if (self.goodImages.count > 0) {
        
        //更多按钮
        UIButton *moreBtn = [[UIButton alloc] init];
        moreBtn.frame = CGRectMake(x, 0, width, width);
        moreBtn.titleLabel.font = MyFont(10);
        [moreBtn setTitleColor:OrangeColor forState:UIControlStateNormal];
        [moreBtn setTitle:[NSString stringWithFormat:@"%@+",self.goodsum] forState:UIControlStateNormal];
        moreBtn.layer.cornerRadius = width/2;
        moreBtn.clipsToBounds = YES;
        moreBtn.layer.borderColor = OrangeColor.CGColor;
        moreBtn.layer.borderWidth = 0.5;
//        [moreBtn setBackgroundImage:[UIImage imageNamed:@"gdjy-100-50.png"] forState:UIControlStateNormal];
        [goodlistView addSubview:moreBtn];
        [moreBtn addTarget:self action:@selector(goToGoodList) forControlEvents:UIControlEventTouchUpInside];
    }
    
//    UIView *grayView = [[UIView alloc] init];
//    grayView.frame = CGRectMake(0, beforeHeight + 20 + width, SCREEN_WIDTH, 10);
//    [headView addSubview:grayView];
//    grayView.backgroundColor = [WWTolls colorWithHexString:@"#efefef"];
    
//    if (self.data.count>0) {
//        grayView.layer.borderWidth = 0.5;
//        grayView.layer.borderColor = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;
//    }
    return headView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 0;
    }
    CGFloat h = 135;
    
    if (self.content.length>0) {
        h += [WWTolls heightForString:self.content fontSize:15 andWidth:(SCREEN_WIDTH-30)];
    }else h-=15;
    if (![WWTolls isNull:self.showimage])  {
        h += (SCREEN_WIDTH - 30)*[WWTolls sizeForQNURLStr:self.showimage].height/[WWTolls sizeForQNURLStr:self.showimage].width + 15;
    }
    self.headerViewHEIGH = h;
    return h;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DisReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"discoverReplyCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"DisReplyTableViewCell" owner:self options:nil]lastObject];
    }
    cell.model = self.data[indexPath.row];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMan:)];
    [cell addGestureRecognizer:tap];
    return cell;
}

-(void)clickMan:(UIGestureRecognizer*)tap{
    DiscoverReplyModel *model = ((DisReplyTableViewCell*)tap.view).model;
    if ([model.userid isEqualToString:[NSUSER_Defaults objectForKey:ZDS_USERID]]) {
        _tool.myTextView.placeholder = @"添加评论";
        self.bycommentid = self.discoverId;
        return;
    }
    _tool.myTextView.placeholder = [NSString stringWithFormat:@"回复:%@",model.username];
    [_tool.myTextView becomeFirstResponder];
    self.bycommentid = model.commentid;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//选择评论发表二级回复
    DiscoverReplyModel *model = self.data[indexPath.row];
    if ([model.userid isEqualToString:[NSUSER_Defaults objectForKey:ZDS_USERID]]) {
        _tool.myTextView.placeholder = @"添加评论";
        self.bycommentid = self.discoverId;
        return;
    }
    _tool.myTextView.placeholder = [NSString stringWithFormat:@"回复:%@",model.username];
    [_tool.myTextView becomeFirstResponder];
    self.bycommentid = model.commentid;
}

//Editing
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

//对选中的Cell根据editingStyle进行操作
- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSLog(@"删除评论事件");
        
        self.currentIndexPath = indexPath;
        [self requestWithDelcomment];
    }
}

//Editing
//当在Cell上滑动时会调用此函数
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DiscoverReplyModel *model = self.data[indexPath.row];
    
    NSString *myUserId = [[NSUserDefaults standardUserDefaults] objectForKey:ZDS_USERID];
    
    //自己发布的撒欢 (可以删除所有人的评论) || 不是自己发布的撒欢是自己发布的评论可以删除
    if ([self.userId isEqualToString:myUserId] || [model.userid isEqualToString:myUserId]) {
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self tapGRActive:nil];
    NSLog(@"scrollViewWillBeginDragging");
}



#pragma mark - Event Response

#pragma mark - Private Methods

#pragma mark - Request
#pragma mark 删除撒欢评论
- (void)requestWithDelcomment {
    
    [self showWaitView];
    
    DiscoverReplyModel *currentModel = self.data[self.currentIndexPath.row];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:currentModel.commentid forKey:@"commentid"];
    WEAKSELF_SS
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_DELCOMMENT parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        [weakSelf removeWaitView];
        if ([dic[@"result"] isEqualToString:@"0"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteDiscover" object:@{@"showid":weakSelf.discoverId}];
            [weakSelf showAlertMsg:@"删除成功" andFrame:CGRectZero];
            [weakSelf.data removeObjectAtIndex:self.currentIndexPath.row];
            [weakSelf.table deleteRowsAtIndexPaths:@[self.currentIndexPath] withRowAnimation:UITableViewRowAnimationRight];
        }
    }]; 
}

#pragma mark - 头像点击事件
-(void)clickHead{
    if (self.userId.length<1) {
        return;
    }
    MeViewController *single = [[MeViewController alloc]init];
    single.userID = self.userId;
    single.otherOrMe = 1;
    [self.navigationController pushViewController:single animated:YES];
}
-(void)clickGoodMan:(UIButton*)btn{
    MeViewController *single = [[MeViewController alloc]init];
    single.userID = btn.titleLabel.text;
    single.otherOrMe = 1;
    [self.navigationController pushViewController:single animated:YES];
}


#pragma mark - 前往点赞列表
-(void)goToGoodList{
    GoodListViewController *good = [[GoodListViewController alloc] init];
    good.goodType = @"3";
    good.goodId = self.discoverId;
    [self.navigationController pushViewController:good animated:YES];
}

#pragma mark - 点赞
- (void)goodBtn:(id)sender {
    self.goodButton.userInteractionEnabled = NO;
    [self.goodButton popOutsideWithDuration:0.5];
    if ([self.praisestatus isEqualToString:@"1"]) {//如果用户未被赞
        
        [self clickGoodSender:@"0"];
    }else{
        
        [self clickGoodSender:@"1"];
        
    }
}
-(void)clickGoodSender:(NSString*)praisesta
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setObject:self.discoverId forKey:@"receiveid"];
    [dictionary setValue:praisesta forKey:@"praisestatus"];
    [dictionary setObject:@"3" forKey:@"praisetype"];//0 赞人/1 赞游戏/2赞团聊
    __weak typeof(self) weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_PRAISE_104 parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        weakSelf.goodButton.userInteractionEnabled = YES;
        if ([dic[@"result"] isEqualToString:@"0"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"goodyouDiscover" object:dictionary];
            [weakSelf reloadGoodMan];
            
        }
        
    }];
    if ([self.praisestatus isEqualToString:@"0"]) {
        self.praisestatus = @"1";
        [self.goodButton setBackgroundImage:[UIImage imageNamed:@"jy-32"] forState:UIControlStateNormal];
        [self.goodButton popInsideWithDuration:0.4];
        self.goodsum = [NSString stringWithFormat:@"%d",self.goodsum.intValue-1];
    }else{
        [self.goodButton setBackgroundImage:[UIImage imageNamed:@"jy-36-"] forState:UIControlStateNormal];
        self.praisestatus = @"0";
        [self.goodButton popOutsideWithDuration:0.5];
        [self.goodButton animate];
        self.goodsum = [NSString stringWithFormat:@"%d",self.goodsum.intValue+1];
    }
    
}
#pragma mark - 刷新点赞列表
-(void)reloadGoodMan{
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:6];
    [dictionary setObject:@"1" forKey:@"pageNum"];
    [dictionary setObject:@"7" forKey:@"pageSize"];
    [dictionary setObject:@"3" forKey:@"praisetype"];
    [dictionary setObject:self.discoverId forKey:@"receiveid"];
    
    //发送请求感兴趣的人
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_DISCOVER_GOOD parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        if (!dic[ERRCODE]) {
            NSArray *tempArray = dic[@"userlist"];
            [weakSelf.goodImages removeAllObjects];
            [weakSelf.goodImages addObjectsFromArray:tempArray];
            CGFloat margin = 5;
            CGFloat width = 34;
            for (UIView *btn in weakSelf.goodListView.subviews){
                [btn removeFromSuperview];
            }
            CGFloat x = 0;
            for (int i = 0; i<self.goodImages.count; i++) {
                
                UIButton *head = [[UIButton alloc] init];
                head.frame = CGRectMake(x, 0, width, width);
                [head makeCorner:width / 2];
                [head sd_setBackgroundImageWithURL:[NSURL URLWithString:self.goodImages[i][@"imageurl"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"mrtx_98_98"]];
                head.titleLabel.text = self.goodImages[i][@"userid"];
                [head addTarget:self action:@selector(clickGoodMan:) forControlEvents:UIControlEventTouchUpInside];
                [weakSelf.goodListView addSubview:head];
                
                x += margin + width;
                if (x + width*2 > weakSelf.goodListView.width) {
                    break;
                }
            }
            
            if (self.goodImages.count > 0) {
                
                //更多按钮
                UIButton *moreBtn = [[UIButton alloc] init];
                moreBtn.frame = CGRectMake(x, 0, width, width);
                moreBtn.titleLabel.font = MyFont(10);
                [moreBtn setTitleColor:OrangeColor forState:UIControlStateNormal];
                [moreBtn setTitle:[NSString stringWithFormat:@"%@+",self.goodsum] forState:UIControlStateNormal];
                moreBtn.layer.cornerRadius = width/2;
                moreBtn.clipsToBounds = YES;
                moreBtn.layer.borderColor = OrangeColor.CGColor;
                moreBtn.layer.borderWidth = 0.5;
                //        [moreBtn setBackgroundImage:[UIImage imageNamed:@"gdjy-100-50.png"] forState:UIControlStateNormal];
                [weakSelf.goodListView addSubview:moreBtn];
                [moreBtn addTarget:self action:@selector(goToGoodList) forControlEvents:UIControlEventTouchUpInside];
                
                //        UILabel *countLable = [[UILabel alloc] initWithFrame:CGRectMake(1, 5,40, 14)];
                //        countLable.text = self.goodsum;
                //        countLable.textAlignment = NSTextAlignmentCenter;
                //        countLable.font = [UIFont fontWithName:@"Helvetica Neue" size:14.0];
                //        countLable.textColor = [WWTolls colorWithHexString:@"#ffffff"];
                //        self.goodLbl = countLable;
                //        [moreBtn addSubview:countLable];
            }

//            //点赞人头像
//            CGFloat margin = 6;
//            CGFloat width = 25;
//            for (UIView *btn in weakSelf.goodListView.subviews){
//                [btn removeFromSuperview];
//            }
//            CGFloat x = 0;
//            for (int i = 0; i<weakSelf.goodImages.count; i++) {
//                UIButton *head = [[UIButton alloc] init];
//                head.frame = CGRectMake(x, 0, width, width);
//                head.clipsToBounds = YES;
//                head.layer.cornerRadius = width/2;
//                [head sd_setBackgroundImageWithURL:[NSURL URLWithString:self.goodImages[i][@"imageurl"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"mrtx_98_98"]];
//                head.titleLabel.text = self.goodImages[i][@"userid"];
//                head.userInteractionEnabled = YES;
//                [head addTarget:weakSelf action:@selector(clickGoodMan:) forControlEvents:UIControlEventTouchUpInside];
//                [weakSelf.goodListView addSubview:head];
//                x+=margin+width;
//            }
//            if (self.goodImages.count>0) {
//                //更多按钮
//                UIButton *moreBtn = [[UIButton alloc] init];
//                moreBtn.frame = CGRectMake(x, 0, 50, 25);
//                [moreBtn setBackgroundImage:[UIImage imageNamed:@"gdjy-100-50"] forState:UIControlStateNormal];
//                [weakSelf.goodListView addSubview:moreBtn];
//                [moreBtn addTarget:weakSelf action:@selector(goToGoodList) forControlEvents:UIControlEventTouchUpInside];
//                
//                UILabel *countLable = [[UILabel alloc] initWithFrame:CGRectMake(1, 5,40, 14)];
//                countLable.text = self.goodsum;
//                countLable.textAlignment = NSTextAlignmentCenter;
//                countLable.font = [UIFont fontWithName:@"Helvetica Neue" size:14.0];
//                countLable.textColor = [WWTolls colorWithHexString:@"#ffffff"];
//                self.goodLbl = countLable;
//                [moreBtn addSubview:countLable];
//            }
        }
        [weakSelf.header endRefreshing];
    }];
}


#pragma mark - 键盘处理
#pragma mark 键盘即将显示
- (void)keyBoardWillShow:(NSNotification *)note{
    _tool.faceboardIsShow = YES;
    _tool.keyboardIsShow = YES;
    [_tool disFaceKeyboard];
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = - rect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, ty);
        if ([self.bycommentid isEqualToString:self.discoverId]) {//一级评论
            if (SCREEN_HEIGHT + ty - 77>=self.headerViewHEIGH) {
                self.table.contentOffset = CGPointMake(0, ty);
            }else{
                self.table.contentOffset = CGPointMake(0, self.headerViewHEIGH - SCREEN_HEIGHT+106);
            }
        }else{//二级评论
            CGFloat h = self.headerViewHEIGH;
            for (DiscoverReplyModel *model in self.data) {
                NSString *s;
                if ([model.commentlevel isEqualToString:@"1"]) {
                    s = model.content;
                }else{
                    s = [NSString stringWithFormat:@"回复%@:%@",model.byusername,model.content];
                }
                h += [WWTolls heightForString:s fontSize:14 andWidth:SCREEN_WIDTH-66];
                h+= 54;
                if ([model.commentid isEqualToString:self.bycommentid]) {
                    break;
                }
            }
            h += 18;
            if (SCREEN_HEIGHT + ty-77>=h) {
                self.table.contentOffset = CGPointMake(0, ty);
            }else{
                self.table.contentOffset = CGPointMake(0, h - SCREEN_HEIGHT+106);
            }

            
        }
    }];
    
}

#pragma mark 键盘即将退出
- (void)keyBoardWillHide:(NSNotification *)note{
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.transform = CGAffineTransformIdentity;
        self.table.contentOffset = CGPointZero;
    }];
}

-(void)tapGRActive:(UITapGestureRecognizer *)tapGR
{
    if (_tool.myTextView.text.length<1) {
        _tool.myTextView.placeholder = @"添加评论";
        self.bycommentid = self.discoverId;
    }
    if (_tool.faceboardIsShow) {
        [_tool disFaceKeyboard];
    }
    [self.view endEditing:YES];
}

-(void)faceSendBtnClick{
    [self sendDidClick];
    [_tool disFaceKeyboard];
    [self.view endEditing:YES];
}

#pragma mark - 文本框代理方法
#pragma mark 点击textField键盘的回车按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [self commitPingLun];
    return YES;
}

#pragma mark - 发表评论
-(void)sendDidClick{
//    [_tool disFaceKeyboard];
    [self commitPingLun];
}


-(void)commitPingLun{
    if ([_tool.myTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length < 1) {
        [self.view endEditing:YES];
        [self showAlertMsg:@"不能发布空评论" yOffset:0];
        return;
    }else if(_tool.myTextView.text.length > 1000){
        [self.view endEditing:YES];
        [self showAlertMsg:@"评论内容最多1000字" yOffset:0];
        return;
    }else if([WWTolls isHasSensitiveWord:_tool.myTextView.text]){
        [self.view endEditing:YES];
        [self showAlertMsg:ZDS_HASSENSITIVE yOffset:0];
        return;
    }
    if (!self.isCanPingLun) {
        return;
    }
    self.isCanPingLun = NO;
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:6];
    [dictionary setObject:_tool.myTextView.text forKey:@"content"];
    [dictionary setObject:self.discoverId forKey:@"showid"];
    [dictionary setObject:self.bycommentid forKey:@"bycommentid"];
    [dictionary setObject:[self.discoverId isEqualToString:self.bycommentid]?@"1":@"2" forKey:@"commentlevel"];
    
    //发送请求评论
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_FABU_PINLUN parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        self.isCanPingLun = YES;
        if ([dic[@"result"] isEqualToString:@"0"]) {//成功
            [[NSNotificationCenter defaultCenter] postNotificationName:@"comyouDiscover" object:dictionary];
            [weakSelf.view endEditing:YES];
            //刷新数据
            [weakSelf LoadDataWithIsMore:NO];
            
            [weakSelf showAlertMsg:@"评论成功" andFrame:CGRectZero];
            weakSelf.bycommentid = weakSelf.discoverId;
            weakSelf.tool.myTextView.placeholder = @"添加评论";
            if (weakSelf.data.count>0) {
                [weakSelf.table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
            //清空文本框内容
            _tool.myTextView.text = nil;
            
        }
    }];
}


@end
