//
//  taskDetailViewController.m
//  zhidoushi
//
//  Created by nick on 15/9/21.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import "taskDetailViewController.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "submitTaskViewController.h"
#import "TaskDoneListViewController.h"
#import "GroupTalkDetailViewController.h"
#import "PublicTaskViewController.h"

#import "UIView+SSLAlertViewTap.h"


#import "DXAlertView.h"
#import "YCTaskHeaderView.h"

@interface taskDetailViewController ()

@property(nonatomic,copy)NSString *content;//团长用户ID
@property(nonatomic,copy)NSString *gamecrtor;//完结状态
@property(nonatomic,copy)NSString *taskcmpl;//任务完成状态
@property(nonatomic,copy)NSString *tasksts;//完成任务人数
@property(nonatomic,copy)NSString *fstaskpct;//任务图像
@property(nonatomic,copy)NSString *taskimg;//任务id
@property(nonatomic,copy)NSString *gameid;//游戏ID
@property(nonatomic,copy)NSString *createtime;//时间
@property(nonatomic,strong)UIImageView *statusImage;//状态图片

@property(nonatomic,strong)UIScrollView *backView;//背景视图

/** 弹窗 */
@property (nonatomic, strong)UIView *alertView;

@end

@implementation taskDetailViewController

#pragma mark - Life Cycle
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [MobClick endLogPageView:@"任务详情页面"];
    [self.httpOpt cancel];
    self.statusImage.hidden = YES;
    if(self.statusImage.superview) [self.statusImage removeFromSuperview];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_640_88"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    //友盟打点
    [MobClick beginLogPageView:@"任务详情页面"];
    //导航栏标题
    self.titleLabel.text = self.taskMonth ? [NSString stringWithFormat:@"%@月任务%@",self.taskMonth,self.taskNum] :[NSString stringWithFormat:@"任务详情"];
    self.titleLabel.textColor = TitleColor;
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
    
    if ([self.taskcmpl isEqualToString:@"0"]) {//已结束
        self.statusImage.image = [UIImage imageNamed:@"game_workEnd-62-92"];
        self.statusImage.hidden = NO;
    }else if([self.tasksts isEqualToString:@"0"]){
        self.statusImage.image = [UIImage imageNamed:@"game_workDone-62-92"];
        self.statusImage.hidden = NO;
    }else self.statusImage.hidden = YES;
    if (!self.statusImage.superview) {
//        [[UIApplication sharedApplication].keyWindow addSubview:self.statusImage];
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    [self.view endEditing:YES];
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    
    [self reloadTask];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(submitSucess) name:@"submitTaskSucess" object:nil];
//    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"game_workEnd-62-92"]];
//    self.statusImage = image;
//    image.hidden = YES;
//    image.frame = CGRectMake(SCREEN_WIDTH - 56, 27, 46, 31);
//    [[UIApplication sharedApplication].keyWindow addSubview:image];
}


