//
//  PushCardViewController.m
//  zhidoushi
//
//  Created by nick on 15/10/27.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import "PushCardViewController.h"
#import "UITextView+LimitLength.h"
#import "QiniuSDK.h"
#import "IQKeyboardManager.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "UIImage+fixOrientation.h"
#import "MyCalendarViewController.h"
#import "FacialView.h"
@interface PushCardViewController ()
@property(nonatomic,assign)BOOL isNew;//七牛图片token获取
@property(nonatomic,strong)UIButton *imageBtn;//图片按钮
@property(nonatomic,weak)UILabel *textPlacehoader;//占位

//标签button数组
@property (nonatomic,strong) NSMutableArray *buttonArray;

//标签数组
@property (nonatomic,strong) NSMutableArray *tagListArray;

@property (nonatomic,strong) TPKeyboardAvoidingScrollView *tpBgView;

@property (nonatomic,strong) UITextView *textView;

@property(nonatomic,strong)UILabel *contentNumLbl;//字数提示
@property(nonatomic,strong)UIButton *tongbuBtn;//同步
@property(nonatomic,strong)UILabel *tongbuLbl;//同步提示
@property (nonatomic,strong) UIView *back;
@property (nonatomic,strong) UIView *imageBack;
@property (nonatomic,strong) UIView *bottomView;
@property(nonatomic,strong)UIScrollView *scrollView;//表情键盘
@property(nonatomic,strong)UIPageControl *pageControl;//表情
@property(nonatomic,strong)UIView *myToolBar;//键盘工具栏
@property(nonatomic,strong)UIButton *facialBtn;//表情按钮

@end

@implementation PushCardViewController

#pragma mark Life Cycle
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.httpOpt cancel];
    [MobClick endLogPageView:@"打卡添加文字页面"];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //友盟打点
    [MobClick beginLogPageView:@"打卡添加文字页面"];
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].enable = NO;
    
    //广场标题
    self.titleLabel.text = @"蜕变日记";
    self.titleLabel.font = MyFont(18);
    self.titleLabel.textColor = ZDS_DHL_TITLE_COLOR;
    
    //导航栏返回
//    [self.leftButton setTitle:@"取消" forState:UIControlStateNormal];
//    [self.leftButton setTitleColor:[WWTolls colorWithHexString:@"#959595"] forState:UIControlStateNormal];
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"fh-36"] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = MyFont(16);
    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width = 18;
    labelRect.size.height = 18;
    self.leftButton.frame = labelRect;
    //导航栏发布
    [self.rightButton setTitle:@"完成" forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = MyFont(16);
    [self.rightButton setTitleColor:OrangeColor forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(inputImage) forControlEvents:UIControlEventTouchUpInside];
    self.rightButton.width = 40;
    self.rightButton.height = 16;
    self.rightButton.enabled = YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupGUI];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - UI
#pragma mark 初始化UI
-(void)setupGUI{
    
    self.view.backgroundColor = ZDS_BACK_COLOR;
    
    //    self.tpBgView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:self.view.bounds];
    //    [self.view addSubview:self.tpBgView];
    
    //背景view
    UIView *back = [[UIView alloc] init];
    back.frame = CGRectMake(0, 15, SCREEN_WIDTH, 140);
    back.backgroundColor = [UIColor whiteColor];
    self.back = back;
    [self.view addSubview:back];
//    UIView *tb = [UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)
    //textView
    UITextView *text = [[UITextView alloc] initWithFrame:CGRectMake(10, 5, back.width - 22,150)];
    [text setValue:@100 forKey:@"limit"];
//    [text limitTextLength:100];
    self.textView = text;
    text.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    text.layoutManager.allowsNonContiguousLayout = NO;
    text.delegate = self;
    text.font = MyFont(16);
    text.textColor = [WWTolls colorWithHexString:@"#4E777F"];
    text.scrollEnabled = YES;
    [back addSubview:text];
    
    UILabel *textlbl = [[UILabel alloc] initWithFrame:CGRectMake(5, 8, text.width - 10, 16)];
    textlbl.numberOfLines = 0;
    self.textPlacehoader = textlbl;
    textlbl.text = @"记录你的蜕变时光...";
    textlbl.textColor = [[WWTolls colorWithHexString:@"#4E777F"] colorWithAlphaComponent:0.6];
    textlbl.font = MyFont(16);
    [text addSubview:textlbl];
    
    //同步分享到广场
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(12, back.bottom + 15, 16, 16)];
    [btn setBackgroundImage:[UIImage imageNamed:@"xz-34"] forState:UIControlStateSelected];
    [btn setBackgroundImage:[UIImage imageNamed:@"wxz-34"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(tongbu:) forControlEvents:UIControlEventTouchUpInside];
    //    btn.selected = YES;
    //    if(self.password && self.password.length > 0){
    [self.view addSubview:btn];
    btn.selected = YES;
    //    }
    self.tongbuBtn = btn;
    
    UILabel *tongbuLbl = [[UILabel alloc] initWithFrame:CGRectMake(32, btn.top, 240, 14)];
    tongbuLbl.font = MyFont(13);
    tongbuLbl.textColor = [WWTolls colorWithHexString:@"#a7a7a7"];
    tongbuLbl.text = @"同步到乐活吧和撒欢";
    self.tongbuLbl = tongbuLbl;
    [self.view addSubview:tongbuLbl];
    

    
    //字数提示
    UILabel *contentNumLbl = [[UILabel alloc] init];
    self.contentNumLbl = contentNumLbl;
    contentNumLbl.frame = CGRectMake(SCREEN_WIDTH - 100, 121, 85, 12);
    contentNumLbl.text = @"(0/100)";
    contentNumLbl.textAlignment = NSTextAlignmentRight;
    contentNumLbl.font = MyFont(13);
    contentNumLbl.textColor = [WWTolls colorWithHexString:@"#a7a7a7"];
    [back addSubview:contentNumLbl];
    
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
- (void)tongbu:(UIButton*)btn{
    btn.selected = !btn.selected;
}
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
        if(newStr.length <= 100) [self.textView setText:newStr];
    }
    [self reloadNum];
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
        if(newStr.length <= 100) [self.textView setText:newStr];
        NSLog(@"点击其他后更新%lu,%@",(unsigned long)str.length,self.textView.text);
    }
    [self reloadNum];
}

