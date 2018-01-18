//
//  GroupEditorViewController.m
//  zhidoushi
//
//  Created by nick on 15/5/4.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "GroupEditorViewController.h"
#import "UITextView+LimitLength.h"

@interface GroupEditorViewController ()<UITextViewDelegate>
@property(nonatomic,strong)UITextView *content;//内容框
@end

@implementation GroupEditorViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"编辑团公告页面"];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //友盟打点
    [MobClick beginLogPageView:@"编辑团公告页面"];
    //导航栏返回
    [self.leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[WWTolls colorWithHexString:@"#959595"] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = MyFont(16);
    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width = 40;
    labelRect.size.height = 16;
    self.leftButton.frame = labelRect;
    //导航栏发布
    [self.rightButton setTitle:@"发布" forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = MyFont(16);
    [self.rightButton setTitleColor:[WWTolls colorWithHexString:@"#959595"] forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
    [self.rightButton addTarget:self action:@selector(editor) forControlEvents:UIControlEventTouchUpInside];
    self.rightButton.width = 40;
    self.rightButton.height = 16;
}

#pragma mark - 返回上一级
-(void)popButton{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)viewDidLoad{
    [super viewDidLoad];
    [self setupGUI];
}
#pragma mark - 初始化UI
-(void)setupGUI{
    self.view.backgroundColor = [WWTolls colorWithHexString:@"#efefef"];
    //文本输入框
    UITextView *text = [[UITextView alloc] init];
    self.content = text;
    text.frame = CGRectMake(7, 7, 306, 83);
    text.delegate = self;
    text.font = MyFont(15);
    text.textColor = [WWTolls colorWithHexString:@"#999999"];
    text.text = self.msg;
    text.contentInset = UIEdgeInsetsMake(5, 3, -5, -3);
    [text limitTextLength:50];
    [self.view addSubview:text];
    //提示
    UILabel *lbl = [[UILabel alloc] init];
    lbl.text = @"最多可以输入50个字";
    lbl.frame = CGRectMake(14, 97, 150, 12);
    lbl.font = MyFont(11);
    lbl.textColor = [WWTolls colorWithHexString:@"#80cafb"];
    [self.view addSubview:lbl];
    
}

#pragma mark - 发表发现
-(void)editor{
    self.rightButton.enabled = NO;
    if (self.content.text.length<1) {
        [self showAlertMsg:@"内容不能为空" yOffset:-100];
        self.rightButton.enabled = YES;
        return;
    }else if([WWTolls isHasSensitiveWord:self.content.text]){
        [self showAlertMsg:@"注意哦！团公告中含有敏感词！" yOffset:-100];
        self.rightButton.enabled = YES;
        return;
    }
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:4];
    [dictionary setObject:self.content.text forKey:@"gmslogan"];
    [dictionary setObject:self.groupId forKey:@"gameid"];
    
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_GROUP_EDITOR_GONGGAO parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if ([dic[@"result"] isEqualToString:@"0"]) {
            weakSelf.model.xuanyan = weakSelf.content.text;
            [weakSelf showAlertMsg:@"发布成功" yOffset:0];
            weakSelf.content.text = nil;
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        self.rightButton.enabled = YES;
    }];
}

#pragma mark - UItextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    [self.rightButton setTitleColor:ZDS_DHL_TITLE_COLOR forState:UIControlStateNormal];
    [textView textFieldTextLengthLimit:nil];
}

@end