- (void)popButton{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupGUI{
    if (self.backView) {
        [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    self.titleLabel.text = [NSString stringWithFormat:@"%@月任务%@",self.taskMonth,self.taskNum];
    if ([self.taskcmpl isEqualToString:@"0"]) {//已结束
        self.statusImage.image = [UIImage imageNamed:@"game_workEnd-62-92"];
        self.statusImage.hidden = NO;
    }else if([self.tasksts isEqualToString:@"0"]){
        self.statusImage.image = [UIImage imageNamed:@"game_workDone-62-92"];
        self.statusImage.hidden = NO;
    }else self.statusImage.hidden = YES;
    for (UIView *chirldView in self.view.subviews) {
        [chirldView removeFromSuperview];
    }
    
    //背景视图
    UIScrollView *headView = [[UIScrollView alloc] init];
    headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 55);
    headView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    self.backView = headView;
    
//    headView.contentInset = UIEdgeInsetsMake(0, 0, -44, 0);
    
    [self.view addSubview:headView];
    
    
    
    // 头部
    //累计完成人次
    YCTaskHeaderView *taskHeaderV = [[YCTaskHeaderView alloc] init];
    
    if(![self.fstaskpct isEqualToString:@"0"]) {
        
        [headView addSubview:taskHeaderV];
    }
    
    taskHeaderV.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    taskHeaderV.width = SCREEN_WIDTH;
    
    taskHeaderV.timeLabel.text = [WWTolls timeString22:self.createtime];
    taskHeaderV.competeLabel.text = [NSString stringWithFormat:@"%@",self.fstaskpct];
    
    
    
    //头部分割线
    //    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    //    topLine.backgroundColor = [WWTolls colorWithHexString:@"#efefef"];
    //    topLine.layer.borderColor = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;
    //    topLine.layer.borderWidth = 0.5;
    //    [headView addSubview:topLine];
    
    CGFloat contentH = [WWTolls heightForString:self.content fontSize:15 andWidth:SCREEN_WIDTH-30]+1;
    
    // 任务内容标签文字
    UILabel *taskTag = [[UILabel alloc] init];
    taskTag.text = @"任务内容";
    
    CGFloat taskTagY = [self.fstaskpct isEqualToString:@"0"] ? 0 : taskHeaderV.maxY;
    
    taskTag.frame = CGRectMake(15, taskTagY + 30,SCREEN_WIDTH-30, [WWTolls heightForString:@"任务内容" fontSize:15]);
    taskTag.font = MyFont(15);
    taskTag.textColor = [WWTolls colorWithHexString:@"ff5304"];
    
    [headView addSubview:taskTag];
    
    //内容
    UILabel *lblcontent = [[UILabel alloc] init];
    lblcontent.numberOfLines = 0;
    lblcontent.frame = CGRectMake(15, taskTag.maxY + 10,SCREEN_WIDTH-30, contentH);
    lblcontent.font = MyFont(15);
    lblcontent.textColor = [WWTolls colorWithHexString:@"#535353"];
    //    lblcontent.userInteractionEnabled = YES;
    if(self.content && self.content.length>0){
        NSAttributedString *as = [[NSAttributedString alloc] initWithString:self.content];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        NSMutableAttributedString *aas = [[NSMutableAttributedString alloc] initWithAttributedString:as];
        [paragraphStyle setLineSpacing:8];//调整行间距
        [aas addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, [self.content length])];
        lblcontent.attributedText = aas;
        lblcontent.height = [WWTolls heightForString:self.content fontSize:15 andWidth:SCREEN_WIDTH-30];
//        [lblcontent sizeToFit];
    }
    //    UILongPressGestureRecognizer *longtap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(ContentlongTap:)];
    //    [headView addGestureRecognizer:longtap];
    
    [headView addSubview:lblcontent];
    
    // 完成次数标签(老版)
    
    //    CGFloat beforeHeight = lblcontent.maxY;
    
    CGFloat beforeHeight = 140;
    
    UILabel *competeLbl = [[UILabel alloc] init];
    if(![self.fstaskpct isEqualToString:@"0"]) {
        
        //        [headView addSubview:competeLbl];
    }
    competeLbl.frame = CGRectMake(15, beforeHeight + 10, 200, 12);
    competeLbl.font = MyFont(12);
    competeLbl.textColor = [WWTolls colorWithHexString:@"#80cafb"];
    competeLbl.text = [NSString stringWithFormat:@"累计完成%@人次",self.fstaskpct];
    competeLbl.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToDoneList)];
    [competeLbl addGestureRecognizer:tap];
    
    //时间
    UILabel *timeLbl = [[UILabel alloc] init];
    //    [headView addSubview:timeLbl];
    timeLbl.frame = CGRectMake(SCREEN_WIDTH - 165, beforeHeight + 10, 150, 12);
    timeLbl.textAlignment = NSTextAlignmentRight;
    timeLbl.font = MyFont(12);
    timeLbl.textColor = [WWTolls colorWithHexString:@"#959595"];
    timeLbl.text = [WWTolls timeString22:self.createtime];
    
    //    beforeHeight = timeLbl.bottom;
    
    beforeHeight = lblcontent.maxY;
    
    //配图
