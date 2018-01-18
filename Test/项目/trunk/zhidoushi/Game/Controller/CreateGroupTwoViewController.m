//
//  CreateGroupTwoViewController.m
//  zhidoushi
//
//  Created by nick on 15/5/18.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "CreateGroupTwoViewController.h"
#import "QiniuSDK.h"
#import "MLImageCrop.h"
#import "UITextField+LimitLength.h"
#import "UITextView+LimitLength.h"
#import "GroupViewController.h"
#import "IQKeyboardManager.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "CreateGroupSetPasswordViewController.h"
#import "EditorTagAlertView.h"
#import "UIView+SSLAlertViewTap.h"
#import "ZdsTagButton.h"
#import "MLSelectPhotoAssets.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MLSelectPhotoBrowserViewController.h"

#import "CreatGroupSubViewTwoController.h"

#import "PingInvertTransition.h"

@interface CreateGroupTwoViewController()<UIActionSheetDelegate,UIPickerViewDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate,MLImageCropDelegate,EditorTagDelegate>{
    UIActionSheet *photoActionSheet;
    NSString *name;
    
    UIPercentDrivenInteractiveTransition *percentTransition;
}
@property(nonatomic,strong)UITextView *content;//文本框
@property(nonatomic,strong)UILabel *textPlacehoader;//占位
@property(nonatomic,strong)UITextView *usercontent;//文本框
@property(nonatomic,strong)UILabel *usertextPlacehoader;//占位
@property(nonatomic,strong)UIImagePickerController *picker;
@property(nonatomic,strong)UIButton *imageButton;//选择封面
@property(nonatomic,assign)BOOL isNew;//是否请求生产新凭证
@property(nonatomic,copy)NSString *Photohash;//上传图片hash值
@property(nonatomic,copy)NSString *Photokey;//上传图片key值
@property(nonatomic,assign)CGSize PhotoSize;//尺寸
@property(nonatomic,assign)long long PhotoBig;//大小
@property(nonatomic,strong)NSMutableArray *whereData;//<#强引用#>
@property (nonatomic,strong) TPKeyboardAvoidingScrollView *tpBgView;
@property(nonatomic,strong)UIView *tagBgView;//标签背景视图
@property(nonatomic,strong)UIButton *addTagBtn;//添加标签按钮
@property(nonatomic,strong)UILabel *tagLbl;//标签提示label
@property(nonatomic,strong)UILabel *contentNumLbl;//字数提示
@property(nonatomic,strong)UIScrollView *hotTagView;//热门标签视图
@property(nonatomic,strong)UIPageControl *pageControl;//页数控制
@property(nonatomic,strong)UIButton *submitBtn;//提交按钮
@property(nonatomic,strong)HKKTagWriteView *tagWriteView;


@end

@implementation CreateGroupTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadWhereTag];
    self.whereData = [NSMutableArray array];
    self.tagArray = [NSMutableArray array];
    self.hotTags = [NSMutableArray array];
//    NSDictionary *dic = [NSUSER_Defaults valueForKey:ZDS_CREATE_TAGS];
//    if (![dic isKindOfClass:[NSDictionary class]] || dic==nil) {
//        
//    }else{
//        [self.whereData removeAllObjects];
//        [self.whereData addObjectsFromArray:dic[@"wherelist"]];
//    }
//    if(self.whereData.count > 0){
//        [self setUpGUI];
//    }
    UIView *titleViews = [[UIView alloc] init];
    [titleViews addSubview:self.leftButton];
    [titleViews addSubview:self.rightButton];
    self.navigationItem.titleView = titleViews;
    //导航栏返回
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"fh-36"] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = MyFont(14);
    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width = 16;
    labelRect.size.height = 16;
    self.leftButton.frame = labelRect;

    
    
