//
//  ReplyViewController.m
//  zhidoushi
//
//  Created by nick on 15/7/22.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "ReplyViewController.h"
#import "UITextView+LimitLength.h"
#import "IQKeyboardManager.h"
#import "FacialView.h"

@interface ReplyViewController ()<UITextViewDelegate>
@property(nonatomic,strong)UILabel *textPlacehoader;//占位字符
@property(nonatomic,strong)UITextView *textView;//输入框
@property(nonatomic,assign)BOOL isCanPingLun;//评论
@property(nonatomic,strong)UILabel *contentNumLbl;//字数提示

@property(nonatomic,strong)UIScrollView *scrollView;//表情键盘
@property(nonatomic,strong)UIPageControl *pageControl;//表情
@property(nonatomic,strong)UIView *myToolBar;//键盘工具栏
@property(nonatomic,strong)UIButton *facialBtn;//表情按钮
@end

@implementation ReplyViewController
#pragma mark Life Cycle
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"回复评论页面"];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //友盟打点
    [MobClick beginLogPageView:@"回复评论页面"];
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].enable = NO;
    //广场标题
    self.titleLabel.text = @"回复评论";
    self.titleLabel.font = MyFont(18);
    self.titleLabel.textColor = ZDS_DHL_TITLE_COLOR;
    
    //导航栏返回
//    [self.leftButton setTitle:@"取消" forState:UIControlStateNormal];
//    [self.leftButton setTitleColor:[WWTolls colorWithHexString:@"#959595"] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = MyFont(16);
    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"fh-36"] forState:UIControlStateNormal];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width = 18;
    labelRect.size.height = 18;
    self.leftButton.frame = labelRect;
    //导航栏发布
    [self.rightButton setTitle:@"发布" forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = MyFont(16);
    [self.rightButton setTitleColor:OrangeColor forState:UIControlStateDisabled];
    [self.rightButton setTitleColor:ZDS_DHL_TITLE_COLOR forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(reply) forControlEvents:UIControlEventTouchUpInside];
    self.rightButton.width = 40;
    self.rightButton.height = 16;
    self.rightButton.enabled = NO;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = ZDS_BACK_COLOR;
    //文本框
    UITextView *text = [[UITextView alloc] initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 200)];
    self.textView = text;
    text.contentMode = UIViewContentModeRedraw;
    text.contentSize = CGSizeMake(SCREEN_WIDTH-30, 170);
//    text.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    text.backgroundColor = [UIColor whiteColor];
    text.font = MyFont(16);
    text.textColor = ContentColor;
    text.delegate = self;
//    text.layer.borderColor = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;
//    text.layer.borderWidth = 0.5;
    [text setValue:@1000 forKey:@"limit"];
