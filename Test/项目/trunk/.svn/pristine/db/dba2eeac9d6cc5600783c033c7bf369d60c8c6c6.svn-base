//
//  EditLoseWeightMethodViewController.m
//  zhidoushi
//
//  Created by licy on 15/6/18.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "EditLoseWeightMethodViewController.h"
#import "UITextView+LimitLength.h"

@interface EditLoseWeightMethodViewController () <UITextViewDelegate>

@property (nonatomic,strong) UILabel *placeLabel;
@property(nonatomic,strong)UITextView *content;//内容
@end

@implementation EditLoseWeightMethodViewController

#pragma mark Life Cycle
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //友盟打点  
    [MobClick beginLogPageView:@"编辑减脂方法页面"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    //友盟打点
    [MobClick endLogPageView:@"编辑减脂方法页面"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏标题
    self.titleLabel.text = @"编辑减脂方法";
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
    [self.rightButton setTitleColor:[WWTolls colorWithHexString:@"#959595"] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(menu) forControlEvents:UIControlEventTouchUpInside];
    self.rightButton.width = 40;
    self.rightButton.height = 16;
    self.rightButton.enabled = YES;
    
    [self setUpUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    
}

#pragma mark UI
- (void)setUpUI {
    
    self.view.backgroundColor = COLOR_NORMAL_CELL_BG;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(7.5, 10, 305, 210)];
    [self.view addSubview:bgView];
    bgView.backgroundColor = [UIColor whiteColor];
    [bgView makeCorner:2.0];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, bgView.width, 15)];
    [bgView addSubview:label];
    label.text = self.groupName;
    label.font = MyFont(15.0);
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [WWTolls colorWithHexString:@"#535353"];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, label.maxY + 15, bgView.width, 0.8)];
    [bgView addSubview:lineLabel];
    lineLabel.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(7, lineLabel.maxY + 5, bgView.width - 7 * 2, bgView.height - lineLabel.maxY - 14)];
    [bgView addSubview:textView];
    textView.text = self.loseway;
    //    textView.backgroundColor = [UIColor redColor];
    textView.font = MyFont(12);
    textView.delegate = self;
    textView.textColor = [WWTolls colorWithHexString:@"#999999"];
    self.content = textView;
    [textView limitTextLength:300];
    UILabel *placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 9, textView.width - 6, 12)];
    self.placeLabel = placeLabel;
    [textView addSubview:placeLabel];
    placeLabel.font = MyFont(12.0);
    placeLabel.textColor = [WWTolls colorWithHexString:@"#999999"];
    placeLabel.text = @"减脂方式不能为空";
    self.placeLabel.hidden = YES;
    UILabel *reminderLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, bgView.maxY + 10, 200, 11)];
    [self.view addSubview:reminderLabel];
    reminderLabel.text = @"最多可以输入300个字";
    reminderLabel.font = MyFont(11);
    reminderLabel.textColor = [WWTolls colorWithHexString:@"#80cafb"];
}

#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    [textView textFieldTextLengthLimit:nil];
    self.placeLabel.hidden = textView.text.length > 0;
}   


#pragma mark Event Responses

- (void)popButton {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 修改
- (void)menu {
    if (self.content.text.length<1) {
        [self showAlertMsg:@"减脂方式不能为空" andFrame:CGRectZero];
        return;
    }else if([WWTolls isHasSensitiveWord:self.content.text]){
        [self.view endEditing:YES];
        [self showAlertMsg:@"注意哦！减脂方式中含有敏感词！" yOffset:0];
        return;
    }

    self.rightButton.enabled = NO;
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:4];
    [dictionary setObject:self.groupId forKey:@"gameid"];
    [dictionary setObject:self.crtorintro forKey:@"crtorintro"];
    [dictionary setObject:self.content.text forKey:@"loseway"];
    
    //发送请求
    WEAKSELF_SS
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_GROUP_EDITOR parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        weakSelf.rightButton.enabled = YES;
        if ([dic[@"result"] isEqualToString:@"0"]) {
            [weakSelf showAlertMsg:@"修改成功" andFrame:CGRectZero];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
}

@end