//    if (self.taskimg.length > 0) {
//        NSArray *images = [self.taskimg componentsSeparatedByString:@"|"];
//        contentH = beforeHeight + 10;
//        for (int i = 0; i<images.count; i++) {
//            UIImageView *showImage = [[UIImageView alloc] init];
//            [headView addSubview:showImage];
//            showImage.userInteractionEnabled = YES;
//            showImage.tag = i+1;
//            [showImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
//            showImage.backgroundColor = [WWTolls colorWithHexString:@"#e5e5e5"];
//            [showImage sd_setImageWithURL:[NSURL URLWithString:images[i]]];
//            CGSize imagesize = [WWTolls sizeForQNURLStr:images[i]];
//            imagesize = CGSizeMake(SCREEN_WIDTH - 14, imagesize.height / imagesize.width * (SCREEN_WIDTH - 14));
//            showImage.frame = CGRectMake(7, contentH,imagesize.width , imagesize.height);
//            showImage.contentMode = UIViewContentModeScaleAspectFit;
//            contentH +=  7+imagesize.height;
//        }
//        beforeHeight = contentH - 7;
//    }
    
    
    if (self.taskimg && self.taskimg.length > 0) {
        NSArray *images = [self.taskimg componentsSeparatedByString:@"|"];
        int imageCount = (int)images.count;
        switch (imageCount) {
            case 1:{
                //配图
                if (self.taskimg.length > 0) {
                    for (int i = 0; i<images.count; i++) {
                        UIImageView *showImage = [[UIImageView alloc] init];
                        [headView addSubview:showImage];
                        showImage.userInteractionEnabled = YES;
                        showImage.tag = i+1;
                        [showImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
                        showImage.backgroundColor = [WWTolls colorWithHexString:@"#e5e5e5"];
                        [showImage sd_setImageWithURL:[NSURL URLWithString:images[i]]];
                        CGSize imagesize = [WWTolls sizeForQNURLStr:images[i]];
                        showImage.frame = CGRectMake(15, lblcontent.maxY + 15,SCREEN_WIDTH - 30, (SCREEN_WIDTH - 30)*imagesize.height/imagesize.width);
                        //                        showImage.contentMode = UIViewContentModeScaleAspectFit;
                        beforeHeight = showImage.bottom;
                    }
                }
            }
                break;
                //3、4张 以上 为九宫格
            case 4:
            case 2:{
                
                for (int i = 0; i<images.count; i++) {
                    UIImageView *showImage = [[UIImageView alloc] init];
                    [headView addSubview:showImage];
                    showImage.userInteractionEnabled = YES;
                    showImage.tag = i+1;
                    [showImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
                    showImage.backgroundColor = [WWTolls colorWithHexString:@"#e5e5e5"];
                    [showImage sd_setImageWithURL:[NSURL URLWithString:images[i]]];
                    showImage.contentMode = UIViewContentModeScaleAspectFill;
                    showImage.clipsToBounds = YES;
                    CGFloat width = (SCREEN_WIDTH - 30 - 3)/2;
                    showImage.frame = CGRectMake(15 + (width + 3)*(i%2), lblcontent.maxY + 15 + (width +3)*(i/2), width, width);
                    beforeHeight = showImage.bottom;
                    
                    NSLog(@"%@", NSStringFromCGRect(lblcontent.frame));
                    
                    NSLog(@"%@", NSStringFromCGRect(showImage.frame));
                    
                }
                
                
            }
                break;
                
            case 5:
            case 6:
            case 7:
            case 8:
            case 9:
            case 3:{
                
                for (int i = 0; i<images.count; i++) {
                    
                    UIImageView *showImage = [[UIImageView alloc] init];
                    [headView addSubview:showImage];
                    showImage.userInteractionEnabled = YES;
                    showImage.tag = i+1;
                    [showImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
                    showImage.backgroundColor = [WWTolls colorWithHexString:@"#e5e5e5"];
                    [showImage sd_setImageWithURL:[NSURL URLWithString:images[i]]];
                    showImage.contentMode = UIViewContentModeScaleAspectFill;
                    showImage.clipsToBounds = YES;
                    CGFloat width = (SCREEN_WIDTH - 30 - 6)/3;
                    
                    showImage.frame = CGRectMake(15 + (width + 3)*(i%3), lblcontent.maxY + 15 + i/3*(width+3), width, width);
                    beforeHeight = showImage.bottom;
                    
                }
                
            }
                break;
                
            default:
            {
                for (int i = 0; i<images.count; i++) {
                    UIImageView *showImage = [[UIImageView alloc] init];
                    [headView addSubview:showImage];
                    showImage.userInteractionEnabled = YES;
                    showImage.tag = i+1;
                    [showImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
                    showImage.backgroundColor = [WWTolls colorWithHexString:@"#e5e5e5"];
                    [showImage sd_setImageWithURL:[NSURL URLWithString:images[i]]];
                    showImage.contentMode = UIViewContentModeScaleAspectFill;
                    showImage.clipsToBounds = YES;
                    CGFloat width = (SCREEN_WIDTH - 30 - 3)/2;
                    showImage.frame = CGRectMake(15 + (width + 3)*i, lblcontent.maxY, width, width);
                    beforeHeight = showImage.bottom;
                    
                }

            }

                break;
        }
        
    }
    
    
    
    beforeHeight += 10;
    if ([self.gameAngle isEqualToString:@"3"]) {//访客
        //加入团组参与讨论
        UIImageView *joinbg = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 47 -NavHeight, SCREEN_WIDTH, 47)];
        joinbg.userInteractionEnabled = YES;
        joinbg.image = [UIImage imageNamed:@"dhbj-750-128"];
        [self.view addSubview:joinbg];
        UIButton *joinBtn = [[UIButton alloc] initWithFrame:CGRectMake(66,8,SCREEN_WIDTH-132,47-16)];
        joinBtn.backgroundColor = ZDS_DHL_TITLE_COLOR;
        joinBtn.titleLabel.textColor = [UIColor whiteColor];
        joinBtn.titleLabel.font = MyFont(17);
        [joinBtn setTitle:@"加入团组  参与讨论" forState:UIControlStateNormal];
        joinBtn.clipsToBounds = YES;
        joinBtn.layer.cornerRadius = 14;
        [joinBtn addTarget:self action:@selector(gotoGroup) forControlEvents:UIControlEventTouchUpInside];
        [joinbg addSubview:joinBtn];
    }else if(![self.taskcmpl isEqualToString:@"0"]){
        //任务状态按钮
        if ([self.gamecrtor isEqualToString:[NSUSER_Defaults objectForKey:ZDS_USERID]]) {//团长
            UIImageView *joinbg = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 47 -NavHeight, SCREEN_WIDTH, 47)];
            joinbg.userInteractionEnabled = YES;
            joinbg.image = [UIImage imageNamed:@"dhbj-750-128"];
            joinbg.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:joinbg];
            //提交成绩
            UIButton *btn = [[UIButton alloc] init];
            [btn setTitle:@"提交成绩" forState:UIControlStateNormal];
            
            btn.titleLabel.font = MyFont(15);
            
            [btn setTitleColor:[WWTolls colorWithHexString:@"#475564"] forState:UIControlStateNormal];
//            [btn setBackgroundImage:[UIImage imageNamed:@"game_submitChengji-270-82"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(submitTask) forControlEvents:UIControlEventTouchUpInside];
            btn.frame = CGRectMake(15, 3, 135, 41);
            [joinbg addSubview:btn];
            //结束任务
            btn = [[UIButton alloc] init];
            btn.titleLabel.font = MyFont(15);
            [btn setTitle:@"结束任务" forState:UIControlStateNormal];
            
            [btn setTitleColor:[WWTolls colorWithHexString:@"#FF723E"] forState:UIControlStateNormal];
            
//            [btn setBackgroundImage:[UIImage imageNamed:@"game_jsrw-274-82"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(endTask) forControlEvents:UIControlEventTouchUpInside];
            btn.frame = CGRectMake(SCREEN_WIDTH - 135 - 15, 3, 135, 41);
            [joinbg addSubview:btn];
        }else{
            //提交成绩
            UIImageView *joinbg = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 47 -NavHeight, SCREEN_WIDTH, 47)];
            joinbg.backgroundColor = [UIColor whiteColor];
            joinbg.userInteractionEnabled = YES;
            joinbg.image = [UIImage imageNamed:@"dhbj-750-128"];
            [self.view addSubview:joinbg];
            UIButton *btn = [[UIButton alloc] init];
            btn.titleLabel.font = MyFont(15);
            [btn setTitle:@"提交成绩" forState:UIControlStateNormal];
            
            [btn setTitleColor:[WWTolls colorWithHexString:@"#FF723E"] forState:UIControlStateNormal];
            