//    [text limitTextLength:1000];
    [self.view addSubview:text];
    //占位文字
    UILabel *lbl = [[UILabel alloc] init];
    self.textPlacehoader = lbl;
    lbl.font = MyFont(16);
    lbl.textColor = [ContentColor colorWithAlphaComponent:0.6];
    lbl.text = [NSString stringWithFormat:@"回复%@：",self.byuserName];
    lbl.frame = CGRectMake(10, 8, 220, 18);
    [text addSubview:lbl];
    self.isCanPingLun = YES;
    
    UILabel *contentNumLbl = [[UILabel alloc] init];
    self.contentNumLbl = contentNumLbl;
    contentNumLbl.frame = CGRectMake(SCREEN_WIDTH - 100, text.bottom - 20, 85, 12);
    contentNumLbl.text = @"(0/1000)";
    contentNumLbl.textAlignment = NSTextAlignmentRight;
    contentNumLbl.font = MyFont(11);
    contentNumLbl.textColor = TimeColor;
    [self.view addSubview:contentNumLbl];
    
    /*********表情工具条********/
    //创建工具条
    UIView *myToolBar = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 48)];
    myToolBar.backgroundColor = [UIColor whiteColor];
    myToolBar.layer.borderWidth = 0.5;
    myToolBar.layer.borderColor = [WWTolls colorWithHexString:@"#989898"].CGColor;
    self.myToolBar = myToolBar;
    [self.view addSubview:myToolBar];
    //完成按钮
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-47, 0, 34, 48)];
    cancelBtn.titleLabel.font = MyFont(17);
    [cancelBtn setTitle:@"完成" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[WWTolls colorWithHexString:@"#535353"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [myToolBar addSubview:cancelBtn];
    //表情按钮
    UIButton *facialBtn = [[UIButton alloc] initWithFrame:CGRectMake(13, 13, 25, 25)];
    self.facialBtn = facialBtn;
    //    [facialBtn setTitle:@"表情" forState:UIControlStateNormal];
    //    [facialBtn setTitle:@"键盘" forState:UIControlStateSelected];
    //    [facialBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [facialBtn setBackgroundImage:[UIImage imageNamed:@"chat_facial"] forState:UIControlStateNormal];
    [facialBtn setBackgroundImage:[UIImage imageNamed:@"chat_keyboard"] forState:UIControlStateSelected];
    [facialBtn addTarget:self action:@selector(facial:) forControlEvents:UIControlEventTouchUpInside];
    [myToolBar addSubview:facialBtn];
    //创建表情键盘
    if (_scrollView==nil) {
        _scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 212 - 66, SCREEN_WIDTH, 212)];
        [_scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"facesBack"]]];
        for (int i=0; i<9; i++) {
            FacialView *fview=[[FacialView alloc] initWithFrame:CGRectMake(12+SCREEN_WIDTH*i, 15, SCREEN_WIDTH-20, 170)];
            [fview setBackgroundColor:[UIColor clearColor]];
            [fview loadFacialView:i size:CGSizeMake(33*SCREEN_WIDTH/320, 43)];
            fview.delegate=self;
            [_scrollView addSubview:fview];
            //                [fview release];
        }
    }
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    _scrollView.contentSize=CGSizeMake(SCREEN_WIDTH*9, 212);
    _scrollView.pagingEnabled=YES;
    _scrollView.delegate=self;
    _scrollView.hidden = YES;
    [self.view addSubview:_scrollView];
    //        [scrollView release];
    self.pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-150)/2,SCREEN_HEIGHT -30-64, 150, 30)];
    [self.pageControl setCurrentPage:0];
    self.pageControl.pageIndicatorTintColor=RGBACOLOR(195, 179, 163, 1);
    self.pageControl.currentPageIndicatorTintColor=RGBACOLOR(132, 104, 77, 1);
    self.pageControl.numberOfPages = 9;//指定页面个数
    [self.pageControl setBackgroundColor:[UIColor clearColor]];
    self.pageControl.hidden=YES;
    [self.pageControl addTarget:self action:@selector(changePage:)forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.pageControl];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)reply{
    if([self.ReplyType isEqualToString:@"1"]) [self commitTalk];
    else if([self.ReplyType isEqualToString:@"2"]) [self commitDiscover];
}

#pragma mark - 评论团聊
-(void)commitTalk{
    if ([_textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length < 1) {
        [self showAlertMsg:@"不能发布空回复" yOffset:0];
        return;
    }else if(_textView.text.length > 1000){
        [self.view endEditing:YES];
        [self showAlertMsg:@"评论内容最多1000字" yOffset:0];
        return;
    }else if([WWTolls isHasSensitiveWord:_textView.text]){
        [self showAlertMsg:ZDS_HASSENSITIVE yOffset:0];
        return;
    }

    if (!self.isCanPingLun) {
        return;
    }
    _isCanPingLun = NO;
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:6];
    [dictionary setObject:self.parentId forKey:@"talkid"];
    [dictionary setObject:self.textView.text forKey:@"rpycontent"];//回复内容
    [dictionary setObject:@"2" forKey:@"replylevel"];//回复级别
    [dictionary setObject:_ReplyId forKey:@"byreplyid"];

    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_PUBLISHRPY parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        if ([dic[@"result"] isEqualToString:@"0"]) {//成功
            [weakSelf.view endEditing:YES];
            [weakSelf showAlertMsg:@"评论成功" andFrame:CGRectZero];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }else{//失败
            weakSelf.isCanPingLun = YES;
        }
    }];
}

#pragma mark - 评论撒欢
-(void)commitDiscover{
    if ([_textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length < 1) {
        [self showAlertMsg:@"不能发布空回复" yOffset:0];
        return;
    }else if(_textView.text.length > 1000){
        [self.view endEditing:YES];
        [self showAlertMsg:@"评论内容最多1000字" yOffset:0];
        return;
    }else if([WWTolls isHasSensitiveWord:_textView.text]){
        [self showAlertMsg:ZDS_HASSENSITIVE yOffset:0];
        return;
    }
    if (!self.isCanPingLun) {
        return;
    }
    self.isCanPingLun = NO;
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:6];
    [dictionary setObject:_textView.text forKey:@"content"];
    [dictionary setObject:_parentId forKey:@"showid"];
    [dictionary setObject:_ReplyId forKey:@"bycommentid"];
    [dictionary setObject:@"2" forKey:@"commentlevel"];
    
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_FABU_PINLUN parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {

        if ([dic[@"result"] isEqualToString:@"0"]) {//成功
            [weakSelf.view endEditing:YES];
            [weakSelf showAlertMsg:@"评论成功" andFrame:CGRectZero];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
            
        }else{//失败
            self.isCanPingLun = YES;
        }
    }];
}

