//
//  CreateGroupSetPasswordViewController.m
//  zhidoushi
//
//  Created by nick on 15/8/11.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "CreateGroupSetPasswordViewController.h"
#import "IQKeyboardManager.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "GroupViewController.h"
#import "ZSDPaymentForm.h"

@interface CreateGroupSetPasswordViewController ()
@property (nonatomic,strong) TPKeyboardAvoidingScrollView *tpBgView;
@property(nonatomic,strong)UIView *pwdBackView;//密码背景视图
@property(nonatomic,strong)ZSDPaymentForm *pwdForm;//密码框
@property(nonatomic,strong)ZSDPaymentForm *pwdAgainForm;//重复密码框

@property(nonatomic,strong)UILabel *lbl1;
@property(nonatomic,strong)UILabel *lbl2;
@property(nonatomic,strong)UILabel *lbl3;
@property(nonatomic,strong)UILabel *lbl4;
@end

@implementation CreateGroupSetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [self.rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(Next) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton setTitleColor:[WWTolls colorWithHexString:@"#959595"] forState:UIControlStateNormal];
    self.rightButton.width = 54;
    self.rightButton.left += 110;
    self.rightButton.titleLabel.font = MyFont(16);
    
    UIImageView *lineAImageView = [UIImageView new];
    lineAImageView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, 4);
    NSLog(@"---------------%f",self.view.frame.size.width);
    lineAImageView.backgroundColor = [UIColor redColor];//[WWTolls colorWithHexString:@"#dcdcdc"];
    [self.view addSubview:lineAImageView];
    
    
    //导航栏标题
    UILabel *title = [[UILabel alloc] init];
    title.text = @"入团密码";
    title.textColor = ZDS_DHL_TITLE_COLOR;
    title.font = MyFont(18);
    title.textAlignment = NSTextAlignmentCenter;
    title.frame = CGRectMake(0, 0, 320, 44);
    title.center = titleViews.center;
    [titleViews addSubview:title];
    [self setUpGUI];
    
    
    // Do any additional setup after loading the view.
}

#pragma mark - 初始化UI
-(void)setUpGUI{
    self.tpBgView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 4, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight)];
    [self.view addSubview:self.tpBgView];
    //密码提示
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 15, SCREEN_WIDTH-28, 50)];
    messageLabel.textColor = [WWTolls colorWithHexString:@"#535353"];
    messageLabel.font = MyFont(14);
    messageLabel.text = @"若你设置了入团密码，则只有知道该密码的小伙伴才能加入你的团组哦";
    messageLabel.numberOfLines = 2;
    [messageLabel sizeToFit];
    [self.tpBgView addSubview:messageLabel];
    //分割线
    UILabel *firstLine = [[UILabel alloc] initWithFrame:CGRectMake(14, messageLabel.bottom+15, SCREEN_WIDTH-28, 0.5)];
    firstLine.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
    [self.tpBgView addSubview:firstLine];
    //设置入团密码
    UILabel *setPwdLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, firstLine.bottom + 15, SCREEN_WIDTH-28, 16)];
    setPwdLabel.textColor = [WWTolls colorWithHexString:@"#535353"];
    setPwdLabel.font = MyFont(16);
    setPwdLabel.text = @"设置入团密码";
    [self.tpBgView addSubview:setPwdLabel];
    //设置入团密码按钮
    UIButton *setPwdButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 36, firstLine.bottom + 15, 16, 16)];
    [setPwdButton setBackgroundImage:[UIImage imageNamed:@"createGroup_select_32_32"] forState:UIControlStateSelected];
    [setPwdButton setBackgroundImage:[UIImage imageNamed:@"createGroup_noselect_32_32"] forState:UIControlStateNormal];
    [self.tpBgView addSubview:setPwdButton];
    setPwdButton.selected = NO;
    [setPwdButton addTarget:self action:@selector(setPwdClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.tpBgView addSubview:setPwdButton];
    //分割线
    UILabel *secondLine = [[UILabel alloc] initWithFrame:CGRectMake(14, setPwdLabel.bottom+15, SCREEN_WIDTH-28, 0.5)];
    secondLine.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
    [self.tpBgView addSubview:secondLine];
    //密码背景视图
    UIView *pwdBack = [[UIView alloc] initWithFrame:CGRectMake(24, secondLine.bottom + 38, SCREEN_WIDTH - 48, 190)];
    self.pwdBackView = pwdBack;
    [self.tpBgView addSubview:pwdBack];
    //入团密码
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 16)];
    titleLable.font = MyFont(16);
    titleLable.textColor = [WWTolls colorWithHexString:@"#535353"];
    titleLable.text = @"入团密码";
    self.lbl1 = titleLable;
    [titleLable sizeToFit];
    [pwdBack addSubview:titleLable];
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLable.right + 10, 5, 200, 11)];
    detailLabel.font = MyFont(11);
    detailLabel.textColor = [WWTolls colorWithHexString:@"#999999"];
    detailLabel.text = @"密码由6位数字组成";
    self.lbl2 = detailLabel;
    [pwdBack addSubview:detailLabel];
    ZSDPaymentForm *pwdForm = [[[NSBundle mainBundle]loadNibNamed:@"ZSDPaymentForm" owner:self options:nil]lastObject];
    pwdForm.frame = CGRectMake(0, titleLable.bottom + 10, SCREEN_WIDTH-48, 45);
    self.pwdForm = pwdForm;
    [pwdBack addSubview:pwdForm];
    //重复密码
    titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, pwdForm.bottom + 30, 100, 16)];
    titleLable.font = MyFont(16);
    titleLable.textColor = [WWTolls colorWithHexString:@"#535353"];
    titleLable.text = @"重复密码";
    self.lbl3 = titleLable;
    [titleLable sizeToFit];
    [pwdBack addSubview:titleLable];
    detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLable.right + 10, pwdForm.bottom + 35, 200, 11)];
    detailLabel.font = MyFont(11);
    detailLabel.textColor = [WWTolls colorWithHexString:@"#999999"];
    detailLabel.text = @"密码由6位数字组成";
    self.lbl4 = detailLabel;
    [pwdBack addSubview:detailLabel];
    pwdForm = [[[NSBundle mainBundle]loadNibNamed:@"ZSDPaymentForm" owner:self options:nil]lastObject];
    pwdForm.frame = CGRectMake(0, titleLable.bottom + 10, SCREEN_WIDTH-48, 45);
    self.pwdAgainForm = pwdForm;
    [pwdBack addSubview:pwdForm];
    pwdBack.hidden = YES;
    self.tpBgView.contentSize = CGSizeMake(SCREEN_WIDTH, pwdForm.bottom+20);

    //键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)setPwdClick:(UIButton*)btn{
    self.pwdBackView.hidden = btn.selected;
    [self.view endEditing:btn.selected];
    btn.selected = !btn.selected;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"创建私密减脂团页面"];
    [self.view endEditing:YES];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"创建私密减脂团页面"];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}
