//
//  ILSMLAlertView.m
//  MoreLikers
//
//  Created by xiekw on 13-9-9.
//  Copyright (c) 2013年 谢凯伟. All rights reserved.
//

#import "DXAlertView.h"
#import <QuartzCore/QuartzCore.h>

#import "WWTolls.h"


#define kAlertWidth 260.0f
#define kAlertHeight 150.0f

@interface DXAlertView ()
{
    BOOL _leftLeave;
}

@property (nonatomic, strong) UILabel *alertTitleLabel;
@property (nonatomic, strong) UILabel *alertContentLabel;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIView *backImageView;

@end

@implementation DXAlertView

+ (CGFloat)alertWidth
{
    return kAlertWidth;
}

+ (CGFloat)alertHeight
{
    return kAlertHeight;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#define kTitleYOffset 15.0f
#define kTitleHeight 25.0f

#define kContentOffset 30.0f
#define kBetweenLabelOffset 20.0f

- (id)initWithTitle:(NSString *)title
        contentText:(NSString *)content
    leftButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle
{
    if (self = [super init]) {
        self.layer.cornerRadius = 5.0;
        self.backgroundColor = [UIColor whiteColor];
        self.alertTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kTitleYOffset, kAlertWidth, kTitleHeight)];
        self.alertTitleLabel.font = MyFont(15);
        self.alertTitleLabel.textColor = [UIColor colorWithRed:56.0/255.0 green:64.0/255.0 blue:71.0/255.0 alpha:1];
        [self addSubview:self.alertTitleLabel];
        
        CGFloat contentLabelWidth = kAlertWidth - 16;
        self.alertContentLabel = [[UILabel alloc] initWithFrame:CGRectMake((kAlertWidth - contentLabelWidth) * 0.5, CGRectGetMaxY(self.alertTitleLabel.frame), contentLabelWidth, 60)];
        self.alertContentLabel.numberOfLines = 0;
        self.alertContentLabel.textAlignment = self.alertTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.alertContentLabel.textColor = [WWTolls colorWithHexString:@"#000000"];
        self.alertContentLabel.font = MyFont(15);
        [self addSubview:self.alertContentLabel];
        
        CGRect leftBtnFrame;
        CGRect rightBtnFrame;
#define kSingleButtonWidth 160.0f
#define kCoupleButtonWidth 50.0f
#define kButtonHeight 40.0f
#define kButtonBottomOffset 15.0f
#define kButtonLRMargin 15.0f
        
        /**
         *  计算按钮frame
         */
        
        
        /**
         *  计算按钮的宽度和高度
         */
        CGFloat leftButtonWidth = [WWTolls WidthForString:leftTitle fontSize:15];
        CGFloat leftButtonHeight = [WWTolls heightForString:leftTitle fontSize:15];
        
        CGFloat rightButtonWidth = [WWTolls WidthForString:rigthTitle fontSize:15];
        CGFloat rightButtonHeight = [WWTolls heightForString:rigthTitle fontSize:15];
        
        
//        CGFloat buttonMargin = kAlertWidth - (kCoupleButtonWidth + kButtonLRMargin) * 2;
//        
//        leftBtnFrame = CGRectMake(kButtonLRMargin, kAlertHeight - kButtonBottomOffset - kButtonHeight, kCoupleButtonWidth, kButtonHeight);
//        rightBtnFrame = CGRectMake(CGRectGetMaxX(leftBtnFrame) + buttonMargin, kAlertHeight - kButtonBottomOffset - kButtonHeight, kCoupleButtonWidth, kButtonHeight);
//        self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.leftBtn.frame = leftBtnFrame;
//        self.rightBtn.frame = rightBtnFrame;
        
        
        if (!leftTitle || [leftTitle isEqualToString:@""]) { // 只初始化右侧的按钮
//            rightBtnFrame = CGRectMake((kAlertWidth - kSingleButtonWidth) * 0.5, kAlertHeight - kButtonBottomOffset - kButtonHeight, kSingleButtonWidth, kButtonHeight);
//            self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            self.rightBtn.frame = rightBtnFrame;
            
            self.leftBtn.enabled = NO;
            
            
            CGFloat buttonMargin = kAlertWidth - leftButtonWidth - rightButtonWidth - kButtonLRMargin * 2;
            
            leftBtnFrame = CGRectMake(kButtonLRMargin, kAlertHeight - kButtonBottomOffset - leftButtonHeight, leftButtonWidth, leftButtonHeight);
            rightBtnFrame = CGRectMake(CGRectGetMaxX(leftBtnFrame) + buttonMargin, kAlertHeight - kButtonBottomOffset - rightButtonHeight, rightButtonWidth, rightButtonHeight);
//            self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            self.leftBtn.frame = leftBtnFrame;
            self.rightBtn.frame = rightBtnFrame;
            
            
            
        }else { // 初始化左右两侧的按钮
            
            
            self.leftBtn.enabled = YES;
            CGFloat buttonMargin = kAlertWidth - leftButtonWidth - rightButtonWidth - kButtonLRMargin * 2;
            
            leftBtnFrame = CGRectMake(kButtonLRMargin, kAlertHeight - kButtonBottomOffset - leftButtonHeight, leftButtonWidth, leftButtonHeight);
            rightBtnFrame = CGRectMake(CGRectGetMaxX(leftBtnFrame) + buttonMargin, kAlertHeight - kButtonBottomOffset - rightButtonHeight, rightButtonWidth, rightButtonHeight);
            self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.leftBtn.frame = leftBtnFrame;
            self.rightBtn.frame = rightBtnFrame;
        }
        
        /**
         *  设置按钮的背景颜色
         */
        [self.rightBtn setBackgroundImage:[UIImage imageWithColor:[WWTolls colorWithHexString:@"#ffffff"]] forState:UIControlStateNormal];
        [self.leftBtn setBackgroundImage:[UIImage imageWithColor:[WWTolls colorWithHexString:@"#ffffff"]] forState:UIControlStateNormal];
        
        /**
         *  设置按钮的文字
         */
        [self.rightBtn setTitle:rigthTitle forState:UIControlStateNormal];
        [self.leftBtn setTitle:leftTitle forState:UIControlStateNormal];
        
        /**
         *  设置按钮的字体大小
         */
        self.leftBtn.titleLabel.font = self.rightBtn.titleLabel.font = MyFont(15);
        
        /**
         *  设置按钮的文字颜色
         */
        [self.leftBtn setTitleColor:[WWTolls colorWithHexString:@"#ff5304"] forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:[WWTolls colorWithHexString:@"#ff5304"] forState:UIControlStateNormal];
        
        /**
         *  添加监听
         */
        [self.leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        /**
         *  设置按钮的圆角
         */
        self.leftBtn.layer.masksToBounds = self.rightBtn.layer.masksToBounds = YES;
        self.leftBtn.layer.cornerRadius = self.rightBtn.layer.cornerRadius = 3.0;
        
        /**
         *  添加左右按钮
         */
        [self addSubview:self.leftBtn];
        [self addSubview:self.rightBtn];
        
        
        /**
         *  设置标题及提示信息的文字
         */
        self.alertTitleLabel.text = title;
        self.alertContentLabel.text = content;
        
        /**
         *  右上角的叉号按钮
         */
        UIButton *xButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [xButton setImage:[UIImage imageNamed:@"x-24"] forState:UIControlStateNormal];
        xButton.frame = CGRectMake(kAlertWidth - 12 - 15, 15, 12, 12);
        [self addSubview:xButton];
        [xButton addTarget:self action:@selector(dismissAlert) forControlEvents:UIControlEventTouchUpInside];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    }
    return self;
}