//    if (self.isPassWordGrouper) {
//        [self.rightButton setTitle:@"下一步" forState:UIControlStateNormal];
//    }else [self.rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.rightButton setTitle:@"下一步" forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(Next) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton setTitleColor:[WWTolls colorWithHexString:@"#959595"] forState:UIControlStateNormal];
    self.rightButton.width = 54;
    self.rightButton.left += 110;
    self.rightButton.titleLabel.font = MyFont(16);
    
    //导航栏标题
    UILabel *title = [[UILabel alloc] init];
    title.text = @"创建减脂团";
    title.textColor = ZDS_DHL_TITLE_COLOR;
    title.font = MyFont(18);
    title.textAlignment = NSTextAlignmentCenter;
    title.frame = CGRectMake(0, 0, 320, 44);
    title.center = titleViews.center;
    [titleViews addSubview:title];
    
    //分割线
    UIImageView *lineAImageView = [UIImageView new];
    lineAImageView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, 4);
    [lineAImageView setImage: [UIImage imageNamed:@"jdt-640-8.jpg"]];
    //[WWTolls colorWithHexString:@"#dcdcdc"];
    [self.view addSubview:lineAImageView];

    //测试  YES 是创建密码团
//    _isPassWordGrouper = YES;
    UIImageView *lineBImageView = [UIImageView new];
    if (_isPassWordGrouper == YES) {
        lineBImageView.frame = CGRectMake(self.view.frame.size.width-(self.view.frame.size.width*3/4), self.view.frame.origin.y, self.view.frame.size.width, 4);
    }
    else{
        lineBImageView.frame = CGRectMake(self.view.frame.size.width-(self.view.frame.size.width*2/3), self.view.frame.origin.y, self.view.frame.size.width, 4);
    }
    lineBImageView.backgroundColor = [UIColor grayColor];
    //[WWTolls colorWithHexString:@"#dcdcdc"];
    [self.view addSubview:lineBImageView];
    
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // Do any additional setup after loading the view.
}

#pragma mark - 初始化UI
-(void)setUpGUI{
    self.tpBgView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 4, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight)];
    [self.view addSubview:self.tpBgView];

    //选择封面
    _imageButton = [[UIButton alloc]init];
    _imageButton.frame = CGRectMake(SCREEN_MIDDLE(84),15, 84, 84);
    //[_imageButton setTitle:@"上传头像" forState:UIControlStateNormal];
    _imageButton.titleLabel.font = MyFont(12);
    _imageButton.backgroundColor = [UIColor grayColor];
    _imageButton.layer.cornerRadius = 2;
    [_imageButton setBackgroundImage:[UIImage imageNamed:@"xj-b-104-90"] forState:UIControlStateNormal];
    [_imageButton setBackgroundImage:[UIImage imageNamed:@"xj-h-104-90"] forState:UIControlStateHighlighted];
    [_imageButton addTarget:self action:@selector(photoFileSelector) forControlEvents:UIControlEventTouchUpInside];
    _picker = [[UIImagePickerController alloc] init];
    [_picker setDelegate:self];
    [self.tpBgView addSubview:_imageButton];
    
    
    //团组名称
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
    line.frame = CGRectMake(0, self.imageButton.bottom+15, SCREEN_WIDTH, 0.5);
    [self.tpBgView addSubview:line];
    
    UILabel *lbl1 = [[UILabel alloc] init];
    lbl1.frame = CGRectMake(13, line.bottom+15, 64,15);
    lbl1.text = @"团组名称";
    lbl1.font = MyFont(14);
    lbl1.textColor = [WWTolls colorWithHexString:@"#535353"];
    [self.tpBgView addSubview:lbl1];
    
    self.nameTextField = [[UITextField alloc] init];
    self.nameTextField.font = MyFont(14);
    self.nameTextField.placeholder = @"输入团组名称";
    self.nameTextField.textColor =  [WWTolls colorWithHexString:@"#999999"];
    self.nameTextField.frame = CGRectMake(85, lbl1.top, 150, 15);
    self.nameTextField.textAlignment = NSTextAlignmentCenter;
    self.nameTextField.delegate = self;
    [self.nameTextField limitTextLength:10];
    [self.tpBgView addSubview:self.nameTextField];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, lbl1.top, 320, 20)];
    [self.tpBgView addSubview:btn];
    [btn addTarget:self action:@selector(name) forControlEvents:UIControlEventTouchUpInside];
    //团组标签
    //分割线
    line = [[UIView alloc] init];
    line.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
    line.frame = CGRectMake(0, lbl1.bottom+15, SCREEN_WIDTH, 0.5);
    [self.tpBgView addSubview:line];
    
    
    
    UILabel *lbl2 = [[UILabel alloc] init];
    lbl2.text = @"减脂宣言";
    lbl2.frame = CGRectMake(13, line.bottom+10, 64,15);
    lbl2.font = MyFont(14);
    lbl2.textColor = [WWTolls colorWithHexString:@"#535353"];
    self.tagBgView.layer.borderColor = [UIColor redColor].CGColor;
    self.tagBgView.layer.borderWidth = 1;
    [self.tpBgView addSubview:lbl2];
    
    line = [[UIView alloc] init];
    line.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
    line.frame = CGRectMake(0, lbl2.bottom + 107, SCREEN_WIDTH, 0.5);
    [self.tpBgView addSubview:line];
    
    //招募宣言
