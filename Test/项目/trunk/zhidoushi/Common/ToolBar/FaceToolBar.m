//
//  FaceToolBar.m
//  iSport
//
//  Created by xinglei on 13-5-27.
//  Copyright (c) 2013年 xinglei. All rights reserved.
//

#import "FaceToolBar.h"

#import "WWTolls.h"
#import "CustomActionSheet.h"
//#import "SFHFKeychainUtils.h"
//#import "CommentViewController.h"
//#import "DetailNewsViewController.h"
#import "MBProgressHUD+MJ.h"
#import "UITextView+LimitLength.h"
#import "UIView+ViewController.h"

#define tempHeight (iPhone5)?(self.theSuperView.height==568?0:64):(self.theSuperView.height==480?0:64)
#define TOOLBARHEIGHT 49 //点击发表后应该减去的高度

@interface FaceToolBar() <UIActionSheetDelegate, CustomActionSheetDelegate>

@end

@implementation FaceToolBar
{
    float superHeight;
}

@synthesize myTextView;

-(id)initWithFrame:(CGRect)frame superView:(UIView *)superView  withBarType:(FaceToolBarType)type
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        //初始化时，键盘未弹出为NO
        _keyboardIsShow = NO;
        self.theSuperView = superView;
        self.toolBarType = type;
        superHeight = SCREEN_HEIGHT;//修改表情view显示高度
        //给键盘注册通知
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        //默认toolBar在视图最下方
        //        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f,[UIScreen mainScreen].bounds.size.height-toolBarHeight-64,self.theSuperView.bounds.size.width,toolBarHeight)];
        _toolBar = [[UIToolbar alloc] initWithFrame:frame];
        NSLog(@"toolBar所在的高度是:%f",_toolBar.frame.origin.y);
        _toolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        //        UIEdgeInsets insets = UIEdgeInsetsMake(40, 0, 40, 0);
        //        [_toolBar setBackgroundImage:[[UIImage imageNamed:@"FrindInptBg.png"] resizableImageWithCapInsets:insets] forToolbarPosition:0 barMetrics:0];
        [_toolBar setBarStyle:UIBarStyleDefault];
        [self.theSuperView addSubview:_toolBar];
        
        //        if (_toolBarType == ChatToolBar) { //朋友聊天 输入框样式
        //            faceButton.frame = CGRectMake(LeftWidth -2,_toolBar.bounds.size.height-38.0f,buttonWh,buttonWh);
        //
        //            //可以自适应高度的文本输入框
        //            myTextView = [[UIExpandingTextView alloc] initWithFrame:CGRectMake(_pictureButton.frame.origin.x+_pictureButton.frame.size.width+16 -6, 5, 180, 36)];
        //            myTextView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(4.0f, 0.0f, 10.0f, 0.0f);
        //            [myTextView.internalTextView setReturnKeyType:UIReturnKeySend];
        //            myTextView.delegate = self;
        //            myTextView.maximumNumberOfLines=5;
        //            [_toolBar addSubview:myTextView];
        //
        //            //发送按钮
        //            self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //            self.sendButton.layer.cornerRadius = ToolButtonRadius;
        //            self.sendButton.layer.masksToBounds = YES;
        //            self.sendButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
        //            //[self.sendButton setBackgroundImage:[UIImage imageNamed:@"BtnSave"] forState:UIControlStateNormal];
        //            //[self.sendButton setBackgroundImage:[UIImage imageNamed:@"BtnSavePres"] forState:UIControlStateHighlighted];
        //            [self.sendButton setBackgroundColor:[UIColor greenColor]];
        //            [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
        //            [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //            self.sendButton.titleLabel.font = [UIFont systemFontOfSize:17];
        //
        //            [self.sendButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
        //            self.sendButton.frame = CGRectMake(myTextView.frame.origin.x+myTextView.frame.size.width+10-2, myTextView.frame.origin.y+3, buttonWh +12,buttonWh+2);
        //            [_toolBar addSubview:self.sendButton];
        //        }
        //        else if (_toolBarType == PostDynamicToolBar) {
        //
        //        }else
        if (_toolBarType == CommentDynamicToolBar) { //评论 输入框样式
            //站内信用了此种方式
            //可以自适应高度的文本输入框
            self.backgroundColor = [UIColor clearColor];
            myTextView = [[UIExpandingTextView alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH-50, 36)];
            myTextView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(4.0f, 0.0f, 10.0f, 0.0f);
            [myTextView.internalTextView setReturnKeyType:UIReturnKeySend];
            myTextView.layer.borderColor =[UIColor redColor].CGColor;
            myTextView.layer.borderWidth = 5;
            myTextView.delegate = self;
            
            myTextView.maximumNumberOfLines=4;
            [_toolBar addSubview:myTextView];
            //[myTextView.internalTextView limitTextLength:300];
            //[myTextView.internalTextView textFieldTextLengthLimit:nil];
            //发送按钮
            self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
            //            self.sendButton.layer.cornerRadius = 5;
            //            self.sendButton.layer.borderWidth = 0.5;
            //            self.sendButton.layer.borderColor = [WWTolls colorWithHexString:@"#cacaca"].CGColor;
            //            [self.sendButton setTitleColor:[WWTolls colorWithHexString:@"#666666"] forState:UIControlStateNormal];
            //            self.sendButton.titleLabel.textColor = [WWTolls colorWithHexString:@"#666666"];
            //            self.sendButton.clipsToBounds = YES;
            //            self.sendButton.titleLabel.font = MyFont(14);
            //            self.sendButton.layer.cornerRadius = ToolButtonRadius;
            //            //self.sendButton.layer.masksToBounds = YES;
            //            self.sendButton.layer.borderColor = [[WWTolls colorWithHexString:@"#d5d5d5"] CGColor];
            //            self.sendButton.layer.borderWidth = 0.5;
            self.sendButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
            //            [self.sendButton setBackgroundImage:[UIImage imageNamed:@"BtnSave"] forState:UIControlStateNormal];
            //            [self.sendButton setBackgroundImage:[UIImage imageNamed:@"BtnSavePres"] forState:UIControlStateHighlighted];
            //            [self.sendButton setTitle:@"表情" forState:UIControlStateNormal];
            //            [self.sendButton setBackgroundColor:[WWTolls colorWithHexString:@"#ea5b57"]];
            //            self.sendButton.titleLabel.font = MyFont(14);
            //            [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            //            [self.sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
            
            [self.sendButton setBackgroundImage:[UIImage imageNamed:@"chat_facial"] forState:UIControlStateNormal];
            [self.sendButton setBackgroundImage:[UIImage imageNamed:@"chat_keyboard"] forState:UIControlStateSelected];
            
            
            
#warning
            [self.sendButton addTarget:self action:@selector(disFaceKeyboard) forControlEvents:UIControlEventTouchUpInside];
            //            [self.sendButton addTarget:self action:@selector(sendStationInformation) forControlEvents:UIControlEventTouchUpInside];
            self.sendButton.frame = CGRectMake(myTextView.frame.origin.x+myTextView.frame.size.width+16, 12, 25,25);
            [_toolBar addSubview:self.sendButton];
            myTextView.backgroundColor = [UIColor clearColor];
            faceButton.hidden = YES;
        }else if (_toolBarType == UserFeedBackToolBar) { //意见反馈 输入框样式
            [faceButton removeFromSuperview];
            //可以自适应高度的文本输入框
            myTextView = [[UIExpandingTextView alloc] initWithFrame:CGRectMake(40, 5, SCREEN_WIDTH-100, 36)];
            myTextView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(4.0f, 0.0f, 10.0f, 0.0f);
            myTextView.backgroundColor = [UIColor clearColor];
            [myTextView.internalTextView setReturnKeyType:UIReturnKeySend];
            myTextView.delegate = self;
            myTextView.maximumNumberOfLines=4;
            [_toolBar addSubview:myTextView];
            
            
            //表情按钮
            faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
            faceButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
            [faceButton setBackgroundImage:[UIImage imageNamed:@"chat_facial"] forState:UIControlStateNormal];
            [faceButton addTarget:self action:@selector(disFaceKeyboard) forControlEvents:UIControlEventTouchUpInside];
            faceButton.frame = CGRectMake(5,_toolBar.bounds.size.height-38.0f,buttonWh,buttonWh);
            [_toolBar addSubview:faceButton];
            
            //发送按钮
            self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.sendButton.layer.cornerRadius = ToolButtonRadius;
            self.sendButton.layer.masksToBounds = YES;
            //            self.sendButton.layer.borderColor = [[AppTools colorWithHexString:@"#83e726"] CGColor];
            self.sendButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
            //[self.sendButton setBackgroundImage:[UIImage imageNamed:@"BtnSave"] forState:UIControlStateNormal];
            //[self.sendButton setBackgroundImage:[UIImage imageNamed:@"BtnSavePres"] forState:UIControlStateHighlighted];
            [self.sendButton setBackgroundColor:[UIColor colorWithRed:0.322 green:0.725 blue:0.980 alpha:1.000]];
            [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
            [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            [self.sendButton addTarget:self action:@selector(faceBtnClick) forControlEvents:UIControlEventTouchUpInside];
            _sendButton.frame = CGRectMake(_toolBar.bounds.size.width - 59,0,buttonWh+29,_toolBar.height);
            [_toolBar addSubview:self.sendButton];
        }
        //
        //        if (PublishDynamicToolBar == _toolBarType) {
        //            _toolBar.hidden = YES;
        //
        //        }
        /***
         //创建表情键盘
         _scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, self.theSuperView.frame.size.height, self.theSuperView.frame.size.width, keyboardHeight)];
         //        [_scrollView setBackgroundColor:[AppTools colorWithHexString:@"ece5de"]];
         [_scrollView setBackgroundColor:[UIColor grayColor]];
         _scrollView.scrollsToTop = NO;
         
         for (int i=0; i<42; i++) {
         
         UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
         if (i ==20 || i == 41) { //编号为21的表情跟 删除图片冲突了。
         [button setBackgroundImage:[UIImage imageNamed:@"FaceDelete.png"] forState:UIControlStateNormal];
         
         [button setBackgroundImage:[UIImage imageNamed:@"FaceDeletePressed.png"] forState:UIControlStateHighlighted];
         button.tag=10000;
         
         }
         else{
         
         button.tag = i;
         [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"Small%03d.png",i+1]] forState:UIControlStateNormal];
         [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"Small%03d.png",i+1]] forState:UIControlStateHighlighted];
         
         if (i>20) {
         [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"Small%03d.gif",i+1]] forState:UIControlStateNormal];
         [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"Small%03d.gif",i+1]] forState:UIControlStateHighlighted];
         //                    NSLog(@"gif图片--------%@",[NSString stringWithFormat:@"Small%03d.gif",i+1]);
         }
         
         }
         [button addTarget:self action:@selector(sendFace:) forControlEvents:UIControlEventTouchUpInside];
         
         float horSpace = 110.0/8;
         float verSpace = 30;
         button.frame = CGRectMake(horSpace + (i%7) * (horSpace + 30) + (i/21)*320, verSpace + ((i%21)/7) * (30+verSpace), 35, 35);
         
         if (i > 20) {
         //                float verSpace = 35;
         button.frame = CGRectMake(horSpace + (i%7) * (horSpace + 30) + (i/21)*320, verSpace + ((i%21)/7) * (30+verSpace), 35, 35);
         //                NSLog(@"表情按钮>>>>>>>%f======%f",button.frame.origin.x,button.frame.origin.y);
         }
         
         [_scrollView addSubview:button];
         }
         [_scrollView setShowsVerticalScrollIndicator:NO];
         [_scrollView setShowsHorizontalScrollIndicator:NO];
         _scrollView.contentSize = CGSizeMake(320*2, keyboardHeight); //*改******* 是scrollview可以滚动的区域
         _scrollView.pagingEnabled = YES;
         _scrollView.delegate = self;
         
         [self.theSuperView addSubview:_scrollView];
         
         pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(98, superHeight-35, 150, 30)];
         [pageControl setCurrentPage:0];
         pageControl.numberOfPages = 2;//指定页面个数
         [pageControl setBackgroundColor:[UIColor clearColor]];
         pageControl.hidden = YES;
         [pageControl addTarget:self action:@selector(changePage:)forControlEvents:UIControlEventValueChanged];
         [self.theSuperView addSubview:pageControl];
         **/
        //创建表情键盘
        if (_scrollView==nil) {
            _scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, superView.frame.size.height, superView.frame.size.width, keyboardHeight)];
            [_scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"facesBack"]]];
            for (int i=0; i<9; i++) {
                FacialView *fview=[[FacialView alloc] initWithFrame:CGRectMake(12+SCREEN_WIDTH*i, 15, facialViewWidth, facialViewHeight)];
                [fview setBackgroundColor:[UIColor clearColor]];
                [fview loadFacialView:i size:CGSizeMake(33*SCREEN_WIDTH/320, 43)];
                fview.delegate=self;
                [_scrollView addSubview:fview];
                //                [fview release];
            }
        }
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        _scrollView.contentSize=CGSizeMake(SCREEN_WIDTH*9, keyboardHeight);
        _scrollView.pagingEnabled=YES;
        _scrollView.delegate=self;
        [superView addSubview:_scrollView];
        //        [scrollView release];
        //CGRectMake((SCREEN_WIDTH-150)/2,SCREEN_HEIGHT -30-64, 150, 30)
        pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT -30-64-30, SCREEN_WIDTH, 30)];
        [pageControl setCurrentPage:0];
        pageControl.pageIndicatorTintColor=RGBACOLOR(195, 179, 163, 1);
        pageControl.currentPageIndicatorTintColor=RGBACOLOR(132, 104, 77, 1);
        pageControl.numberOfPages = 9;//指定页面个数
        [pageControl setBackgroundColor:[UIColor clearColor]];
        pageControl.hidden=YES;
        [pageControl addTarget:self action:@selector(changePage:)forControlEvents:UIControlEventValueChanged];
        [superView addSubview:pageControl];
        //表情键盘 发送按钮
        //        faceSendBtn = [[UIButton alloc] init];
        //        faceSendBtn.titleLabel.font = MyFont(14);
        //        faceSendBtn.frame = CGRectMake(SCREEN_WIDTH - 48,SCREEN_HEIGHT -30-64,48, 32);
        //        faceSendBtn.hidden = YES;
        //        [faceSendBtn setTitle:@"发送" forState:UIControlStateNormal];
        //        faceButton.layer.borderColor = [UIColor redColor].CGColor;
        //        faceButton.layer.borderWidth = 1.0f;
        //        [faceSendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //        [faceSendBtn addTarget:self action:@selector(faceBtnClick) forControlEvents:UIControlEventTouchUpInside];
        //        [faceSendBtn setBackgroundColor:[WWTolls colorWithHexString:@"#027cff"]];
        //        [superView addSubview:faceSendBtn];
        
    }
    return self;
}

