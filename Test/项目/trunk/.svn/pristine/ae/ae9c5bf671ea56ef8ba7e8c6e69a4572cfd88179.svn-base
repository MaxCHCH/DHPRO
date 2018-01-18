//
//  ChatViewController.m
//  zhidoushi
//
//  Created by nick on 15/4/24.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "ChatViewController.h"
#import "IQKeyboardManager.h"
#import "MessageFrame.h"
#import "Message.h"
#import "MessageCell.h"
#import "FaceToolBar.h"
@interface ChatViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,FaceToolBarDelegate>
{
    NSMutableArray  *_allMessagesFrame;
}
@property(nonatomic,strong)UITableView* Table;//tableView
@property(nonatomic,strong)NSMutableArray* data;//数据
@property(nonatomic,strong)MJRefreshHeaderView *header;//头部刷新
@property(nonatomic,strong)MJRefreshFooterView *footer;//底部刷新
@property(nonatomic,assign)int PageNum;//当前页数
@property(nonatomic,copy)NSString *shieldsts;//屏蔽状态
@property(nonatomic,assign)CGFloat lastrowhigh;//最后一个cell高度
@property(nonatomic,strong)NSTimer *timer;//定时器
@property(nonatomic,copy)NSString *lastletterid;//最后一条私信id
@property(nonatomic,copy)NSString *firstletterid;//第一条私信id
@property(nonatomic,assign)BOOL isCanSend;//是否可以发送标示
@property(nonatomic,strong)FaceToolBar *tool;//输入框
@property(nonatomic,strong)UILabel *pingbiTip;//屏蔽view
@property(nonatomic,assign)CGFloat cellSumheight;//聊天气泡总高度
@property(nonatomic,assign)CGFloat ty;//键盘高度
@end

@implementation ChatViewController
{
    //    记录上一个消息的时间
    NSString *previousTime ;
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.header free];
    [self.footer free];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [MobClick endLogPageView:@"私信页面"];
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
    NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:((NSDictionary*)[NSUSER_Defaults objectForKey:@"newMessage"])];
    [temp removeObjectForKey:self.userId];
    [NSUSER_Defaults setObject:temp forKey:@"newMessage"];
    [NSUSER_Defaults synchronize];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //友盟打点
    [MobClick beginLogPageView:@"私信页面"];
    [MobClick event:@"MESSAGEPERSON"];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    //添加定时器
    //定时刷新
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(getMoreMessage) userInfo:nil repeats:YES];
    
}

#pragma mark - 返回上一级
-(void)popButton{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.titleLabel.center = CGPointMake(160, 0);
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    [self.tool.myTextView.internalTextView becomeFirstResponder];
}
-(void)viewDidLoad{
    [super viewDidLoad];
    [self setupGUI];
    [self loadData];
    self.isCanSend = YES;
    UIView *titleViews = [[UIView alloc] init];
    [titleViews addSubview:self.leftButton];
    [titleViews addSubview:self.rightButton];
    self.navigationItem.titleView = titleViews;
    //导航栏返回
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"BarBtn_goBack_32_32"] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = MyFont(14);
    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width = 16;
    labelRect.size.height = 16;
    self.leftButton.frame = labelRect;
    [self.rightButton removeTarget:self action:@selector(EnableThisPeron) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton removeTarget:self action:@selector(ableThisPeron) forControlEvents:UIControlEventTouchUpInside];
    if ([self.shieldsts isEqualToString:@"0"]) {//未屏蔽
        [self.rightButton setTitle:@"  屏蔽私信" forState:UIControlStateNormal];
        [self.rightButton addTarget:self action:@selector(EnableThisPeron) forControlEvents:UIControlEventTouchUpInside];
    }else{//已屏蔽
        [self.rightButton setTitle:@"  取消屏蔽" forState:UIControlStateNormal];
        [self.rightButton addTarget:self action:@selector(ableThisPeron) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.rightButton setTitleColor:[WWTolls colorWithHexString:@"#959595"] forState:UIControlStateNormal];
    self.rightButton.width = 64;
    self.rightButton.left += 84;
    self.rightButton.titleLabel.font = MyFont(13);
    self.rightButton.transform = CGAffineTransformMakeTranslation(18, 0);
    [self.rightButton addTarget:self action:@selector(EnableThisPeron) forControlEvents:UIControlEventTouchUpInside];
    
    //导航栏标题
    UILabel *title = [[UILabel alloc] init];
    title.text = self.title;
    if (title.text.length<1) {
        title.text = @"私信";
    }
    title.textColor = ZDS_DHL_TITLE_COLOR;
    //    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    title.font = MyFont(18);
    title.textAlignment = NSTextAlignmentCenter;
    title.frame = CGRectMake(0, 0, 320, 44);
    title.center = titleViews.center;
    [titleViews addSubview:title];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyHiden) name:@"notifyToggle" object:nil];
}
- (void)notifyHiden{
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-88);
}

