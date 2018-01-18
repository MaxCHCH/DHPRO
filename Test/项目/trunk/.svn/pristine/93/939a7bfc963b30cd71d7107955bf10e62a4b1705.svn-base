//
//  EditorLoseWayAlertView.m
//  zhidoushi
//
//  Created by nick on 15/10/14.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import "EditorLoseWayAlertView.h"
#import "UIView+SSLAlertViewTap.h"
#import "UITextView+LimitLength.h"

@interface EditorLoseWayAlertView()
@property(nonatomic,strong)UIButton *submitBtn;//提交按钮
@property(nonatomic,strong)UITextView *textView;//文本框
@property(nonatomic,strong)UILabel *textPlacehoader;//占位
@property(nonatomic,strong)UILabel *contentNumLbl;//字数提示
@end

@implementation EditorLoseWayAlertView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame delegate:(id <EditorLoseWayDelegate>)delegate {
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
- (void)createViewWithLoseWay:(NSString *)loseway{
    
    self.backgroundColor = [UIColor clearColor];
    
    [self ssl_addOnlyTap];
    
    [self ssl_addBlackBlur];
    //背景
    UIView *createBg = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 210, SCREEN_WIDTH, 212)];
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
    title.text = @"减脂方法";
    [createBg addSubview:title];
    
    //输入框
    UITextView *text = [[UITextView alloc] initWithFrame:CGRectMake(12, line.bottom+12, SCREEN_WIDTH-24, 111)];
    [text limitTextLength:301];
    text.text = loseway;
    self.textView = text;
    [text scrollsToTop];
    text.delegate = self;
    text.layoutManager.allowsNonContiguousLayout = NO;
    text.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    text.font = MyFont(15);
    text.contentInset = UIEdgeInsetsMake(-7, -5, 0, 0);
    text.textColor = [WWTolls colorWithHexString:@"#535353"];
    [createBg addSubview:text];
    //内容占位文字
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(15, line.bottom + 14, 300, 18)];
    self.textPlacehoader = lbl;
    lbl.hidden = YES;
    lbl.font = MyFont(15);
    lbl.textColor = [WWTolls colorWithHexString:@"#959595"];
    lbl.text = @"减脂方式不能为空";
    [createBg addSubview:lbl];
    //字数提示
    UILabel *contentNumLbl = [[UILabel alloc] init];
    self.contentNumLbl = contentNumLbl;
    contentNumLbl.frame = CGRectMake(SCREEN_WIDTH - 100, text.bottom + 12, 88, 12);
    contentNumLbl.text = [NSString stringWithFormat:@"%ld/300",loseway.length];
    contentNumLbl.textAlignment = NSTextAlignmentRight;
    contentNumLbl.font = MyFont(11);
    contentNumLbl.textColor = [WWTolls colorWithHexString:@"#959595"];
    [createBg addSubview:contentNumLbl];
    
    
}

#pragma mark - Event Responses

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    [textView textFieldTextLengthLimit:nil];
    [self reloadNum];
}

- (void)reloadNum{
    self.textPlacehoader.hidden = _textView.text.length > 0;
    self.contentNumLbl.text = [NSString stringWithFormat:@"%ld/300",_textView.text.length];
    self.submitBtn.selected = _textView.text.length >= 1;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (text.length + textView.text.length - range.length >= 301) {
        NSString *newText = [textView.text stringByReplacingCharactersInRange:range withString:text];
        textView.text = [newText substringToIndex:300];
        [self reloadNum];
        return NO;
    }
    return YES;
}

#pragma mark 提交点击事件
-(void)commitEditorButtonClick:(UIButton *)button{
    if (self.textView.text.length < 1) {
        [MBProgressHUD showError:@"减脂方法不能为空"];
        return;
    }else if([WWTolls isHasSensitiveWord:self.textView.text]){
        [MBProgressHUD showError:ZDS_HASSENSITIVE];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(commitLoseWay:)]) {
        [self.delegate commitLoseWay:self.textView.text];
    }
    [self ssl_hidden];
}
#pragma mark 取消点击事件
- (void)cancelButtonClick:(UIButton *)button {
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


@end
