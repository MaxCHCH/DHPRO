//
//  CreatGroupSubViewTwoController.m
//  zhidoushi
//
//  Created by glaivelee on 15/10/30.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import "CreatGroupSubViewTwoController.h"
#import "CreatGroupSubViewThreeController.h"
#import "CreatQuanViewController.h"
#import "IQKeyboardManager.h"
@interface CreatGroupSubViewTwoController ()
{
    //选择的目标 标签；热词;选中标记
    NSMutableArray *tagArray,*hotTags;
    UIButton *addButton;


}
@end

@implementation CreatGroupSubViewTwoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    tagArray = [NSMutableArray array];
    hotTags = [NSMutableArray array];
    tagArray = _tempDic[@"tagArray"];
    hotTags =  _tempDic[@"hotTags"];
    
    UIView *titleViews = [[UIView alloc] init];
    [titleViews addSubview:self.leftButton];
    [titleViews addSubview:self.rightButton];
    self.navigationItem.titleView = titleViews;
    //导航栏返回
    self.leftButton.frame = CGRectMake(0, 0, 12.5, 12.5);
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"fh-36.png"] forState:UIControlStateNormal];
    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width = 18;
    labelRect.size.height = 18;
    self.leftButton.frame = labelRect;
    
    [self.rightButton setTitle:@"下一步" forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(nextPageController) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton setTitleColor:[WWTolls colorWithHexString:@"#fe5303"] forState:UIControlStateNormal];
    self.rightButton.frame = CGRectMake(0, 0, 45, 15);
    self.rightButton.titleLabel.font = MyFont(15);
    //导航栏标题
    UILabel *title = [[UILabel alloc] init];
    title.text = @"编辑标签";
    title.textColor = [WWTolls colorWithHexString:@"#4a5767"];
    title.font = MyFont(17);
    title.textAlignment = NSTextAlignmentCenter;
    title.frame = CGRectMake(self.view.frame.size.width/2-30, 0, 80, 50);

    title.center = titleViews.center;
    [titleViews addSubview:title];
    
    
    addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(self.view.frame.size.width-80, self.view.frame.size.height - 44 - 30 - 50 - 20, 50, 50);
    [addButton setBackgroundImage:[UIImage imageNamed:@"jh-100"] forState:(UIControlStateNormal)];
    [addButton addTarget:self action:@selector(addTagMethod:) forControlEvents:(UIControlEventTouchUpInside)];
    addButton.layer.cornerRadius = 25;
    [self.view addSubview:addButton];
    
    [self setupUI];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"编辑标签"];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"编辑标签"];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}
-(void)popButton{
    [self.navigationController popViewControllerAnimated:YES];
    addButton.hidden = YES;
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _pageControl.currentPage = (scrollView.contentOffset.x+scrollView.width/2)/scrollView.width;
}
-(void)addTagMethod:(UIButton *)sender{
    _tagWriteView.hidden=NO;
    [_tagWriteView setFocusOnAddTag:YES];
    UIImageView *imageViewS = (UIImageView *)[self.view viewWithTag:78787];
    imageViewS.hidden = NO;
    sender.hidden = YES;
    
    UILabel *lineLabel = (UILabel *)[self.view viewWithTag:78788];
    lineLabel.hidden = NO;
    
    UILabel *titleTagLabel = (UILabel *)[self.view viewWithTag:78789];
    titleTagLabel.hidden = NO;
}
-(void)setupUI{
    UIView *createBg = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.origin.y+9, SCREEN_WIDTH, 285)];
    //    createBg.alpha = 0.8;
    createBg.tag = 6666;
    createBg.backgroundColor = [UIColor whiteColor];
    createBg.layer.cornerRadius = 5;
    [self.view addSubview:createBg];
    
    
    //底部分割线  YES : VIP
    UILabel *labelBottomline = [UILabel new];
    labelBottomline.backgroundColor = [WWTolls colorWithHexString:@"#ffffff" AndAlpha:0.3];
    labelBottomline.frame = CGRectMake(0 ,self.view.bottom-68 ,SCREEN_WIDTH , 4);
    [self.view addSubview:labelBottomline];
    
    UILabel *labelBottomGrayline = [UILabel new];
    labelBottomGrayline.backgroundColor = OrangeColor;
    if (_tempDic[@"isPassWordGrouper"]) {
        labelBottomGrayline.frame = CGRectMake(0 ,self.view.bottom-68 ,SCREEN_WIDTH*2/4 , 4);
    }
    else{
        labelBottomGrayline.frame = CGRectMake(0 ,self.view.bottom-68 ,SCREEN_WIDTH*2/3 , 4);

    }
    [self.view addSubview:labelBottomGrayline];
 
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
    //热门标签视图
