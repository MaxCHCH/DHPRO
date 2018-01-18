//
//  TalkBarViewController.m
//  zhidoushi
//
//  Created by nick on 15/6/16.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//
//分享相关
#import "InitShareButton.h"
#import "InitShareView.h"
#import "InitShareGameView.h"
#import "InitShareWeightView.h"
#import "ShareGameSubClassView.h"
#import "NARShareView.h"
#import "InvitationViewController.h"
#import "PlanViewController.h"
#import "GroupHeaderModel.h"
#import "MCFireworksButton.h"
#import "GroupTalkModel.h"
#import "PICircularProgressView.h"
#import "TalkAboutViewController.h"
#import "GroupEditorViewController.h"
#import "GroupTeamViewController.h"
#import "GroupTalkDetailViewController.h"
#import "UIButton+WebCache.h"
#import "MeViewController.h"
#import "GameRuleViewController.h"
#import "ZDSPublishActivityViewController.h"

#import "ZDSGroupActCell.h"
#import "ZDSGroupBubbleCell.h"
#import "ZDSActDetailViewController.h"
#import "ZDSGroupBubbleModel.h"
#import "MJExtension.h"
#import "DeleteBarModel.h"
#import "SSLImageTool.h"

#import "TalkBarViewController.h"

@interface TalkBarViewController ()<NARShareViewDelegate,InitShareViewDelegate,InitShareDelegate,
UITableViewDelegate,UITableViewDataSource,groupTalkCellDelegate,sendMessageDelegate,ZDSGroupActCellDelegate,ZDSGroupBubbleCellDelegate,UIActionSheetDelegate>
{
    InitShareView * shareView;
    InitShareButton * button;
    InitShareGameView *shareGameView;
    InitShareWeightView *shareWeightView;
    int topNumber;
    int topUpper;
    UIActionSheet *myActionSheetView;
    NSString *talkid;
    //举报类型
    NSString *repotType;
    NSString *talkResult;
    //    NSString *topType;
    NSString *stopResult;
}

@property (nonatomic,strong) NSString *topType;

//倒计时label
@property (nonatomic,strong) UILabel *countDownLabel;
@property (nonatomic,strong) NSTimer *countDownTimer;
@property (nonatomic) long countDown;

@property (nonatomic,strong) UIImage *shareImage;

@property (nonatomic,strong) NSIndexPath *currentIndexPath;

@property(nonatomic,strong)UITableView* table;//tableView
@property(nonatomic,strong)NSMutableArray* data;//数据
@property(nonatomic,strong)MJRefreshHeaderView *header;//头部刷新
@property(nonatomic,strong)MJRefreshFooterView *footer;//底部刷新
@property(nonatomic,assign)int timePageNum;//当前页数

//更多菜单栏
@property(strong,nonatomic) UIButton* jindu;//进度按钮
@property(strong,nonatomic) UIButton* homeBtn;//返回首页按钮
@property(nonatomic,strong) UIButton* ruleBtn;//规则
@property(strong,nonatomic) UIButton* fenxiangBtn;//分享按钮
@property(nonatomic,strong) UIButton* delBtn;//退出按钮
@property(strong,nonatomic) UIView* menuView;//选择菜单
//介绍类别视图
@property(nonatomic,strong)UIView *typeIntro;//介绍类别视图
//点赞状态
@property(nonatomic,copy)NSString *praisestatus;//点赞状态
@property(nonatomic,strong)MCFireworksButton *goodButton;//点赞按钮
@property(nonatomic,strong)UILabel *googLabel;//点赞数量

@property(nonatomic,copy)NSString *parterid;//上传体重id

@property(nonatomic,strong)UIImage *image;//分享用的图片
@property(nonatomic,strong)UIView *footerView;//底部视图

@end

@implementation TalkBarViewController


#pragma mark Life Cycle
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
}
-(void)dealloc{
    [self.header free];
    [self.footer free];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self createTimerWith:NO];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"self.model:%@",[self.model logClassData]);
    
    self.countDown = 0;
    self.data = [NSMutableArray array];
    self.model = [[GroupHeaderModel alloc] init];
    [self setUpGUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(good:) name:@"goodReply" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(com:) name:@"comReply" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(joinAct:) name:@"joinAct" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delteReply:) name:@"delteReply" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"pushcardSucess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"submitTaskSucess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(JoinSucess:) name:@"joinGroupSucess" object:nil];
    [self.header beginRefreshing];
}

- (void)JoinSucess:(NSNotification*)no{
    if ([no.object[@"gameid"] isEqualToString:self.groupId]) {
        self.gameangle = @"2";
        [self.table reloadData];
    }
}

#pragma mark NARShareViewDelegate
-(void)clickInvitationButton
{
    InvitationViewController *invitation = [[InvitationViewController alloc]initWithNibName:@"InvitationViewController" bundle:nil];
    invitation.gameid = self.groupId;
    invitation.userid = [NSUSER_Defaults objectForKey:ZDS_USERID];
    [self.navigationController pushViewController:invitation animated:YES];
}

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

#pragma mark 置顶回调
- (void)shareViewDelegateSetTop {
    
    [self topBar];
    
}

