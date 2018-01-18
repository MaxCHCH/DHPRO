//
//  MyActivesViewController.m
//  zhidoushi
//
//  Created by nick on 15/11/14.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import "MyActivesViewController.h"
#import "DiscoverDetailViewController.h"
#import "DiscoverListTableViewCell.h"
#import "XimageView.h"
#import "MLImageCrop.h"
#import "DiscoverModel.h"
#import "NARShareView.h"
#import "DeleteShowModel.h"
#import "MJExtension.h"
#import "SSLImageTool.h"
#import "GroupViewController.h"
#import "OfficialInformTableViewCell.h"
#import "GroupTalkDetailViewController.h"
#import "ArticleTableViewCell.h"
#import "GroupTalkTableViewCell.h"
#import "DeleteBarModel.h"
#import "ZDSPhotosViewController.h"
#import "MyArticleListViewController.h"

@interface MyActivesViewController ()
{
    UIActionSheet *myActionSheetView;//举报行为
    NSString *talkid;//团聊更多
}
@property(nonatomic,copy)NSString *disCoverId;//举报id
@property(nonatomic,strong)NSIndexPath *currentIndexPath;//当前indexPath
@property(nonatomic,strong)UIImagePickerController *picker;//相片选择
@property(nonatomic,assign)BOOL isNew;//七牛图片token获取
@property(nonatomic,strong)UITableView* DisCoverTable;//tableView
@property(nonatomic,strong)NSMutableArray* data;//数据
@property(nonatomic,strong)MJRefreshHeaderView *header;//头部刷新
@property(nonatomic,strong)MJRefreshFooterView *footer;//底部刷新
@property(nonatomic,assign)int timePageNum;//当前页数
@property(nonatomic,copy)NSString *topImage;//介绍图片
@end

@implementation MyActivesViewController


#pragma mark - Life Cycle
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.httpOpt cancel];
    [MobClick endLogPageView:@"个人动态页面"];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //友盟打点
    [MobClick beginLogPageView:@"个人动态页面"];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    //导航栏标题
    self.titleLabel.textColor = ZDS_DHL_TITLE_COLOR;
    self.titleLabel.font = MyFont(18);
    self.titleLabel.text = @"动态";
    
    //导航栏返回
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"fh-36"] forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = MyFont(13);
    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width = 18;
    labelRect.size.height = 18;
    self.leftButton.frame = labelRect;
    
    //    self.leftButton.bounds = CGRectMake(0, 0, 18, 18);
    //    self.leftButton.enabled = NO;
    self.rightButton.titleLabel.font = MyFont(16);
    self.rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.rightButton.bounds = CGRectMake(0, 0, 40, 18);
    [self.rightButton setTitle:@"相册" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:OrangeColor forState:UIControlStateNormal];
//    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"discover_fabu-38"] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(goToAblum) forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    
    [self setupGUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sucess:) name:@"adddiscoverSucess" object:nil];
    [self.header beginRefreshing];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(good:) name:@"goodyouDiscover" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(com:) name:@"comyouDiscover" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteDiscover:) name:@"deleteDiscover" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyHiden) name:@"notifyToggle" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goodTalk:) name:@"goodReply" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(comTalk:) name:@"comReply" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delteReply:) name:@"delteReply" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupTitleDelete:) name:@"grouptitletoggle" object:nil];
}
- (void)notifyHiden{
    self.DisCoverTable.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT - 24);
}

