//
//  FinishAlertView.m
//  zhidoushi
//
//  Created by licy on 15/6/16.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "FinishAlertView.h"

static NSString *FinishImage = @"insure_finish_task";
static NSString *FlagImage = @"task_flag";

@interface FinishAlertView ()

@property (nonatomic,strong) NSString *message;

@end

@implementation FinishAlertView

#pragma mark Init

- (instancetype)initWithFrame:(CGRect)frame withMessage:(NSString *)message delegate:(id <FinishAlertViewDelegate>)delegate {
    
    self.delegate = delegate;
    self.message = message;
    if (self = [self initWithFrame:frame]) {
        
    }
    
    return self;
}   

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    
    return self;
}

#pragma mark Private Methods

- (void)createView {
    
    [self ssl_addGeneralTap];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 275)/2, 185 * SSL_Height_Value, 275, 154)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    [bgView makeCorner:10.0];
    
    UIImageView *flagImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - 50)/2, bgView.y - 25, 50, 50)];
    [self addSubview:flagImageView];
    [flagImageView setImage:[UIImage imageNamed:FlagImage]];
    
    self.message = @"你确认完成任务了吗？听说在脂斗士撒谎的人要胖十斤哦。";
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 25 + 15, bgView.width - 18 * 2, 34)];
    [bgView addSubview:contentLabel];
    contentLabel.text = self.message;
    contentLabel.numberOfLines = 2;
    contentLabel.textColor = [WWTolls colorWithHexString:@"#6D6E6F"];
    contentLabel.font = MyFont(14.0);
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, contentLabel.maxY + 15 , bgView.width, 0.8)];
    [bgView addSubview:lineLabel];
    lineLabel.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
    
    UIButton *finishButton = [[UIButton alloc] initWithFrame:CGRectMake((bgView.width - 187) / 2, lineLabel.maxY + 15, 187, 32)];
    [bgView addSubview:finishButton];
    [finishButton setImage:[UIImage imageNamed:FinishImage] forState:UIControlStateNormal];
    [finishButton addTarget:self action:@selector(finishButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}       

#pragma mark Event Responses
- (void)finishButtonClick:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(finishAlertView:)]) {
        [self.delegate finishAlertView:self];
    }
    [self ssl_hidden];
}

@end