#pragma mark 取消置顶回调
- (void)shareViewDelegateCancelTop {
    
    [self topBar];
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 888) {//加入弾框
        if (buttonIndex == 1) {
            [self joinMyGame];
        }
    }else if(alertView.tag == 999){//退出弾框
        if (buttonIndex == 1) {
            [self ExitMyGame];
        }
    } else if (alertView.tag == 777) {//删除
        if (buttonIndex == 1) {
            
            GroupTalkModel *model = self.data[self.currentIndexPath.row];
            NSString *type = nil;
            
            if ([model.bartype isEqualToString:@"0"]) {
                type = @"1";
            } else if ([model.bartype isEqualToString:@"1"]) {
                type = @"2";
            }
            
            [self requestWithDeleteBarWithDeleteid:model.barid andDelType:type];
        }
    }
}

#pragma mark groupTalkCellDelegate
#pragma mark - 举报
-(void)reportClick:(NSString*)discoverId AndType:(NSString*)type{
    talkid = discoverId;
    repotType = type;
    [self jubaoShare];
}

- (void)reportClick:(NSString *)talkId andType:(NSString *)type andIndexPath:(NSIndexPath *)indexPath {
    talkid = talkId;
    repotType = type;
    self.currentIndexPath = indexPath;
    [self jubaoShare];
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

#pragma mark - actionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
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

#pragma mark - UITableViewDelegate
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
    
    GroupTalkModel *model = self.data[indexPath.row];
    
    //活动
    if ([model.bartype isEqualToString:@"1"]) {
        return [ZDSGroupActCell getMyCellHeightWithModel:self.data[indexPath.row]];
    }
    
    //冒泡
    if ([model.bartype isEqualToString:@"2"]) {
        return 60;
    }
    
    NSInteger row = indexPath.row;
    CGFloat h = [self.groupCell getMyCellHeight:self.data[indexPath.row]]+6;
    h-=8;
    return h;
}

#pragma mark - 脚视图
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    //    if (section == 1) {
    //            self.footerView.height = 47;
    //            self.footerView.backgroundColor = ZDS_BACK_COLOR;
    //            return 47;
    //    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
    }
    UIView *foot = [[UIView alloc] init];
    foot.userInteractionEnabled = NO;
    return foot;
}