- (void)faceBtnClick{
    
    if ([self.faceToolBardelegate respondsToSelector:@selector(faceSendBtnClick)]) {
        [self.faceToolBardelegate faceSendBtnClick];
        [self sendActionEngine];
        
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = _scrollView.contentOffset.x / 320;//通过滚动的偏移量来判断目前页面所对应的小白点
    pageControl.currentPage = page;//pagecontroll响应值的变化
}

//pagecontroll的委托方法
- (void)changePage:(id)sender
{
    NSInteger page = pageControl.currentPage;//获取当前pagecontroll的值
    [_scrollView setContentOffset:CGPointMake(320 * page, 0)];//根据pagecontroll的值来改变scrollview的滚动位置，以此切换到指定的页面
}

#pragma mark -
#pragma mark UIExpandingTextView delegate
//改变键盘高度
-(void)expandingTextView:(UIExpandingTextView *)expandingTextView willChangeHeight:(float)height
{
    /* Adjust the height of the toolbar when the input component expands */
    //    NSLog(@"textfield %f",textView.frame.size.height);
    
    float textFieldHeight = myTextView.frame.size.height;
    float diff = (textFieldHeight - height);
    CGRect r = _toolBar.frame;
    r.origin.y += diff;
    r.size.height -= diff;
    _toolBar.frame = r;
    faceButton.frame = CGRectMake(5,faceButton.frame.origin.y,buttonWh,buttonWh);//锁定笑脸图标位置
    //    if (expandingTextView.text.length > 5 ) {
    //
    //        myTextView.internalTextView.contentOffset=CGPointMake(0,myTextView.internalTextView.contentSize.height-myTextView.internalTextView.frame.size.height );
    //    }
    //    if ([self.faceToolBardelegate respondsToSelector:@selector(faceToolBarDidChangeFrame:)]) {
    //        [self.faceToolBardelegate faceToolBarDidChangeFrame:_toolBar];
    //    }
    //    float diff = (myTextView.frame.size.height - height);
    //    CGRect r = _toolBar.frame;
    //    r.origin.y += diff;
    //    r.size.height -= diff;
    //    _toolBar.frame = r;
    if (expandingTextView.text.length>2&&[[Emoji allEmoji] containsObject:[expandingTextView.text substringFromIndex:expandingTextView.text.length-2]]) {
        //        NSLog(@"最后输入的是表情%@",[textView.text substringFromIndex:textView.text.length-2]);
        myTextView.internalTextView.contentOffset=CGPointMake(0,myTextView.internalTextView.contentSize.height-myTextView.internalTextView.frame.size.height );
    }
    if ([self.faceToolBardelegate respondsToSelector:@selector(faceToolBarDidChangeFrame:)]) {
        [self.faceToolBardelegate faceToolBarDidChangeFrame:_toolBar];
    }
}
#pragma mark - textView的代理方法》》》》》》》》》》》》》》》》》
#pragma mark -  textView的return方法(键盘上的发送按钮)
- (BOOL)expandingTextViewShouldReturn:(UIExpandingTextView *)expandingTextView
{
    //    if(_toolBarType == PostDynamicToolBar){
    //    }
    //    //[self sendStationInformation];
    //    //[myTextView clearText];
    //    [UIView animateWithDuration:0.2 animations:^{
    //        [myTextView resignFirstResponder];
    //        _toolBar.frame = CGRectMake(0, self.theSuperView.bounds.size.height-TOOLBARHEIGHT,  self.theSuperView.bounds.size.width, toolBarHeight);
    ////        [_scrollView setFrame:CGRectMake(0, superHeight, self.theSuperView.frame.size.width, _scrollView.frame.size.height)];
    //    }];
    //    if (myTextView.text.length > 0) {
    //        //*****由于此处发送修改为键盘消失时发送所以注销掉*****//
    ////        if ([self.faceToolBardelegate respondsToSelector:@selector(sendTextAction:)]) {
    ////            [self.faceToolBardelegate sendTextAction:myTextView.text];
    ////        }
    //    }
    [self sendStationInformation];
    //[faceButton setBackgroundImage:[UIImage imageNamed:@"news-bq@x2.png"] forState:UIControlStateNormal];
    return YES;
}

//文本是否改变
-(BOOL)expandingTextView:(UIExpandingTextView *)expandingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (text.length == 0) {
        return YES;
    }
    if (expandingTextView.text.length > 1000) {
        return NO;
    }
    return YES;
}
-(void)expandingTextViewDidChange:(UIExpandingTextView *)expandingTextView
{
    if (expandingTextView.text.length > 1000) {
        //[expandingTextView endEditing:YES];
        
        //[self showError:@"最多输入300个字符" toView:self.superview];
    }
    if ([self.faceToolBardelegate respondsToSelector:@selector(faceToolBarDidChangeFrame:)]) {
        [self.faceToolBardelegate faceToolBarDidChangeFrame:_toolBar];
    }
}