#pragma mark - 初始化UI
-(void)setupGUI{
    
    self.cellSumheight = 0;
    //初始化屏蔽状态
    self.shieldsts = @"0";
    //    消息列表,tableview
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-88) style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsSelection = NO;
    self.tableView.scrollsToTop = YES;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    //初始化刷新
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    self.header = header;
    header.scrollView = self.tableView;
    __weak typeof(self) weakself = self;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [weakself refreshData];
    };
    
    //    点击手势收起键盘
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRActive:)];
    [self.view addGestureRecognizer:tapGR];
    
    [self.view addSubview:self.tableView];
    
    
    //警告视图
    self.pingbiTip = [[UILabel alloc] init];
    _pingbiTip.frame = CGRectMake(-1, 0, SCREEN_WIDTH+2, 30);
    _pingbiTip.layer.borderColor = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;
    _pingbiTip.font = MyFont(13);
    _pingbiTip.text = @"回复后，将自动解除对他的私信屏蔽";
    _pingbiTip.backgroundColor = RGBCOLOR(253, 232, 190);
    _pingbiTip.layer.borderWidth = 0.5;
    _pingbiTip.textAlignment = NSTextAlignmentCenter;
    _pingbiTip.textColor = RGBCOLOR(174, 149, 1);
    _pingbiTip.hidden = YES;
    [self.view addSubview:self.pingbiTip];
    
    //    数据源数组
    _allMessagesFrame = [NSMutableArray array];
    
    previousTime = nil;

    
    //键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //新私信通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNewMessage:) name:@"newmessage" object:nil];
    
    //底部输入视图
    FaceToolBar *tool = [[FaceToolBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-46, self.view.frame.size.width, 50) superView:self.view withBarType:UserFeedBackToolBar];
    tool.faceToolBardelegate = self;
    self.tool = tool;
}
#pragma mark - 加载更多
-(void)refreshData{
    if (self.firstletterid == nil || self.firstletterid.length == 0) {
        [self.header endRefreshing];
        [self loadData];
        return;
    }
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:5];
    [dictionary setObject:self.userId forKey:@"rcvuserid"];
    [dictionary setObject:self.firstletterid forKey:@"startid"];
    [dictionary setObject:@"20" forKey:@"pageSize"];
    [dictionary setObject:@"1" forKey:@"pageNum"];
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_ME_MYMESSAGE parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (!dic[ERRCODE]){
            weakSelf.PageNum++;
            //    读取假数据填充数据源数组
            NSArray *temp = dic[@"letterlist"];
            if (temp.count == 0) {
                [weakSelf showAlertMsg:@"没有更多了" yOffset:0];
            }
            for (int i = 0;i<temp.count;i++){
                NSDictionary *d = temp[i];
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:d];
                dict[@"sndimageurl"] = dic[@"sndimageurl"];
                dict[@"rcvimageurl"] = dic[@"rcvimageurl"];
                if(i == temp.count-1){
                    weakSelf.firstletterid = dict[@"letterid"];
                }
                MessageFrame *messageFrame = [[MessageFrame alloc] init];
                Message *message = [[Message alloc] init];
                message.dict = dict;
                
                //前一条消息和本条消息时间不一样才显示
                messageFrame.showTime = ![[WWTolls date:previousTime] isEqualToString:[WWTolls date:message.time]];
                
                messageFrame.message = message;
                
                previousTime = message.time;
                
                [_allMessagesFrame insertObject:messageFrame atIndex:0];
            }
            [weakSelf.tableView reloadData];
            if(temp.count>0){
                //滚动至当前行
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:temp.count-1 inSection:0];
                [weakSelf.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
            
        }
        [weakSelf.header endRefreshing];
    }];
}