//    UILabel *lbl4 = [[UILabel alloc] init];
//    lbl4.text = @"减脂方法";
//    lbl4.font = MyFont(14);
//    lbl4.frame = CGRectMake(13, line.bottom+10, 64,15);
//    lbl4.textColor = [WWTolls colorWithHexString:@"#535353"];
//    [self.tpBgView addSubview:lbl4];
    
    
    //减肥方式
//    UITextView *usertext = [[UITextView alloc] init];
//    self.usercontent = usertext;
//    usertext.frame = CGRectMake(6, lbl2.bottom+5, 308, 80);
//    usertext.delegate = self;
//    usertext.font = MyFont(14);
//    usertext.textColor = [WWTolls colorWithHexString:@"#999999"];
//    usertext.contentInset = UIEdgeInsetsMake(5, 3, -5, -3);
//    [usertext limitTextLength:301];
//    [self.tpBgView addSubview:usertext];
    
//    UILabel *usertextlbl = [[UILabel alloc] initWithFrame:CGRectMake(16, usertext.top+12, 200, 20)];
//    usertextlbl.numberOfLines = 0;
//    self.usertextPlacehoader = usertextlbl;
//    usertextlbl.text = @"团长大人，说说你的神技能吧";
//    usertextlbl.textColor = [WWTolls colorWithHexString:@"#a0a0a0"];
//    usertextlbl.font = MyFont(14);
//    [self.tpBgView addSubview:usertextlbl];
    
//    //字数提醒
//    UILabel *lbl = [[UILabel alloc] init];
//    lbl.text = @"最多可以输入300个字";
//    lbl.font = MyFont(11);
//    lbl.textColor = [WWTolls colorWithHexString:@"#80cafb"];
//    lbl.frame = CGRectMake(12, usertext.bottom+2, 200, 12);
//    [self.tpBgView addSubview:lbl];
    
    //减肥方式
    UITextView *text = [[UITextView alloc] init];
    self.content = text;
    [text setValue:@30 forKey:@"limit"];
    text.frame = CGRectMake(6, lbl2.bottom+5, 308, 80);
    text.delegate = self;
    text.font = MyFont(14);
    text.textColor = [WWTolls colorWithHexString:@"#999999"];
    text.contentInset = UIEdgeInsetsMake(5, 3, -5, -3);
    [text limitTextLength:301];
    [self.tpBgView addSubview:text];
    
    UILabel *textlbl = [[UILabel alloc] initWithFrame:CGRectMake(16, text.top+12, 300, 20)];
    textlbl.numberOfLines = 0;
    self.textPlacehoader = textlbl;
    textlbl.text = @"说出你的宣言，召唤更多减脂小伙伴~";
    textlbl.textColor = [WWTolls colorWithHexString:@"#a0a0a0"];
    textlbl.font = MyFont(14);
    [self.tpBgView addSubview:textlbl];
    
    //字数提醒