#pragma mark - 点击发送按钮
-(void)sendStationInformation{
    NSLog(@"400****************toolBar点击了发送按钮");
    if ([self.faceToolBardelegate respondsToSelector:@selector(sendDidClick)]) {
        [self.faceToolBardelegate sendDidClick];
    }
    //    if (myTextView.text.length==0) {
    //        [MBProgressHUD showSuccess:@"不能发送空内容" toView:self.superview.superview.superview.superview];
    //        return;
    //        [self sendActionEngine];
    //
    //    }
    //    else if (myTextView.text.length>300)
    //    {
    //        [MBProgressHUD showSuccess:@"不能超过300字"];
    ////        [[UIApplication sharedApplication].keyWindow.viewController showAlertMsg:@"不能超过300字" andFrame:CGRectMake(0, 0,  0, 0)];
    ////        [SHAREDAPPDELE.window.viewController showAlertMsg:@"不能超过300字" andFrame:CGRectMake(0, 0,  0, 0)];
    //    }
    //    else{
    //        if ([self.faceToolBardelegate respondsToSelector:@selector(sendTextAction:inputState:)]) {
    //            [self.faceToolBardelegate sendTextAction:myTextView.text inputState:self.stateString];
    //            [self sendActionEngine];
    //
    //        }
    //    }
}

