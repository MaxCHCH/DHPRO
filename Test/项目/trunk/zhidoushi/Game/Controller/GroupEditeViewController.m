//
//  GroupEditeViewController.m
//  zhidoushi
//
//  Created by glaivelee on 15/11/17.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//
/**
 *  本地保存数据
 *  CreateGroupTwoNewViewController.m
 *  [NSUSER_Defaults setObject:dictionary forKey:@"ZXLTEMPDIC"];
 *
 */
#import "TPKeyboardAvoidingScrollView.h"
#import "GroupEditeViewController.h"
#import "HKKTagWriteView.h"
#import "ZdsTagButton.h"
#import "EditorTagAlertView.h"
#import "IQKeyboardManager.h"
#import "UITextView+LimitLength.h"

@interface GroupEditeViewController ()<HKKTagWriteViewDelegate,EditorTagDelegate,UIScrollViewDelegate,UITextViewDelegate>{
    NSMutableArray *tagArray,*hotTags,*whereData;

}
@property(nonatomic, strong) TPKeyboardAvoidingScrollView *tpBgView;
@property(nonatomic, strong) UIView *tagBgView;//标签背景视图
@property (strong, nonatomic)NSMutableDictionary *tempDic;
@property(nonatomic,strong)UIScrollView *hotTagView;//热门标签视图
@property(nonatomic,strong)UIPageControl *pageControl;//页数控制
@property(nonatomic,strong)HKKTagWriteView *tagWriteView;
@property(nonatomic, strong) UILabel *textPlacehoader;//占位
@property(nonatomic, strong) UITextView *content;//文本框
@property(nonatomic, strong) UILabel *contentNumLbl;//字数提示
@property(nonatomic, strong) UIButton *submitBtn;//提交按钮
@property(nonatomic, strong) UITextField *nameTextField;//名字输入框
@property(nonatomic, strong) UIButton *addTagBtn;//添加标签按钮


@end

@implementation GroupEditeViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    //友盟打点
    [MobClick beginLogPageView:@"编辑团组页面"];
    //导航栏添加
//    UIView *titleViews = [[UIView alloc] init];
//    [titleViews addSubview:self.leftButton];
//    [titleViews addSubview:self.rightButton];
//    self.navigationItem.titleView = titleViews;
//    团组宣言
//    UILabel *title = [[UILabel alloc] init];
    self.titleLabel.text = @"编辑团组";
    self.titleLabel.font = MyFont(17);
    self.titleLabel.textColor = ZDS_DHL_TITLE_COLOR;
//    title.textColor = OrangeColor;
//    title.font = MyFont(17);
//    title.textAlignment = NSTextAlignmentCenter;
//    title.frame = CGRectMake(self.view.frame.size.width/2-30, 0, 80, 50);
//    title.center = titleViews.center;
//    [titleViews addSubview:title];
    
    //导航栏返回
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"fh-36"] forState:UIControlStateNormal];
    //    [self.leftButton setTitle:@"取消" forState:UIControlStateNormal];
    //    [self.leftButton setTitleColor:[WWTolls colorWithHexString:@"#959595"] forState:UIControlStateNormal];
    //    self.leftButton.titleLabel.font = MyFont(16);
    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width = 18;
    labelRect.size.height = 18;
    self.leftButton.frame = labelRect;
    //导航栏发布
    [self.rightButton setTitle:@"完成" forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = MyFont(16);
    [self.rightButton setTitleColor:OrangeColor forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
    [self.rightButton addTarget:self action:@selector(editor) forControlEvents:UIControlEventTouchUpInside];
    self.rightButton.width = 40;
    self.rightButton.height = 16;

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"编辑团组页面"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    whereData = [NSMutableArray array];
    tagArray = [NSMutableArray arrayWithArray:[self.groupTags componentsSeparatedByString:@","]];
    hotTags = [NSMutableArray arrayWithArray:self.grouphottags];
    
//    _tempDic = [NSUSER_Defaults objectForKey:@"ZXLTEMPDIC"];
//    tagArray = _tempDic[@"tagArray"];
//    hotTags =  _tempDic[@"hotTags"];
//
//    
    [self setUpUI];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)setUpUI{
    UILabel *topLine = [UILabel new];
    topLine.frame = CGRectMake(0, 0, SCREEN_WIDTH, 48);
    topLine.backgroundColor = [UIColor colorWithRed:0.965 green:0.937 blue:0.937 alpha:1.000];
    topLine.text = @"     团组标签";
    topLine.textColor = [WWTolls colorWithHexString:@"#FFFF723E"];
    topLine.font = MyFont(17);
    [self.view addSubview:topLine];
    
    UIView *createBg = [[UIView alloc] initWithFrame:CGRectMake(0, topLine.bottom, SCREEN_WIDTH, 135)];
    createBg.tag = 6666;
    [self.view addSubview:createBg];
    //
    //热门标签视图
    UIScrollView *hotTagView = [[UIScrollView alloc] initWithFrame:CGRectMake(30,15, SCREEN_WIDTH - 60, 105)];
    self.hotTagView = hotTagView;
    hotTagView.pagingEnabled = YES;
    hotTagView.bounces = NO;
    hotTagView.delegate = self;
    hotTagView.showsVerticalScrollIndicator = NO;
    hotTagView.showsHorizontalScrollIndicator = NO;
    hotTagView.scrollEnabled = YES;
//    hotTagView
    [createBg addSubview:hotTagView];
    int pageIndex = 0;
    int rowIndex = 0;
    int WidthSumTemp = 0;//x
    CGFloat margin = 7;
    
    for (int i = 0; i<hotTags.count; i++) {
        NSString *tagStr = hotTags[i];
        ZdsTagButton *tagBtn = [[ZdsTagButton alloc] init];
        CGFloat fontWidth = [WWTolls WidthForString:tagStr fontSize:13] + 30;
        [tagBtn addTarget:self action:@selector(clickHotTagBtn:) forControlEvents:UIControlEventTouchUpInside];
        if (WidthSumTemp + fontWidth + margin > hotTagView.bounds.size.width) {
            WidthSumTemp = 0;
            rowIndex++;
            if (rowIndex>2) {
                rowIndex = 0;
                pageIndex ++;
            }
        }
        tagBtn.frame = CGRectMake(WidthSumTemp + pageIndex*hotTagView.bounds.size.width, rowIndex*(margin+30), fontWidth, 30);
        tagBtn.tagStr = tagStr;
        [hotTagView addSubview:tagBtn];
        WidthSumTemp += fontWidth;
        WidthSumTemp += margin;
    }
    hotTagView.contentSize = CGSizeMake((pageIndex+1)*hotTagView.width, 105);
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, hotTagView.bottom+8, self.view.frame.size.width, 3)];
    _pageControl.userInteractionEnabled = NO;
    _pageControl.hidesForSinglePage = YES;
    