//    UILabel *lbl = [[UILabel alloc] init];
//    lbl.text = @"最多可以输入300个字";
//    lbl.font = MyFont(11);
//    lbl.textColor = [WWTolls colorWithHexString:@"#80cafb"];
//    lbl.frame = CGRectMake(12, text.bottom+2, 200, 12);
//    [self.tpBgView addSubview:lbl];
    
    //字数提示
    UILabel *contentNumLbl = [[UILabel alloc] init];
    self.contentNumLbl = contentNumLbl;
    contentNumLbl.frame = CGRectMake(SCREEN_WIDTH - 100, text.bottom+2, 85, 12);
    contentNumLbl.text = @"0/30";
    contentNumLbl.textAlignment = NSTextAlignmentRight;
    contentNumLbl.font = MyFont(11);
    contentNumLbl.textColor = [WWTolls colorWithHexString:@"#80cafb"];
    [self.tpBgView addSubview:contentNumLbl];
//    line = [[UIView alloc] init];
//    line.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
//    line.frame = CGRectMake(0, lbl.bottom + 7, SCREEN_WIDTH, 0.5);
//    [self.tpBgView addSubview:line];
    
    
    
    //提示
//    lbl = [[UILabel alloc] init];
//    self.tagLbl = lbl;
//    lbl.text = @"这是个什么样子的团，添加个标签吧";
//    lbl.textAlignment = NSTextAlignmentCenter;
//    lbl.font = MyFont(11);
//    lbl.textColor = [WWTolls colorWithHexString:@"#80cafb"];
//    lbl.frame = CGRectMake(0, addTagBtn.bottom+15, SCREEN_WIDTH, 12);
//    [self.tpBgView addSubview:lbl];
    
    
}
#pragma mark 键盘即将退出
- (void)keyBoardWillHide:(NSNotification *)note{
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        weakself.view.transform = CGAffineTransformIdentity;
//        self.tagBgView.height = (margin + 25)*(rowIndex+1);
//        self.addTagBtn.top = self.tagBgView.bottom;
//        self.tpBgView.contentSize = CGSizeMake(SCREEN_WIDTH, self.addTagBtn.bottom+15);
    }];
}
- (CGFloat) WidthForString:(NSString *)value fontSize:(CGFloat)fontsize
{
    UIFont *fnt = [UIFont fontWithName:@"HelveticaNeue" size:fontsize];
    CGSize size = [value sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
    return size.width;
    
}
-(void)commitEditor:(EditorTagAlertView *)discussAlert{
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    NSArray *hotTags = discussAlert.tagWriteView.tags;
    [_tagArray removeAllObjects];
    [_tagArray addObjectsFromArray:hotTags];
    int rowIndex = 0;
    int WidthSumTemp = 0;
    CGFloat margin = 8;
    for (UIView *chirld in self.tagBgView.subviews) {
        [chirld removeFromSuperview];
    }
    for (int i =0; i<hotTags.count; i++) {
        NSString *tagStr = hotTags[i];
        ZdsTagButton *tagBtn = [[ZdsTagButton alloc] init];
        CGFloat fontWidth = [self WidthForString:tagStr fontSize:11] + 16;
        if (WidthSumTemp + fontWidth > self.tagBgView.bounds.size.width) {
            WidthSumTemp = 0;
            rowIndex++;
        }
        tagBtn.frame = CGRectMake(WidthSumTemp, rowIndex*(margin+25), fontWidth, 25);
        tagBtn.tagStr = tagStr;
        [self.tagBgView addSubview:tagBtn];
        WidthSumTemp += margin;
        WidthSumTemp += fontWidth;
    }
    self.tagBgView.height = (margin + 25)*(rowIndex+1);
    self.addTagBtn.top = self.tagBgView.bottom;
    self.tpBgView.contentSize = CGSizeMake(SCREEN_WIDTH, self.addTagBtn.bottom+15);
}

#pragma mark - 瘦哪里点击事件
-(void)whereClick:(UIButton*)btn{
    if (btn.tag == 1) {//瘦哪里
        BOOL isselect = btn.selected;
        for (UIButton *chirdV in self.tpBgView.subviews) {
            if (chirdV.tag == 1) {
                chirdV.selected = NO;
            }
        }
        btn.selected = !isselect;
        self.Wheretag = btn.selected ? btn.titleLabel.text : @"";
    }
}
-(void)name{
    [self.nameTextField becomeFirstResponder];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    self.navigationController.delegate = nil;

    [MobClick endLogPageView:@"创建欢乐减脂团页面"];
    [self.tpBgView endEditing:YES];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    self.navigationController.delegate = self;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [MobClick beginLogPageView:@"创建欢乐减脂团页面"];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

#pragma mark - 请求标签
-(void)loadWhereTag{
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:2];
    
    //发送请求即将开团
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_CREATE_TAGS];
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:urlString parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (![dic isKindOfClass:[NSDictionary class]] || dic==nil) {
            
        }else{
            [weakSelf.whereData removeAllObjects];
            [weakSelf.whereData addObjectsFromArray:dic[@"wherelist"]];
            [weakSelf.hotTags removeAllObjects];
            [weakSelf.hotTags addObjectsFromArray:dic[@"taglist"]];
//            [NSUSER_Defaults setValue:dic forKey:ZDS_CREATE_TAGS];
            if (!weakSelf.nameTextField) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf setUpGUI];
                });
            }
        }
    }];
}

