//
//  EditorTagAlertView.m
//  zhidoushi
//
//  Created by nick on 15/9/29.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import "EditorTagAlertView.h"
#import "UIView+SSLAlertViewTap.h"
#import "ZdsTagButton.h"

@interface EditorTagAlertView()<HKKTagWriteViewDelegate>
@property(nonatomic,strong)UIScrollView *hotTagView;//热门标签视图
@property(nonatomic,strong)UIPageControl *pageControl;//页数控制
@property(nonatomic,strong)UIButton *submitBtn;//提交按钮
@end

@implementation EditorTagAlertView
#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame delegate:(id <EditorTagDelegate>)delegate {
    if (self = [self initWithFrame:frame]) {
        self.delegate = delegate;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UI

#pragma mark 编辑 并传入标签数组
- (void)createViewWithSelectTags:(NSArray*)selectTags AndHotTags:(NSArray*)hotTags{

    self.backgroundColor = [UIColor clearColor];
    
    [self ssl_addOnlyTap];
    
    [self ssl_addBlackBlur];
    //背景
    UIView *createBg = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 283, SCREEN_WIDTH, 285)];
//    createBg.alpha = 0.8;
    createBg.backgroundColor = [UIColor whiteColor];
    createBg.layer.cornerRadius = 5;
    [self addSubview:createBg];
    
    
    //取消按钮
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(18, 16, 40, 17)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[WWTolls colorWithHexString:@"#959595"] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = MyFont(16.0);
    [createBg addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //提交按钮
    UIButton *submitButton = [[UIButton alloc] initWithFrame:CGRectMake(self.width - 58, 16, 40, 17)];
    self.submitBtn = submitButton;
    submitButton.selected = YES;
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [submitButton setTitleColor:[WWTolls colorWithHexString:@"#959595"] forState:UIControlStateNormal];
    [submitButton setTitleColor:ZDS_DHL_TITLE_COLOR forState:UIControlStateSelected];
    submitButton.titleLabel.font = MyFont(16.0);
    [createBg addSubview:submitButton];
    [submitButton addTarget:self action:@selector(commitEditorButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //分割线
    UIView *line = [[UIView alloc] init];
    line.frame = CGRectMake(0, cancelButton.bottom + 16, self.width, 0.5);
    line.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
    [createBg addSubview:line];
    
    //题目
    UILabel *title = [[UILabel alloc] init];
    title.frame = CGRectMake(0, 16, self.width, 19);
    title.font = MyFont(18);
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [WWTolls colorWithHexString:@"#535353"];
    title.text = @"编辑标签";
    [createBg addSubview:title];
    
    //热门标签视图
    
    UIScrollView *hotTagView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 63, SCREEN_WIDTH, 91)];
    self.hotTagView = hotTagView;
    hotTagView.pagingEnabled = YES;
    hotTagView.bounces = NO;
    hotTagView.showsVerticalScrollIndicator = NO;
    hotTagView.showsHorizontalScrollIndicator = NO;
    [createBg addSubview:hotTagView];
    int pageIndex = 0;
    int rowIndex = 0;
    int WidthSumTemp = 0;
    CGFloat margin = 8;
    for (int i =0; i<hotTags.count; i++) {
        WidthSumTemp += margin;
        NSString *tagStr = hotTags[i];
        ZdsTagButton *tagBtn = [[ZdsTagButton alloc] init];
        CGFloat fontWidth = [WWTolls WidthForString:tagStr fontSize:11] + 16;
        [tagBtn addTarget:self action:@selector(clickHotTagBtn:) forControlEvents:UIControlEventTouchUpInside];
        if (WidthSumTemp + fontWidth + margin > hotTagView.bounds.size.width) {
            WidthSumTemp = margin;
            rowIndex++;
            if (rowIndex>2) {
                rowIndex = 0;
                pageIndex ++;
            }
        }
        tagBtn.frame = CGRectMake(WidthSumTemp + pageIndex*hotTagView.bounds.size.width, rowIndex*(margin+25), fontWidth, 25);
        tagBtn.tagStr = tagStr;
        [hotTagView addSubview:tagBtn];
        WidthSumTemp += fontWidth;
    }
    hotTagView.contentSize = CGSizeMake(self.width*pageIndex+self.width, hotTagView.height);
    
    hotTagView.delegate = self;
    //页
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, hotTagView.bottom+8, self.width, 3)];
    _pageControl.userInteractionEnabled = NO;
    _pageControl.hidesForSinglePage = YES;
#define color(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
    _pageControl.pageIndicatorTintColor = [WWTolls colorWithHexString:@"#d6d6d6"];//白色半透明
    //        _pageControl.currentPageIndicatorTintColor = color(45, 45, 45, 0.8);//灰色半透明
    _pageControl.currentPageIndicatorTintColor = [WWTolls colorWithHexString:@"#999999"];
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = pageIndex+1;
    if(pageIndex > 0) [createBg addSubview:_pageControl];
    
    //标签输入框
    _tagWriteView = [[HKKTagWriteView alloc] initWithFrame:CGRectMake(7, 173, SCREEN_WIDTH - 15, 100)];
    UIImageView *writeBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tagEditorBg-610-197"]];
    writeBg.backgroundColor = [WWTolls colorWithHexString:@"#f8f8f8"];
    writeBg.layer.cornerRadius = 4;
    writeBg.clipsToBounds = YES;
    CGRect rect = _tagWriteView.frame;
    rect.size.height += 2;
    rect.origin.y -= 1;
    _tagWriteView.maxTagLength = 5;
    writeBg.frame = rect;
    [createBg addSubview:writeBg];
    [createBg addSubview:_tagWriteView];
    _tagWriteView.delegate = self;
    [_tagWriteView setBackgroundColor:[UIColor clearColor]];
    if(selectTags && selectTags.count > 0) [_tagWriteView addTags:selectTags];
    [self reloadHotTags];


}

#pragma mark - Event Responses

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

#pragma mark 提交点击事件
-(void)commitEditorButtonClick:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(commitEditor:)]) {
        [self.delegate commitEditor:self];
    }
    [self ssl_hidden];
}
#pragma mark 取消点击事件
- (void)cancelButtonClick:(UIButton *)button {
    [WWTolls zdsClick:self.clickEvent];
    [self ssl_hidden];
}

#pragma mark - 键盘处理
#pragma mark 键盘即将显示
- (void)keyBoardWillShow:(NSNotification *)note{
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = - rect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, ty);
    }];
    
}

#pragma mark 键盘即将退出
- (void)keyBoardWillHide:(NSNotification *)note{
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.transform = CGAffineTransformIdentity;
    }];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _pageControl.currentPage = (scrollView.contentOffset.x+scrollView.width/2)/scrollView.width;
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
@end