#pragma mark - 头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    //    CGFloat space = (SCREEN_WIDTH - 30*3) / 4;
    //    
    //    for (int i = 0; i < 3; i++) {
    //        
    //        CGFloat tempX = space + (space + 30)*i;
    //        
    //        if (i == 0) {
    //            tempX -= 15;
    //        } else if (i == 2) {
    //            tempX += 15;
    //        }
    //        
    //        UIButton *tempButton = [[UIButton alloc] initWithFrame:CGRectMake(tempX ,5, 30, 36)];
    //        [bg addSubview:tempButton];
    //        
    //        //冒泡
    //        if (i == 0) {
    //            //                tempButton.backgroundColor = [UIColor redColor];
    //            [tempButton setImage:[UIImage imageNamed:MaoPaoImage] forState:UIControlStateNormal];
    //            [tempButton addTarget:self action:@selector(grougBubbleClick:) forControlEvents:UIControlEventTouchUpInside];
    //            
    //            NSMutableArray *arr = [NSMutableArray array];
    //            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 0, 21, 21)];
    //            //                imageView.backgroundColor = [UIColor yellowColor];
    //            for (int i = 1; i < 26; i++) {
    //                [arr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%d@2x.png",i]]];
    //            }
    //            
    //            imageView.animationDuration = 1.35;
    //            imageView.animationImages = arr;
    //            [imageView startAnimating];
    //            [tempButton addSubview:imageView];
    //            
    //            self.countDownLabel = [[UILabel alloc] initWithFrame:CGRectMake(-5,25, tempButton.width + 10, 12)];
    //            self.countDownLabel.backgroundColor = COLOR_NORMAL_CELL_BG;
    //            self.countDownLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",self.countDown/60,self.countDown%60];
    //            self.countDownLabel.font = MyFont(12.0);
    //            self.countDownLabel.textAlignment = NSTextAlignmentCenter;
    //            self.countDownLabel.textColor = [WWTolls colorWithHexString:TextColor];
    //            [tempButton addSubview:self.countDownLabel];
    //            
    //            if (self.countDown > 0) {
    //                self.countDownLabel.hidden = NO;
    //                [self createTimerWith:YES];
    //            } else {
    //                self.countDownLabel.hidden = YES;
    //            }
    //            
    //            //活动
    //        } else if (i == 1) {
    //            [tempButton setImage:[UIImage imageNamed:YueHuoDongImage] forState:UIControlStateNormal];
    //            [tempButton addTarget:self action:@selector(groupActivityClick) forControlEvents:UIControlEventTouchUpInside];
    //            //发表图文（即说点啥）
    //        } else if (i == 2) {
    //            [tempButton setImage:[UIImage imageNamed:ShuoDianShaImage] forState:UIControlStateNormal];
    //            [tempButton addTarget:self action:@selector(groupTalkButton) forControlEvents:UIControlEventTouchUpInside];
    //        }
    //    }
    //    if (section == 1) {
    if(self.data.count == 0){
        UIView *back = [[UIView alloc] init];
        //            UILabel *headView = [[UILabel alloc] init];
        //            headView.text = @"  乐活吧";
        //            headView.backgroundColor = ZDS_BACK_COLOR;
        //            headView.font = MyFont(15);
        //            headView.textColor = ZDS_DHL_TITLE_COLOR;
        //            headView.frame = CGRectMake(0, 0, 320, 40);
        //            [back addSubview:headView];
        UILabel *huashu = [[UILabel alloc] init];
        huashu.backgroundColor = [UIColor clearColor];
        huashu.text = @"还没有人发言，求破冰~(●'◡'●)ﾉ♥";
        huashu.textColor = [WWTolls colorWithHexString:@"#959595"];
        huashu.textAlignment = NSTextAlignmentCenter;
        huashu.font = MyFont(14);
        huashu.frame= CGRectMake(0, 30, 320, 22);
        [back addSubview:huashu];
        return back;
    }
    UILabel *headView = [[UILabel alloc] init];
    //        headView.text = @"  乐活吧";
    headView.backgroundColor = ZDS_BACK_COLOR;
    headView.font = MyFont(15);
    headView.textColor = ZDS_DHL_TITLE_COLOR;
    headView.frame = CGRectMake(0, 0, 0, 0);
    return headView;
    //    }
    
    
    //    return [[UIView alloc] init];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        if(self.data.count == 0) return 60;
        return 0;
    }
    
    CGFloat h = 0;
    
    return h;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        
        GroupTalkModel *model = self.data[indexPath.row];
        UITableViewCell *cell = nil;
        
        //活动
        if ([model.bartype isEqualToString:@"1"]) {
            
            //            NSLog(@"model:%@",[model logClassData]);
            
            static NSString *CellIdentifier = @"ZDSGroupActCell";
            ZDSGroupActCell *groupCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (groupCell == nil) {
                
                groupCell = [ZDSGroupActCell loadNib];
                groupCell.selectionStyle = UITableViewCellSelectionStyleNone;
                groupCell.delegate = self;
            }
            
            groupCell.topupper = topNumber;
            groupCell.indexPath = indexPath;
            [groupCell initMyCellWithModel:model];
            cell = groupCell;
        }
        //冒泡
        else if ([model.bartype isEqualToString:@"2"]) {
            
            static NSString *CellIdentifier = @"ZDSGroupBubbleCell";
            ZDSGroupBubbleCell *groupCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (groupCell == nil) {
                
                groupCell = [ZDSGroupBubbleCell loadNib];
                groupCell.selectionStyle = UITableViewCellSelectionStyleNone;
                groupCell.delegate = self;
            }
            groupCell.topupper = topNumber;
            [groupCell initMyCellWithModel:model];
            cell = groupCell;
        }
        //团聊
        else if ([model.bartype isEqualToString:@"0"]) {
            
            NSString *CellIdentifier = @"cellGroup";
            
            GroupTalkTableViewCell *groupCell = [tableView dequeueReusableCellWithIdentifier:
                                                 CellIdentifier];
            
            if (groupCell==nil) {
                groupCell = [[[NSBundle mainBundle]loadNibNamed:@"GroupTalkTableViewCell" owner:self options:nil]lastObject];
                groupCell.selectionStyle = UITableViewCellSelectionStyleNone;
                groupCell.talkCellDelegate = self;
            }
            groupCell.topupper = topNumber;
            groupCell.indexPath = indexPath;
            if([self.gameangle isEqualToString:@"3"]) model.isparter = @"1";
            else model.isparter = @"0";
            [groupCell initMyCellWithModel:model];
            groupCell.consLineHeight.constant = 0.5;
            groupCell.smallLine.top = 0;
            groupCell.line.height = 0;
            cell = groupCell;
        }
        
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GroupTalkModel *model = [self.data objectAtIndex:indexPath.row];
    if ([model.bartype isEqualToString:@"1"]) {
        ZDSActDetailViewController *vc = [[ZDSActDetailViewController alloc] init];
        vc.activityid = model.barid;
        [((UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController).selectedViewController pushViewController:vc animated:YES];
    } else if ([model.bartype isEqualToString:@"2"]) {
        GroupTalkModel *model = self.data[indexPath.row];
        MeViewController *single = [[MeViewController alloc]init];
        single.userID = model.userid;
        single.otherOrMe = 1;
        [((UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController).selectedViewController pushViewController:single animated:YES];
    } else if ([model.bartype isEqualToString:@"0"]) {
        GroupTalkDetailViewController *reply = [[GroupTalkDetailViewController alloc] init];
        reply.talkid = model.barid;
        [self.happyCtl.navigationController pushViewController:reply animated:YES];
        //        [((UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController).selectedViewController pushViewController:reply animated:YES];
    }
}

#pragma mark Event Response

#pragma mark 冒泡 点击
- (void)grougBubbleClick:(UIButton*)btn {
    
    btn.userInteractionEnabled = NO;
    if (self.countDown > 0) {
        btn.userInteractionEnabled = YES;
        [self showAlertMsg:@"现在还不能冒泡" andFrame:CGRectZero];
    } else {
        NSLog(@"冒泡");
        [self requestWithBubble:(UIButton*)btn];
    }
}

#pragma mark 活动 点击
- (void)groupActivityClick {
    //    TestViewController *activityVC = [[TestViewController alloc] init];
    ZDSPublishActivityViewController *activityVC = [[ZDSPublishActivityViewController alloc] init];
    activityVC.delegate = self;
    activityVC.groupId = self.groupId;
    [self.navigationController pushViewController:activityVC animated:YES];
}

#pragma mark - 分享
-(void)createGame{
    [MobClick event:@"GroupShareClick"];//分享点击次数
    [self hideMenu];
    [shareView removeFromSuperview];
    [self createShareView:outType];
}

#pragma mark 冒泡定时器
- (void)countDown:(NSTimer *)timer {
    
    if (self.countDown > 0) {
        self.countDownLabel.hidden = NO;
        self.countDown--;
        self.countDownLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",self.countDown/60,self.countDown%60];
    } else {
        [self createTimerWith:NO];
        self.countDownLabel.hidden = YES;
    }
}

#pragma mark Private Methods

//创建定时器
- (void)createTimerWith:(BOOL)create {
    
    if (create) {
        [self createTimerWith:NO];
        self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:self.countDownTimer forMode:NSRunLoopCommonModes];
    } else {
        if (self.countDownTimer) {
            [self.countDownTimer invalidate];
            self.countDownTimer = nil;
        }
    }
}