-(void)dealloc{
    [self.header free];
    [self.footer free];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UI
#pragma mark 初始化UI
-(void)setupGUI{
    //初始化空页面
    self.view.backgroundColor = ZDS_BACK_COLOR;
    UIView *ttheader = [[UIView alloc] init];
    ttheader.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
    UIView *bView = [[UIView alloc] initWithFrame:CGRectMake(0, 14, SCREEN_WIDTH, 50)];
    bView.backgroundColor = [UIColor whiteColor];
    [ttheader addSubview:bView];
    
    UILabel *blbl = [UILabel new];
    blbl.font = MyFont(15);
    blbl.textColor = TitleColor;
    blbl.text = @"我的收藏";
    blbl.frame = CGRectMake(15, 0, 100, 50);
    [bView addSubview:blbl];
    
    UIImageView *jtt = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 15 -7, 20, 7, 10)];
    jtt.image = [UIImage imageNamed:@"jt-14-20"];
    [bView addSubview:jtt];
    
    UITapGestureRecognizer *ttap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToCollection)];
    [bView addGestureRecognizer:ttap];
    if([self.seeUserID isEqualToString:[NSUSER_Defaults objectForKey:ZDS_USERID]]){
        [self.view addSubview:ttheader];
    }
    
    UIImageView *tt = [[UIImageView alloc] init];
    tt.image = [UIImage imageNamed:@"kbicon-120"];
    tt.frame = CGRectMake(SCREEN_MIDDLE(60), 140, 60, 60);
    [self.view addSubview:tt];
    UILabel *ll = [[UILabel alloc] initWithFrame:CGRectMake(0, tt.bottom + 20, SCREEN_WIDTH, 27)];
    ll.font = MyFont(13);
    ll.textColor = TimeColor;
    ll.textAlignment = NSTextAlignmentCenter;
    ll.text = [self.seeUserID isEqualToString:[NSUSER_Defaults objectForKey:ZDS_USERID]]?@"你还没有发布过动态\n快去团组里活跃起来":@"这个人没有发布过动态";
    [self.view addSubview:ll];
    
    
    //发现列表
    UITableView *tableView = [[UITableView alloc] init];
    tableView.scrollsToTop = YES;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = ZDS_BACK_COLOR;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    tableView.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    [self.view addSubview:tableView];
    //headerview
    UIView *tableheader = [[UIView alloc] init];
    tableheader.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, 14, SCREEN_WIDTH, 50)];
    btnView.backgroundColor = [UIColor whiteColor];
    [tableheader addSubview:btnView];
    
    UILabel *lbl = [UILabel new];
    lbl.font = MyFont(15);
    lbl.textColor = TitleColor;
    lbl.text = @"我的收藏";
    lbl.frame = CGRectMake(15, 0, 100, 50);
    [btnView addSubview:lbl];
    
    UIImageView *jt = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 15 -7, 20, 7, 10)];
    jt.image = [UIImage imageNamed:@"jt-14-20"];
    [btnView addSubview:jt];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToCollection)];
    [btnView addGestureRecognizer:tap];
    
    if([self.seeUserID isEqualToString:[NSUSER_Defaults objectForKey:ZDS_USERID]])tableView.tableHeaderView = tableheader;
    
    
    self.DisCoverTable = tableView;
    
    //初始化刷新
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    self.header = header;
    header.scrollView = tableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [self LoadDataWithIsMore:NO];
    };
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    self.footer = footer;
    footer.scrollView = tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [self LoadDataWithIsMore:YES];
    };
}


#pragma mark - 点击跳转我的收藏页面
-(void)goToCollection{
    MyArticleListViewController *art = [[MyArticleListViewController alloc] init];
    [self.navigationController pushViewController:art animated:YES];
}

