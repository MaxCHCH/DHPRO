//
//  CreatGroupSubViewThreeController.m
//  zhidoushi
//
//  Created by glaivelee on 15/10/30.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import "CreatGroupSubViewThreeController.h"
#import "CreateGroupSetPasswordViewController.h"
#import "GroupViewController.h"
#import "YCSquareButton.h"
#import "YCCircleModel.h"
#import "HealthCircleViewController.h"

#import "CreateGroupSetPasswordNewViewController.h"
@interface CreatGroupSubViewThreeController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, assign)CGFloat btnHeight;
@property (nonatomic, strong)NSMutableArray *btnSelectArra;;
@property (nonatomic, strong)NSMutableArray *m_DataArray;
@property (nonatomic, strong)NSMutableArray *titleAllArr;

@end

@implementation CreatGroupSubViewThreeController
-(void)next{
    NSString *quan = @"";
    for (NSString *btntitle in _titleAllArr) {
        quan = [quan stringByAppendingString:[NSString stringWithFormat:@"%@",btntitle]];
        quan = [quan stringByAppendingString:@","];
        
    }
    [_tempDic setObject:quan forKey:@"gamecircle"];
    
    CreateGroupSetPasswordNewViewController*uc = [CreateGroupSetPasswordNewViewController new];
    uc.tempDic = _tempDic;
    [self.navigationController pushViewController:uc animated:YES];
    
//    CreateGroupSetPasswordViewController *uc = [CreateGroupSetPasswordViewController new];
//    uc.tempDic = _tempDic;
//    [self.navigationController pushViewController:uc animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    UIView *titleViews = [[UIView alloc] init];
    [titleViews addSubview:self.leftButton];
    [titleViews addSubview:self.rightButton];
    self.navigationItem.titleView = titleViews;
    _btnSelectArra = [NSMutableArray array];
    _m_DataArray = [NSMutableArray array];
    _titleAllArr = [NSMutableArray array];

    [self loadTagDate];

    //导航栏返回
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"BarBtn_goBack_32_32"] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = MyFont(14);
    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width = 16;
    labelRect.size.height = 16;
    self.leftButton.frame = labelRect;
    
    [self.rightButton setTitleColor:[WWTolls colorWithHexString:@"#959595"] forState:UIControlStateNormal];
    //分割线
    UIImageView *lineAImageView = [UIImageView new];
    lineAImageView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, 4);
    lineAImageView.image = [UIImage imageNamed:@"jdt-640-8"];
    //[WWTolls colorWithHexString:@"#dcdcdc"];
    [self.view addSubview:lineAImageView];

    UIImageView *lineBImageView = [UIImageView new];

    if ([_tempDic[@"passwordBool"] boolValue] == NO) {
        [self.rightButton setTitle:@"完成" forState:UIControlStateNormal];
        [self.rightButton addTarget:self action:@selector(overMethod) forControlEvents:UIControlEventTouchUpInside];

    }
    else {
        lineBImageView.frame = CGRectMake(self.view.frame.size.width-(self.view.frame.size.width*1/4), self.view.frame.origin.y, self.view.frame.size.width, 4);
        [self.rightButton setTitle:@"下一步" forState:UIControlStateNormal];
        [self.rightButton addTarget:self action:@selector(next) forControlEvents:(UIControlEventTouchUpInside)];
    }
    lineAImageView.image = [UIImage imageNamed:@"jdt-640-8.jpg"];
    lineBImageView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:lineBImageView];