//            [btn setBackgroundImage:[UIImage imageNamed:@"game_submitChengji-478-82"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(submitTask) forControlEvents:UIControlEventTouchUpInside];
            btn.frame = CGRectMake(SCREEN_MIDDLE(239), 3, 239, 41);
            [joinbg addSubview:btn];
        }
    }else if([self.gameAngle isEqualToString:@"1"]){
        UIImageView *joinbg = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 47 -NavHeight, SCREEN_WIDTH, 47)];
        joinbg.backgroundColor = [UIColor whiteColor];
        joinbg.userInteractionEnabled = YES;
        joinbg.image = [UIImage imageNamed:@"dhbj-750-128"];
        [self.view addSubview:joinbg];
        //发布新任务
        UIButton *btn = [[UIButton alloc] init];
        
        [btn setTitle:@"发布新任务" forState:UIControlStateNormal];
        
        [btn setTitleColor:[WWTolls colorWithHexString:@"#FF723E"] forState:UIControlStateNormal];
        
//        [btn setBackgroundImage:[UIImage imageNamed:@"group_pub_new_task"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(publicTask) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(SCREEN_MIDDLE(239), 3, 239, 41);
        [joinbg addSubview:btn];
        
    }else beforeHeight -= 55;
    
    headView.contentSize = CGSizeMake(SCREEN_WIDTH, beforeHeight + 51);
    
    [self removeWaitView];
}

