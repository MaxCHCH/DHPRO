//
//  UserFeedBackViewContorller.m
//  zhidoushi
//
//  Created by xiang on 15-3-1.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "UserFeedBackViewContorller.h"
#import "MobClick.h"
#import "UITextView+LimitLength.h"
#import "UITextField+LimitLength.h"
#import "WWRequestOperationEngine.h"
#import "WWTolls.h"
#import "JSONKit.h"

#include <sys/types.h>
#include <sys/sysctl.h>

@interface UserFeedBackViewContorller()<UITextViewDelegate>
@property(weak,nonatomic) UILabel* textPlacehoader;
@property(weak,nonatomic) UIButton* submit;
@property(weak,nonatomic) UITextView* text;
@property(weak,nonatomic) UITextField* QQ;
@property(weak,nonatomic) UITextField* phone;
@end

@implementation UserFeedBackViewContorller
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"设置反馈页面"];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"设置反馈页面"];
    self.titleLabel.text = [NSString stringWithFormat:@"反馈"];
    self.titleLabel.textColor = ZDS_DHL_TITLE_COLOR;
    self.titleLabel.font = MyFont(18);
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"BarBtn_goBack_32_32"] forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = MyFont(11);
    [self.leftButton addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width = 16;
    labelRect.size.height = 16;
    labelRect.origin.x = 0;
    self.leftButton.frame = labelRect;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [WWTolls colorWithHexString:@"#eeeeee"];
    
    UITextView *text = [[UITextView alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH-40, 150)];
    self.text = text;
    text.layer.borderWidth = 0.4;
    text.layer.borderColor = [UIColor grayColor].CGColor;
    text.layer.cornerRadius = 5;
    text.delegate = self;
    text.font = MyFont(14);
    text.contentInset = UIEdgeInsetsMake(5, 3, -5, -3);
    [text limitTextLength:500];
    [self.view addSubview:text];
    
    UILabel *textlbl = [[UILabel alloc] initWithFrame:CGRectMake(28, 25, 267, 50)];
    textlbl.numberOfLines = 0;
    self.textPlacehoader = textlbl;
    textlbl.text = @"你好，我是脂斗士的产品经理，欢迎吐槽提意见~";
    textlbl.textColor = [WWTolls colorWithHexString:@"#a0a0a0"];
    textlbl.font = MyFont(14);
    [self.view addSubview:textlbl];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(35, text.bottom+18, 300, 20)];
    lbl.text = @"留下您的联系方式，方便我们为你解决问题哦~";
    lbl.font = MyFont(12);
    lbl.textColor = [WWTolls colorWithHexString:@"#535353"];
    [self.view addSubview:lbl];
    
    
    UIImageView *qqicon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"weixin_60_60"]];
    qqicon.frame = CGRectMake(20, lbl.bottom+18, 30, 30);
    [self.view addSubview:qqicon];
    
    UITextField *QQtext = [[UITextField alloc] initWithFrame:CGRectMake(60, lbl.bottom+18, 240, 30)];
    self.QQ=QQtext;
    QQtext.keyboardType = UIKeyboardTypeNamePhonePad;
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 30)];
    v.backgroundColor = [UIColor redColor];
    QQtext.leftView = v;
    QQtext.borderStyle = UITextBorderStyleRoundedRect;
    QQtext.font = MyFont(14);
    QQtext.placeholder = @"微信号（选填）";
    [QQtext limitTextLength:40];
    [self.view addSubview:QQtext];
    
    
    UIImageView *phoneicon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dianhua_60_60"]];
    phoneicon.frame = CGRectMake(20, QQtext.bottom+15, 30, 30);
    [self.view addSubview:phoneicon];
    
    UITextField *Phonetext = [[UITextField alloc] initWithFrame:CGRectMake(60, QQtext.bottom+15, 240, 30)];
    self.phone = Phonetext;
    Phonetext.keyboardType = UIKeyboardTypeNumberPad;
    Phonetext.borderStyle = UITextBorderStyleRoundedRect;
    Phonetext.font = MyFont(14);
    Phonetext.placeholder = @"手机号（选填）";
    [Phonetext limitTextLength:20];
    [self.view addSubview:Phonetext];
    
    UIButton *submit = [[UIButton alloc] initWithFrame:CGRectMake(20, Phonetext.bottom+15, SCREEN_WIDTH-40, 40)];
    self.submit = submit;
    [submit addTarget:self action:@selector(submitFeedback) forControlEvents:UIControlEventTouchUpInside];
    [submit setBackgroundImage:[UIImage imageNamed:@"wancheng-600-88_"] forState:UIControlStateNormal];
    [submit setBackgroundImage:[UIImage imageNamed:@"wancheng-600-88"] forState:UIControlStateDisabled];
    submit.enabled = NO;
    [self.view addSubview:submit];
    
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView.text.length==0&&text.length==0) {
        self.submit.enabled = NO;
        self.textPlacehoader.hidden = NO;
    }else{
        self.textPlacehoader.hidden = YES;
        self.submit.enabled = YES;
    }
    if (textView.text.length==1&&text.length==0) {
        self.textPlacehoader.hidden = NO;
        self.submit.enabled = NO;
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    [textView textFieldTextLengthLimit:nil];
}

-(void)submitFeedback{
    
    NSString *fbcontent = self.text.text;
    NSString *wechatnum = self.QQ.text;
    NSString *phonenum = self.phone.text;

    //手机系统版本
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    NSLog(@"手机系统版本: %@", phoneVersion);
    //手机型号
    NSString* phoneModel = [WWTolls getCurrentDeviceModel];
    NSLog(@"手机型号: %@",phoneModel );
    // 当前应用软件版本
    NSString *appCurVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"当前应用软件版本:%@",appCurVersion);
    
    //提交反馈信息
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:2];
    [dictionary setObject:fbcontent forKey:@"fbcontent"];
    [dictionary setObject:wechatnum forKey:@"wechatnum"];
    [dictionary setObject:phonenum forKey:@"phonenum"];
    [dictionary setObject:phoneVersion forKey:@"osversion"];
    [dictionary setObject:phoneModel forKey:@"phonemodel"];
    [dictionary setObject:appCurVersion forKey:@"appversion"];
    //..给服务器发送状态..//
    __weak typeof(self) weakself = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_FEEDBACK parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        if (!dic[ERRCODE]) {
            [weakself showAlertMsg:@"反馈成功" andFrame:CGRectMake(70,100,200,60)];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakself.navigationController popViewControllerAnimated:YES];
            });
            
        }
    }];
    
}
-(void)backTo
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