//    UIScrollView *hotTagView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height-35, SCREEN_WIDTH, 91)];
//    self.hotTagView = hotTagView;
//    hotTagView.pagingEnabled = YES;
//    hotTagView.bounces = NO;
//    hotTagView.showsVerticalScrollIndicator = NO;
//    hotTagView.showsHorizontalScrollIndicator = NO;
//    [createBg addSubview:hotTagView];
//    int pageIndex = 0;
//    int rowIndex = 0;
//    int WidthSumTemp = 7;//x
//    CGFloat margin = 8;
//        
//    for (int i = 0; i<hotTags.count; i++) {
//        WidthSumTemp += margin;
//        
//        NSString *tagStr = hotTags[i];
//        ZdsTagButton *tagBtn = [[ZdsTagButton alloc] init];
//        CGFloat fontWidth = [WWTolls WidthForString:tagStr fontSize:11] + 16;
//        [tagBtn addTarget:self action:@selector(clickHotTagBtn:) forControlEvents:UIControlEventTouchUpInside];
//        if (WidthSumTemp + fontWidth + margin > hotTagView.bounds.size.width - 30) {
//            WidthSumTemp = 15;
//            rowIndex++;
//            if (rowIndex>2) {
//                rowIndex = 0;
//                pageIndex ++;
//            }
//        }
//        tagBtn.frame = CGRectMake(15 + WidthSumTemp + pageIndex*hotTagView.bounds.size.width, rowIndex*(margin+25), fontWidth, 25);
//        tagBtn.tagStr = tagStr;
//        [hotTagView addSubview:tagBtn];
//        WidthSumTemp += fontWidth;
//    }
    //间隔线
    UILabel *lineLabel = [UILabel new];
    lineLabel.frame= CGRectMake(0, _hotTagView.frame.size.height+_hotTagView.frame.origin.y+25, self.view.frame.size.width, 15);
    lineLabel.tag = 78788;
    lineLabel.hidden = YES;
    [lineLabel setBackgroundColor:[WWTolls colorWithHexString:@"#f7f1f1"]];
    [self.view addSubview:lineLabel];
        
    UILabel *titleTagLabel = [UILabel new];
    titleTagLabel.frame= CGRectMake(8, lineLabel.frame.size.height+lineLabel.frame.origin.y+18, 103, 20);
    titleTagLabel.font = MyFont(14);
    titleTagLabel.tag = 78789;
    titleTagLabel.hidden = YES;
    [titleTagLabel setTextColor:[WWTolls colorWithHexString:@"#485565"]];
    titleTagLabel.text = @"添加更多标签";
    [self.view addSubview:titleTagLabel];
    //用户输入标签
    hotTagView.contentSize = CGSizeMake(self.view.frame.size.width*pageIndex+self.view.frame.size.width,hotTagView.frame.size.height);//hotTagView.frame.size.height
    hotTagView.delegate = self;
#define color(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
    _pageControl.pageIndicatorTintColor = [WWTolls colorWithHexString:@"#d6d6d6"];//白色半透明
    _pageControl.currentPageIndicatorTintColor = color(45, 45, 45, 0.8);//灰色半透明
    _pageControl.currentPageIndicatorTintColor = [WWTolls colorWithHexString:@"#999999"];
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = pageIndex+1;
    if(pageIndex > 0)
        [createBg addSubview:_pageControl];
//    hotTagView.scrollEnabled = NO;
    //页