#pragma mark - 接收到新消息
-(void)recieveNewMessage:(NSNotification*)no{
    if ([no.object isEqualToString:self.userId]) {
        [self.timer invalidate];
        [self getMoreMessage];
    }
}

-(void)getMoreMessage{
    if (self.tableView.contentOffset.y+self.tableView.height+40+self.lastrowhigh<self.tableView.contentSize.height) {
        return;
    }
    if (_allMessagesFrame.count<1) {
        [self loadData];
        return;
    }
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:4];
    [dictionary setObject:self.userId forKey:@"rcvuserid"];
    [dictionary setObject:self.lastletterid forKey:@"lastletterid"];
    
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_NEW_MESSAGE_LIST parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        if (!dic[ERRCODE]) {
            //    读取假数据填充数据源数组
            NSArray *temp = dic[@"letterlist"];
            for (int i = temp.count-1; i>=0; i--) {
                NSDictionary *d = temp[i];
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:d];
                dict[@"sndimageurl"] = dic[@"sndimageurl"];
                dict[@"rcvimageurl"] = dic[@"rcvimageurl"];
                weakSelf.lastletterid = dict[@"letterid"];
                MessageFrame *messageFrame = [[MessageFrame alloc] init];
                Message *message = [[Message alloc] init];
                message.dict = dict;
                
                //前一条消息和本条消息时间不一样才显示
                messageFrame.showTime = ![[WWTolls date:previousTime] isEqualToString:[WWTolls date:message.time]];
                
                messageFrame.message = message;
                
                previousTime = message.time;
                [_allMessagesFrame addObject:messageFrame];
            }
            if (temp.count>0) {
                NSMutableArray *indexpaths = [NSMutableArray array];
                for (int i = 0; i<temp.count; i++) {
                    [indexpaths addObject:[NSIndexPath indexPathForRow:_allMessagesFrame.count-i-1 inSection:0]];
                }
                [weakSelf.tableView insertRowsAtIndexPaths:indexpaths withRowAnimation:UITableViewRowAnimationRight];
                if (_allMessagesFrame.count>1) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_allMessagesFrame.count - 1 inSection:0];
                    [weakSelf.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                    if (weakSelf.tableView.top != 0) {
                        [weakSelf keyBoardreload];
                    }
                }
            }
        }
    }];
}

#pragma mark - 刷新
-(void)loadData{
    if (self.tableView.contentOffset.y+self.tableView.height+40+self.lastrowhigh<self.tableView.contentSize.height) {
        return;
    }
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:5];
    [dictionary setObject:self.userId forKey:@"rcvuserid"];
    [dictionary setObject:@"1" forKey:@"pageNum"];
    [dictionary setObject:@"20" forKey:@"pageSize"];
    
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_ME_MYMESSAGE parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        if (!dic[ERRCODE]){
            weakSelf.PageNum=1;
            [_allMessagesFrame removeAllObjects];
            //    读取假数据填充数据源数组
            weakSelf.shieldsts = dic[@"shieldsts"];
            [weakSelf.rightButton removeTarget:self action:@selector(EnableThisPeron) forControlEvents:UIControlEventTouchUpInside];
            [weakSelf.rightButton removeTarget:self action:@selector(ableThisPeron) forControlEvents:UIControlEventTouchUpInside];
            if ([weakSelf.shieldsts isEqualToString:@"0"]) {//未屏蔽
                weakSelf.pingbiTip.hidden = YES;
                [weakSelf.rightButton setTitle:@"  屏蔽私信" forState:UIControlStateNormal];
                [weakSelf.rightButton addTarget:self action:@selector(EnableThisPeron) forControlEvents:UIControlEventTouchUpInside];
            }else{//已屏蔽
                weakSelf.pingbiTip.hidden = NO;
                [weakSelf.rightButton setTitle:@"  取消屏蔽" forState:UIControlStateNormal];
                [weakSelf.rightButton addTarget:self action:@selector(ableThisPeron) forControlEvents:UIControlEventTouchUpInside];
            }
            NSArray *temp = dic[@"letterlist"];
            for (int i = temp.count-1; i>=0; i--) {
                
                NSDictionary *d = temp[i];
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:d];
                dict[@"sndimageurl"] = dic[@"sndimageurl"];
                dict[@"rcvimageurl"] = dic[@"rcvimageurl"];
                weakSelf.lastletterid = dict[@"letterid"];
                if(i == temp.count-1){
                    weakSelf.firstletterid = dict[@"letterid"];
                }
                MessageFrame *messageFrame = [[MessageFrame alloc] init];
                Message *message = [[Message alloc] init];
                message.dict = dict;
                
                //前一条消息和本条消息时间不一样才显示
                messageFrame.showTime = ![[WWTolls date:previousTime] isEqualToString:[WWTolls date:message.time]];
                
                messageFrame.message = message;
                
                previousTime = message.time;
                
                [_allMessagesFrame addObject:messageFrame];
            }
            [weakSelf.tableView reloadData];
            //滚动至当前行
            if (_allMessagesFrame.count>1) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_allMessagesFrame.count - 1 inSection:0];
                [weakSelf.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
            
            
        }
        [weakSelf.footer endRefreshing];
    }];
}