#pragma mark - 下一步
-(void)Next{
    if (self.nameTextField.text.length<1) {
        [self showAlertMsg:@"请输入团组名称" yOffset:-40];
    }else if(self.Photohash.length<1){
        [self showAlertMsg:@"请选择封面" yOffset:-40];
    }else if(self.content.text.length<1){
        [self showAlertMsg:@"请输入减脂方法" yOffset:-40];
        
    } else if(![WWTolls isNameValidate:self.nameTextField.text]){
        [self showAlertMsg:@"团组名称中必须包含汉字、字母或者数字，请修改您的昵称" yOffset:-40];
    }else if([WWTolls isHasSensitiveWord:self.nameTextField.text]){
        [self showAlertMsg:@"注意哦！团组名称中含有敏感词！" yOffset:-40];
    }else if([WWTolls isHasSensitiveWord:self.content.text]){
        [self showAlertMsg:@"注意哦！减脂方法中含有敏感词！" yOffset:-40];
    }else{
        if(self.tagArray.count > 0){
            for (NSString *tag in self.tagArray) {
                if ([WWTolls isHasSensitiveWord:tag]) {
                    [self showAlertMsg:@"注意哦！标签中含有敏感词！" yOffset:-40];
                    return;
                }
            }
        }
//        if(!self.isPassWordGrouper){
//            self.isPassWordGrouper = NO;
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:10];
            if(self.Photokey.length>0){
                [dictionary setObject:[NSString stringWithFormat:@"%@?%@?%.0f?%.0f?%lld",self.Photokey,self.Photohash,self.PhotoSize.width,self.PhotoSize.height,self.PhotoBig] forKey:@"imageurl"];
            }else{
                [dictionary setObject:ZDS_DEFAULTIMAGEURL forKey:@"imageurl"];
            }
            [dictionary setObject:self.nameTextField.text forKey:@"gamename"];//宣言
//            NSString *tags = @"";
//            for (NSString *tag in self.tagArray) {
//                tags = [tags stringByAppendingString:tag];
//                tags = [tags stringByAppendingString:@","];
//            }
//            if (self.tagArray.count > 0) {
//                tags = [tags substringToIndex:tags.length-1];
//            }
            //创建团设置标签
//            [dictionary setObject:tags forKey:@"taglist"];//标签
            [dictionary setObject:self.content.text forKey:@"gmslogan"];
            [dictionary setObject:self.tagArray forKey:@"tagArray"];
            [dictionary setObject:self.hotTags forKey:@"hotTags"];
            [dictionary setObject:[NSNumber numberWithBool:_isPassWordGrouper] forKey:@"passwordBool"];
            if(_WhereSelected) [dictionary setObject:_WhereSelected forKey:@"whereselected"];
            //想瘦哪里 标签
//            if(self.Wheretag.length>0)
//                [dictionary setObject:[NSString stringWithFormat:@"%@,",self.Wheretag] forKey:@"gametags"];
#pragma mark -创建减脂团下一步
            CreatGroupSubViewTwoController *grouoTwoVC = [CreatGroupSubViewTwoController new];
            grouoTwoVC.tempDic = dictionary;
            [self.navigationController pushViewController:grouoTwoVC animated:YES];
            
//            CreateGroupSetPasswordViewController *setPwd = [[CreateGroupSetPasswordViewController alloc] init];
//            setPwd.tempDic = dictionary;
//            [self.navigationController pushViewController:setPwd animated:YES];
//        }else{
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认创建吗?" message:@"是否确认创建？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
//            [alert show];
//        }
    }
}
#pragma mark - 热门标签点击事件
-(void)clickHotTagBtn:(ZdsTagButton*)btn{
    if (!btn.selected && self.tagWriteView.tags.count >= 10) {
        [MBProgressHUD showError:@"只能选择十个标签"];
        return;
    }
    if (btn.selected) {
        [self.tagWriteView removeTag:btn.tagStr animated:NO];
    }else {
        [self.tagWriteView addTagToLast:btn.tagStr animated:NO];
    }
}