- (void)leftBtnClicked:(id)sender
{
    _leftLeave = YES;
    
    if (self.leftBlock) {
        self.leftBlock();
    }
    
    [self dismissAlert];
}

- (void)rightBtnClicked:(id)sender
{
    _leftLeave = NO;
    
    if (self.rightBlock) {
        self.rightBlock();
    }
    [self dismissAlert];
}

- (void)show
{
    UIViewController *topVC = [self appRootViewController];
    self.frame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, - kAlertHeight - 30, kAlertWidth, kAlertHeight);
    [topVC.view addSubview:self];
}

- (void)dismissAlert
{
    
    if (self.dismissBlock) {
        self.dismissBlock();
    }
    [self removeFromSuperview];
}

- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}


- (void)removeFromSuperview
{
    [self.backImageView removeFromSuperview];
    self.backImageView = nil;
    UIViewController *topVC = [self appRootViewController];
    CGRect afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, CGRectGetHeight(topVC.view.bounds), kAlertWidth, kAlertHeight);
    
    [super removeFromSuperview];
    
    /*************************移除的动画**************************/
    
    
//    [UIView animateWithDuration:0.35f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        self.frame = afterFrame;
//        if (_leftLeave) {
//            self.transform = CGAffineTransformMakeRotation(-M_1_PI / 1.5);
//        }else {
//            self.transform = CGAffineTransformMakeRotation(M_1_PI / 1.5);
//        }
//    } completion:^(BOOL finished) {
//        [super removeFromSuperview];
//    }];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview == nil) {
        return;
    }
    UIViewController *topVC = [self appRootViewController];

    if (!self.backImageView) {
        self.backImageView = [[UIView alloc] initWithFrame:topVC.view.bounds];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        
        [self.backImageView addGestureRecognizer:tap];
        
        self.backImageView.backgroundColor = [UIColor blackColor];
        self.backImageView.alpha = 0.8f;
        self.backImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    [topVC.view addSubview:self.backImageView];
    self.transform = CGAffineTransformMakeRotation(-M_1_PI / 2);
    CGRect afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, (CGRectGetHeight(topVC.view.bounds) - kAlertHeight) * 0.5, kAlertWidth, kAlertHeight);
    
    self.transform = CGAffineTransformMakeRotation(0);
    self.frame = afterFrame;
    /*************************弹出时的动画**************************/
    
//    [UIView animateWithDuration:0.35f delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//        self.transform = CGAffineTransformMakeRotation(0);
//        self.frame = afterFrame;
//    } completion:^(BOOL finished) {
//    }];
    [super willMoveToSuperview:newSuperview];
}

- (void)tap: (UITapGestureRecognizer *)tap {

    [self removeFromSuperview];
}

@end

@implementation UIImage (colorful)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