-(void)sendAction
{
    NSLog(@"409****************toolBar点击了发送按钮");
    if (myTextView.text.length > 0) {
        //        [self publishAction];
        [myTextView clearText];
    }
    [self sendActionEngine];
    if (self.theSuperView.height == 568 || self.theSuperView.height == 480) {
        self.toolBar.hidden = YES;
    }
}

-(void)sendActionEngine{
    
    [myTextView resignFirstResponder];
    [self dismissKeyBoard];
    
}

#pragma mark 点击表情按钮
-(void)sendFace:(UIButton*)button
{
    NSLog(@"点击的表情按钮1==%ld",(long)button.tag);
    
    if (10000 == button.tag) {//如果是删除按钮
        NSString *newStr = nil;
        
        if (myTextView.text.length > 0) {
            
            if ([@"]" isEqualToString:[myTextView.text substringFromIndex:myTextView.text.length-1]]) {
                if ([myTextView.text rangeOfString:@"["].location == NSNotFound) {
                    newStr = [myTextView.text substringToIndex:myTextView.text.length - 1];
                }
                else{
                    newStr = [myTextView.text substringToIndex:[myTextView.text rangeOfString:@"[" options:NSBackwardsSearch].location];
                }
            }
            else{
                newStr = [myTextView.text substringToIndex:myTextView.text.length - 1];
            }
            myTextView.text = newStr;
        }
        //        NSLog(@"删除后更新%@",textView.text);
        if (_toolBarType == PublishDynamicToolBar) {
            if (self.faceToolBardelegate && [self.faceToolBardelegate respondsToSelector:@selector(faceToolBarDeleteFace)]) {
                [self.faceToolBardelegate faceToolBarDeleteFace];
            }
        }
    }
    
    else{//如果点击表情按钮的时候
        NSString* str;
        if (button.tag > 20) {
            //            str = [SHAREDAPPDELE.faceArray objectAtIndex:button.tag-1];
            //        }else{
            //            str = [SHAREDAPPDELE.faceArray objectAtIndex:button.tag];
        }
        NSLog(@"点击的表情按钮222===%ld====%@",(long)button.tag,str);
        
        NSString *newStr = [NSString stringWithFormat:@"%@%@",myTextView.text,str];
        [myTextView setText:newStr];
        if (_toolBarType == PublishDynamicToolBar) {
            if (self.faceToolBardelegate && [self.faceToolBardelegate respondsToSelector:@selector(faceToolBarDidSelectFace:)]) {
                [self.faceToolBardelegate faceToolBarDidSelectFace:str];
            }
        }
    }
}

