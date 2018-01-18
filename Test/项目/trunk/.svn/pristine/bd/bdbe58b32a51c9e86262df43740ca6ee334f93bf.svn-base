//
//  SendAllMessageViewController.m
//  zhidoushi
//
//  Created by licy on 15/6/18.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "SendAllMessageViewController.h"
#import "MassmsgModel.h"
#import "MJExtension.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "IQKeyboardManager.h"
#import "UITextView+LimitLength.h"
#import "GroupSendMsgListViewController.h"

@interface SendAllMessageViewController () <UITextViewDelegate>

@property (nonatomic,strong) UILabel *placeLabel;

@property(nonatomic,strong)UILabel *contentNumLbl;//字数提示

@property (nonatomic,strong) UITextView *textView;

@property (nonatomic,strong) TPKeyboardAvoidingScrollView *tpBgView;

@end

@implementation SendAllMessageViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //友盟打点
    [MobClick beginLogPageView:@"群发通知页面"];
    
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    
    //导航栏标题
    self.titleLabel.text = @"群发通知";
    self.titleLabel.textColor = ZDS_DHL_TITLE_COLOR;
    self.titleLabel.font = MyFont(18);
    //导航栏返回
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"BarBtn_goBack_32_32"] forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = MyFont(13);
    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width = 16;
    labelRect.size.height = 16;
    self.leftButton.frame = labelRect;
    //导航栏右边按钮
    //导航栏发布
    [self.rightButton setTitle:@"发布" forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = MyFont(16);
    [self.rightButton setTitleColor:ZDS_DHL_TITLE_COLOR forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[WWTolls colorWithHexString:@"#959595"] forState:UIControlStateDisabled];
    [self.rightButton addTarget:self action:@selector(menu) forControlEvents:UIControlEventTouchUpInside];
    self.rightButton.width = 40;
    self.rightButton.height = 16;
    self.rightButton.enabled = self.textView.text.length>0;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"群发通知页面"];
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    
}