#pragma mark - HKKTagWriteViewDelegate

- (void)reloadHotTags{
    for (ZdsTagButton *btn in self.hotTagView.subviews) {
        btn.selected = NO;
        for (NSString *tag in self.tagWriteView.tags) {
            if ([btn.tagStr isEqualToString:tag]) {
                btn.selected = YES;
                break;
            }
        }
    }
}

- (void)tagWriteView:(HKKTagWriteView *)view didMakeTag:(NSString *)tag{
    //    for (ZdsTagButton *btn in self.hotTagView.subviews) {
    //        if ([btn.tagStr isEqualToString:tag]) {
    //            btn.selected = NO;
    ////            [self clickHotTagBtn:btn];
    //            break;
    //        }
    //    }
    [self reloadHotTags];
}
- (void)tagWriteView:(HKKTagWriteView *)view didRemoveTag:(NSString *)tag{
    //    for (ZdsTagButton *btn in self.hotTagView.subviews) {
    //        if ([btn.tagStr isEqualToString:tag]) {
    //            btn.selected = NO;
    ////            [self clickHotTagBtn:btn];
    //            break;
    //        }
    //    }
    [self reloadHotTags];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        self.rightButton.userInteractionEnabled = NO;
        [self showWaitView];
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:10];
        if(self.Photokey.length>0){
            [dictionary setObject:[NSString stringWithFormat:@"%@?%@?%.0f?%.0f?%lld",self.Photokey,self.Photohash,self.PhotoSize.width,self.PhotoSize.height,self.PhotoBig] forKey:@"imageurl"];
        }else{
            [dictionary setObject:ZDS_DEFAULTIMAGEURL forKey:@"imageurl"];
        }
        [dictionary setObject:self.nameTextField.text forKey:@"gamename"];//宣言
        NSString *tags = @"";
        for (NSString *tag in self.tagArray) {
            tags = [tags stringByAppendingString:tag];
            tags = [tags stringByAppendingString:@","];
        }
        if (self.tagArray.count > 0) {
            tags = [tags substringToIndex:tags.length-1];
        }
        [dictionary setObject:tags forKey:@"taglist"];//标签
        [dictionary setObject:[NSString stringWithFormat:@"%@",self.content.text] forKey:@"loseway"];
        if(self.Wheretag.length>0)
            [dictionary setObject:[NSString stringWithFormat:@"%@,",self.Wheretag] forKey:@"gametags"];
        __weak typeof(self)weakSelf = self;
        [WWRequestOperationEngine operationManagerRequest_Post:ZDS_CREATEPTDO parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
            [self removeWaitView];
                if ([dic[@"createflg"] isEqualToString:@"0"]) {
                    [weakSelf showAlertMsg:@"创建成功" andFrame:CGRectMake(70,100,200,60)];
                    [NSUSER_Defaults setValue:@"YES" forKey:@"tuanzubianhua"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"createGroupSucess" object:nil];
                    NSLog(@"*********%@", [dic objectForKey:@"errinfo"]);
                    NSString *gameid = [dic objectForKey:@"gameid"];
                    GroupViewController *detail = [[GroupViewController alloc]init];
                    detail.clickevent = 0;
                    detail.joinClickevent = @"0";
                    detail.groupId = gameid;//20150206020000000078
                    detail.gameDetailStatus = @"10086";
                    [weakSelf.navigationController pushViewController:detail animated:YES];
                    weakSelf.rightButton.userInteractionEnabled = NO;
                }else{
                    weakSelf.rightButton.userInteractionEnabled = YES;
                }
            
        }];
    }
}