- (void)reloadTask{
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:6];
    [dictionary setObject:self.taskId forKey:@"taskid"];
    //发送请求即将开团
    if (self.httpOpt && ![self.httpOpt isFinished]) {
        return;
    }
    [self showWaitView];
    __weak typeof(self)weakSelf = self;
    self.httpOpt = [WWRequestOperationEngine operationManagerRequest_Post:ZDS_GROUP_TASKDETAIL  parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (!dic[ERRCODE]) {
            /*
             任务ID	taskid
             任务内容	content
             团长用户ID	gamecrtor
             完结状态	taskcmpl
             任务完成状态	tasksts
             完成任务人数	fstaskpct
             任务图像	taskimg
             游戏ID	gameid
             该任务月份	themonth
             该任务月份第几次	thecount
             当月	month
             当月第几次	taskcount
             */
            weakSelf.content = dic[@"content"];
            weakSelf.gamecrtor = dic[@"gamecrtor"];
            weakSelf.taskcmpl = dic[@"taskcmpl"];
            weakSelf.tasksts = dic[@"tasksts"];
            weakSelf.fstaskpct = dic[@"fstaskpct"];
            weakSelf.taskimg = dic[@"taskimg"];
            weakSelf.gameid = dic[@"gameid"];
            weakSelf.taskMonth = dic[@"month"];
            weakSelf.taskNum = dic[@"taskcount"];
            weakSelf.nextNum = dic[@"thecount"];
            weakSelf.nextMonth = dic[@"themonth"];
            weakSelf.createtime = dic[@"createtime"];
            //导航栏标题
            weakSelf.titleLabel.text = [NSString stringWithFormat:@"%@月任务%@",weakSelf.taskMonth,weakSelf.taskNum];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf setupGUI];
            });
        }
    }];
}

