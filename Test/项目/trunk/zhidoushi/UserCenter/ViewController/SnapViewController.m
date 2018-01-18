//
//  SnapViewController.m
//  zhidoushi
//
//  Created by glaivelee on 15/11/11.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import "SnapViewController.h"
#import "IQKeyboardManager.h"
#import "UIView+SSLAlertViewTap.h"
#import "chatView.h"
#import "InfoView.h"
#import "MyAttentionModel.h"
#import "PickerView+.h"
#import "InitShareView.h"
#import "InitShareWeightView.h"

@interface SnapViewController ()<InitShareDelegate,InitShareViewDelegate,PickerViewDelegate>
{
    int timePageNum;//页数
    chatView* chat;//曲线视图
    bool isMore;//加载状态
    UIView* dayView;//横坐标日期
    InitShareWeightView * shareWeightView;
    InitShareView * shareView;
    BMIAlertSView *customAlertView;
    
    
}
@property (nonatomic,strong) UIButton *uploadWeightButton;
@property(nonatomic, strong)InfoView* info;
@property(nonatomic, assign)BOOL hasMore;//有没有更低
@property(nonatomic,strong)PickerView_ * height_picker;
@property(nonatomic,copy)NSString *height_String;
@property(nonatomic,strong)UIButton *selectButn;//确定
@property(nonatomic,strong)UIButton *concelButn;//取消
@property(nonatomic,strong)NSMutableArray *m_DataArray;

@end

