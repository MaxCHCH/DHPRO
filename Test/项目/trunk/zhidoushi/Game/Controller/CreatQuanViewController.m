//
//  CreatQuanViewController.m
//  zhidoushi
//
//  Created by glaivelee on 15/11/14.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import "CreatQuanViewController.h"

#import "CreateGroupSetPasswordViewController.h"
#import "GroupViewController.h"
#import "YCSquareButton.h"
#import "YCCircleModel.h"
#import "HealthCircleViewController.h"
#import "CreateGroupSetPasswordNewViewController.h"
#import "UIButton+WebCache.h"

@interface CreatQuanViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, assign)CGFloat btnHeight;
@property (nonatomic, strong)NSMutableArray *btnSelectArra;;
@property (nonatomic, strong)NSMutableArray *m_DataArray;
@property (nonatomic, strong)NSMutableArray *titleAllArr;
@end

@implementation CreatQuanViewController
- (NSMutableArray *)m_DataArray{
    if (!_m_DataArray) {
        _m_DataArray = [NSMutableArray array];
    }
    return _m_DataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _titleAllArr = [NSMutableArray array];
    [self loadTagDate];
    UIView *titleViews = [[UIView alloc] init];
    [titleViews addSubview:self.leftButton];
    [titleViews addSubview:self.rightButton];
    self.navigationItem.titleView = titleViews;

    //导航栏返回
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"fh-36.png"] forState:UIControlStateNormal];
    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width = 18;
    labelRect.size.height = 18;
    self.leftButton.frame = labelRect;
    [self.rightButton setTitleColor:[WWTolls colorWithHexString:@"#959595"] forState:UIControlStateNormal];
    self.rightButton.width = 45;
    self.rightButton.left = 15;
    self.rightButton.titleLabel.font = MyFont(15);
    //导航栏标题
    UILabel *title = [[UILabel alloc] init];
    title.text = @"圈子";
    title.textColor = ZDS_DHL_TITLE_COLOR;
    title.font = MyFont(17);
    title.textAlignment = NSTextAlignmentCenter;
    title.frame = CGRectMake(0, 0, 320, 44);
    title.center = titleViews.center;
    [titleViews addSubview:title];
    //底部分割线  YES : VIP
    UILabel *labelBottomline = [UILabel new];
    labelBottomline.backgroundColor = OrangeColor;
    labelBottomline.frame = CGRectMake(0 ,self.view.bottom ,SCREEN_WIDTH , 4);
    [self.backgroundImageView addSubview:labelBottomline];

    //分割线
    if ([_tempDic[@"passwordBool"] boolValue] == NO) {
        [self.rightButton setTitle:@"完成" forState:UIControlStateNormal];
        [self.rightButton setTitleColor:OrangeColor forState:(UIControlStateNormal)];
        [self.rightButton addTarget:self action:@selector(overMethod) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        [self.rightButton setTitle:@"下一步" forState:UIControlStateNormal];
        [self.rightButton addTarget:self action:@selector(next) forControlEvents:(UIControlEventTouchUpInside)];

    }

    _buttonOne.layer.cornerRadius = 125/2;
    _buttonTwo.layer.cornerRadius = 86.5/2;
    _buttonThree.layer.cornerRadius = 85/2;
    _buttonFour.layer.cornerRadius = 96/2;
    _buttonFive.layer.cornerRadius = 105/2;
    _buttonSix.layer.cornerRadius = 82.5/2;
    _buttonSeven.layer.cornerRadius = 87/2;
    _buttonEight.layer.cornerRadius = 115/2;
    
    
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
//        [_tempDic objectForKey:@"gametags"];
        [_tempDic setObject:quan forKey:@"gamecircle"];
        NSMutableDictionary *diction = [NSMutableDictionary dictionaryWithDictionary:_tempDic];
        [diction removeObjectsForKeys:@[@"hotTags",@"passwordBool",@"tagArray"]];
        [diction setObject:_titleAllArr forKey:@"taglist"];

        [WWRequestOperationEngine operationManagerRequest_Post:ZDS_CREATEPTDO parameters:diction requestOperationBlock:^(NSDictionary *dic) {
            [self removeWaitView];
            if ([dic[@"createflg"] isEqualToString:@"0"]) {
                [weakSelf showAlertMsg:@"创建成功" andFrame:CGRectMake(70,100,200,60)];
                [NSUSER_Defaults setValue:@"YES" forKey:@"tuanzubianhua"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"createGroupSucess" object:nil];
                NSString *gameid = [dic objectForKey:@"gameid"];
                GroupViewController *detail = [[GroupViewController alloc]init];
                //gametags
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
//加载
- (void)loadTagDate{
    
    //  1 减脂吧
    //  2 创建团组
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:@"2" forKey:@"clickevent"];
    //发送请求即将开团
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_CIRCLE parameters:dictionary requestOperationBlock:^(NSDictionary *object) {

        [self reloadDataArr:[object objectForKey:@"circlelist"]];
        
        [self setButtonImage];
    }];
}
-(void)reloadDataArr:(NSArray *)arr{
    [self.m_DataArray removeAllObjects];
    for (int i = 0; i< arr.count; i++) {
        NSDictionary *dict = arr[i];
        YCCircleModel  *cirObj = [YCCircleModel new];
        cirObj.circlename = dict[@"circlename"];
        cirObj.imageurlNormal = dict[@"imageurl"] ;
        
        [self.m_DataArray addObject:cirObj];
    }
}

- (void)setButtonImage{

    if (self.m_DataArray.count < 8) {
        return;
    }
    YCCircleModel  *cirObj1 = self.m_DataArray[0];
    [_buttonOne sd_setBackgroundImageWithURL:[NSURL URLWithString:cirObj1.imageurlNormal] forState:(UIControlStateNormal)];
    
    YCCircleModel  *cirObj2 = self.m_DataArray[1];
    [_buttonTwo sd_setBackgroundImageWithURL:[NSURL URLWithString:cirObj2.imageurlNormal] forState:(UIControlStateNormal)];
    
    YCCircleModel  *cirObj3 = self.m_DataArray[2];
    [_buttonThree sd_setBackgroundImageWithURL:[NSURL URLWithString:cirObj3.imageurlNormal] forState:(UIControlStateNormal)];
    YCCircleModel  *cirObj4 = self.m_DataArray[3];
    [_buttonFour sd_setBackgroundImageWithURL:[NSURL URLWithString:cirObj4.imageurlNormal] forState:(UIControlStateNormal)];
    
    YCCircleModel  *cirObj5 = self.m_DataArray[4];
    [_buttonFive sd_setBackgroundImageWithURL:[NSURL URLWithString:cirObj5.imageurlNormal] forState:(UIControlStateNormal)];
    
    YCCircleModel  *cirObj6 = self.m_DataArray[5];
    [_buttonSix sd_setBackgroundImageWithURL:[NSURL URLWithString:cirObj6.imageurlNormal] forState:(UIControlStateNormal)];
    
    YCCircleModel  *cirObj7 = self.m_DataArray[6];
    [_buttonSeven sd_setBackgroundImageWithURL:[NSURL URLWithString:cirObj7.imageurlNormal] forState:(UIControlStateNormal)];
    
    YCCircleModel  *cirObj8 = self.m_DataArray[7];
    [_buttonEight sd_setBackgroundImageWithURL:[NSURL URLWithString:cirObj8.imageurlNormal] forState:(UIControlStateNormal)];
}
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


- (void)public:(UIButton*)sender{
    if (sender.selected){
        [_titleAllArr addObject:[NSString stringWithFormat:@"%@",sender.currentTitle]];
        [self buttonSelectedState:sender.tag];
        NSLog(@"%ld",(long)sender.tag);
        
    }
    else{
        [_titleAllArr removeObject:[NSString stringWithFormat:@"%@",sender.currentTitle]];
        sender.layer.borderColor = [UIColor clearColor].CGColor;
        sender.layer.borderWidth = 0;
        [self setButtonImage];
    }
}
- (void)buttonSelectedState:(NSInteger)tag{
    
    switch (tag) {
        case 30:
            [_buttonOne setBackgroundImage:[WWTolls imageWithColor:[WWTolls colorWithHexString:@"#50E3C2"]] forState:UIControlStateSelected];
            break;
        case 31:
            [_buttonTwo setBackgroundImage:[WWTolls imageWithColor:[WWTolls colorWithHexString:@"#FB6C6A"]] forState:(UIControlStateSelected)];
            break;
        case 32:
            [_buttonThree setBackgroundImage:[WWTolls imageWithColor:[WWTolls colorWithHexString:@"#B8E986"]] forState:(UIControlStateSelected)];
            break;
        case 33:
            [_buttonFour setIsPressdWithTitle:nil backgroundImage:[WWTolls imageWithColor:[WWTolls colorWithHexString:@"#FF723E"]] forState:(UIControlStateSelected)];
            break;
        case 34:
            [_buttonFive setBackgroundImage:[WWTolls imageWithColor:[WWTolls colorWithHexString:@"#FFC835"]] forState:(UIControlStateSelected)];
            break;
        case 35:
            [_buttonSix setBackgroundImage:[WWTolls imageWithColor:[WWTolls colorWithHexString:@"#4599FB"]] forState:(UIControlStateSelected)];
            break;
        case 36:
            [_buttonSeven setBackgroundImage:[WWTolls imageWithColor:[WWTolls colorWithHexString:@"#F5A623"]] forState:(UIControlStateSelected)];
            break;
        case 37:
            [_buttonEight setBackgroundImage:[WWTolls imageWithColor:[WWTolls colorWithHexString:@"#7ED321"]] forState:(UIControlStateSelected)];

            break;
            
        default:
            
            break;
    }

}


- (IBAction)touchHealthWithTag:(UIButton *)sender {
    sender.selected =! sender.selected;

    switch (sender.tag) {
        case 30:
            [self public:sender];
            break;
        case 31:
            [self public:sender];
            break;
        case 32:
            [self public:sender];
            break;
        case 33:
            [self public:sender];
            break;
        case 34:
            [self public:sender];
            break;
        case 35:
            [self public:sender];
            break;
        case 36:
            [self public:sender];
            break;
        case 37:
            [self public:sender];
            break;

        default:
            
            break;
    }
}

- (void)buttonNormalState:(NSInteger)tag{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
