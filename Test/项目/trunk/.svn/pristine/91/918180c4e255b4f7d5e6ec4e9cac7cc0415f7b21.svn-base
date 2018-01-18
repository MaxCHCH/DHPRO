//
//  DiscoverAddViewController.m
//  zhidoushi
//
//  Created by nick on 15/4/20.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "DiscoverAddViewController.h"
#import "UITextView+LimitLength.h"
#import "QiniuSDK.h"
#import <CoreText/CoreText.h>
#import "QEDTextView.h"
#import "IQKeyboardManager.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "UIImage+fixOrientation.h"
#import "HotTagView.h"
#import "FacialView.h"
#import "MLSelectPhotoAssets.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MLSelectPhotoBrowserViewController.h"

@interface DiscoverAddViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,HotTagViewDelegate,facialViewDelegate>

@property(nonatomic,strong)UIImagePickerController *picker;//相片选择
@property(nonatomic,assign)BOOL isNew;//七牛图片token获取
@property(nonatomic,strong)UIButton *imageBtn;//图片按钮
@property(nonatomic,weak)UILabel *textPlacehoader;//占位


//标签button数组
@property (nonatomic,strong) NSMutableArray *buttonArray;

//标签数组
@property (nonatomic,strong) NSMutableArray *tagListArray;

@property (nonatomic,strong) TPKeyboardAvoidingScrollView *tpBgView;

@property (nonatomic,strong) QEDTextView *textView;

@property(nonatomic,strong)UILabel *contentNumLbl;//字数提示

@property (nonatomic,strong) UIView *back;
@property (nonatomic,strong) UIView *imageBack;
@property (nonatomic,strong) UIView *bottomView;
@property(nonatomic,strong)UIScrollView *scrollView;//表情键盘
@property(nonatomic,strong)UIPageControl *pageControl;//表情
@property(nonatomic,strong)UIView *myToolBar;//键盘工具栏
@property(nonatomic,strong)UIButton *facialBtn;//表情按钮
@property (nonatomic, assign) UIViewController *controller;

@end

@implementation DiscoverAddViewController

#pragma mark Life Cycle
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.httpOpt cancel];
    [MobClick endLogPageView:@"发送晒图页面"];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //友盟打点
    [MobClick beginLogPageView:@"发送晒图页面"];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].enable = NO;
    //TUSDK
    //    [TuSDK checkManagerWithDelegate:self];
    
    //广场标题
    self.titleLabel.text = @"发布撒欢";
    self.titleLabel.font = MyFont(18);
    self.titleLabel.textColor = ZDS_DHL_TITLE_COLOR;
    
    //导航栏返回