#pragma mark - UI
- (void)setUpUI {
    
    self.view.backgroundColor = COLOR_NORMAL_CELL_BG;
    
    self.tpBgView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight)];
    [self.view addSubview:self.tpBgView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(7.5, 10, self.tpBgView.width - 15, 210)];
    [self.tpBgView addSubview:bgView];
    bgView.backgroundColor = [UIColor whiteColor];
    [bgView makeCorner:2.0];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, bgView.width, 17)];
    [bgView addSubview:label];
    label.text = self.gameName;
    label.font = MyFont(15.0);
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [WWTolls colorWithHexString:@"#535353"];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, label.maxY + 15, bgView.width, 0.8)];
    [bgView addSubview:lineLabel];
    lineLabel.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
    
    UILabel *toAllLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, lineLabel.maxY + 14, bgView.width - 14, 14)];
    [bgView addSubview:toAllLabel];
    toAllLabel.text = @"To 所有团员";
    toAllLabel.font = MyFont(14.0);
    toAllLabel.textColor = [WWTolls colorWithHexString:@"#565bd9"];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(7, toAllLabel.maxY + 5, bgView.width - 7 * 2, bgView.height - lineLabel.maxY - 54)];
    [bgView addSubview:textView];
    //    textView.backgroundColor = [UIColor redColor];
    textView.font = MyFont(12);
    textView.delegate = self;
    [textView limitTextLength:301];
    textView.textColor = [WWTolls colorWithHexString:@"#999999"];
    self.textView = textView;
    
    UILabel *placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 9, textView.width - 6, 12)];
    self.placeLabel = placeLabel;
    [textView addSubview:placeLabel];
    placeLabel.font = MyFont(12.0);
    placeLabel.textColor = [WWTolls colorWithHexString:@"#999999"];
    placeLabel.text = @"团长大人，在这里编辑信息可以发布给所有团员";
    
    UILabel *reminderLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, bgView.maxY + 10, 200, 11)];
    [self.tpBgView addSubview:reminderLabel];
    reminderLabel.text = [self.model.sendmsgct isEqualToString:@"0"]?@"今日群发消息次数已用尽":[NSString stringWithFormat:@"今日还可发布%@次群发通知",self.model.sendmsgct];
    reminderLabel.font = MyFont(11);
    reminderLabel.textColor = [WWTolls colorWithHexString:@"#80cafb"];
    
    UILabel *contentNumLbl = [[UILabel alloc] init];
    self.contentNumLbl = contentNumLbl;
    contentNumLbl.frame = CGRectMake(SCREEN_WIDTH - 115, textView.bottom, 85, 12);
    contentNumLbl.text = @"0/300";
    contentNumLbl.textAlignment = NSTextAlignmentRight;
    contentNumLbl.font = MyFont(11);
    contentNumLbl.textColor = [WWTolls colorWithHexString:@"#959595"];
    [bgView addSubview:contentNumLbl];
    
    UIButton *Morebtn = [[UIButton alloc] init];
    Morebtn.frame = CGRectMake(60, SCREEN_HEIGHT - NavHeight - 30, SCREEN_WIDTH-120, 22);
    Morebtn.titleLabel.font = MyFont(11);
    [Morebtn setTitleColor:[WWTolls colorWithHexString:@"#959595"] forState:UIControlStateNormal];
    [Morebtn setTitle:@"查看历史群发消息 >" forState:UIControlStateNormal];
    [self.tpBgView addSubview:Morebtn];
    [Morebtn addTarget: self action:@selector(lookMore) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 查看历史消息
- (void)lookMore{
    GroupSendMsgListViewController *message = [[GroupSendMsgListViewController alloc] init];
    message.groupId = self.gameId;
    [self.navigationController pushViewController:message animated:YES];
}

#pragma mark - Delegate
#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    
    [textView textFieldTextLengthLimit:nil];
    self.placeLabel.hidden = textView.text.length > 0;
    self.rightButton.enabled = self.placeLabel.hidden;
    self.contentNumLbl.text = [NSString stringWithFormat:@"%ld/300",textView.text.length];
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (text.length + textView.text.length - range.length >= 301) {
        NSString *newText = [textView.text stringByReplacingCharactersInRange:range withString:text];
        textView.text = [newText substringToIndex:300];
        return NO;
    }
    return YES;
}

#pragma mark - Event Responses

- (void)popButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)menu {
    
    
    
    NSString *content = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (!(content.length > 0)) {
        [self showAlertMsg:@"任务内容不能为空" andFrame:CGRectZero];
        
        return;
    }else if([WWTolls isHasSensitiveWord:content]){
        [self showAlertMsg:ZDS_HASSENSITIVE yOffset:0];
        return;
    }

    
    self.rightButton.userInteractionEnabled = NO;
    
    [self requestWithMassmsg];
}   

#pragma mark - Private Methods

#pragma 团长向团员群发通知请求
- (void)requestWithMassmsg {
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:[NSString stringWithFormat:@"%@",self.gameId] forKey:@"gameid"];
    [dictionary setObject:[NSString stringWithFormat:@"%@",self.textView.text] forKey:@"content"];
    
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_Massmsg parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        weakSelf.rightButton.userInteractionEnabled = YES;
        MassmsgModel *model = [MassmsgModel objectWithKeyValues:dic];
        //成功
        if ([model.result isEqualToString:@"0"]) {
            [[UIApplication sharedApplication].keyWindow.rootViewController showAlertMsg:@"发布成功！" andFrame:CGRectZero];
            if(weakSelf.model.sendmsgct && ![weakSelf.model.sendmsgct isEqualToString:@"0"]) weakSelf.model.sendmsgct = [NSString stringWithFormat:@"%d",[weakSelf.model.sendmsgct intValue] - 1];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - Public Methods
#pragma mark - UIResponder
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

@end