#pragma mark - 屏蔽消息
-(void)EnableThisPeron{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定屏蔽吗?" message:@"你将不再收到该用户的信息哦" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 999;
    [alert show];
    
}
-(void)ableThisPeron{
    
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:5];
    [dictionary setObject:@"0" forKey:@"shieldsts"];
    [dictionary setObject:@"0" forKey:@"shieldtype"];
    [dictionary setObject:self.userId forKey:@"shielduserid"];
    
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_ME_PINGBI parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        if ([dic[@"result"] isEqualToString:@"0"]) {
            [weakSelf showAlertMsg:@"已取消屏蔽" yOffset:0];
            weakSelf.shieldsts=@"0";
            weakSelf.pingbiTip.hidden = YES;
            [weakSelf.rightButton removeTarget:self action:@selector(ableThisPeron) forControlEvents:UIControlEventTouchUpInside];
            [weakSelf.rightButton setTitle:@"  屏蔽私信" forState:UIControlStateNormal];
            [weakSelf.rightButton addTarget:weakSelf action:@selector(EnableThisPeron) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 999){
        if (buttonIndex == 1) {
            //构造请求参数
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:5];
            [dictionary setObject:@"1" forKey:@"shieldsts"];
            [dictionary setObject:@"0" forKey:@"shieldtype"];
            [dictionary setObject:self.userId forKey:@"shielduserid"];
            
            __weak typeof(self)weakSelf = self;
            [WWRequestOperationEngine operationManagerRequest_Post:ZDS_ME_PINGBI parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
                if ([dic[@"result"] isEqualToString:@"0"]) {
                    [weakSelf showAlertMsg:@"屏蔽成功" yOffset:0];
                    weakSelf.pingbiTip.hidden = NO;
                    weakSelf.shieldsts = @"1";
                    [weakSelf.rightButton removeTarget:self action:@selector(EnableThisPeron) forControlEvents:UIControlEventTouchUpInside];
                    [weakSelf.rightButton setTitle:@"  取消屏蔽" forState:UIControlStateNormal];
                    [weakSelf.rightButton addTarget:weakSelf action:@selector(ableThisPeron) forControlEvents:UIControlEventTouchUpInside];
                }
            }];
        }
    }
    
    
}

#pragma mark - 键盘处理
#pragma mark 键盘即将显示
- (void)keyBoardWillShow:(NSNotification *)note{
    _tool.faceboardIsShow = YES;
    _tool.keyboardIsShow = YES;
    [_tool disFaceKeyboard];
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = - rect.size.height;
    self.ty = ty;
    WEAKSELF_SS
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        weakSelf.view.transform = CGAffineTransformMakeTranslation(0, ty);
        if (weakSelf.cellSumheight<weakSelf.tableView.height) {
            if (weakSelf.cellSumheight<weakSelf.tableView.height + ty - 50 - 20) {
                weakSelf.tableView.top = -ty;
            }else{
                weakSelf.tableView.top = weakSelf.tableView.height - self.cellSumheight - self.lastrowhigh-20;
            }
        }
        weakSelf.pingbiTip.top = -ty;
    }];
    
}