#pragma mark - UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if(textView == self.content){
        if (textView.text.length==0&&text.length==0) {
            self.textPlacehoader.hidden = NO;
        }else{
            self.textPlacehoader.hidden = YES;    }
        if (textView.text.length==1&&text.length==0) {
            self.textPlacehoader.hidden = NO;    }
        if (text.length + textView.text.length - range.length >= 31) {
            NSString *newText = [textView.text stringByReplacingCharactersInRange:range withString:text];
            textView.text = [newText substringToIndex:30];
            return NO;
        }
        return YES;
    }else{
        if (textView.text.length==0&&text.length==0) {
            self.usertextPlacehoader.hidden = NO;
        }else{
            self.usertextPlacehoader.hidden = YES;    }
        if (textView.text.length==1&&text.length==0) {
            self.usertextPlacehoader.hidden = NO;    }
        if (text.length + textView.text.length - range.length >= 301) {
            NSString *newText = [textView.text stringByReplacingCharactersInRange:range withString:text];
            textView.text = [newText substringToIndex:300];
            return NO;
        }
        return YES;
    }
}

-(void)textViewDidChange:(UITextView *)textView{
    if(textView == self.content){
        if(textView.text.length>0){
            self.textPlacehoader.hidden = YES;
        }
        self.content = textView;
    }else{
        if(textView.text.length>0){
            self.usertextPlacehoader.hidden = YES;
        }
    }
    [self reloadNum];

}
- (void)reloadNum{
    self.textPlacehoader.hidden = _content.text.length > 0;
    self.contentNumLbl.text = [NSString stringWithFormat:@"%lu/30",(unsigned long)_content.text.length];
    self.submitBtn.selected = _content.text.length >= 1;

}
#pragma mark - 返回
-(void)popButton{
    [WWTolls zdsClick:TJ_CREATEGROUP_QX];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 相机功能
-(void)photoFileSelector{
    [self.view endEditing:YES];
//    photoActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开相机",@"从手机相册获取", nil];
//    photoActionSheet.tag = 999;
//    [photoActionSheet showInView:self.view];
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
        MLImageCrop *imageCrop = [[MLImageCrop alloc]init];
        imageCrop.delegate = self;
        imageCrop.ratioOfWidthAndHeight = 600.0f/600.0f;
        imageCrop.image =image;
        [imageCrop showWithAnimation:NO];
    };

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //弹出的菜单按钮点击后的响应
    if (buttonIndex == photoActionSheet.cancelButtonIndex)
    {
    }
    switch (buttonIndex)
    {
        case 0:  //打开照相机拍照
            
            [self takePhoto:YES];
            break;
            
        case 1:  //打开本地相册
            
            [self LocalPhoto:YES];
            break;
    }
}