#pragma mark 乐活吧分享
- (void)jubaoShare {
    
    [self hideMenu];
    
    [shareView removeFromSuperview];
    
    NARShareView *myshareView = [[NARShareView alloc]initWithFrame:self.view.bounds];
    myshareView.narDelegate = self;
    
    GroupTalkModel *tempModel = nil;
    
    int i = 0;
    for (; i < self.data.count; i++) {
        GroupTalkModel *model = self.data[i];
        if ([model.barid isEqualToString:talkid]) {
            tempModel = model;
            break;
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:self.gameangle forKey:@"shareGroupGameAngle"];
    [[NSUserDefaults standardUserDefaults] setObject:tempModel.userid forKey:@"shareGroupUserId"];
    [[NSUserDefaults standardUserDefaults] setObject:self.model.gamecrtor forKey:@"shareGroupUserId"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:topUpper] forKey:@"shareGroupTopUpper"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:topNumber] forKey:@"shareGroupTopNumber"];
    [[NSUserDefaults standardUserDefaults] setObject:tempModel.istop forKey:@"shareGroupIsTop"];
    
    //团聊
    if ([tempModel.bartype isEqualToString:@"0"]) {
        
        GroupTalkTableViewCell *cell = (GroupTalkTableViewCell *)[self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
        
        UIImage *tempImage = [SSLImageTool scaleToSize:CGSizeMake(120, 120) withImage:cell.contentImageView.image];
        NSData *data = [SSLImageTool compressImage:tempImage withMaxKb:32];
        UIImage *image = [UIImage imageWithData:data];
        
        [myshareView createView:GrouptTalkShareType withModel:tempModel withGroupModel:self.model];
        [myshareView setShareImage:image];
        
        //活动
    } else if ([tempModel.bartype isEqualToString:@"1"]) {
        [myshareView createView:ActiveShareType withModel:tempModel withGroupModel:self.model];
    }
}

#pragma mark 置顶/取消置顶
- (void)topBar {
    
    GroupTalkModel *cuModel = self.data[self.currentIndexPath.row];
    
    //置顶类型
    if ([cuModel.bartype isEqualToString:@"0"]) {
        self.topType = @"0";
    } else if ([cuModel.bartype isEqualToString:@"1"]) {
        self.topType = @"1";
    }
    
    talkResult = cuModel.barid;
    
    //是否置顶
    if ([cuModel.istop isEqualToString:@"0"]) {
        stopResult = @"1";
    } else {
        stopResult = @"0";
    }
    
    [self topRequestReload:talkResult stopID:stopResult];
}

#pragma mark Request
#pragma mark 冒泡请求
- (void)requestWithBubble:(UIButton*)btn {
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:self.groupId forKey:@"gameid"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_Group_Bubble];
    WEAKSELF_SS
    [WWRequestOperationEngine operationManagerRequest_Post:urlString parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        btn.userInteractionEnabled = YES;
        
        if (dic == nil || ![dic isKindOfClass:[NSDictionary class]]) {
            [weakSelf showAlertMsg:ZDS_NONET_HUASHU andFrame:CGRectZero];
        }else{
            
            ZDSGroupBubbleModel *model = [ZDSGroupBubbleModel objectWithKeyValues:dic];
            
            //处理成功
            if ([model.result isEqualToString:@"0"]) {
                weakSelf.countDown = model.waittime.integerValue;
                [weakSelf createTimerWith:YES];
                [weakSelf refresh];
                if (weakSelf.data.count > 0) {
                    [weakSelf.table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
            } else {
                
                [weakSelf showAlertMsg:@"冒泡失败" andFrame:CGRectMake(60, 100, 200, 50)];
            }
        }
    }];
    
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
    //    [self showWaitView:@"正在删除"];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:deleteid forKey:@"deleteid"];
    [dictionary setObject:deltype forKey:@"deltype"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_Del_Bar];
    WEAKSELF_SS
    [WWRequestOperationEngine operationManagerRequest_Post:urlString parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        [weakSelf removeWaitView];
        
        DeleteBarModel *model = [DeleteBarModel objectWithKeyValues:dic];
        
        //处理成功
        if ([model.result isEqualToString:@"0"]) {
            [weakSelf refresh];
            //                [weakSelf.data removeObjectAtIndex:weakSelf.currentIndexPath.row];
            //                [weakSelf.table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.currentIndexPath.row inSection:1]] withRowAnimation:YES];
            [weakSelf showAlertMsg:@"删除成功" andFrame:CGRectZero];
            
            //                [weakSelf.table reloadData];
        }
    }];
}

