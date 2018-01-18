//
//  NARLoginViewController.m
//  zhidoushi
//
//  Created by xinglei on 14-11-5.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "NARLoginViewController.h"

@interface NARLoginViewController ()
{
    UIView *_baseView;

}
@end

@implementation NARLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _baseView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [_baseView setBackgroundColor:[UIColor clearColor]];
        [_baseView setUserInteractionEnabled:true];
        
        //触摸消失键盘的事件
        UIButton *tapDownKeyboardButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [tapDownKeyboardButton setAdjustsImageWhenHighlighted:false];
        [tapDownKeyboardButton setAdjustsImageWhenDisabled:false];
        [tapDownKeyboardButton addTarget:self action:@selector(textFieldAllResignFirstResponder) forControlEvents:UIControlEventTouchUpInside];
        [_baseView addSubview:tapDownKeyboardButton];
        
        //基本输入区域
        _inputContentView=[[UIButton alloc]init];
        _nameTextField=[[NARTextField alloc]init];
        _passTextField=[[NARTextField alloc]init];
        _loginButton = [[UIButton alloc]init];
        
        [_baseView addSubview:_inputContentView];
        [_inputContentView addSubview:_nameTextField];
        [_inputContentView addSubview:_passTextField];
        [_inputContentView addSubview:_loginButton];
        
        _inputContentView.backgroundColor = [UIColor grayColor];
        [_inputContentView setAdjustsImageWhenHighlighted:false];
        [_inputContentView setAdjustsImageWhenDisabled:false];
        [_inputContentView addTarget:self action:@selector(textFieldAllResignFirstResponder) forControlEvents:UIControlEventTouchUpInside];
        [_inputContentView.layer setCornerRadius:4];
        
        //用户名输入框
        [_nameTextField setBackgroundColor:[UIColor colorWithRed:184/255.0 green:195/255.0 blue:203/255.0 alpha:1]];
        _nameTextField.borderStyle = UITextBorderStyleNone;
        _nameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _nameTextField.returnKeyType = UIReturnKeyNext;
        _nameTextField.placeholder = @"请输入账号";
        _nameTextField.clearButtonMode =  UITextFieldViewModeWhileEditing;
        [_nameTextField setTextColor:[UIColor whiteColor]];
        _nameTextField.delegate = self;
        [_nameTextField setLeftViewMode:UITextFieldViewModeAlways];
        [_nameTextField setPlaceholderColor:[UIColor whiteColor]];
        
        [_passTextField setBackgroundColor:[UIColor colorWithRed:184/255.0 green:195/255.0 blue:203/255.0 alpha:1]];
        _passTextField.borderStyle = UITextBorderStyleNone;
        _passTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _passTextField.returnKeyType = UIReturnKeyGo;
        _passTextField.placeholder = @"请输入密码";
        _passTextField.secureTextEntry = YES;
        _passTextField.clearButtonMode =  UITextFieldViewModeWhileEditing;
        _passTextField.delegate = self;
        [_passTextField setTextColor:[UIColor whiteColor]];
        [_passTextField setLeftViewMode:UITextFieldViewModeAlways];
        [_passTextField setPlaceholderColor:[UIColor whiteColor]];
        
        
        _loginButton.backgroundColor = [UIColor colorWithRed:253/255.0 green:125/255.0 blue:121/255.0 alpha:1];
        [_loginButton setImage:[UIImage imageNamed:@"立即登录.png"] forState:UIControlStateNormal];
        [_loginButton setImage:[UIImage imageNamed:@"立即登录（不可点）.png"] forState:UIControlStateDisabled];
        [_loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:_baseView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [_inputContentView setFrame:CGRectMake(20, 72.5, 280, 378/2)];
    [_nameTextField setFrame:CGRectMake(37.5, 25, 205, 35)];
    [_passTextField setFrame:CGRectMake(_nameTextField.frame.origin.x, _nameTextField.frame.origin.y+_nameTextField.frame.size.height+15, _nameTextField.frame.size.width, _nameTextField.frame.size.height)];
    [_loginButton setFrame:CGRectMake(_nameTextField.frame.origin.x, _passTextField.frame.origin.y+_passTextField.frame.size.height+15, _nameTextField.frame.size.width, 35)];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.autoShowKeyboard) {
        [self.nameTextField becomeFirstResponder];
    }
}

#pragma mark - UITextField delegate
//监听键盘Done按钮功能
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _nameTextField) {
        [_nameTextField resignFirstResponder];
        if ([_passTextField respondsToSelector:@selector(becomeFirstResponder)]) {
            [_passTextField becomeFirstResponder];
        }
    }
    if (textField == _passTextField) {
        [self loginButtonClick];
    }
    return YES;
}

- (void)textFieldAllResignFirstResponder {
    [_nameTextField resignFirstResponder];
    [_passTextField resignFirstResponder];
}

-(void)loginButtonClick{
    if (self.loginEventBlock) {
        self.loginEventBlock(_nameTextField.text,_passTextField.text);
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