#pragma mark 返回上一级
-(void)popButton{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
//    [textView textFieldTextLengthLimit:nil];
    self.textPlacehoader.hidden = textView.text.length > 0;
    self.rightButton.enabled = self.textPlacehoader.hidden;
    self.contentNumLbl.text = [NSString stringWithFormat:@"(%ld/1000)",textView.text.length>1000?1000:textView.text.length];

}

//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    if (text.length + textView.text.length - range.length >= 1001) {
//        NSString *newText = [textView.text stringByReplacingCharactersInRange:range withString:text];
//        textView.text = [newText substringToIndex:1000];
//        return NO;
//    }
//    return YES;
//}

#pragma mark -  表情键盘 Delegate
//工具栏完成
-(void)cancel{
    [self.view endEditing:YES];
    self.scrollView.hidden = YES;
    self.pageControl.hidden = YES;
    self.myToolBar.top = SCREEN_HEIGHT;
    self.facialBtn.selected = NO;
}
-(void)facial:(UIButton*)btn{
    if (self.scrollView.hidden) {
        [self.textView endEditing:YES];
        self.scrollView.hidden = NO;
        self.pageControl.hidden = NO;
        btn.selected = YES;
        self.myToolBar.frame = CGRectMake(0, self.scrollView.top-48, SCREEN_WIDTH, 48);
    }else{
        btn.selected = NO;
        [self.textView becomeFirstResponder];
    }
}
#pragma mark 键盘即将显示
- (void)keyBoardWillShow:(NSNotification *)note{
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = rect.size.height;
    self.scrollView.hidden = YES;
    self.pageControl.hidden = YES;
    self.facialBtn.selected = NO;
    self.myToolBar.frame = CGRectMake(0, SCREEN_HEIGHT-ty-48-64, SCREEN_WIDTH, 48);
}
- (void)keyBoardWillHide:(NSNotification *)note{
    if (self.scrollView.hidden) {
        self.myToolBar.top = SCREEN_HEIGHT;
        self.facialBtn.selected = NO;
    }
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = _scrollView.contentOffset.x / SCREEN_WIDTH;//通过滚动的偏移量来判断目前页面所对应的小白点
    _pageControl.currentPage = page;//pagecontroll响应值的变化
}

//pagecontroll的委托方法
- (void)changePage:(id)sender
{
    NSInteger page = _pageControl.currentPage;//获取当前pagecontroll的值
    [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * page, 0)];//根据pagecontroll的值来改变scrollview的滚动位置，以此切换到指定的页面
}

#pragma mark 点击表情按钮
-(void)sendFace:(UIButton*)button
{
    NSLog(@"点击的表情按钮1==%ld",(long)button.tag);
    
    if (10000 == button.tag) {//如果是删除按钮
        NSString *newStr = nil;
        
        if (self.textView.text.length > 0) {
            
            if ([@"]" isEqualToString:[self.textView.text substringFromIndex:self.textView.text.length-1]]) {
                if ([self.textView.text rangeOfString:@"["].location == NSNotFound) {
                    newStr = [self.textView.text substringToIndex:self.textView.text.length - 1];
                }
                else{
                    newStr = [self.textView.text substringToIndex:[self.textView.text rangeOfString:@"[" options:NSBackwardsSearch].location];
                }
            }
            else{
                newStr = [self.textView.text substringToIndex:self.textView.text.length - 1];
            }
            self.textView.text = newStr;
        }
    }
    
    else{//如果点击表情按钮的时候
        NSString* str;
        NSString *newStr = [NSString stringWithFormat:@"%@%@",self.textView.text,str];
        if(newStr.length <= 1000) [self.textView setText:newStr];
    }
}
-(void)selectedFacialView:(NSString*)str
{
    NSString *newStr;
    if ([str isEqualToString:@"删除"]) {
        if (self.textView.text.length > 1) {
            if ([[Emoji allEmoji] containsObject:[self.textView.text substringFromIndex:self.textView.text.length-2]]) {
                //                NSLog(@"删除emoji %@",[textView.text substringFromIndex:textView.text.length-2]);
                newStr = [self.textView.text substringToIndex:self.textView.text.length-2];
            }else{
                NSLog(@"删除文字%@",[self.textView.text substringFromIndex:self.textView.text.length-1]);
                newStr = [self.textView.text substringToIndex:self.textView.text.length-1];
            }
            self.textView.text = newStr;
        }else if(self.textView.text.length > 0){
            newStr = [self.textView.text substringToIndex:self.textView.text.length-1];
            self.textView.text = newStr;
        }
    }else{
        NSString *newStr = [NSString stringWithFormat:@"%@%@",self.textView.text,str];
        if(newStr.length <= 1000) [self.textView setText:newStr];
        NSLog(@"点击其他后更新%lu,%@",(unsigned long)str.length,self.textView.text);
    }
}
@end