#define color(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
    _pageControl.pageIndicatorTintColor = [WWTolls colorWithHexString:@"#d6d6d6"];//白色半透明
    _pageControl.currentPageIndicatorTintColor = color(45, 45, 45, 0.8);//灰色半透明
    _pageControl.currentPageIndicatorTintColor = [WWTolls colorWithHexString:@"#999999"];
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = pageIndex+1;
    if(pageIndex > 0)
        [createBg addSubview:_pageControl];
//    [self reloadHotTags];
    
    
    topLine = [UILabel new];
    topLine.frame = CGRectMake(0, createBg.bottom, SCREEN_WIDTH, 48);
    topLine.backgroundColor = [UIColor colorWithRed:0.965 green:0.937 blue:0.937 alpha:1.000];
    topLine.text = @"     添加更多标签";
    topLine.font = MyFont(17);
    topLine.textColor = [WWTolls colorWithHexString:@"#FFFF723E"];
    [self.view addSubview:topLine];
    
    //        //标签输入框
    _tagWriteView = [[HKKTagWriteView alloc] initWithFrame:CGRectMake(30,topLine.bottom, SCREEN_WIDTH - 60, 100)];
    [self.view addSubview:_tagWriteView];
    _tagWriteView.delegate = self;
    [_tagWriteView setBackgroundColor:[UIColor whiteColor]];
    if(tagArray && tagArray.count > 0) [_tagWriteView addTags:tagArray];
    [self reloadHotTags];
    
    topLine = [UILabel new];
    topLine.frame = CGRectMake(0, 330, SCREEN_WIDTH, 48);
    topLine.backgroundColor = [UIColor colorWithRed:0.965 green:0.937 blue:0.937 alpha:1.000];
    topLine.text = @"     减肥宣言";
    topLine.font = MyFont(17);
    topLine.textColor = [WWTolls colorWithHexString:@"#FFFF723E"];
    [self.view addSubview:topLine];
    
    //减肥方式
    UITextView *text = [[UITextView alloc] init];
    self.content = text;
    [text setValue:@30 forKey:@"limit"];
    text.frame = CGRectMake(23, topLine.bottom, self.view.frame.size.width-46, 60);
    text.delegate = self;
    text.scrollEnabled = NO;
    text.font = MyFont(14);
    text.text = self.groupXuanyan;
    text.backgroundColor = [UIColor clearColor];
    text.textColor = ContentColor;
    text.contentInset = UIEdgeInsetsMake(5, 0, -5, 5);
    [self.view addSubview:text];

    //

    
    
    UILabel *textlbl = [[UILabel alloc] init];
    textlbl.frame = CGRectMake(30, topLine.bottom+15, self.view.frame.size.width, 20);
    textlbl.numberOfLines = 0;
    self.textPlacehoader = textlbl;
    textlbl.text = @"点此输入您的减肥宣言，不超过30字";
    if (text.text.length > 0) {
        textlbl.hidden = YES;
    }
    self.textPlacehoader.textColor = [ContentColor colorWithAlphaComponent:0.6];
    textlbl.font = MyFont(14);
    [self.view addSubview:textlbl];
    
}
- (void)popButton{
    [self.navigationController popViewControllerAnimated:YES];
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
        if (text.length + textView.text.length - range.length >= 101) {
            NSString *newText = [textView.text stringByReplacingCharactersInRange:range withString:text];
            textView.text = [newText substringToIndex:100];
            return NO;
        }
        return YES;
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    if(textView == self.content){
        if(textView.text.length>0){
            self.textPlacehoader.hidden = YES;
        }
        self.content = textView;
    }
    [self reloadNum];
    
}
- (void)reloadNum{
    self.textPlacehoader.hidden = _content.text.length > 0;
    self.contentNumLbl.text = [NSString stringWithFormat:@"(%lu/30)",(unsigned long)_content.text.length];
    self.submitBtn.selected = _content.text.length >= 1;
    
}
-(void)commitEditor:(EditorTagAlertView *)discussAlert{
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    NSArray *hotTags = discussAlert.tagWriteView.tags;
    [tagArray removeAllObjects];
    [tagArray addObjectsFromArray:hotTags];
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
            [whereData removeAllObjects];
            [whereData addObjectsFromArray:dic[@"wherelist"]];
            [hotTags removeAllObjects];
            [hotTags addObjectsFromArray:dic[@"taglist"]];
            //            [NSUSER_Defaults setValue:dic forKey:ZDS_CREATE_TAGS];
            if (!weakSelf.nameTextField) {
                dispatch_async(dispatch_get_main_queue(), ^{

                });
            }
        }
    }];
}

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
    NSMutableArray *titleArray = [NSMutableArray array];
    
    for (ZdsTagButton *btn in self.hotTagView.subviews) {
        if (![btn isKindOfClass:[ZdsTagButton class]]) {
            continue;
        }
        btn.selected = NO;
//        [btn setTitleColor:ContentColor forState:(UIControlStateNormal)];
//        [btn setBackgroundImage:[WWTolls imageWithColor:[WWTolls colorWithHexString:@"#95aeb3"] size:self.view.bounds.size] forState:UIControlStateSelected];
        btn.layer.borderColor = [WWTolls colorWithHexString:@"#95aeb3"].CGColor;
        for (NSString *tag in self.tagWriteView.tags) {
            if ([btn.tagStr isEqualToString:tag]) {
                btn.selected = YES;
                [titleArray addObject:tag];
//                [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
//                [btn setBackgroundImage:[WWTolls imageWithColor:[WWTolls colorWithHexString:@"#fe5303"] size:self.view.bounds.size] forState:UIControlStateSelected];
//                btn.layer.borderColor = [WWTolls colorWithHexString:@"#fe5303"].CGColor;
                
                break;
            }
        }
    }
}
- (void)tagWriteView:(HKKTagWriteView *)view didMakeTag:(NSString *)tag{
 
    [self reloadHotTags];
}
- (void)tagWriteView:(HKKTagWriteView *)view didRemoveTag:(NSString *)tag{

    [self reloadHotTags];
    
}
- (CGFloat) WidthForString:(NSString *)value fontSize:(CGFloat)fontsize
{
    UIFont *fnt = [UIFont fontWithName:@"HelveticaNeue" size:fontsize];
    CGSize size = [value sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
    return size.width;
    
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _pageControl.currentPage = (self.hotTagView.contentOffset.x+self.hotTagView.width/2)/self.hotTagView.width;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 编辑
- (void)editor{
    NSString *content = self.content.text;
    content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    if ([content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
        
        [MBProgressHUD showError:@"减脂宣言不能为空格"];
        
    }
    if([WWTolls isHasSensitiveWord:content]){
        [self showAlertMsg:ZDS_HASSENSITIVE yOffset:-100];
        return;
    }
    NSArray *Tags = self.tagWriteView.tags;
    NSString *tags = @"";
    for (NSString *tag in Tags) {
        tags = [tags stringByAppendingString:tag];
        tags = [tags stringByAppendingString:@","];
    }
    if (Tags.count > 0) {
        tags = [tags substringToIndex:tags.length-1];
    }
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:2];
    [dictionary setObject:self.groupId forKey:@"gameid"];
    [dictionary setObject:tags forKey:@"taglist"];
    [dictionary setObject:content forKey:@"gmslogan"];
    [dictionary setObject:@"3,5" forKey:@"edittype"];
    
    WEAKSELF_SS
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_GROUP_EDITOR parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        [weakSelf removeWaitView];
        if ([dic[@"result"] isEqualToString:@"0"]) {
            [weakSelf showAlertMsg:@"修改成功" andFrame:CGRectMake(70,100,200,60)];
            
            if ([self.delegate respondsToSelector:@selector(editSuccessWithTags:AndContent:)]) {
                [self.delegate editSuccessWithTags:tags AndContent:content];
            }
            [weakSelf popButton];
        }
    }];
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