//    [self.leftButton setTitle:@"取消" forState:UIControlStateNormal];
//    [self.leftButton setTitleColor:[WWTolls colorWithHexString:@"#959595"] forState:UIControlStateNormal];
//    self.leftButton.titleLabel.font = MyFont(16);
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"fh-36"] forState:UIControlStateNormal];
    [self.leftButton addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width = 18;
    labelRect.size.height = 18;
    self.leftButton.frame = labelRect;
    //导航栏发布
    [self.rightButton setTitle:@"发布" forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = MyFont(16);
    [self.rightButton setTitleColor:OrangeColor forState:UIControlStateNormal];
    if(self.textView.text.length > 0 || self.Photokey.length > 0) [self.rightButton setTitleColor:OrangeColor forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(addDiscover) forControlEvents:UIControlEventTouchUpInside];
    self.rightButton.width = 40;
    self.rightButton.height = 16;
    self.rightButton.enabled = YES;
    
    if(!self.back){
        [self setupGUI];
        if (self.tagName.length > 0) {
            self.textView.text = self.tagName;
        }
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //相机功能初始化选择器
    //    self.picker = [[UIImagePickerController  alloc] init];
    //    self.picker.delegate = self;
    //    //// 启动GPS
    //    [[TuSDKTKLocation shared] requireAuthorWithController:self];
    //    [TuSDK checkManagerWithDelegate:self];
    
    
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - UI
#pragma mark 初始化UI
-(void)setupGUI{
    
    self.view.backgroundColor = ZDS_BACK_COLOR;
    //    NSString *widthVfl = @"H:|-0-[tableView]-0-|";
    //    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:widthVfl options:0 metrics:nil views:views]];
    //    self.tpBgView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:self.view.bounds];
    //    [self.view addSubview:self.tpBgView];
    
    UIView *back = [[UIView alloc] init];
    back.frame = CGRectMake(0, 15, SCREEN_WIDTH, 140);
    back.backgroundColor = [UIColor whiteColor];
    self.back = back;
    [self.view addSubview:back];
    
    //textView
    QEDTextView *text = [[QEDTextView alloc] initWithFrame:CGRectMake(10, 0, back.width - 22, 110)];
    [text setValue:@500 forKey:@"limit"];
    //    [text limitTextLength:501];
    self.textView = text;
    text.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    text.layoutManager.allowsNonContiguousLayout = NO;
    text.delegate = self;
    text.font = MyFont(16);
    text.textColor = [WWTolls colorWithHexString:@"#535353"];
    text.scrollEnabled = YES;
    [back addSubview:text];
    
    UILabel *textlbl = [[UILabel alloc] initWithFrame:CGRectMake(5, 8, text.width - 10, 16)];
    textlbl.numberOfLines = 0;
    self.textPlacehoader = textlbl;
    textlbl.text = @"说点什么...";
    textlbl.textColor = [ContentColor colorWithAlphaComponent:0.6];
    textlbl.font = MyFont(16);
    [text addSubview:textlbl];
    
    UIView *imageBack = [[UIView alloc] initWithFrame:CGRectMake(0, back.maxY+15, SCREEN_WIDTH, 100)];
    imageBack.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:imageBack];
    self.imageBack = imageBack;
    
    //字数提示
    UILabel *contentNumLbl = [[UILabel alloc] init];
    self.contentNumLbl = contentNumLbl;
    contentNumLbl.frame = CGRectMake(SCREEN_WIDTH - 100, 122, 85, 12);
    contentNumLbl.text = @"(0/500)";
    contentNumLbl.textAlignment = NSTextAlignmentRight;
    contentNumLbl.font = MyFont(11);
    contentNumLbl.textColor = TimeColor;
    [back addSubview:contentNumLbl];
    
    //相机按钮
    UIButton *btn = [[UIButton alloc] init];
    self.imageBtn = btn;
    btn.frame = CGRectMake(5,5, 90, 90);
    [imageBack addSubview:btn];
    [btn setBackgroundImage:[UIImage imageNamed:@"tjtp-174"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(photoSelector) forControlEvents:UIControlEventTouchUpInside];
    btn.contentMode = UIViewContentModeScaleAspectFill;
    btn.clipsToBounds = YES;
    
    NSLog(@"self.imageBtn.frame:%@",[NSValue valueWithCGRect:self.imageBtn.frame]);
    
    //获取热门标签
    [self requestWithHottags];
    
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

#pragma mark 热门标签UI
- (void)createTagView {
    
    if (self.tagListArray.count == 0) {
        return;
    }
    
//    HotTagView *tagView = [[HotTagView alloc] initWithFrame:CGRectMake(0, self.imageBack.maxY + 10, SCREEN_WIDTH, 100) tagArray:self.tagListArray];
//    tagView.delegate = self;
//    //    [self.view addSubview:tagView];
//    [self.view insertSubview:tagView atIndex:0];
//    //    [self.view bringSubviewToFront:tagView];
//    [tagView makeCorner:1.0];
//    tagView.layer.cornerRadius = 1;
//    tagView.backgroundColor = [UIColor whiteColor];
    UIScrollView *tagView = [[UIScrollView alloc] init];
    tagView.backgroundColor = [UIColor whiteColor];
    tagView.bounces = NO;
    tagView.showsHorizontalScrollIndicator = NO;
    tagView.showsVerticalScrollIndicator = NO;
    [self.view insertSubview:tagView atIndex:0];
    tagView.frame = CGRectMake(0, 282, SCREEN_WIDTH, 50);
    CGFloat x = 15;
    for (int i = 0; i < self.tagListArray.count; i++){
        CGFloat width = [WWTolls WidthForString:self.tagListArray[i] fontSize:14] + 30;
        UIButton *cButton = [[UIButton alloc] initWithFrame:CGRectMake(x,10, width, 30)];
        [cButton setImage:nil forState:UIControlStateHighlighted];
        [tagView addSubview:cButton];
        cButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [cButton makeCorner:15];
        cButton.clipsToBounds = YES;
        cButton.layer.cornerRadius = 15;
        cButton.layer.borderColor = ContentColor.CGColor;
        cButton.layer.borderWidth = 1;
        [cButton setTitle:self.tagListArray[i] forState:UIControlStateNormal];
        cButton.titleLabel.text = self.tagListArray[i];
        [cButton setTitleColor:ContentColor forState:UIControlStateNormal];
        cButton.titleLabel.font = MyFont(14.0);
        
//        [cButton setBackgroundImage:[WWTolls imageWithColor:[WWTolls colorWithHexString:@"#efefef"] size:CGSizeMake(width, 30)] forState:UIControlStateNormal];
        x += width+10;
        [cButton addTarget:self action:@selector(hotTagClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    tagView.contentSize = CGSizeMake(x, 50);
    self.bottomView = tagView;
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
    int page = _scrollView.contentOffset.x / 320;//通过滚动的偏移量来判断目前页面所对应的小白点
    _pageControl.currentPage = page;//pagecontroll响应值的变化
}

//pagecontroll的委托方法
- (void)changePage:(id)sender
{
    NSInteger page = _pageControl.currentPage;//获取当前pagecontroll的值
    [_scrollView setContentOffset:CGPointMake(320 * page, 0)];//根据pagecontroll的值来改变scrollview的滚动位置，以此切换到指定的页面
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
        if(newStr.length <= 500) [self.textView setText:newStr];
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
        if(newStr.length <= 500) [self.textView setText:newStr];
        NSLog(@"点击其他后更新%lu,%@",(unsigned long)str.length,self.textView.text);
    }
    [self reloadNum];
}




#pragma mark HotTagViewDelegate
#pragma mark 热门标签点击回调
- (void)hotTagClick:(UIButton *)btn {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    self.textView.text = [NSString stringWithFormat:@"%@%@",self.textView.text,btn.titleLabel.text];
    self.textPlacehoader.hidden = YES;
}

#pragma mark UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    viewController.wantsFullScreenLayout = YES;
    navigationController.navigationBar.translucent = YES;
}

#pragma mark UIActionSheetDelegate
//选择框选择响应
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //弹出的菜单按钮点击后的响应
    switch (buttonIndex)
    {
        case 0:  //打开照相机拍照
            
            [self takePhoto:YES];
            break;
            
        case 1:  //打开本地相册
            
            [self LocalPhoto:YES];
            break;
        case 2: //打开默认图
            break;
    }
}   
- (void)onTuSDKFilterManagerInited:(TuSDKFilterManager *)manager;
{
    [self showAlertMsg:@"初始化完成" andFrame:CGRectZero];
}

///**
// *  显示范例
// *
// *  @param controller 启动控制器
// */
//- (void)showSimpleWithController:(UIViewController *)controller;
//{
//    if (!controller) return;
////    self.controller = controller;
//    
//    lsqLDebug(@"avatarComponentHandler");
//    
//    // 组件选项配置
//    // @see-http://tusdk.com/docs/ios/api/Classes/TuSDKCPAvatarComponent.html
//    _albumComponent =
//    [TuSDKGeeV1 avatarCommponentWithController:controller
//                                 callbackBlock:^(TuSDKResult *result, NSError *error, UIViewController *controller)
//     {
//         _albumComponent = nil;
//         // 获取头像图片
//         if (error) {
//             lsqLError(@"avatar reader error: %@", error.userInfo);
//             return;
//         }
//         [result logInfo];
//     }];


//    // 组件选项配置
//    // @see-http://tusdk.com/docs/ios/api/Classes/TuSDKCPAvatarOptions.html
//    // _avatarComponent.options
//    
//    // @see-http://tusdk.com/docs/ios/api/Classes/TuSDKPFAlbumOptions.html
//    // _avatarComponent.options.albumOptions
//    
//    // @see-http://tusdk.com/docs/ios/api/Classes/TuSDKPFPhotosOptions.html
//    // _avatarComponent.options.photosOptions
//    
//    // @see-http://tusdk.com/docs/ios/api/Classes/TuSDKPFCameraOptions.html
//    // _avatarComponent.options.cameraOptions
//    
//    // http://tusdk.com/docs/ios/api/Classes/TuSDKPFEditTurnAndCutOptions.html
//    // _avatarComponent.options.editTurnAndCutOptions
//    
//    
//    
//    // 需要显示的滤镜名称列表 (如果为空将显示所有自定义滤镜)
////    _albumComponent.options.cameraOptions.filterGroup = @[@"SkinNature", @"SkinPink", @"SkinJelly", @"SkinNoir", @"SkinRuddy", @"SkinPowder", @"SkinSugar"];
//    // 是否在组件执行完成后自动关闭组件 (默认:NO)
//    _albumComponent.autoDismissWhenCompelted = YES;
//    [_albumComponent showComponent];
//}

#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    
    //    [textView textFieldTextLengthLimit:nil];
    [self reloadNum];
}

- (void)reloadNum{
    self.textPlacehoader.hidden = _textView.text.length > 0;
    self.contentNumLbl.text = [NSString stringWithFormat:@"(%ld/500)",(unsigned long)_textView.text.length>500?500:_textView.text.length];
//    if (_textView.text.length > 0 || self.Photokey.length > 0) {
//        [self.rightButton setTitleColor:ZDS_DHL_TITLE_COLOR forState:UIControlStateNormal];
//    } else {
//        [self.rightButton setTitleColor:[WWTolls colorWithHexString:@"#959595"] forState:UIControlStateNormal];
//    }
}

//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    if (text.length + textView.text.length - range.length >= 501) {
//        NSString *newText = [textView.text stringByReplacingCharactersInRange:range withString:text];
//        textView.text = [newText substringToIndex:500];
//        [self reloadNum];
//        return NO;
//    }
//    return YES;
//}
#pragma mark - Event Resposnes

#pragma mark 发布撒欢
-(void)addDiscover{
    
    BOOL isNull = YES;
    
    NSString *content = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (self.Photokey.length>0 || content.length>0) {
        isNull = NO;
    }
    
    if (isNull) {
        [self showAlertMsg:@"请输入内容！或拍照！" andFrame:CGRectZero];
        return;
    }else if([WWTolls isHasSensitiveWord:content]){
        [self showAlertMsg:ZDS_HASSENSITIVE yOffset:-100];
        return;
    }
    [self.view endEditing:YES];
    self.rightButton.userInteractionEnabled = NO;
    
    self.rightButton.enabled = NO;
    
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:5];
    
    if (self.Photokey.length>0) {
        [dictionary setObject:[NSString stringWithFormat:@"%@?%@?%.0f?%.0f?%lld",self.Photokey,self.Photohash,self.PhotoSize.width,self.PhotoSize.height,self.PhotoBig] forKey:@"imageurl"];
    }
    NSString *con = self.textView.text;
    con = [con stringByReplacingOccurrencesOfString:@"＃" withString:@"#" options:NSCaseInsensitiveSearch range:NSMakeRange(0, con.length)];
    [dictionary setObject:con forKey:@"content"];
    if(self.clickevent.length > 0) [dictionary setObject:self.clickevent forKey:@"clickevent"];
    [self showWaitView];
    __weak typeof(self)weakSelf = self;
    self.httpOpt = [WWRequestOperationEngine operationManagerRequest_Post:ZDS_DISCOVER_ADDDISCOVER parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        [self removeWaitView];
        if ([dic[@"result"] isEqualToString:@"0"]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"adddiscoverSucess" object:dic];
            if (self.tagName.length > 0 &&[weakSelf.textView.text hasPrefix:self.tagName]) {
                [weakSelf showAlertMsg:@"发布成功" yOffset:0];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            } else {
                [weakSelf showAlertMsg:@"已成功发布至广场" yOffset:0];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                });
            }
            
        }else{
            weakSelf.rightButton.enabled = YES;
        }
        
    }];
}