#pragma mark NSNotification
-(void)good:(NSNotification*)object{
    NSDictionary *dic = object.object;
    for (int i = 0;i<self.data.count;i++) {
        GroupTalkModel *model  = self.data[i];
        if ([model.barid isEqualToString:dic[@"receiveid"]]) {
            model.goodStatus = dic[@"praisestatus"];
            model.goodSum =[NSString stringWithFormat:@"%d",[model.goodStatus isEqualToString:@"0"]?model.goodSum.intValue+1:model.goodSum.intValue-1];
            [self.table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
    }
}
-(void)com:(NSNotification*)object{
    NSDictionary *dic = object.object;
    for (int i = 0;i<self.data.count;i++) {
        GroupTalkModel *model  = self.data[i];
        if ([model.barid isEqualToString:dic[@"talkid"]]) {
            model.commentcount =[NSString stringWithFormat:@"%d",model.commentcount.intValue+1];
            [self.table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}
//通知
- (void)joinAct:(NSNotification *)object {
    NSString *activeid = object.object;
    for (int i = 0;i<self.data.count;i++) {
        GroupTalkModel *model  = self.data[i];
        if ([model.barid isEqualToString:activeid]) {
            model.isjoin = @"0";
            [self.table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

-(void)delteReply:(NSNotification*)object{
    
    NSDictionary *dic = object.object;
    for (int i = 0;i<self.data.count;i++) {
        GroupTalkModel *model  = self.data[i];
        if ([model.barid isEqualToString:dic[@"talkid"]]) {
            model.commentcount =[NSString stringWithFormat:@"%d",model.commentcount.intValue-1];
            [self.table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
    }
}

#pragma mark - 返回上一级
-(void)popButton{
    [shareView removeFromSuperview];
    if (self.navigationController.viewControllers.count == 1) {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}




#pragma mark - 初始化UI
-(void)setUpGUI{
    
    
    
    //初始化tableview
    self.table = [[UITableView alloc] init];
    self.table.dataSource = self;
    self.table.delegate = self;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.table.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:self.table];
    self.table.contentInset = UIEdgeInsetsMake(45, 0, 20, 0);
    self.table.scrollsToTop = YES;
    
    
    
    self.table.backgroundColor = ZDS_BACK_COLOR;
    //    self.table.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 95)];
    self.table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    self.groupCell = [[GroupTalkTableViewCell alloc] init];
    //脚视图
    //    self.footerView = [[UIView alloc] init];
    //    self.footerView.frame = CGRectMake(0, SCREEN_HEIGHT-109, SCREEN_WIDTH, 47);
    //    self.footerView.clipsToBounds = YES;
    //    self.footerView.backgroundColor = [UIColor blueColor];
    //    [self.view addSubview:_footerView];
    //初始化刷新
    //    WEAKSELF_SS
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    self.header = header;
    header.scrollView = self.table;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [self refresh];
    };
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    self.footer = footer;
    footer.scrollView = self.table;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [self loadData];
    };
}
#pragma mark - 刷新数据
-(void)refresh{
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:5];
    [dictionary setObject:self.groupId forKey:@"gameid"];
    [dictionary setObject:@"1" forKey:@"pageNum"];
    [dictionary setObject:@"10" forKey:@"pageSize"];
    //发送请求即将开团
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_TALKDETAIL];
    __weak typeof(self)weakSelf = self;
    
    [WWRequestOperationEngine operationManagerRequest_Post:urlString parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        topNumber = [dic[@"topcount"] intValue];
        topUpper = [dic[@"topupper"] intValue];
        //topupper
        
        if ([dic[@"waittime"] intValue] > 0) {
            weakSelf.countDown = [dic[@"waittime"] integerValue];
            [weakSelf createTimerWith:YES];
        }
        
        if (![dic isKindOfClass:[NSDictionary class]] || dic==nil) {
            [weakSelf showAlertMsg:ZDS_NONET_HUASHU andFrame:CGRectZero];
        }else{
            
            weakSelf.timePageNum=1;
            [weakSelf.data removeAllObjects];
            NSArray *tempArray = dic[@"barlist"];
            
            for (int i=0; i<tempArray.count; i++) {
                
                GroupTalkModel *groupTalkModel = [[GroupTalkModel alloc]init];
                
                NSDictionary *dict = [tempArray objectAtIndex:i];
                groupTalkModel.bartype = [dict objectForKey:@"bartype"];
                groupTalkModel.barid = [dict objectForKey:@"barid"];
                groupTalkModel.content = [dict objectForKey:@"content"];
                groupTalkModel.commentcount = [dict objectForKey:@"commentcount"];
                groupTalkModel.partercount = dict[@"partercount"];
                groupTalkModel.acttime = [dict objectForKey:@"acttime"];
                groupTalkModel.place = [dict objectForKey:@"place"];
                groupTalkModel.logangle = weakSelf.gameangle;
                groupTalkModel.userid = [dict objectForKey:@"userid"];
                groupTalkModel.username = [dict objectForKey:@"username"];
                groupTalkModel.userinfoimageurl =dict [@"userimage"];
                groupTalkModel.imageurl = dict[@"talkimage"];
                groupTalkModel.istop = [dict objectForKey:@"istop"];
                groupTalkModel.createtime =  [dict objectForKey:@"createtime"];
                groupTalkModel.goodSum = [dict objectForKey:@"praisecount"];
                groupTalkModel.goodStatus = [dict objectForKey:@"praisestatus"];
                groupTalkModel.isjoin = [dict objectForKey:@"isjoin"];
                groupTalkModel.actdate = [dict objectForKey:@"actdate"];
                groupTalkModel.acttiming = [dict objectForKey:@"acttiming"];
                
                [weakSelf.data addObject:groupTalkModel];
                //                weakSelf.lastId = groupTalkModel.barid;
            }
            weakSelf.lastId = tempArray.lastObject[@"barid"];
            [weakSelf.table reloadData];
        }
        [weakSelf.header endRefreshing];
    }];
}

#pragma mark - 加载更多回复
-(void)loadData{
    
    if (self.data.count == 0||self.data.count%10!=0||self.data.count<self.timePageNum*10) {
        [self showAlertMsg:@"没有更多了" andFrame:CGRectZero];
        [self.footer endRefreshing];
        return;
    }
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:6];
    [dictionary setObject:self.groupId forKey:@"gameid"];
    [dictionary setObject:[NSString stringWithFormat:@"%d",self.timePageNum+1] forKey:@"pageNum"];
    [dictionary setObject:@"10" forKey:@"pageSize"];
    if(self.lastId!=nil) [dictionary setObject:self.lastId forKey:@"lastid"];
    //发送请求即将开团
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_TALKDETAIL];
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:urlString parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (![dic isKindOfClass:[NSDictionary class]] || dic==nil) {
            [weakSelf showAlertMsg:ZDS_NONET_HUASHU andFrame:CGRectZero];
        }else{
            weakSelf.timePageNum++;
            NSArray *tempArray = dic[@"barlist"];
            for (int i=0; i<tempArray.count; i++) {
                GroupTalkModel *groupTalkModel = [[GroupTalkModel alloc]init];
                
                NSDictionary *dict = [tempArray objectAtIndex:i];
                
                //                groupTalkModel.topcount = [dic objectForKey:@""]
                //                groupTalkModel.bartype = [dict objectForKey:@"bartype"];
                //                groupTalkModel.barid = [dict objectForKey:@"barid"];
                //                groupTalkModel.content = [dict objectForKey:@"content"];
                //                groupTalkModel.commentcount = [dict objectForKey:@"commentcount"];
                //                groupTalkModel.acttime = [dict objectForKey:@"acttime"];
                //                groupTalkModel.place = [dict objectForKey:@"place"];
                //                groupTalkModel.logangle = self.gameangle;
                //                groupTalkModel.userid = [dict objectForKey:@"userid"];
                //                groupTalkModel.username = [dict objectForKey:@"username"];
                //                groupTalkModel.userinfoimageurl =dict [@"imageurl"];
                //                groupTalkModel.talkcontent = [dict objectForKey:@"talkcontent"];
                //                groupTalkModel.imageurl = dict[@"imageurl"];
                //                groupTalkModel.istop = [dict objectForKey:@"istop"];
                ////                groupTalkModel.replycount =  [dict objectForKey:@"replycount"];
                //                groupTalkModel.createtime =  [dict objectForKey:@"createtime"];
                //                groupTalkModel.goodSum = [dict objectForKey:@"praisecount"];
                //                groupTalkModel.goodStatus = [dict objectForKey:@"praisestatus"];
                groupTalkModel.bartype = [dict objectForKey:@"bartype"];
                groupTalkModel.barid = [dict objectForKey:@"barid"];
                groupTalkModel.content = [dict objectForKey:@"content"];
                groupTalkModel.commentcount = [dict objectForKey:@"commentcount"];
                groupTalkModel.partercount = dict[@"partercount"];
                groupTalkModel.acttime = [dict objectForKey:@"acttime"];
                groupTalkModel.place = [dict objectForKey:@"place"];
                groupTalkModel.logangle = weakSelf.gameangle;
                groupTalkModel.userid = [dict objectForKey:@"userid"];
                groupTalkModel.username = [dict objectForKey:@"username"];
                groupTalkModel.userinfoimageurl =dict [@"userimage"];
                //                groupTalkModel.talkcontent = [dict objectForKey:@"talkcontent"];
                groupTalkModel.imageurl = dict[@"talkimage"];
                groupTalkModel.istop = [dict objectForKey:@"istop"];
                groupTalkModel.createtime =  [dict objectForKey:@"createtime"];
                groupTalkModel.goodSum = [dict objectForKey:@"praisecount"];
                groupTalkModel.goodStatus = [dict objectForKey:@"praisestatus"];
                groupTalkModel.isjoin = [dict objectForKey:@"isjoin"];
                groupTalkModel.actdate = [dict objectForKey:@"actdate"];
                groupTalkModel.acttiming = [dict objectForKey:@"acttiming"];
                
                [weakSelf.data addObject:groupTalkModel];
                weakSelf.lastId = groupTalkModel.barid;
            }
            [weakSelf.table reloadData];
        }
        [weakSelf.footer endRefreshing];
    }];
}



#pragma mark - 置顶事件
-(void)talkidString:(NSString *)talk andType:(NSString *)type
{
    self.topType = type;
    talkResult = talk;
}

-(void)topString:(NSString *)top{
    stopResult = top;
}

-(void)clickTopButton{
    [self topRequestReload:talkResult stopID:stopResult];
    NSLog(@"stopResult********%@",stopResult);
}

-(void)topRequestReload:(NSString*)talkID stopID:(NSString*)stopid{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:5];
    [dictionary setObject:self.groupId forKey:@"gameid"];
    [dictionary setObject:stopid forKey:@"istop"];
    [dictionary setObject:self.topType forKey:@"toptype"];
    [dictionary setObject:talkID forKey:@"topid"];
    NSLog(@"——————————————%@",dictionary);
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,@"ineract/topbar.do"];
    
    WEAKSELF_SS
    [WWRequestOperationEngine operationManagerRequest_Post:urlString parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        
        if (dic == nil || ! [dic isKindOfClass:[NSDictionary class]]) {
            [weakSelf showAlertMsg:ZDS_NONET_HUASHU andFrame:CGRectZero];
        }else{
            talkid = [dic objectForKey:@"talkid"];
            if (dic[@"errinfo"]) {
                [weakSelf showAlertMsg:dic[@"errinfo"] andFrame:CGRectMake(60, 100, 200, 50)];
            }else{
                if ([stopid isEqualToString:@"1"]) {
                    [weakSelf showAlertMsg:@"置顶成功" andFrame:CGRectZero];
                }else [weakSelf showAlertMsg:@"取消置顶成功" andFrame:CGRectZero];
                [weakSelf refresh];
            }
            
            NSLog(@"置顶信息*********%@", dic);
        }
    }];
}