//获取图片后的行为
-(void)inputImage
{
    [self.view endEditing:YES];
    if (self.Photohash && self.Photohash.length > 0) {
        [self addDiscover];
        return;
    }
        UIImage *image = [self.image fixOrientation];
        __weak typeof(self) weakSelf = self;
            [self showWaitView];
            NSDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:self.isNew?@"0":@"1" forKey:@"isnew"];
            [WWRequestOperationEngine operationManagerRequest_Post:[NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_UPLOADTOKEN] parameters:dict requestOperationBlock:^(NSDictionary *dic) {
                
                if (dic[ERRCODE]) {
                    [weakSelf removeWaitView];
                }else{
#pragma mark - 七牛上传图片
                    NSString *token = dic[@"uptoken"];
                    if(token.length>0){
                        NSData *data = [SSLImageTool compressImage:image withMaxKb:300];
                        //七牛上传管理器
                        QNUploadManager *upManager = [[QNUploadManager alloc] init];
                        //开始上传
                        CFUUIDRef uuidRef =CFUUIDCreate(NULL);
                        
                        CFStringRef uuidStringRef =CFUUIDCreateString(NULL, uuidRef);
                        
                        CFRelease(uuidRef);
                        
                        NSString *UUIDStr = (__bridge NSString *)uuidStringRef;
                        NSString *QNkey = [NSString stringWithFormat:@"images/0/%@.jpg",UUIDStr];
                        [upManager putData:data key:QNkey token:token
                                  complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {//resp hash key
                                      weakSelf.isNew = NO;
                                      if (info.isOK) {
                                          
                                          if(resp){
                                              weakSelf.Photohash = resp[@"hash"];
                                              weakSelf.Photokey = resp[@"key"];
                                              weakSelf.PhotoBig = data.length;
                                              weakSelf.PhotoSize = image.size;
                                              [weakSelf addDiscover];
                                          }
                                      }else{
                                          [weakSelf removeWaitView];
                                          if (info.isConnectionBroken) {
                                              [MBProgressHUD showError:@"网速太不给力了"];
                                          }
                                          else if(info.statusCode == 401){//授权失败
                                              weakSelf.isNew = YES;
                                              [MBProgressHUD showError:@"上传失败，请重试"];
                                          }else [MBProgressHUD showError:@"上传失败，请重试"];
                                      }
                                      NSLog(@"%@", info);
                                      NSLog(@"%@", resp);
                                  } option:nil];
                    }else{
                        [weakSelf removeWaitView];
                        [MBProgressHUD showError:@"上传失败请重试"];
                    }
                }
            }];
}

#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    
//    [textView textFieldTextLengthLimit:nil];
    [self reloadNum];
}

- (void)reloadNum{
    self.textPlacehoader.hidden = _textView.text.length > 0;
    self.contentNumLbl.text = [NSString stringWithFormat:@"(%ld/100)",_textView.text.length>100?100:_textView.text.length];
}

//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    if (text.length + textView.text.length - range.length >= 101) {
//        NSString *newText = [textView.text stringByReplacingCharactersInRange:range withString:text];
//        textView.text = [newText substringToIndex:100];
//        [self reloadNum];
//        return NO;
//    }
//    return YES;
//}
#pragma mark - Event Resposnes

#pragma mark 发布打卡
-(void)addDiscover{
    [self showWaitView];
    self.rightButton.enabled = NO;
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:5];
    
    if (self.Photokey.length>0) {
        [dictionary setObject:[NSString stringWithFormat:@"%@?%@?%.0f?%.0f?%lld",self.Photokey,self.Photohash,self.PhotoSize.width,self.PhotoSize.height,self.PhotoBig] forKey:@"imageurl"];
    }
    NSString *con = self.textView.text;
    [dictionary setObject:con forKey:@"punchcontent"];
    [dictionary setObject:self.gameid forKey:@"gameid"];
    [dictionary setObject:self.tongbuBtn.selected?@"0":@"1" forKey:@"synshow"];
    __weak typeof(self)weakSelf = self;
    self.httpOpt = [WWRequestOperationEngine operationManagerRequest_Post:ZDS_GROUP_PUSHCARD parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        [self removeWaitView];
        if ([dic[@"result"] isEqualToString:@"0"]) {
            [self removeWaitView];
            [MBProgressHUD showError:@"照片已保存至手机相册"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"pushcardSucess" object:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                for (int i = (int)weakSelf.navigationController.childViewControllers.count - 1; i>0;i--) {
                    if([weakSelf.navigationController.childViewControllers[i] isKindOfClass:[MyCalendarViewController class]]){
                        [weakSelf.navigationController popToViewController:weakSelf.navigationController.childViewControllers[i] animated:YES];
                        break;
                    }
                }
                
                });
            
        }else{
            weakSelf.rightButton.enabled = YES;
        }
        
    }];
}

#pragma mark 相机功能
//弹出选择框
-(void)photoSelector{
    UIActionSheet *photoActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开相机",@"从手机相册获取", nil];
    photoActionSheet.tag = 999;
    [photoActionSheet showInView:self.view];
}

#pragma mark 返回上一级
-(void)popButton{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