//调用相机
-(void)takePhoto:(BOOL)Editing
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
        
    {
        //设置拍照后的图片可被编辑
        _picker.allowsEditing = NO;
        _picker.sourceType = sourceType;
        [self presentViewController:_picker animated:YES completion:nil];
    }else{
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
    
}

//调用相册
-(void)LocalPhoto:(BOOL)Editing
{
    
    _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    //    _picker.delegate = self;
    
    //设置选择后的图片可被编辑
    
    _picker.allowsEditing = NO;
    
    [self presentViewController:_picker animated:YES completion:nil];
    
}

//获取图片后的行为
#pragma mark - crop delegate
- (void)cropImage:(UIImage*)cropImage forOriginalImage:(UIImage*)originalImage
{
    [self showWaitView];
    UIImage *image = cropImage;
    if (image.size.width>image.size.height) {
        UIGraphicsBeginImageContext(CGSizeMake(image.size.width, image.size.width));
        
        // Draw image1
        [image drawInRect:CGRectMake(0, (image.size.width-image.size.height)/2, image.size.width, image.size.height)];
        
        UIImage *newimage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        image = nil;
        image = newimage;
    }else if(image.size.width<image.size.height){
        UIGraphicsBeginImageContext(CGSizeMake(image.size.height, image.size.height));
        
        // Draw image1
        [image drawInRect:CGRectMake((image.size.height-image.size.width)/2, 0, image.size.width, image.size.height)];
        
        UIImage *newimage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        image = nil;
        image = newimage;
    }
//    float f = 0.5;
//    NSData *data = UIImageJPEGRepresentation(image,1);
//    if(data.length>1024*1024*10){
//        [self removeWaitView];
//        [self showAlertMsg:@"您选择的图片太大,请重新上传" andFrame:CGRectZero];
//    }else if (data.length>1024*1024*2) {
//        data = UIImageJPEGRepresentation(image,0.3);
//    }else{
//        while (data.length>300*1024) {
//            data=nil;
//            data = UIImageJPEGRepresentation(image,f);
//            f*=0.8;
//        }
//    }
    
    __weak typeof(self) weakSelf = self;
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
                              [weakSelf removeWaitView];
                              if (info.isOK) {
                                  
                                  if(resp){
                                      weakSelf.Photohash = resp[@"hash"];
                                      weakSelf.Photokey = resp[@"key"];
                                      weakSelf.PhotoSize = image.size;
                                      weakSelf.PhotoBig = data.length;
                
                                      //直接把该图片读出来显示在按钮上
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [weakSelf.imageButton setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
                                      });
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
}

//获取图片后的行为
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        UIImage* editeImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        UIImage* originalImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        UIImage *image;//原图
        
        if (editeImage!=nil) {
            image = editeImage;
        }else{
            image = originalImage;
        }
        [picker dismissViewControllerAnimated:YES completion:^{
            MLImageCrop *imageCrop = [[MLImageCrop alloc]init];
            imageCrop.delegate = self;
            imageCrop.ratioOfWidthAndHeight = 600.0f/600.0f;
            imageCrop.image =image;
            [imageCrop showWithAnimation:NO];
            
        }];
        
    }
}


- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    return percentTransition;
}

- (IBAction)clickToPop:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)edgePan:(UIPanGestureRecognizer *)recognizer{
    CGFloat per = [recognizer translationInView:self.view].x / (self.view.bounds.size.width);
    per = MIN(1.0,(MAX(0.0, per)));
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        percentTransition = [[UIPercentDrivenInteractiveTransition alloc]init];
        [self.navigationController popViewControllerAnimated:YES];
    }else if (recognizer.state == UIGestureRecognizerStateChanged){
        [percentTransition updateInteractiveTransition:per];
    }else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled){
        if (per > 0.3) {
            [percentTransition finishInteractiveTransition];
        }else{
            [percentTransition cancelInteractiveTransition];
        }
        percentTransition = nil;
    }
}


- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPop) {
        PingInvertTransition *pingInvert = [PingInvertTransition new];
        return pingInvert;
    }else{
        return nil;
    }
}

- (IBAction)popClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
