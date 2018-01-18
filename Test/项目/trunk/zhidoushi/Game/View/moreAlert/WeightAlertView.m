//
//  WeightAlertView.m
//  zhidoushi
//
//  Created by licy on 15/6/16.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "WeightAlertView.h"

static NSString *ContinueImage = @"alert_continue_try";
static NSString *UploadWeightImage = @"alert_upload_weight";

@interface WeightAlertView ()

@property (nonatomic,strong) NSString *message;

@end

@implementation WeightAlertView

#pragma mark Init

- (instancetype)initWithFrame:(CGRect)frame withMessage:(NSString *)message {
    
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
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 275)/2, 185 * SSL_Height_Value, 275, 160)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    [bgView makeCorner:10.0];
    
    UIImageView *uploadImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - 50)/2, bgView.y - 25, 50, 50)];
    [self addSubview:uploadImageView];
    [uploadImageView setImage:[UIImage imageNamed:UploadWeightImage]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 25 + 7, bgView.width, 18)];
    [bgView addSubview:label];
    label.text = @"上传体重";
    label.font = MyFont(18.0);
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [WWTolls colorWithHexString:@"#f39800"];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, label.maxY + 10   , bgView.width, 0.8)];
    [bgView addSubview:lineLabel];
    lineLabel.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
    
    if (self.message.floatValue > 0) {
        self.message = [NSString stringWithFormat:@"比上次瘦了%@kg，在脂斗士减脂，你不是一个人在战斗",self.message];
    } else if (self.message.floatValue < 0) {
        self.message = [NSString stringWithFormat:@"居然胖了%.01fkg，啥也不说了，马上运动去!肉肉我和你拼了!",-self.message.floatValue];
    } else if (self.message.floatValue == 0) {
        self.message = [NSString stringWithFormat:@"体重没变哦，保持也是一种进步，继续加油！"];
    }   
    
//    self.message = @"比上次瘦了1kg，在脂斗士减脂，你不是一个人在战斗";
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, lineLabel.maxY + 8, bgView.width - 18 * 2, 34)];
    [bgView addSubview:contentLabel];
    contentLabel.text = self.message;
    contentLabel.numberOfLines = 2;
    contentLabel.textColor = [WWTolls colorWithHexString:@"#6D6E6F"];
    contentLabel.font = MyFont(14.0);
    
    UIButton *tryButton = [[UIButton alloc] initWithFrame:CGRectMake((bgView.width - 135) / 2, contentLabel.maxY + 9, 135, 32)];
    [bgView addSubview:tryButton];
    [tryButton setImage:[UIImage imageNamed:ContinueImage] forState:UIControlStateNormal];
    [tryButton addTarget:self action:@selector(tryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}   

#pragma mark Event Responses
- (void)tryButtonClick:(UIButton *)button {
    [self ssl_hidden];
}

@end