#pragma mark - 下一步
-(void)Next{
    if (!self.pwdBackView.hidden) {
        if (self.pwdForm.inputPassword.length<6) {
            [self showAlertMsg:@"密码由六位数字组成" yOffset:0];
            return;
        }else if (![self.pwdForm.inputPassword isEqualToString:self.pwdAgainForm.inputPassword]) {
            [self showAlertMsg:@"两次密码不一致" yOffset:0];
            return;
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认创建吗?" message:@"是否确认创建" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        self.rightButton.userInteractionEnabled = NO;
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:self.tempDic];
        [dictionary removeObjectsForKeys:@[@"hotTags",@"passwordBool",@"tagArray"]];
        if (!self.pwdBackView.hidden && self.pwdForm.inputPassword.length==6) {
            long long pwd = self.pwdForm.inputPassword.longLongValue;
            pwd = pwd*9299L+1126L+0126L;
            [dictionary setObject:[NSString stringWithFormat:@"%lld",pwd] forKey:@"gmpassword"];
        }
        __weak typeof(self)weakSelf = self;
        [WWRequestOperationEngine operationManagerRequest_Post:ZDS_CREATEPTDO parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
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

#pragma mark - 返回
-(void)popButton{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 键盘处理
#pragma mark 键盘即将显示
- (void)keyBoardWillShow:(NSNotification *)note{
    if ([self.pwdForm.inputView.passwordTextField isFirstResponder]) {
        self.lbl1.textColor = ZDS_DHL_TITLE_COLOR;
        self.lbl2.textColor = ZDS_DHL_TITLE_COLOR;
        self.lbl3.textColor = [WWTolls colorWithHexString:@"#535353"];
        self.lbl4.textColor = [WWTolls colorWithHexString:@"#535353"];
    }else if([self.pwdAgainForm.inputView.passwordTextField isFirstResponder]){
        self.lbl3.textColor = ZDS_DHL_TITLE_COLOR;
        self.lbl4.textColor = ZDS_DHL_TITLE_COLOR;
        self.lbl1.textColor = [WWTolls colorWithHexString:@"#535353"];
        self.lbl2.textColor = [WWTolls colorWithHexString:@"#535353"];
    }
}
#pragma mark 键盘即将退出
- (void)keyBoardWillHide:(NSNotification *)note{
    self.lbl1.textColor = [WWTolls colorWithHexString:@"#535353"];
    self.lbl2.textColor = [WWTolls colorWithHexString:@"#535353"];
    self.lbl3.textColor = [WWTolls colorWithHexString:@"#535353"];
    self.lbl4.textColor = [WWTolls colorWithHexString:@"#535353"];
}
@end