#pragma mark - Delegate
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

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 777) {
        if (buttonIndex == 1) {
            //删除操作
            DiscoverModel *model = self.data[self.currentIndexPath.row];
            [self requestWithDelShowWithDeleteid:model.showid];
        }
    }
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 999) {
        
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

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DiscoverModel *model = self.data[indexPath.row];
    
    /**
     *  1 : 团组动态
     2 : 用户撒欢
     */
    if ([model.showkind isEqualToString:@"0"]) {
        
        DiscoverListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DiscoverListTableViewCell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"DiscoverListTableViewCell" owner:self options:nil]lastObject];
        }
        
        cell.delegate = self;
        cell.indexPath = indexPath;
        cell.model = model;
        return cell;
    }else if ([model.showkind isEqualToString:@"1"]){
        
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
    }else if ([model.showkind isEqualToString:@"2"]) {
        NSString *CellIdentifier = @"ZDSGroupActicalCell";
        
        ArticleTableViewCell *groupCell = [tableView dequeueReusableCellWithIdentifier:
                                           CellIdentifier];
        
        if (groupCell==nil) {
            groupCell = [[[NSBundle mainBundle]loadNibNamed:@"ArticleTableViewCell" owner:self options:nil]lastObject];
            groupCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [groupCell setUpWithDiscoverModel:model];
        return groupCell;
    }
    
    
    return nil;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DiscoverModel *model = self.data[indexPath.row];
    if ([model.showkind isEqualToString:@"0"]){//撒欢
        return [model getDiscoverHeight];
    }else if ([model.showkind isEqualToString:@"1"]){//乐活吧同步
        
        CGFloat h = [GroupTalkTableViewCell getShowCellHeight:self.data[indexPath.row]]+6;
        h+=2;
        return h;
    }else if ([model.showkind isEqualToString:@"2"]) {//精华帖
        if (!model.talkimage || model.talkimage.length<1) {
            NSString *content = [[model.content stringByReplacingOccurrencesOfString:@"\r" withString:@" "] stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
            CGFloat heigh = [WWTolls heightForString:content fontSize:13 andWidth:SCREEN_WIDTH - 30];
            if (heigh<55) {
                return 97 + heigh;
            }else return 147;
        }
        return 147;
    }
    return [model getDiscoverHeight];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DiscoverModel *model = self.data[indexPath.row];
    if([model.showkind isEqualToString:@"2"]){
        DiscoverDetailViewController *dd = [[DiscoverDetailViewController alloc] init];
        dd.discoverId = model.showid;
        [self.navigationController pushViewController:dd animated:YES];
    }else if([model.showkind isEqualToString:@"1"]){
        GroupViewController *group = [[GroupViewController alloc] init];
        group.clickevent = 7;
        group.joinClickevent = @"7";
        group.groupId = model.gameid;
        [self.navigationController pushViewController:group animated:YES];
    }else if ([model.showkind isEqualToString:@"3"]){//乐活吧同步
        if (model.title && model.title.length > 0) {
            GroupTalkDetailViewController *talk = [[GroupTalkDetailViewController alloc] init];
            talk.talktype = GroupTitleTalkType;
            talk.clickevent = 1;
            talk.talkid = model.showid;
            model.pageview = [NSString stringWithFormat:@"%d",model.pageview.intValue+1];
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.navigationController pushViewController:talk animated:YES];
        }
        else if ([model.isparter isEqualToString:@"0"]) {
            GroupTalkDetailViewController *reply = [[GroupTalkDetailViewController alloc] init];
            reply.talkid = model.showid;
            [self.navigationController pushViewController:reply animated:YES];
        }else{
            GroupViewController *group = [[GroupViewController alloc] init];
            group.clickevent = 5;
            group.joinClickevent = @"5";
            group.groupId = model.gameid;
            [self.navigationController pushViewController:group animated:YES];
        }
    }
}

#pragma mark - Event Responses