-(void)voiceChange
{
    [self dismissKeyBoard];
}

#pragma mark - 点击笑脸图案
-(void)disFaceKeyboard
{
    NSLog(@"****************点击表情按钮%d",_faceboardIsShow);
    
    if (!_faceboardIsShow) {
        [UIView animateWithDuration:Time animations:^{
            _toolBar.frame = CGRectMake(0, superHeight-keyboardHeight-_toolBar.frame.size.height-(tempHeight) - 30,  self.theSuperView.bounds.size.width, _toolBar.frame.size.height);
            [_scrollView setFrame:CGRectMake(0, superHeight-keyboardHeight-(tempHeight) - 30,self.theSuperView.frame.size.width, keyboardHeight)];
        }];
        self.sendButton.selected = YES;
        [pageControl setHidden:NO];
        [faceSendBtn setHidden:NO];
        [faceButton setBackgroundImage:[UIImage imageNamed:@"Keyboard.png"] forState:UIControlStateNormal];
        _faceboardIsShow = YES;
        _keyboardIsShow = NO;
        [myTextView resignFirstResponder];
        
    }else {
        [UIView animateWithDuration:Time animations:^{
            _toolBar.frame = CGRectMake(0, kVIEW_BOUNDS_HEIGHT-_toolBar.frame.size.height-(tempHeight),  self.theSuperView.bounds.size.width, _toolBar.frame.size.height);
            //            _toolBar.top = superHeight - keyboardHeight-(tempHeight) - _toolBar.height;
            [_scrollView setFrame:CGRectMake(0, superHeight, self.theSuperView.frame.size.width, _scrollView.frame.size.height)];
        }];
        self.sendButton.selected = NO;
        [faceButton setBackgroundImage:[UIImage imageNamed:@"chat_facial"] forState:UIControlStateNormal];
        
        [pageControl setHidden:YES];
        [faceSendBtn setHidden:YES];
        [myTextView becomeFirstResponder];
        _faceboardIsShow = NO;
    }
    
    _padDidMovedUp = YES;
    
    
    /**
     //如果直接点击表情，通过toolbar的位置来判断
     if (_toolBar.frame.origin.y== self.theSuperView.bounds.size.height - toolBarHeight&&_toolBar.frame.size.height==toolBarHeight) {
     [UIView animateWithDuration:Time animations:^{
     _toolBar.frame = CGRectMake(0, self.theSuperView.frame.size.height-keyboardHeight-toolBarHeight,  self.theSuperView.bounds.size.width,toolBarHeight);
     }];
     [UIView animateWithDuration:Time animations:^{
     [_scrollView setFrame:CGRectMake(0, self.theSuperView.frame.size.height-keyboardHeight,self.theSuperView.frame.size.width, keyboardHeight)];
     }];
     [pageControl setHidden:NO];
     [faceButton setBackgroundImage:[UIImage imageNamed:@"Text"] forState:UIControlStateNormal];
     return;
     }
     //如果键盘没有显示，点击表情了，隐藏表情，显示键盘
     if (!_keyboardIsShow) {
     [UIView animateWithDuration:Time animations:^{
     [_scrollView setFrame:CGRectMake(0, self.theSuperView.frame.size.height, self.theSuperView.frame.size.width, keyboardHeight)];
     }];
     [_myTextView becomeFirstResponder];
     [pageControl setHidden:YES];
     
     }else{
     
     //键盘显示的时候，toolbar需要还原到正常位置，并显示表情
     [UIView animateWithDuration:Time animations:^{
     _toolBar.frame = CGRectMake(0, self.theSuperView.frame.size.height-keyboardHeight-_toolBar.frame.size.height,  self.theSuperView.bounds.size.width,_toolBar.frame.size.height);
     }];
     
     [UIView animateWithDuration:Time animations:^{
     [_scrollView setFrame:CGRectMake(0, self.theSuperView.frame.size.height-keyboardHeight,self.theSuperView.frame.size.width, keyboardHeight)];
     }];
     [pageControl setHidden:NO];
     [_myTextView resignFirstResponder];
     }
     **/
}