#pragma mark 相机功能
//弹出选择框
-(void)photoSelector{
    MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
    // 默认显示相册里面的内容SavePhotos
    pickerVc.topShowPhotoPicker = YES;
    [NSUSER_Defaults setObject:@"最多只能添加1张图片" forKey:@"zdsselectphotoTip"];
    //        pickerVc.selectPickers = self.assets;
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.minCount = 1;
    [pickerVc showPickerVc:self];
    __weak typeof(self) weakSelf = self;
    pickerVc.callBack = ^(NSArray *assets){
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        UIImage *image;
        if ([assets[0] isKindOfClass:[MLSelectPhotoAssets class]]) {
            image = ((MLSelectPhotoAssets*)assets[0]).originImage;
        }else image = assets[0];
        [weakSelf openEditMultipleWithController:weakSelf result:image];
    };
    
    
    //    UIActionSheet *photoActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开相机",@"从手机相册获取", nil];
    //    photoActionSheet.tag = 999;
    //    [photoActionSheet showInView:self.view];
}
-(NSMutableArray *)assets{
    if (_assets == nil) {
        _assets = [NSMutableArray array];
    }
    return _assets;
}
- (void)openEditMultipleWithController:(UIViewController *)controller  result:(UIImage *)result
{
    if (!self || !result) return;
    
    
    //    [self.imageBtn setBackgroundImage:[MLSelectPhotoPickerViewController getImageWithImageObj:result] forState:UIControlStateNormal];
    
    //    self.controller = controller;
    //    self.controller.view.frame = CGRectMake(0, 0, SSL_Width_Value, 0);
    // 组件选项配置
    // @see-http://tusdk.com/docs/ios/api/Classes/TuSDKCPPhotoEditMultipleComponent.html
    WEAKSELF_SS
    
    _photoEditMultipleComponent =
    [TuSDKGeeV1 photoEditMultipleWithController:self
                                  callbackBlock:^(TuSDKResult *result, NSError *error, UIViewController *controller)
     {
         
         // 如果在RootViewController presentViewController,autoDismissWhenCompelted参数将无效
         // 请使用以下方法关闭
         if (controller) {
             [controller popViewControllerAnimated:YES];
         }
         
         
         WEAKSELF_SS
         NSDictionary *dict = [NSMutableDictionary dictionary];
         [dict setValue:self.isNew?@"0":@"1" forKey:@"isnew"];
         [weakSelf showWaitView];
         [WWRequestOperationEngine operationManagerRequest_Post:[NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_UPLOADTOKEN] parameters:dict requestOperationBlock:^(NSDictionary *dic) {
             
             if (dic[ERRCODE]) {
                 [weakSelf removeWaitView];
             }else{
#pragma mark - 七牛上传图片
                 NSString *token = dic[@"uptoken"];
                 if(token.length>0){
                     UIImage *img =  [UIImage imageWithData:[NSData dataWithContentsOfFile:result.imagePath]];
                     NSData *data = [SSLImageTool compressImage:img withMaxKb:300];
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
                                   [weakSelf removeWaitView];
                                   if (info.isOK) {
                                       
                                       if(resp){
                                           weakSelf.Photohash = resp[@"hash"];
                                           weakSelf.Photokey = resp[@"key"];
                                           weakSelf.PhotoBig = data.length;
                                           weakSelf.PhotoSize = result.image.size;
                                           //直接把该图片读出来显示在按钮上
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               [weakSelf.imageBtn setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
                                           });
//                                           weakSelf.imageBtn.width = 80;
//                                           weakSelf.imageBtn.height = 80;
//                                           weakSelf.imageBack.height = 91;
//                                           weakSelf.bottomView.top = weakSelf.imageBack.maxY + 10;
//                                           weakSelf.contentNumLbl.top = weakSelf.imageBtn.bottom - 10;
//                                           [weakSelf.rightButton setTitleColor:ZDS_DHL_TITLE_COLOR forState:UIControlStateNormal];
                                           NSLog(@"weakSelf.imageBtn.frame:%@",[NSValue valueWithCGRect:weakSelf.imageBtn.frame]);
                                           NSLog(@"weakSelf.textView.frame:%@",[NSValue valueWithCGRect:weakSelf.textView.frame]);
                                       }
                                   }else{
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
         
         // 获取图片失败
         if (error) {
             lsqLError(@"editMultiple error: %@", error.userInfo);
             return;
         }
         [result logInfo];
     }];
    
    // 设置图片
    _photoEditMultipleComponent.inputImage = result;
    //    _photoEditMultipleComponent.inputTempFilePath = result.imagePath;
    //    _photoEditMultipleComponent.inputAsset = result.imageAsset;
    // 是否在组件执行完成后自动关闭组件 (默认:NO)
    _photoEditMultipleComponent.autoDismissWhenCompelted = YES;
    [_photoEditMultipleComponent showComponent];
    
    
    
    //    _albumComponent =
    //    [TuSDKGeeV1 albumCommponentWithController:controller
    //                                callbackBlock:^(TuSDKResult *result, NSError *error, UIViewController *controller)
    //     {
    //         // 获取图片错误
    //         if (error) {
    //             lsqLError(@"album reader error: %@", error.userInfo);
    //             return;
    //         }
    //         [result logInfo];
    //     }];
    //
    //    [_albumComponent showComponent];
    //
    
    
    
}
#pragma mark 返回上一级
- (void)pop{
    if (self.textView.text.length > 0 || self.assets.count > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否放弃当前编辑的内容" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alert show];
    }else [self popButton];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self popButton];
    }
}

-(void)popButton{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private Methods
#pragma mark 调用相机
-(void)takePhoto:(BOOL)Editing
{
    UIImagePickerControllerSourceType sourceType =UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        //设置拍照后的图片可被编辑
        _picker.allowsEditing = NO;
        _picker.sourceType = sourceType;
        _picker.videoQuality = UIImagePickerControllerQualityTypeLow;
        [self.view.window.rootViewController presentViewController:_picker animated:YES completion:nil];
    }else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

#pragma mark 调用相册
-(void)LocalPhoto:(BOOL)Editing
{
    _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //设置选择后的图片可被编辑
    _picker.allowsEditing = NO;
    [self.view.window.rootViewController presentViewController:_picker animated:NO completion:nil];
    //    [self.view.window.rootViewController pushViewController:_picker animated:YES];
}

#pragma mark - Request

#pragma mark 加载所有的热门标签               
- (void)requestWithHottags {
    
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    /**
     *  0 热门标签
     *  1 广场展示标签
     */
    [dictionary setObject:@"0" forKey:@"tagtype"];
    
    //发送请求即将开团
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_HOTTAGS];
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:urlString parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (!dic[ERRCODE]) {
            NSArray *arr = dic[@"taglist"];
            [weakSelf.tagListArray removeAllObjects];
            [weakSelf.tagListArray addObjectsFromArray:arr];
        }
        [weakSelf createTagView];
        weakSelf.rightButton.enabled = YES;
    }];
}

#pragma mark - Getters And Setters
- (NSMutableArray *)buttonArray {
    if (_buttonArray == nil) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

- (NSMutableArray *)tagListArray {
    if (_tagListArray == nil) {
        _tagListArray = [NSMutableArray array];
    }
    return _tagListArray;
}

#pragma mark UIResponder
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

@end