#pragma mark 返回上一级
-(void)popButton{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 点击进入个人相册页面
- (void)goToAblum{
    ZDSPhotosViewController *ablum = [[ZDSPhotosViewController alloc] init];
    ablum.seeUserID = self.seeUserID;
    [self.navigationController pushViewController:ablum animated:YES];
}

#pragma mark - Private Methods
//分享图文
- (void)shareImageAndText {
    
    NARShareView *myshareView = [[NARShareView alloc]initWithFrame:self.view.bounds];
    myshareView.narDelegate = self;
    
    DiscoverModel *tempModel = nil;
    int i = 0;
    for (; i < self.data.count; i++) {
        DiscoverModel *model = self.data[i];
        if ([model.showid isEqualToString:self.disCoverId]) {
            tempModel = model;
            break;
        }
    }
    
    [myshareView createView:DiscoverShareType withModel:tempModel withGroupModel:nil];
    DiscoverListTableViewCell *cell = (DiscoverListTableViewCell *)[self.DisCoverTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    
    if (cell.photoImage.image) {
        UIImage *tempImage = [SSLImageTool scaleToSize:CGSizeMake(120, 120) withImage:cell.photoImage.image];
        NSData *data = [SSLImageTool compressImage:tempImage withMaxKb:32];
        
        [myshareView setShareImage:[UIImage imageWithData:data]];
    } else {
        [myshareView setShareImage:nil];
    }
}

#pragma mark 加载数据
-(void)LoadDataWithIsMore:(BOOL)isLoadMore{
    
    if(isLoadMore){
        if (self.data.count == 0 ||self.data.count%10!=0||self.data.count<self.timePageNum*10) {
            [self showAlertMsg:@"没有更多了" andFrame:CGRectZero];
            [self.footer endRefreshing];
            return;
        }
    }
    
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:5];
    if (isLoadMore) {
        [dictionary setObject:[NSString stringWithFormat:@"%d",self.timePageNum+1] forKey:@"pageNum"];
    }else{
        [dictionary setObject:[NSString stringWithFormat:@"%d",1] forKey:@"pageNum"];
    }
    [dictionary setObject:@"10" forKey:@"pageSize"];
    if(isLoadMore && self.lastId!=nil) {
        [dictionary setObject:self.lastId forKey:@"createtime"];
    }
    [dictionary setObject:self.seeUserID forKey:@"seeuserid"];
    [dictionary setObject:@"0,1,2" forKey:@"type"];
    
    //发送请求
    __weak typeof(self)weakSelf = self;
    if (self.httpOpt && !self.httpOpt.finished) {
        if (isLoadMore) {
            [weakSelf.footer endRefreshing];
        }else{
            [weakSelf.header endRefreshing];
        }
        return;
    }
    self.httpOpt = [WWRequestOperationEngine operationManagerRequest_Post:@"/me/dynamic.do" parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        if (!dic[ERRCODE]) {
            NSArray *tempArray = dic[@"dynamiclist"];
            if (isLoadMore) {
                weakSelf.timePageNum++;
            }else{
                weakSelf.timePageNum = 1;
                [weakSelf.data removeAllObjects];
                if (tempArray.count == 0) {
                    weakSelf.DisCoverTable.hidden = YES;
                }
            }
            for (NSDictionary *dic in tempArray) {
                DiscoverModel *model = [DiscoverModel modelWithDic:dic];
                model.showid = dic[@"dynamicid"];
                model.showtype = dic[@"type"];
                model.showkind = dic[@"type"];
                model.showimage = dic[@"imageurl"];
                model.talkimage = dic[@"imageurl"];
                [weakSelf.data addObject:model];
                weakSelf.lastId = dic[@"dynamicList"];
            }
            [weakSelf.DisCoverTable reloadData];
        }
        if (isLoadMore) {
            [weakSelf.footer endRefreshing];
        }else{
            [weakSelf.header endRefreshing];
        }
    }];
}

#pragma mark - Request


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
                [weakSelf LoadDataWithIsMore:NO];
                [weakSelf showAlertMsg:@"删除成功" andFrame:CGRectZero];
            }
        }
    }];
}

#pragma mark - NSNotificationCenter