-(void)dismissKeyBoard
{
    //键盘消失的时候，toolbar需要还原到正常位置，并显示表情
    [UIView animateWithDuration:Time animations:^{
        
        //        CGFloat y = [UIScreen mainScreen].bounds.size.height-70-toolBarHeight;
        //        CGFloat h = toolBarHeight;
        //        if (self.myTextView.frame.origin.y) {
        //            //self.myTextView.height = choiceBarHeight;
        //            //y = y-22;
        //            //h = h+22;
        //            self.myTextView.frame = CGRectMake(self.myTextView.origin.x, self.myTextView.origin.y-22, self.myTextView.size.width, self.myTextView.size.height);
        //        }
        //_toolBar.frame = CGRectMake(0, y,  self.theSuperView.bounds.size.width, h);
        _toolBar.frame = CGRectMake(0.0f,self.theSuperView.bounds.size.height-toolBarHeight,self.theSuperView.bounds.size.width,toolBarHeight);
        myTextView.frame=CGRectMake(40, 5, SCREEN_WIDTH-100, 36);
        _sendButton.frame = CGRectMake(_toolBar.bounds.size.width - 59.0f,0,buttonWh+29,_toolBar.height);
        [_scrollView setFrame:CGRectMake(0, superHeight,self.theSuperView.frame.size.width, keyboardHeight)];
    }];
    
    [pageControl setHidden:YES];
    [myTextView resignFirstResponder];
    [faceButton setBackgroundImage:[UIImage imageNamed:@"Keyboard.png"] forState:UIControlStateNormal];
    //改过
    _faceboardIsShow = NO;
    if ([self.faceToolBardelegate respondsToSelector:@selector(sendDidClick)]) {
        [self.faceToolBardelegate sendDidClick];
    }
}