//图片游览
- (void)tapImage:(UITapGestureRecognizer *)tap
{
    int count = [self.taskimg componentsSeparatedByString:@"|"].count;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        // 替换为中等尺寸图片
        NSString *url = [self.taskimg componentsSeparatedByString:@"|"][i];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径
        for (UIImageView *imgView in self.backView.subviews) {
            if (imgView.tag == i+1) {
                photo.srcImageView = imgView;
            }
        }
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = tap.view.tag - 1; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}


- (void)goToDoneList{
    TaskDoneListViewController *list = [[TaskDoneListViewController alloc] init];
    list.taskId = self.taskId;
    list.groupId = self.gameId;
    [self.navigationController pushViewController:list animated:YES];
}
- (void)gotoGroup{
    [self.navigationController popViewControllerAnimated:YES];
    //    NSMutableArray *contrllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    //    GroupHappyViewController *group = [[GroupHappyViewController alloc] init];
    //    group.groupId = self.groupId;
    //    group.clickevent = 6;
    //    group.joinClickevent = @"6";
    //    group.comeTitleTalkid = self.talkid;
    //    [contrllers removeLastObject];
    //    [contrllers addObject:group];
    //    [self.navigationController setViewControllers:contrllers animated:YES];
}

#pragma mark - 提交成绩点击
- (void)submitTask{
    [WWTolls zdsClick:TJ_TASKDETAIL_TJCJ];
    if([self.tasksts isEqualToString:@"0"]){ // 该团组还没有提交过成绩
        
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认提示" message:@"已提交过成绩，需要再次提交刷新成绩吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"需要", nil];
        //        alert.tag = 126;
        //        [alert show];
        
        
        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"" contentText:@"已提交过成绩，需要再次提交刷新成绩吗?" leftButtonTitle:nil rightButtonTitle:@"需要"];
        [alert show];
        alert.rightBlock = ^() { // 点击了需要按钮
            
            // 跳转到提交成绩界面
            [self goToSubmitTask];
        };
        
        alert.dismissBlock = ^() {
            
        };
        
    }else { // 该团组已经提交过成绩
        
        [self goToSubmitTask];
    }
    
}

- (void)publicTask{
    PublicTaskViewController *pubTask = [[PublicTaskViewController alloc] init];
    pubTask.delegate = self;
    pubTask.password = self.password;
    pubTask.gameId = self.gameId;
    pubTask.gameName = self.gameName;
    pubTask.isFromGroup = NO;
    pubTask.taskNum = [NSString stringWithFormat:@"%d",self.nextNum.intValue + 1];
    pubTask.taskMonth = self.nextMonth;
    [self.navigationController pushViewController:pubTask animated:YES];
}

- (void)pubTaskSuccess:(NSString*)taskid{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PushTaskGroupSucess" object:nil];
    self.taskId = taskid;
    [self reloadTask];
}

#pragma mark - 提交成绩成功
- (void)submitSucess{
    self.tasksts = @"0";
    self.fstaskpct = [NSString stringWithFormat:@"%d",self.fstaskpct.intValue + 1];
    [self setupGUI];
}