- (void)keyBoardreload{
    CGFloat ty = self.ty;
    self.view.transform = CGAffineTransformMakeTranslation(0, ty);
    if (self.cellSumheight<self.tableView.height) {
        if (self.cellSumheight<self.tableView.height + ty - 50 - 20) {
            self.tableView.top = -ty;
        }else{
            self.tableView.top = self.tableView.height - self.cellSumheight - self.lastrowhigh-20;
        }
    }
    self.pingbiTip.top = -ty;
}

#pragma mark 键盘即将退出
- (void)keyBoardWillHide:(NSNotification *)note{
    self.ty = 0;
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        weakself.view.transform = CGAffineTransformIdentity;
        weakself.tableView.top = 0 ;
        weakself.pingbiTip.top = 0;
    }];
}

-(void)tapGRActive:(UITapGestureRecognizer *)tapGR
{
    if (_tool.faceboardIsShow) {
        [_tool disFaceKeyboard];
    }
    [self.view endEditing:YES];
}

-(void)faceSendBtnClick{
    [self sendMessage];
    [_tool disFaceKeyboard];
    [self.view endEditing:YES];
}

#pragma mark - 发送消息
-(void)sendDidClick{
    [self sendMessage];
}
-(void)sendMessage{
    
    if (_tool.myTextView.text.length < 1) {
        [self showAlertMsg:@"不能发送空消息" yOffset:0];
        return;
    }
    if (!self.isCanSend) {
        return;
    }
    self.isCanSend = NO;
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:5];
    [dictionary setObject:_tool.myTextView.text forKey:@"content"];
    [dictionary setObject:self.userId forKey:@"rcvuserid"];
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_ME_SENDMESSAGE parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
//        if (!dic[ERRCODE]) {
            if (![weakSelf.shieldsts isEqualToString:@"0"]) {//取消屏蔽
                [weakSelf ableThisPeron];
            }
            if ([dic[@"result"] isEqualToString:@"0"]) {//成功
                if (_allMessagesFrame.count<1) {
                    [weakSelf loadData];
                }else{
                    [weakSelf getMoreMessage];
                }
                _tool.myTextView.text = nil;
            }else if([dic[@"result"] isEqualToString:@"2"]){
                if (_allMessagesFrame.count<1) {
                    [weakSelf loadData];
                }else{
                    [weakSelf getMoreMessage];
                }
                _tool.myTextView.text = nil;
            }
//        }
        weakSelf.isCanSend = YES;
    }];
}

#pragma mark - 文本框代理方法
#pragma mark 点击textField键盘的回车按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self sendMessage];
    return YES;
}

#pragma mark 给数据源增加内容
- (void)addMessageWithContent:(NSString *)content time:(NSString *)time{
    
    MessageFrame *mf = [[MessageFrame alloc] init];
    
    //    数据模型
    Message *msg = [[Message alloc] init];
    msg.content = content;
    msg.time = time;
    NSLog(@"time %@",msg.time);
    msg.icon = @"face";
    msg.type = MessageTypeMe;
    
    mf.showTime = ![previousTime isEqualToString:[WWTolls date:msg.time]];
    
    mf.message = msg;
    previousTime = [WWTolls date:msg.time];
    
    [_allMessagesFrame addObject:mf];
}

#pragma mark - tableView数据源方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _allMessagesFrame.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // 设置数据
    cell.messageFrame = _allMessagesFrame[indexPath.row];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    self.lastrowhigh = [_allMessagesFrame[indexPath.row] cellHeight];
    if (indexPath.row == 0) {
        self.cellSumheight = 0;
    }
    self.cellSumheight += self.lastrowhigh;
    return self.lastrowhigh;
}

#pragma mark - 代理方法


@end