- (void)finishedInput
{
    self.foregroundKeyboardIsShow = NO;
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    if (_keyboardIsShow) {
        [self dismissKeyBoard];
    }else {
        [UIView animateWithDuration:Time animations:^{
            _toolBar.frame = CGRectMake(0, superHeight - toolBarHeight, self.superview.frame.size.width,toolBarHeight);
            
            //            [_scrollView setFrame:CGRectMake(0, superHeight+keyboardHeight, self.superview.frame.size.width, keyboardHeight)];
        }];
        [pageControl setHidden:YES];
        [faceButton setBackgroundImage:[UIImage imageNamed:@"Keyboard.png"] forState:UIControlStateNormal];
    }
    
    _padDidMovedUp = NO;
    _faceboardIsShow = NO;
    _keyboardIsShow = NO;
}

#pragma mark 监听键盘事件的显示与隐藏（现已注销）
-(void)inputKeyboardWillShow:(NSNotification *)notification
{
    self.foregroundKeyboardIsShow = YES;
    //键盘显示，设置toolbar的frame跟随键盘的frame
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    _keyboardBounds = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:animationTime animations:^{
        _toolBar.frame = CGRectMake(0, kVIEW_BOUNDS_HEIGHT-_keyboardBounds.size.height-toolBarHeight,  kVIEW_BOUNDS_WIDTH, toolBarHeight);//键盘弹出时的高度
    }];
    
    [faceButton setBackgroundImage:[UIImage imageNamed:@"Keyboard.png"] forState:UIControlStateNormal];
    [pageControl setHidden:YES];
    _faceboardIsShow = NO;
    _keyboardIsShow = YES;
    if (self.faceToolBardelegate && [self.faceToolBardelegate respondsToSelector:@selector(faceToolBarDidChangeFrame:)]) {
        [self.faceToolBardelegate faceToolBarDidChangeFrame:_toolBar];
    }
}