-(void)good:(NSNotification*)object{
    NSDictionary *dic = object.object;
    for (int i = 0;i<self.data.count;i++) {
        DiscoverModel *model  = self.data[i];
        if ([model.showid isEqualToString:dic[@"receiveid"]]) {
            model.praisestatus = dic[@"praisestatus"];
            model.praisecount =[NSString stringWithFormat:@"%d",[model.praisestatus isEqualToString:@"0"]?model.praisecount.intValue+1:model.praisecount.intValue-1];
            [self.DisCoverTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}
-(void)com:(NSNotification*)object{
    NSDictionary *dic = object.object;
    for (int i = 0;i<self.data.count;i++) {
        DiscoverModel *model  = self.data[i];
        if ([model.showid isEqualToString:dic[@"showid"]]) {
            model.commentcount =[NSString stringWithFormat:@"%d",model.commentcount.intValue+1];
            [self.DisCoverTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

//删除
- (void)deleteDiscover:(NSNotification *)object {
    
    NSDictionary *dic = object.object;
    for (int i = 0;i<self.data.count;i++) {
        DiscoverModel *model  = self.data[i];
        if ([model.showid isEqualToString:dic[@"showid"]]) {
            model.commentcount =[NSString stringWithFormat:@"%d",model.commentcount.intValue-1];
            [self.DisCoverTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

#pragma mark 发布成功
- (void)sucess:(NSNotification*)no{
}

#pragma mark - Getters And Setters
-(NSMutableArray *)data{
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}

-(void)removeMyActionSheet
{
    if (myActionSheetView!=nil) {
        [myActionSheetView removeFromSuperview];
    }
}

-(void)reportButtonSender
{
    NSLog(@"-------------点击了举报");
    myActionSheetView = [[UIActionSheet alloc] initWithTitle:@"选择举报类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"垃圾营销",@"淫秽信息",@"不实信息",@"敏感信息",@"其他", nil];
    [myActionSheetView showInView:self.view];
    
}


#pragma mark - 举报接口
-(void)postReport:(NSString*)ifmtype{
    //    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:5];
    //    [dictionary setObject:self.disCoverId forKey:@"receiveid"];
    //    [dictionary setObject:ifmtype forKey:@"ifmtype"];
    //    [dictionary setObject:@"2" forKey:@"ifmkind"];//0 讨论举报1 回复举报
    //    __weak typeof(self)weakSelf = self;
    //    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_TALKINFORM parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
    //        if ([[dic objectForKey:@"result"] isEqualToString:@"0"]) [weakSelf showAlertMsg:@"举报成功" andFrame:CGRectMake(70,100,200,60)];
    //    }];
    DiscoverModel *model = [self.data objectAtIndex:self.currentIndexPath.row];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:5];
    [dictionary setObject:model.showid forKey:@"receiveid"];
    [dictionary setObject:ifmtype forKey:@"ifmtype"];
    [dictionary setObject:[model.showkind isEqualToString:@"2"]?@"2":@"0" forKey:@"ifmkind"];//0 讨论举报1 回复举报
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_TALKINFORM parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        if ([[dic objectForKey:@"result"] isEqualToString:@"0"]) [weakSelf showAlertMsg:@"举报成功" andFrame:CGRectZero];
    }];
}

#pragma mark - 通知监听
//标题帖删除
-(void)groupTitleDelete:(NSNotification*)object{
    [self LoadDataWithIsMore:NO];
}
//团聊点赞
-(void)goodTalk:(NSNotification*)object{
    NSDictionary *dic = object.object;
    for (int i = 0;i<self.data.count;i++) {
        DiscoverModel *model  = self.data[i];
        if ([model.showkind isEqualToString:@"3"]&&[model.showid isEqualToString:dic[@"receiveid"]]) {
            model.praisestatus = dic[@"praisestatus"];
            model.praisecount =[NSString stringWithFormat:@"%d",[model.praisestatus isEqualToString:@"0"]?model.praisecount.intValue+1:model.praisecount.intValue-1];
            [self.DisCoverTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
    }
}
//团聊评论
-(void)comTalk:(NSNotification*)object{
    NSDictionary *dic = object.object;
    for (int i = 0;i<self.data.count;i++) {
        DiscoverModel *model  = self.data[i];
        if ([model.showkind isEqualToString:@"3"]&&[model.showid isEqualToString:dic[@"talkid"]]) {
            model.commentcount =[NSString stringWithFormat:@"%d",model.commentcount.intValue+1];
            [self.DisCoverTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
    }
}
//团聊删除
-(void)delteReply:(NSNotification*)object{
    NSDictionary *dic = object.object;
    for (int i = 0;i<self.data.count;i++) {
        DiscoverModel *model  = self.data[i];
        if ([model.showkind isEqualToString:@"3"]&&[model.showid isEqualToString:dic[@"talkid"]]) {
            model.commentcount =[NSString stringWithFormat:@"%d",model.commentcount.intValue-1];
            [self.DisCoverTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
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
    DiscoverModel*model = self.data[self.currentIndexPath.row];
    tempModel.content = model.content;
    tempModel.imageurl = model.talkimage;
    tempModel.userid = model.userid;
    tempModel.barid = model.showid;
    cell = (GroupTalkTableViewCell *)[self.DisCoverTable cellForRowAtIndexPath:self.currentIndexPath];
    
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
                [weakSelf LoadDataWithIsMore:NO];
                [weakSelf showAlertMsg:@"删除成功" andFrame:CGRectZero];
            }
        }
    }];
}

@end