#pragma mark - 类型提示框
-(void)clickType{
    self.typeIntro.hidden = !self.typeIntro.hidden;
}
#pragma mark - 类型提示框隐藏
-(void)hideType:(UIGestureRecognizer*)tap{
    tap.view.hidden = YES;
}

#pragma mark - 团长跳转
-(void)clickPater:(UIButton*)btn{
    if(btn.titleLabel.text.length<1) return;
    MeViewController *me = [[MeViewController alloc] init];
    me.otherOrMe = 1;
    me.userID = btn.titleLabel.text;
    [self.navigationController pushViewController:me animated:YES];
}

#pragma mark - 举报接口
-(void)postReport:(NSString*)ifmtype{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:4];
    [dictionary setObject:talkid forKey:@"receiveid"];
    [dictionary setObject:ifmtype forKey:@"ifmtype"];
    [dictionary setObject:repotType forKey:@"ifmkind"];//0 讨论举报1 回复举报
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_TALKINFORM parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        if ([dic[@"result"] isEqualToString:@"0"]) [weakSelf showAlertMsg:@"举报成功" andFrame:CGRectMake(70,100,200,60)];
    }];
}

#pragma mark - 编辑宣言
-(void)EditorXuanyan{
    GroupEditorViewController *ge = [[GroupEditorViewController alloc] init];
    ge.msg = self.model.xuanyan;
    ge.model = self.model;
    ge.groupId = self.groupId;
    [self.navigationController pushViewController:ge animated:YES];
}

