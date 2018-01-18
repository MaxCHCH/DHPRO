//
//  SignatureController.m
//  zhidoushi
//
//  Created by ji on 15/11/13.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import "SignatureController.h"

#import "MobClick.h"
#import "UITextView+LimitLength.h"
#import "UITextField+LimitLength.h"
#import "WWTolls.h"
#import "IQKeyboardManager.h"
#import "UserModel.h"


@interface SignatureController ()<UITextViewDelegate>

@end

@implementation SignatureController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"修改个性签名页面"];
    self.rightButton.enabled = YES;
    [self.view endEditing:YES];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [MobClick beginLogPageView:@"修改个性签名页面"];
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"fh-36"] forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = MyFont(13);
    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width =16;
    labelRect.size.height = 16;
    self.leftButton.frame = labelRect;
    
    [self.rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.rightButton setTitle:@"保存" forState:UIControlStateNormal];
    self.rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.rightButton.bounds = CGRectMake(0, 0, 30, 16);
    [self.rightButton setTitleColor:OrangeColor forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = MyFont(15);
    [self.rightButton addTarget:self action:@selector(success:) forControlEvents:UIControlEventTouchUpInside];
    
    self.titleLabel.text = @"编辑签名";
    self.titleLabel.font = MyFont(17);
    self.titleLabel.textColor = [WWTolls colorWithHexString:@"#475564"];
    
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    
}

-(void)popButton{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 上传用户数据
- (IBAction)success:(id)sender {
    
    if(self.signaturetext != nil && self.signaturetext.text.length != 0){//必须输入昵称
        if (self.signblock) {
            self.signblock(self.signaturetext.text);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self showAlertMsg:@"请输入签名" andFrame:CGRectMake(70,100,200,60)];
    }
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [WWTolls colorWithHexString:@"#F7F1F1"];
    
    UITextView *text = [[UITextView alloc] initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 140)];
    self.signaturetext = text;
    self.signaturetext.text = self.strtext;
    self.signaturetext.textColor = [WWTolls colorWithHexString:@"#4E777F"];
    text.delegate = self;
    text.font = MyFont(15);
    text.contentInset = UIEdgeInsetsMake(5, 3, -5, -3);
    [text limitTextLength:30];
    [self.view addSubview:text];
    
    UILabel *textlbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, 200, 16)];
    textlbl.numberOfLines = 0;
    self.textPlacehoader = textlbl;
    textlbl.text = @"输入文字内容";
    textlbl.textColor = [WWTolls colorWithHexString:@"#4E777F"];
    textlbl.font = MyFont(15);
    [textlbl sizeToFit];
    [self.view addSubview:textlbl];
    
    UILabel *numlbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-51,137,47,14)];
    self.textNumber = numlbl;
    numlbl.text = @"(0/30)";
    numlbl.textColor = [WWTolls colorWithHexString:@"#A7A7A7"];
    numlbl.font = MyFont(13);
    [self.view addSubview:numlbl];
    
    if (self.strtext.length != 0) {
        self.textPlacehoader.hidden = YES;
    }else{
        self.textPlacehoader.hidden = NO;
    }
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView.text.length==0&&text.length==0) {
        self.textPlacehoader.hidden = NO;
    }else{
        self.textPlacehoader.hidden = YES;
    }
    
    if (textView.text.length==1&&text.length==0) {
        self.textPlacehoader.hidden = NO;
    }
    
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    [textView textFieldTextLengthLimit:nil];
}

-(void)backTo
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
