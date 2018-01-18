//
//  NickNameModifyController.m
//  zhidoushi
//
//  Created by ji on 15/11/13.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import "NickNameModifyController.h"
#import "MobClick.h"
#import "IQKeyboardManager.h"
#import "UITextView+LimitLength.h"
#import "UITextField+LimitLength.h"
#import "WWTolls.h"
#import "UserModel.h"
#import "NSObject+NARSerializationCategory.h"
#import "NSDictionary+NARSafeDictionary.h"
#import "MyLibraryViewController2.h"

@interface NickNameModifyController ()<UITextViewDelegate>

@end

@implementation NickNameModifyController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"修改昵称页面"];
    self.rightButton.enabled = YES;
    [self.view endEditing:YES];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [MobClick beginLogPageView:@"修改昵称页面"];
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
    
    self.titleLabel.text = @"编辑昵称";
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
    
    if(self.nameText != nil && self.nameText.text.length != 0){//必须输入昵称
        if (self.nameblock) {
            self.nameblock(self.nameText.text);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self showAlertMsg:@"请输入昵称" andFrame:CGRectMake(70,100,200,60)];
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [WWTolls colorWithHexString:@"#F7F1F1"];
    self.nameText.backgroundColor = [WWTolls colorWithHexString:@"#FFFFFF"];
    
    UITextView *text = [[UITextView alloc] initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 50)];
    self.nameText = text;
    self.nameText.text = self.strtext;
    self.nameText.textColor = [WWTolls colorWithHexString:@"#475564"];
    text.delegate = self;
    text.font = MyFont(17);
    text.contentInset = UIEdgeInsetsMake(7, 8, -7, -8);
    [text limitTextLength:10];
    [self.view addSubview:text];
    
    UILabel *textlbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 32, 78, 18)];
    textlbl.numberOfLines = 0;
    self.textPlacehoader = textlbl;
    textlbl.text = @"输入昵称";
    textlbl.textColor = [WWTolls colorWithHexString:@"#475564"];
    textlbl.font = MyFont(17);
    [self.view addSubview:textlbl];
    
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

@end