#pragma mark - 菜单栏事件
-(void)menu{
    self.menuView.hidden = !self.menuView.hidden;
}
-(void)hideMenu{
    self.menuView.hidden = YES;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self hideMenu];
    self.typeIntro.hidden = YES;
}
#pragma mark - 返回广场
-(void)goHome{
    self.navigationController.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - 去往规则页面
-(void)goRule{
    GameRuleViewController *rule = [[GameRuleViewController alloc] initWithNibName:@"GameRuleViewController" bundle:nil];
    [self.navigationController pushViewController:rule animated:YES];
}   

-(void)createShareView:(ShareGameSubClassViewType)type
{
    NARShareView *myshareView = [[NARShareView alloc]initWithFrame:self.view.bounds];
    [NSUSER_Defaults setObject:self.groupId forKey:@"fenxianggameid"];
    [NSUSER_Defaults setObject:self.model.groupName forKey:@"fenxianggamename"];
    
    UIImage *tempImage = [SSLImageTool scaleToSize:CGSizeMake(120, 120) withImage:self.image];
    NSData *data = [SSLImageTool compressImage:tempImage withMaxKb:32];
    
    [NSUSER_Defaults setObject:data forKey:@"fenxianggameimage"];
    myshareView.narDelegate = self;
    [myshareView createView:type withModel:nil withGroupModel:nil];
}

#pragma mark - 参与者视角的邀请按钮
- (IBAction)joinButtonPart:(id)sender {
    [MobClick event:@"GroupInviteClick"];
    [self createShareView:inType];
    
}

#pragma mark - 退出减脂团
- (IBAction)deleteBtn:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定退出吗?" message:@"你在本团的体重数据将不被保存哦" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 999;
    [alert show];
}

#pragma mark - 加入减脂团
- (IBAction)joinButton:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定加入吗?" message:@"在28天里，你只能加入一个减脂团哦" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"加入", nil];
    alert.tag = 888;
    [alert show];
    
}