//    [self.rightButton setTitle:@"完成" forState:UIControlStateNormal];
    self.rightButton.width = 54;
    self.rightButton.left += 110;
    self.rightButton.titleLabel.font = MyFont(16);
    //导航栏标题
    UILabel *title = [[UILabel alloc] init];
    title.text = @"圈子";
    title.textColor = ZDS_DHL_TITLE_COLOR;
    title.font = MyFont(18);
    title.textAlignment = NSTextAlignmentCenter;
    title.frame = CGRectMake(0, 0, 320, 44);
    title.center = titleViews.center;
    [titleViews addSubview:title];

    _nameLabel.frame = CGRectMake(60, lineAImageView.frame.size.height + 20, 278, 15);
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"圈子"];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"圈子"];

}
//加载
- (void)loadTagDate{
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:@"1" forKey:@"clickevent"];
    //发送请求即将开团
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_CIRCLE parameters:dictionary requestOperationBlock:^(NSDictionary *object) {
         [self reloadDataArr:[object objectForKey:@"circlelist"]];
        [self setupUI];
    }];
}
-(void)reloadDataArr:(NSArray *)arr{
    [_m_DataArray removeAllObjects];
    for (int i = 0; i<arr.count; i++) {
        NSDictionary *dict = arr[i];
        YCCircleModel  *cirObj = [YCCircleModel new];
        cirObj.circlename = dict[@"circlename"];
        cirObj.imageurlNormal = [dict[@"imageurl"] componentsSeparatedByString:@"|"][0];
        cirObj.imageurlSelect = [dict[@"imageurl"] componentsSeparatedByString:@"|"][1];

        [_m_DataArray addObject:cirObj];
    }
}
-(void)setupUI{
    
    
    // 一行最多4列
    int maxCols = 4;
    
    // 边间距
    CGFloat marginLR = 23;
    CGFloat marginTB = 15;
    
    // 中间间隙
    CGFloat marginX = 25;
    
    // 中间间隙
    CGFloat marginY = 25;
    
    // 宽度和高度
    CGFloat buttonW = ( SCREEN_WIDTH - marginLR * 2 - marginX * (maxCols - 1) )/ maxCols;
    //    float buttonH = buttonW + 10;
    CGSize size =[@"哈哈哈哈哈哈" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    CGFloat buttonH = buttonW + 10 + size.height;
    
    self.btnHeight = buttonH;
//    NSArray *titles = @[@"瘦成女神", @"减出健康", @"达人驾到", @"身材锻造", @"我是80后", @"学生党", @"运动不止", @"低卡饮食"];
//
//    NSArray *imageNormalArray = @[@"index_first_0",@"index_first_1",@"index_first_2",@"index_first_3",
//                                  @"index_first_4",@"index_first_5",@"index_first_6",@"index_first_7"];
//    NSArray *imageSeletedArray = @[@"index_s_first_0",@"index_s_first_1",@"index_s_first_2",@"index_s_first_3",
//                                  @"index_s_first_4",@"index_s_first_5",@"index_s_first_6",@"index_s_first_7"];
    YCSquareButton *yccButton;

    for (int i = 0; i <_m_DataArray.count; i++) {

        
        yccButton = [YCSquareButton squareButtonWithCircleModel:_m_DataArray[i]];
        
        [yccButton addTarget:self action:@selector(whereClick:) forControlEvents:UIControlEventTouchUpInside];
        yccButton.tag = 10+i;
        
        NSString *btntitle = _tempDic[@"whereselected"];
        if ([yccButton.currentTitle isEqualToString:btntitle]) {
            yccButton.selected = YES;
            yccButton.userInteractionEnabled = NO;
            [_titleAllArr addObject:_tempDic[@"whereselected"]];
        }
        // 计算frame
        int col = i % maxCols;
        int row = i / maxCols;
        yccButton.x = marginLR + col * (buttonW + marginX);
        //        button.y = row * buttonH + marginY + tagView1.height;
        yccButton.y = marginTB + row * (buttonH + marginY) + _nameLabel.height+25;
        yccButton.width = buttonW;
        yccButton.height = buttonH;
        
        [self.view addSubview:yccButton];
    }
    
}

-(void)whereClick:(UIButton *)sender{
    sender.selected =! sender.selected;
    
    
    if (sender.selected){
        
        [_titleAllArr addObject:[NSString stringWithFormat:@"%@",sender.currentTitle]];
    }
    else{
        [_titleAllArr removeObject:[NSString stringWithFormat:@"%@",sender.currentTitle]];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)popButton{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)overMethod{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认创建吗?" message:@"是否确认创建？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        self.rightButton.userInteractionEnabled = NO;
        [self showWaitView];
        __weak typeof(self)weakSelf = self;
        NSString *quan = @"";
        for (NSString *btntitle in _titleAllArr) {
            quan = [quan stringByAppendingString:[NSString stringWithFormat:@"%@",btntitle]];
            quan = [quan stringByAppendingString:@","];

        }
        [_tempDic setObject:quan forKey:@"gamecircle"];
        NSMutableDictionary *diction = [NSMutableDictionary dictionaryWithDictionary:_tempDic];
        [diction removeObjectsForKeys:@[@"hotTags",@"passwordBool",@"tagArray"]];
        [WWRequestOperationEngine operationManagerRequest_Post:ZDS_CREATEPTDO parameters:diction requestOperationBlock:^(NSDictionary *dic) {
                [self removeWaitView];
                if ([dic[@"createflg"] isEqualToString:@"0"]) {
                    [weakSelf showAlertMsg:@"创建成功" andFrame:CGRectMake(70,100,200,60)];
                    [NSUSER_Defaults setValue:@"YES" forKey:@"tuanzubianhua"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"createGroupSucess" object:nil];
                    NSLog(@"*********%@", [dic objectForKey:@"errinfo"]);
                    NSString *gameid = [dic objectForKey:@"gameid"];
                    GroupViewController *detail = [[GroupViewController alloc]init];
                    
                    detail.clickevent = 0;
                    detail.joinClickevent = @"0";
                    detail.groupId = gameid;//20150206020000000078
                    detail.gameDetailStatus = @"10086";
                    [weakSelf.navigationController pushViewController:detail animated:YES];
                    weakSelf.rightButton.userInteractionEnabled = NO;
                }else{
                    weakSelf.rightButton.userInteractionEnabled = YES;
                }
                
            }];
    }
    
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