-(void)inputKeyboardWillHide:(NSNotification *)notification
{
    if (myTextView.text.length>0) {
        //        if ([self.faceToolBardelegate respondsToSelector:@selector(sendTextAction:inputState:)]) {
        //            [self.faceToolBardelegate sendTextAction:myTextView.text inputState:self.stateString];
        //        }
    }
    //[myTextView clearText];
}

#pragma mark -
#pragma mark facialView delegate 点击表情键盘上的文字
-(void)selectedFacialView:(NSString*)str
{
    NSString *newStr;
    if ([str isEqualToString:@"删除"]) {
        if (myTextView.text.length > 1) {
            if ([[Emoji allEmoji] containsObject:[myTextView.text substringFromIndex:myTextView.text.length-2]]) {
                //                NSLog(@"删除emoji %@",[textView.text substringFromIndex:textView.text.length-2]);
                newStr = [myTextView.text substringToIndex:myTextView.text.length-2];
            }else{
                NSLog(@"删除文字%@",[myTextView.text substringFromIndex:myTextView.text.length-1]);
                newStr = [myTextView.text substringToIndex:myTextView.text.length-1];
            }
            myTextView.text = newStr;
        }else if(myTextView.text.length > 0){
            newStr = [myTextView.text substringToIndex:myTextView.text.length-1];
            myTextView.text = newStr;
        }
        NSLog(@"删除后更新%@",myTextView.text);
        if (_toolBarType == PostDynamicToolBar) {
            [self.faceToolBardelegate faceToolBardeleteFaceString:self];
        }
    }else{
        NSString *newStr = [NSString stringWithFormat:@"%@%@",myTextView.text,str];
        [myTextView setText:newStr];
        NSLog(@"点击其他后更新%lu,%@",(unsigned long)str.length,myTextView.text);
        if (_toolBarType == PostDynamicToolBar) {
            [self.faceToolBardelegate faceToolBar:self didSelectedFaceString:str];
        }
    }
}

-(void)dealloc
{
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

//返回按钮
-(void)backTo{
    if ([self.faceToolBardelegate respondsToSelector:@selector(FaceToolBarBackTo)]) {
        [self.faceToolBardelegate FaceToolBarBackTo];
    }
}


@end