-(void)ExitMyGame{
    [self showWaitView];
    //    self.rightButton.userInteractionEnabled = NO;
    //    self.particalButton.userInteractionEnabled = NO;
    //    self.particalDeleteButton.userInteractionEnabled = NO;
    self.view.userInteractionEnabled = NO;
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:2];
    [dictionary setObject:self.groupId forKey:@"gameid"];
    WEAKSELF_SS
    [WWRequestOperationEngine operationManagerRequest_Post:[NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_EXITDO] parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        [weakSelf removeWaitView];
        if (![dic isKindOfClass:[NSDictionary class]] || dic==nil) {
            [weakSelf showAlertMsg:ZDS_NONET_HUASHU andFrame:CGRectZero];
            weakSelf.rightButton.userInteractionEnabled = YES;
            weakSelf.view.userInteractionEnabled = YES;
        }else{
            if ([dic[@"exitflg"] isEqualToString:@"0"]) {
                [NSUSER_Defaults setValue:@"YES" forKey:@"tuanzubianhua"];
                [weakSelf showAlertMsg:@"退出减脂团成功" andFrame:CGRectMake(70,100,200,60)];
                //                [MBProgressHUD showError:@"退出减脂团成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf popButton];
                });
            }
        }
    }];
}
-(void)joinMyGame
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:3];
    [dictionary setObject:self.groupId forKey:@"gameid"];
    WEAKSELF_SS
    [WWRequestOperationEngine operationManagerRequest_Post:[NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_JOINDO] parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        if ([[dic objectForKey:@"joinflg"] isEqualToString:@"0"]) {
            //                self.joinButton.enabled = NO;
            [NSUSER_Defaults setValue:@"YES" forKey:@"tuanzubianhua"];
            if([weakSelf.model.groupType isEqualToString:@"1"]){
                [weakSelf showAlertMsg:@"加入成功！欢乐的减脂之旅即将启程！" andFrame:CGRectMake(70,100,200,60)];
            }else if([weakSelf.model.groupType isEqualToString:@"2"]){
                [weakSelf showAlertMsg:@"加入成功！欢乐的减脂之旅即将启程！" andFrame:CGRectMake(70,100,200,60)];
            }
            [weakSelf.header beginRefreshing];//刷新数据
            
            
        }
    }];
    
}

#pragma mark - 点赞
- (void)goodButton:(id)sender {
    NSLog(@"打招呼了");
    
}

-(void)clickGoodSender:(NSString*)praisesta
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setObject:@"1" forKey:@"praisetype"];//0 赞人/1 赞游戏/2赞团聊
    //  [dictionary setObject:userid forKey:@"rcvuserid"];//被赞人的用户ID当点赞类型为人时必输
    [dictionary setObject:self.groupId forKey:@"receiveid"];//被赞的游戏ID当点赞类型为游戏时必须输入
    //    [dictionary setObject:self.gamecrtor forKey:@"gamecrtor"];//游戏创建者的用户ID
    [dictionary setObject:praisesta forKey:@"praisestatus"];//0 已赞1 已取消2 已删除
    //    [dictionary setObject:self.gameName forKey:@"rcvgamename"];//点赞类型为1时必输
    
    WEAKSELF_SS
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_PRAISE_104 parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if ([dic[@"result"] isEqualToString:@"0"]) {
            if ([weakSelf.praisestatus isEqualToString:@"1"]) {//如果用户未被赞
                [weakSelf.goodButton setBackgroundImage:[UIImage imageNamed:@"yjy-32-32-"] forState:UIControlStateNormal];
                [weakSelf.goodButton popOutsideWithDuration:0.5];
                [weakSelf.goodButton animate];
                weakSelf.praisestatus = @"0";
            }else{
                [weakSelf.goodButton setBackgroundImage:[UIImage imageNamed:@"group_zan-30-30"] forState:UIControlStateNormal];
                [weakSelf.goodButton popInsideWithDuration:0.4];
                weakSelf.praisestatus = @"1";
            }
            if ([praisesta isEqualToString:@"0"]) {
                weakSelf.model.goodSum = [NSString stringWithFormat:@"%d",weakSelf.model.goodSum.intValue+1];
                weakSelf.googLabel.text = [NSString stringWithFormat:@"%d",weakSelf.googLabel.text.intValue+1];
            }
            else{
                weakSelf.model.goodSum = [NSString stringWithFormat:@"%d",weakSelf.model.goodSum.intValue-1];
                weakSelf.googLabel.text = [NSString stringWithFormat:@"%d",weakSelf.googLabel.text.intValue-1];
            }
        }
    }];
    
}

-(void)postPicture:(NSString*)myparterid
{
    shareView.shareMyType = shareInType;
    shareView.initShareView = self;
    shareView.parterid = [NSString stringWithFormat:@"%@",myparterid];
    [shareView createView:shareViewType_loadPhotoView];
    [self.view addSubview:shareView];
}

-(void)confirmShare
{
    //    [self doneLoadingTableViewData];
    [self refresh];
    
}

-(void)initShareViewconfirmShare
{
    //    [self doneLoadingTableViewData];
    
}

#pragma mark - 团组成员页面
-(void)goToGroupUser{
    GroupTeamViewController *team = [[GroupTeamViewController alloc] init];
    team.groupId = self.groupId;
    [self.navigationController pushViewController:team animated:YES];
}

#pragma mark - 去往站内邀请页面
- (IBAction)invitationButton:(id)sender {
    [MobClick event:@"GroupInviteClick"];//邀请点击次数
    [self createShareView:inType];
}

#pragma mark 进度页面（目标完成）
- (void)planButton{
    PlanViewController *plan = [[PlanViewController alloc]initWithNibName:@"PlanViewController" bundle:nil];
    plan.gameid = self.groupId;
    //    plan.grpcompleteString = grpcompleteString;//全团目标
    [self.navigationController pushViewController:plan animated:YES];
}
-(void)sendSuccess{
    [self refresh];
    if (self.data.count>0) {
        [self.table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
}
#pragma mark 团聊页面
- (void)groupTalkButton{
    
    TalkAboutViewController *talk = [[TalkAboutViewController alloc]initWithNibName:@"TalkAboutViewController" bundle:nil];
    talk.delegate = self;
    talk.userid = [NSUSER_Defaults objectForKey:ZDS_USERID];
    talk.gameid = self.groupId;
    talk.gmpassword = self.gmpassword;
    talk.hiddenSynch = NO;
    [self.navigationController
     pushViewController:talk animated:YES];
}

@end


