@implementation SnapViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"创建欢乐减脂团页面"];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [MobClick beginLogPageView:@"创建欢乐减脂团页面"];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    UIImage *bgImage = [WWTolls imageWithColor:[UIColor colorWithWhite:1 alpha:0] size:CGSizeMake(SCREEN_WIDTH, 100)];
    [self.navigationController.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    

}
- (void)viewDidLoad {
    [super viewDidLoad];
    //优先加载当页数据 获取当日的体重
    
//    self.view.backgroundColor = [UIColor greenColor];
    UIImage *bgImage = [WWTolls imageWithColor:[UIColor colorWithWhite:1 alpha:0] size:CGSizeMake(SCREEN_WIDTH, 100)];
    [self.navigationController.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    self.hasMore = YES;
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    UIView *titleViews = [[UIView alloc] init];
    [titleViews addSubview:self.leftButton];
    [titleViews addSubview:self.rightButton];
    self.navigationItem.titleView = titleViews;
    
    
    [self.leftButton setImage:[UIImage imageNamed:@"fh-b-36"] forState:(UIControlStateNormal)];
    [self.leftButton addTarget:self action:@selector(backVC) forControlEvents:(UIControlEventTouchUpInside)];
    CGRect leftRect = self.leftButton.frame;
    leftRect.size.width = 15;
    leftRect.size.height = 15;
    self.leftButton.frame = leftRect;
    
    
//    [self.rightButton setImage:[UIImage imageNamed:@"fx-b-36"] forState:UIControlStateNormal];
//    CGRect rightRect = self.rightButton.frame;
//    rightRect.size.width = 19;
//    rightRect.size.height = 19;
//    self.rightButton.frame = rightRect;
    
    //导航栏标题
    UILabel *title = [[UILabel alloc] init];
    title.text = @"体重";
    title.textColor = ZDS_DHL_TITLE_COLOR;
    title.font = MyFont(18);
    title.textAlignment = NSTextAlignmentCenter;
    title.frame = CGRectMake(0, 0, 320, 44);
    title.center = titleViews.center;
    [titleViews addSubview:title];
    _labelS.userInteractionEnabled = YES;
    
    //记录体重
    [_buttonRecordBMI setBackgroundImage:[UIImage imageNamed:@"jltz-314-88"] forState:(UIControlStateNormal)];
    [_buttonRecordBMI addTarget:self action:@selector(BMIAlert:) forControlEvents:(UIControlEventTouchUpInside)];
    //添加画曲线
    [self controlPressOne];
//    [self aaaaa];
    
}
//- (void)aaaaa{
//    chat.points =[[NSMutableArray arrayWithObjects:@"12",@"14",@"16",@"34",@"23",@"65",@"89", nil] mutableCopy];
//}
- (void)backVC{
    
    [self.navigationController popViewControllerAnimated:YES];
}

//加载数据 曲线
#pragma mark -随机数 模拟数据
- (NSArray* )returnPointXandYWithTip:(int)tip
{
    NSMutableArray* bfPoints = [[NSMutableArray alloc]init];
    NSMutableArray* afPoints = [[NSMutableArray alloc]init];
    int gap = chat.frame.size.width/([self rePointCountWithTip:tip]-2);
    if(([self rePointCountWithTip:tip]-2)*gap>=250){
        gap-=2;
    }
    for(int i=0; i<[self rePointCountWithTip:tip]-1; i++){
        
        CGPoint point1 =CGPointMake(5+gap*i, arc4random()%180);
        CGPoint point2 =CGPointMake(1+gap*i, arc4random()%180+20);
        
        [bfPoints addObject:[NSValue valueWithCGPoint:point1]];
        [afPoints addObject:[NSValue valueWithCGPoint:point2]];
    }
    
    return [NSArray arrayWithObjects:bfPoints,afPoints, nil];
}

- (void)controlPressOne{
    for(id obj in chat.subviews){
        if([obj isKindOfClass:[InfoView class]]){
            [obj removeFromSuperview];
        }
    }
    if(chat.lines){
        [chat.lines removeAllObjects];
        [chat.points removeAllObjects];
        [chat setNeedsDisplay];
    }
    [self reloadTodayWeightData];
    [self readyDrawLineWithTip:0];
    
}
//弹出提示框
- (IBAction)updateloadBMI:(id)sender {
    
    WEAKSELF_SS
    customAlertView = [[BMIAlertSView alloc]initWithFrame:weakSelf.view.window.bounds delegate:weakSelf];
    [customAlertView createView];
    [weakSelf.view.window addSubview:customAlertView];
    [customAlertView ssl_show];
    
}
//加载上传体重view
- (void)BMIAlert:(UIButton *)sender{
    
    WEAKSELF_SS
    shareWeightView = [[InitShareWeightView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    shareWeightView.initShareDelegate = self;
    shareWeightView.initShareType = myWeightType;
    self.shareWeightView.parterid = self.parterid;
    self.shareWeightView.weightView.top += 60;
    
    
    [shareWeightView createView];
    [weakSelf.view.window addSubview:shareWeightView];
}
//体重确认
-(void)confirmShare
{
    self.uploadWeightButton.userInteractionEnabled = YES;
    [self loadWeightData];
    //weightString
    
}
//设置身高
- (void)setWEG:(NSString *)parterid{
    
    self.height_picker = [[PickerView_ alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-200, SCREEN_WIDTH, 200) withType:heightType];
    [self.height_picker.pickerView selectRow:65 inComponent:0 animated:YES];
    
    _height_String = @"165cm";
    
    self.height_picker.pickDelegate = self;
    [self.view.window addSubview:self.height_picker];
    
}
#pragma mark -  pickViewDelegate 必须实现的两个方法
-(void)cancelBtn;{
    [self hiddenPickerView];
    
}
-(void)selectBtn:(PickerView_*)pick{
    
    [self hiddenPickerView];
    [customAlertView ssl_hidden];
    [self loadHeightwData:_height_String];
    
}
-(void)pickerValue:(NSString*)str
{
    _height_String = str;
}

//返回显示的列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return 10;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
}


- (void)readyDrawLineWithTip:(int)tip
{
    if(!chat){
        //画板 曲线
        chat = [[chatView alloc]initWithFrame:CGRectMake(0, 0, _viewBMIQuxian.frame.size.width+75, 210)];
        //        chat.opaque= NO;
        chat.backgroundColor = [UIColor clearColor];
        [_viewBMIQuxian addSubview:chat];
        UISwipeGestureRecognizer* swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(updateChatView:)];
        swipe.direction = UISwipeGestureRecognizerDirectionLeft|UISwipeGestureRecognizerDirectionRight;
        [chat addGestureRecognizer:swipe];
        
    }
    [chat.lines removeAllObjects];
    //横坐标
    if(!dayView){
        dayView = [[UIView alloc]initWithFrame:CGRectMake(0, chat.frame.size.height, chat.frame.size.width, 10)];
        //        dayView.opaque = NO;
        dayView.backgroundColor = [UIColor orangeColor];
        [chat addSubview:dayView];
    }
    if(!chat.lines.count){
        int gap = chat.frame.size.width/([self reLineCountWithTip:tip]-2);
        if(([self reLineCountWithTip:tip]-2)*gap>=250){
            gap -= 200;
        }
        
        //周几 时间 Y坐标
        for(int i=0; i<[self reLineCountWithTip:tip]; i++){
            Line* line = [[Line alloc]init];
            if(i!=[self reLineCountWithTip:tip]-1){
                line.firstPoint = CGPointMake(1+gap*i, 0);
                line.secondPoint = CGPointMake(1+gap*i, 205);
                line.color = [UIColor whiteColor];
                UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(gap*i-8, 0, 45, 10)];
                lab.backgroundColor = [UIColor purpleColor];
                [lab setText:@"09/09"];//[self reWeeksWithDay:i UseTip:tip]];
                [lab setTextColor:[UIColor whiteColor]];
                [lab setFont:[UIFont systemFontOfSize:8]];
                [dayView addSubview:lab];
                
            }else{
                line.firstPoint = CGPointMake(0, 200);
                line.secondPoint = CGPointMake(247, 200);
            }
            [chat.lines addObject:line];
        }
        
        int gap2 = chat.frame.size.width/([self rePointCountWithTip:tip]-2);
        if(([self rePointCountWithTip:tip]-2)*gap2>=250){
            gap2-=2;
        }

        //赋值
        chat.points =[[self returnPointXandYWithTip:tip] mutableCopy];
        NSLog(@"数组是%@",[self returnPointXandYWithTip:tip]);
        //
        if(tip==0){
            [chat.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if([obj isKindOfClass:[InfoView class]]){
                    [obj removeFromSuperview];
                }
            }];
            
            if([[chat.points objectAtIndex:0] count]<8){
                for(int i =0; i<[[chat.points objectAtIndex:0] count]; i++){
                    self.info = [[InfoView alloc]init];
                    [chat addSubview:self.info];
                    self.info.tapPoint = [[[chat.points objectAtIndex:0]objectAtIndex:i] CGPointValue];
                    MeWeightModel *model = _m_DataArray[i];
                    self.info.infoLabel.text = [NSString stringWithFormat:@"%@kg",model.weight];
                    [self.info sizeToFit];
                }
            }else{
                chat.isDrawPoint=YES;
            }
            
            [self.info setNeedsDisplay];
        }
        
        [chat setNeedsDisplay];
    }
}
//更新曲线
- (void)updateChatView:(UISwipeGestureRecognizer* )gesture
{
    [self readyDrawLineWithTip:0];
    [chat update];
}
//根据tip返回线的条数
- (int)reLineCountWithTip:(int)tip{
    switch (tip) {
        case 0:{
            return 3;
            break;
        }
        case 1:{
            return 8;
            break;
        }
        case 2:{
            return 7;
            break;
        }
        case 3:{
            return 4;
        }
        default:
            return 0;
            break;
    }
}
- (int)rePointCountWithTip:(int)tip
{
    switch (tip) {
        case 0:{
            return 6;
            break;
        }
        case 1:{
            return 8;
            break;
        }
        case 2:{
            return 7;
            break;
        }
        case 3:{
            return 5;
        }
        default:
            return 0;
            break;
    }
}