- (void)dealloc{
    if(self.statusImage.superview) [self.statusImage removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 去往提交成绩页面
- (void)goToSubmitTask{
    submitTaskViewController *submit = [[submitTaskViewController alloc] init];
    submit.gameId = self.gameId;
    submit.taskId = self.taskId;
    submit.password = self.password;
    submit.clickevent = @"2";
    [self.navigationController pushViewController:submit animated:YES];
}


#pragma mark - 结束任务
- (void)endTask{
    if([self.fstaskpct isEqualToString:@"0"]){ // 团组没人
        
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认提示" message:@"目前还没有人完成任务，就这样结束任务了吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"是", nil];
        //        alert.tag = 123;
        //        [alert show];
        
        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"" contentText:@"目前还没有任何人完成任务\n就这样结束任务了吗?" leftButtonTitle:nil rightButtonTitle:@"确认"];
        [alert show];
        alert.rightBlock = ^() {
            NSLog(@"点击了确定");
            
            DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"" contentText:@"是否需要生成任务报告?" leftButtonTitle:@"取消" rightButtonTitle:@"确认"];
            [alert show];
            
            alert.leftBlock = ^() { // 取消按钮
                
                [self endTaskRequest:NO];
            };
            alert.rightBlock = ^() { // 确认按钮
                NSLog(@"点击了确定");
                [self endTaskRequest:YES];
                
            };
            alert.dismissBlock = ^() {
                NSLog(@"点击了右上角的叉");
            };
            
        };
        
        alert.dismissBlock = ^() {
            NSLog(@"点击了右上角的叉");
            
        };
        
        
        
    }else{ // 团组有人
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认提示" message:@"是否结束任务" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        //        alert.tag = 124;
        //        [alert show];
        
        
        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"" contentText:@"是否结束任务?" leftButtonTitle:nil rightButtonTitle:@"确认"];
        [alert show];
        alert.rightBlock = ^() { // 点击了确认按钮
            
            [self endTaskRequest:YES];
            
        };
        
        alert.dismissBlock = ^() { // 叉叉按钮
            
        };
        
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 123) {
        if (buttonIndex == 1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认提示" message:@"是否需要生成任务报告？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"是", nil];
            alert.tag = 456;
            [alert show];
            
        }
    }else if(alertView.tag == 456){
        if (buttonIndex == 1) {
            [self endTaskRequest:YES];
        }else if(buttonIndex == 0){
            [self endTaskRequest:NO];
        }
    }else if(alertView.tag == 124){
        if(buttonIndex == 1) [self endTaskRequest:YES];
    }else if(alertView.tag == 126){
        if(buttonIndex == 1) [self goToSubmitTask];
    }
}

- (void)endTaskRequest:(BOOL)isWithDiscover{
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:[NSString stringWithFormat:@"%@",isWithDiscover?@"0":@"1"] forKey:@"syntitle"];
    [dictionary setObject:[NSString stringWithFormat:@"%@",self.gameId] forKey:@"gameid"];
    [dictionary setObject:[NSString stringWithFormat:@"%@",self.taskId] forKey:@"taskid"];
    [dictionary setObject:@"2" forKey:@"clickevent"];
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_GROUP_ENDTASK parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        if([dic[@"result"] isEqualToString:@"0"]){
            weakSelf.taskcmpl = @"0";
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf setupGUI];
            });
            if(isWithDiscover) {
                [MBProgressHUD showError:@"已自动生成任务报告，请到团组精华帖中查看！"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"sendTitleSucess" object:nil];
                if(dic[@"talkid"] && [dic[@"talkid"] length] > 0){
                    GroupTalkDetailViewController *reply = [[GroupTalkDetailViewController alloc] init];
                    reply.talkid = dic[@"talkid"];
                    reply.talktype = GroupTitleTalkType;
                    reply.clickevent = 4;
                    reply.isShowTopBtn = YES;
                    reply.groupId = weakSelf.gameId;
                    [weakSelf.navigationController pushViewController:reply animated:YES];
                }
            }
            else {
                [MBProgressHUD showError:@"结束成功"];
                [weakSelf popButton];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"endTaskSucess" object:nil];
            //            [weakSelf popButton];
        }
    }];
}

@end