//    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, hotTagView.bottom+8, self.view.frame.size.width, 3)];
//    _pageControl.userInteractionEnabled = NO;
//    _pageControl.hidesForSinglePage = YES;
//    
//#define color(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
//    _pageControl.pageIndicatorTintColor = [WWTolls colorWithHexString:@"#d6d6d6"];//白色半透明
//    _pageControl.currentPageIndicatorTintColor = color(45, 45, 45, 0.8);//灰色半透明
//    _pageControl.currentPageIndicatorTintColor = [WWTolls colorWithHexString:@"#999999"];
//    _pageControl.currentPage = 0;
//    _pageControl.numberOfPages = pageIndex+1;
//    if(pageIndex > 0)
//        [createBg addSubview:_pageControl];
//    [self reloadHotTags];
    //
    //    //标签输入框
    _tagWriteView = [[HKKTagWriteView alloc] initWithFrame:CGRectMake(30,titleTagLabel.bottom, SCREEN_WIDTH - 60, 100)];
//    [self.view addSubview:_tagWriteView];
//    _tagWriteView.delegate = self;
    [_tagWriteView setBackgroundColor:[UIColor whiteColor]];
//    if(tagArray && tagArray.count > 0) [_tagWriteView addTags:tagArray];
//    [self reloadHotTags];
    
//    _tagWriteView = [[HKKTagWriteView alloc] initWithFrame:CGRectMake(7, titleTagLabel.frame.size.height+titleTagLabel.frame.origin.y, SCREEN_WIDTH - 15, 100)];
//    UIImageView *writeBg = [[UIImageView alloc] init];//WithImage:[UIImage imageNamed:@"tagEditorBg-610-197"]];
//    writeBg.backgroundColor = [UIColor whiteColor];//[WWTolls colorWithHexString:@"#f8f8f8"];
////    writeBg.layer.cornerRadius = 4;
////    writeBg.clipsToBounds = YES;
//    writeBg.tag = 78787;
//    writeBg.hidden = YES;
//    CGRect rect = _tagWriteView.frame;
//    rect.size.height += 2;
//    rect.origin.y -= 1;
//    _tagWriteView.maxTagLength = 5;
//    writeBg.frame = rect;
//    [createBg addSubview:writeBg];
    [self.view addSubview:_tagWriteView];
    _tagWriteView.delegate = self;
    _tagWriteView.hidden = YES;
//    [_tagWriteView setBackgroundColor:[UIColor whiteColor]];
//    if(tagArray && tagArray.count > 0) [_tagWriteView addTags:tagArray];
//    [self reloadHotTags];
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
        btn.layer.borderColor = [WWTolls colorWithHexString:@"#95aeb3"].CGColor;
        for (NSString *tag in self.tagWriteView.tags) {
            if ([btn.tagStr isEqualToString:tag]) {
                btn.selected = YES;
                [titleArray addObject:tag];
                
                break;
            }
        }
    }
//    for (ZdsTagButton *btn in self.hotTagView.subviews) {
//        btn.selected = NO;
//        [btn setTitleColor:[WWTolls colorWithHexString:@"#95aeb3"] forState:(UIControlStateNormal)];
//        [btn setBackgroundImage:[WWTolls imageWithColor:[WWTolls colorWithHexString:@"#95aeb3"] size:self.view.bounds.size] forState:UIControlStateSelected];
//        btn.layer.borderColor = [WWTolls colorWithHexString:@"#95aeb3"].CGColor;
//        for (NSString *tag in self.tagWriteView.tags) {
//            if ([btn.tagStr isEqualToString:tag]) {
//                btn.selected = YES;
//                [titleArray addObject:tag];
//                [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
//                [btn setBackgroundImage:[WWTolls imageWithColor:[WWTolls colorWithHexString:@"#fe5303"] size:self.view.bounds.size] forState:UIControlStateSelected];
//                btn.layer.borderColor = [WWTolls colorWithHexString:@"#fe5303"].CGColor;
//
//                break;
//            }
//        }
//    }
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
#pragma mark --下一步 圈子
-(void)nextPageController{
    NSString *selectTags = @"";;
    for (ZdsTagButton *btn in self.hotTagView.subviews) {
        if(btn.selected){
            selectTags = [selectTags stringByAppendingString:btn.tagStr];
            selectTags = [selectTags stringByAppendingString:@","];
        }
    }
    [_tempDic setObject:selectTags forKey:@"gametags"];
    
    CreatQuanViewController *uc = [CreatQuanViewController new];
//    CreatGroupSubViewThreeController *uc = [CreatGroupSubViewThreeController new];
    uc.tempDic = _tempDic;
    [self.navigationController pushViewController:uc animated:YES];
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