-(void)hiddenPickerView{
    
    CGRect rr = self.selectButn.frame;
    CGRect r2 = self.concelButn.frame;
    rr.origin.y = SCREEN_HEIGHT;
    r2.origin.y = SCREEN_HEIGHT;
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:0.2f animations:^{
        [weakself.height_picker setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200)];
        weakself.selectButn.frame = rr;
        weakself.concelButn.frame = r2;
    }];
}

//获取当日的体重
- (void)reloadTodayWeightData{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:5];
    [dic setObject:[NSString stringWithFormat:@"%d",1] forKey:@"pageNum"];
    [dic setObject:@"10" forKey:@"pageSize"];
    
//    if(self.lastId!=nil)
    self.lastId = @"";
        [dic setObject:self.lastId forKey:@"lastid"];
    
    __weak typeof(self)weakSelf = self;
    
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_LOAD_MYWEIGHT parameters:dic requestOperationBlock:^(NSDictionary *dic) {
        NSLog(@"获取数据---%@",dic);
        if ([dic[@"bmilock"] isEqualToString:@"1"]){
            _imageLock.hidden = NO;
            _labelBMINum.hidden = YES;
            _labelS.text = @"当前BMI已锁定";
            
        }
        else{
            _imageLock.hidden = YES;
            _labelBMINum.hidden = NO;
            _labelBMINum.text = dic[@"bmi"];//当前bmi
            _labelNum = dic[@"weight"];//当前体重值
            NSLog(@"_labelNum%@",_labelNum);
            _labelS.text = @"当前BMI（正常）";
            _labelDate.text = dic[@"recorddate"];//当前日期
            [self reloadDataArr:dic[@"weightlist"]];
            chat.points = _m_DataArray;
//            CGSize size = [_labelBMINum.text sizeWithFont:[UIFont fontWithName:@"Arial" size:22] constrainedToSize:CGSizeMake([WWTolls WidthForString:_labelBMINum.text fontSize:22], 100) lineBreakMode:NSLineBreakByCharWrapping];
            
            if (_labelBMINum.hidden == NO) {
                _buttonRecordBMI.hidden = NO;
            }
        }
        
    }];
    
    
}
//上传体重
- (void)loadWeightData{
    NSString *weight = [NSUSER_Defaults objectForKey:ZDS_LAST_WEIGHT];
    
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:2];
    [dic setObject:weight forKey:@"weight"];
    //    [dic setObject:@"" forKey:@"imageurl2"];
    WEAKSELF_SS
    if (self.httpOpt && !self.httpOpt.finished) {
        return;
    }
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_LOAD_SAVEWEG parameters:dic requestOperationBlock:^(NSDictionary *dic) {
        NSLog(@"获取数据---%@",dic);
        _labelNum.text =weight;
        if ([dic[@"result"] isEqualToString:@"0"]) {
//            [self reloadTodayWeightData];
        }
        
    }];
    
}
//上传身高
- (void)loadHeightwData:(NSString *)height{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:2];
    NSString *heightStr = [height stringByReplacingOccurrencesOfString:@"cm" withString:@""];
    //    [dic setObject:[NSNumber numberWithInt:[heightStr intValue]] forKey:@"height"];
    [dic setObject:heightStr forKey:@"height"];
    
    WEAKSELF_SS
    if (self.httpOpt && !self.httpOpt.finished) {
        return;
    }
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_LOAD_UPLOADHEIGHT parameters:dic requestOperationBlock:^(NSDictionary *dic) {
        
        NSLog(@"获取数据---%@",dic);

        if ([dic[@"result"] isEqualToString:@"0"]) {
            [customAlertView ssl_hidden];
//            [self reloadTodayWeightData];
        }
        
    }];
}
- (NSMutableArray *)m_DataArray{
    if (!_m_DataArray) {
        _m_DataArray = [NSMutableArray array];
    }
    return _m_DataArray;
}
- (void)reloadDataArr:(NSArray *)Arr{
    [self.m_DataArray removeAllObjects];

    for (int i = 0; i< Arr.count; i++) {
        NSDictionary *dict = Arr[i];
        MeWeightModel  *cirObj = [MeWeightModel new];
        cirObj.recorddate = dict[@"recorddate"];
        cirObj.weight = dict[@"weight"] ;
        cirObj.weightid = dict[@"weightid"] ;
        [self.m_DataArray addObject:cirObj];
    }

    //    for (int i = 0 ;i<Arr.count;i++){
    //        NSMutableArray *array = [NSMutableArray array];
    //
    //        NSDictionary * diction = Arr[i];
    //        NSString *timeStr =[diction[@"createtime"] substringToIndex:10];
    //        if (mutableDic[timeStr]!= nil) {
    //            [array addObjectsFromArray:mutableDic[timeStr]];
    //        }
    //        MePhotoModel *mode = [[MePhotoModel alloc] init];
    //        mode.photosid = diction[@"photosid"];
    //        mode.recorddate = diction[@"recorddate"];
    //        mode.linktype = diction[@"linktype"];
    //        mode.linkid = diction[@"linkid"];
    //        mode.createtime = diction[@"createtime"];
    //        mode.imageurl = diction[@"imageurl"];
    //        [array addObject:mode];
    //        [mutableDic setObject:array forKey:timeStr];
    //        BOOL isHave = false;
    //        for (NSString *s in allKeys) {
    //            if ([s isEqualToString:timeStr]) {
    //                isHave = true;
    //                break;
    //            }
    //        }
    //        if(!isHave) [allKeys addObject:timeStr];
    //    }
}




- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.navigationController.viewControllers.count == 1)//关闭主界面的右滑返回
        　　{
            　　return NO;
            　　}
    else
        　　{
            　　return YES;
            　　}
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
