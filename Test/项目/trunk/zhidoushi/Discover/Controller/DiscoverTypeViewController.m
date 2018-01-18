//
//  DiscoverTypeViewController.m
//  zhidoushi
//
//  Created by nick on 15/4/20.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "DiscoverTypeViewController.h"
#import "DiscoverAddViewController.h"
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

@interface DiscoverTypeViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,discoverReportDelegate,NARShareViewDelegate,UIAlertViewDelegate,MLImageCropDelegate>{
    UIActionSheet *myActionSheetView;//举报行为
    NSString *talkid;//团聊更多
}

@property(nonatomic,copy)NSString *lastKind;//类型

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

@implementation DiscoverTypeViewController

#pragma mark - Life Cycle
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.httpOpt cancel];
    [MobClick endLogPageView:@"标签列表表页面"];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //友盟打点
    [MobClick beginLogPageView:@"标签列表表页面"];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    //导航栏标题
    self.titleLabel.textColor = ZDS_DHL_TITLE_COLOR;
    self.titleLabel.font = MyFont(18);
    self.titleLabel.text = self.showtag;
    
    //导航栏返回
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"BarBtn_goBack_32_32"] forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = MyFont(13);
    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width = 16;
    labelRect.size.height = 16;
    self.leftButton.frame = labelRect;
    
    //    self.leftButton.bounds = CGRectMake(0, 0, 18, 18);
    //    self.leftButton.enabled = NO;
    self.rightButton.titleLabel.font = MyFont(16);
    self.rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.rightButton.bounds = CGRectMake(0, 0, 18, 18);
    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"discover_fabu-38"] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(pubDiscover:) forControlEvents:UIControlEventTouchUpInside];
}   

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    //相机功能初始化选择器
    self.picker = [[UIImagePickerController  alloc] init];
    self.picker.delegate = self;
    
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
    
    //发现列表
    UITableView *tableView = [[UITableView alloc] init];
    tableView.scrollsToTop = YES;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = ZDS_BACK_COLOR;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    tableView.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    [self.view addSubview:tableView];
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
        //弹出的菜单按钮点击后的响应
        switch (buttonIndex)//相机
        {
            case 0:  //打开照相机拍照
                
                [self takePhoto:YES];
                break;
                
            case 1:  //打开本地相册
                
                [self LocalPhoto:YES];
                break;
            case 2: //打开默认图
                break;
        }
        
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
    if ([model.showkind isEqualToString:@"1"]) {
        
        NSString *CellIdentifier = @"dyncell";
        
        OfficialInformTableViewCell *groupCell = [tableView dequeueReusableCellWithIdentifier:
                                                  CellIdentifier];
        
        if (groupCell==nil) {
            groupCell = [[[NSBundle mainBundle]loadNibNamed:@"OfficialInformTableViewCell" owner:self options:nil]lastObject];
            groupCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }   
        
        groupCell.model = model;
        return groupCell;
        
    } else if ([model.showkind isEqualToString:@"2"]) {
        
        DiscoverListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DiscoverListTableViewCell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"DiscoverListTableViewCell" owner:self options:nil]lastObject];
        }
        
        cell.delegate = self;
        cell.indexPath = indexPath;
        cell.model = model;
        return cell;
    }else if ([model.showkind isEqualToString:@"3"]){
        if (model.title && model.title.length > 0) {
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
    
    
    return nil;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DiscoverModel *model = self.data[indexPath.row];
    if ([model.showkind isEqualToString:@"1"]) {//1团组动态 2撒欢 3乐活吧同步
        return 197 + 2;
    }else if ([model.showkind isEqualToString:@"2"]){//撒欢
        return [model getDiscoverHeight];
    }else if ([model.showkind isEqualToString:@"3"]){//乐活吧同步
        if (model.title && model.title.length > 0) {
            if (!model.talkimage || model.talkimage.length<1) {
                NSString *content = [[model.content stringByReplacingOccurrencesOfString:@"\r" withString:@" "] stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
                CGFloat heigh = [WWTolls heightForString:content fontSize:13 andWidth:SCREEN_WIDTH - 30];
                if (heigh<55) {
                    return 97 + heigh;
                }else return 147;
            }
            return 147;
        }
        CGFloat h = [GroupTalkTableViewCell getShowCellHeight:self.data[indexPath.row]]+6;
        h+=2;
        return h;
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

#pragma mark 点击进入发布撒欢页面
- (void)pubDiscover:(UIButton *)button {
    DiscoverAddViewController *add = [[DiscoverAddViewController alloc] init];
    add.tagName = self.showtag;
    [self.navigationController pushViewController:add animated:YES];
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
        [dictionary setObject:self.lastId forKey:@"lastid"];
    }
    if (isLoadMore && self.lastKind!=nil) {
        [dictionary setObject:self.lastKind forKey:@"showkind"];
    }
    [dictionary setObject:self.showtag forKey:@"showtag"];
    
    
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
    self.httpOpt = [WWRequestOperationEngine operationManagerRequest_Post:ZDS_SHOWLIST1 parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        if (!dic[ERRCODE]) {
            if (isLoadMore) {
                weakSelf.timePageNum++;
            }else{
                weakSelf.timePageNum = 1;
                [weakSelf.data removeAllObjects];
            }
            NSArray *tempArray = dic[@"showlist"];
            for (NSDictionary *dic in tempArray) {
                [weakSelf.data addObject:[DiscoverModel modelWithDic:dic]];
                weakSelf.lastId = dic[@"showid"];
                weakSelf.lastKind = dic[@"showkind"];
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
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:5];
    [dictionary setObject:@"1" forKey:@"pageNum"];
    [dictionary setObject:@"10" forKey:@"pageSize"];
    //撒欢标签
    [dictionary setObject:self.showtag forKey:@"showtag"];
    [dictionary setObject:@"0" forKey:@"isinclude"];
    [dictionary setObject:@"2" forKey:@"showkind"];
    [dictionary setObject:no.object[@"showid"] forKey:@"lastid"];
    
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_SHOWLIST1 parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (!dic[ERRCODE]) {
            weakSelf.timePageNum=1;
            [weakSelf.data removeAllObjects];
            weakSelf.titleLabel.text = weakSelf.showtag;
            NSArray *tempArray = dic[@"showlist"];
            for (NSDictionary *dic in tempArray) {
                DiscoverModel *model = [DiscoverModel modelWithDic:dic];
                [weakSelf.data addObject:model];
                weakSelf.lastId = dic[@"showid"];
                weakSelf.lastKind = dic[@"showkind"];
            }
            [weakSelf.DisCoverTable reloadData];
        }
    }];
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

//弹出选择框
-(void)photoSelector{
    
    DiscoverAddViewController *add = [[DiscoverAddViewController alloc] init];
    add.type = self.typeId;
    [self.navigationController pushViewController:add animated:YES];
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


#pragma mark - 相机功能

//调用相机
-(void)takePhoto:(BOOL)Editing
{
    
    UIImagePickerControllerSourceType sourceType =UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        //设置拍照后的图片可被编辑
        _picker.allowsEditing = NO;
        _picker.sourceType = sourceType;
        [self.view.window.rootViewController presentViewController:_picker animated:YES completion:nil];
    }else{
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
    
}

//调用相册
-(void)LocalPhoto:(BOOL)Editing
{
    _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //设置选择后的图片可被编辑
    _picker.allowsEditing = NO;
    [self.view.window.rootViewController presentViewController:_picker animated:YES completion:nil];
}

#pragma mark - crop delegate
- (void)cropImage:(UIImage*)cropImage forOriginalImage:(UIImage*)originalImage
{
    [self showWaitView];
    UIImage *image = cropImage;
    if (image.size.width>image.size.height) {
        UIGraphicsBeginImageContext(CGSizeMake(image.size.width, image.size.width));
        
        // Draw image1
        [image drawInRect:CGRectMake(0, (image.size.width-image.size.height)/2, image.size.width, image.size.height)];
        
        UIImage *newimage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        image = nil;
        image = newimage;
    }else if(image.size.width<image.size.height){
        UIGraphicsBeginImageContext(CGSizeMake(image.size.height, image.size.height));
        
        // Draw image1
        [image drawInRect:CGRectMake((image.size.height-image.size.width)/2, 0, image.size.width, image.size.height)];
        
        UIImage *newimage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        image = nil;
        image = newimage;
    }
    float f = 0.5;
    NSData *data = UIImageJPEGRepresentation(image,1);
    if(data.length>1024*1024*10){
        [self removeWaitView];
        [self showAlertMsg:@"您选择的图片太大,请重新上传" andFrame:CGRectZero];
    }else if (data.length>1024*1024*2) {
        data = UIImageJPEGRepresentation(image,0.3);
    }else{
        while (data.length>300*1024) {
            data=nil;
            data = UIImageJPEGRepresentation(image,f);
            f*=0.8;
        }
    }
    
    __weak typeof(self) weakSelf = self;
    NSDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.isNew?@"0":@"1" forKey:@"isnew"];
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_UPLOADTOKEN parameters:dict requestOperationBlock:^(NSDictionary *dic) {
        
        if (![dic isKindOfClass:[NSDictionary class]] || dic==nil) {
            [self removeWaitView];
            [MBProgressHUD showError:@"上传失败请重试"];
        }else{
#pragma mark - 七牛上传图片
            NSString *token = dic[@"uptoken"];
            if(token.length>0){
                //七牛上传管理器
                QNUploadManager *upManager = [[QNUploadManager alloc] init];
                //开始上传
                CFUUIDRef uuidRef =CFUUIDCreate(NULL);
                
                CFStringRef uuidStringRef =CFUUIDCreateString(NULL, uuidRef);
                
                CFRelease(uuidRef);
                
                NSString *UUIDStr = (__bridge NSString *)uuidStringRef;
                NSString *QNkey = [NSString stringWithFormat:@"images/0/%@.jpg",UUIDStr];
                [upManager putData:data key:QNkey token:token
                          complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {//resp hash key
                              weakSelf.isNew = NO;
                              [weakSelf removeWaitView];
                              if (info.isOK) {
                                  
                                  if(resp){
                                      //                                              [MBProgressHUD showSuccess:@"上传成功"];
                                      DiscoverAddViewController *add = [[DiscoverAddViewController alloc] init];
                                      add.type = weakSelf.typeId;
                                      add.Photohash = resp[@"hash"];
                                      add.Photokey = resp[@"key"];
                                      //直接把该图片读出来显示在按钮上
                                      add.image=[UIImage imageWithData:data];
                                      [weakSelf.navigationController pushViewController:add animated:YES];
                                  }
                              }else{
                                  if (info.isConnectionBroken) {
                                      [MBProgressHUD showError:@"网速太不给力了"];
                                  }
                                  else if(info.statusCode == 401){//授权失败
                                      weakSelf.isNew = YES;
                                      [MBProgressHUD showError:@"上传失败，请重试"];
                                  }else [MBProgressHUD showError:@"上传失败，请重试"];
                              }
                              NSLog(@"%@", info);
                              NSLog(@"%@", resp);
                          } option:nil];
            }else{
                [weakSelf removeWaitView];
                [MBProgressHUD showError:@"上传失败请重试"];
            }
        }
    }];
}

//获取图片后的行为
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        UIImage* editeImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        UIImage* originalImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        UIImage *image;//原图
        
        if (editeImage!=nil) {
            image = editeImage;
        }else{
            image = originalImage;
        }
        [_picker dismissViewControllerAnimated:YES completion:^{
            MLImageCrop *imageCrop = [[MLImageCrop alloc]init];
            imageCrop.delegate = self;
            imageCrop.ratioOfWidthAndHeight = 600.0f/600.0f;
            imageCrop.image =image;
            [imageCrop showWithAnimation:NO];
            
        }];
        
    }
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
