//
//  YCSquareButton.m
//
//  Created by Sunshine on 15/10/30.
//  Copyright (c) 2015年 YotrolZ. All rights reserved.
//

#import "YCSquareButton.h"
#import "WWTolls.h"
#import "YCCircleModel.h"

#import "UIButton+WebCache.h"


@implementation YCSquareButton

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {

    [self setup];
}

- (void)setup {
    
    // 设置文字中心对齐
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    // 设置文字颜色
    [self setTitleColor:[WWTolls colorWithHexString:@"#535353"] forState:UIControlStateNormal];
    // 设置文字大小
    self.titleLabel.font = [UIFont systemFontOfSize:12];
}

- (void)layoutSubviews {

    [super layoutSubviews];
    
    // 设置图片的frame
    self.imageView.width = self.width;
    self.imageView.height = self.imageView.width;
    self.imageView.y = 0;
    self.imageView.centerX = self.width * 0.5;
    
    // 设置文字的frame
    self.titleLabel.y = CGRectGetMaxY(self.imageView.frame) + 10;
    self.titleLabel.width = self.width + 10;
    self.titleLabel.height = self.height - self.imageView.height - 10;
    
//    NSLog(@"%f---%f",self.height, self.titleLabel.height);
    
    self.titleLabel.centerX = self.width * 0.5;
}

+ (YCSquareButton *)squareButtonWithTitle:(NSString *)title imageName:(NSString *)imageName selImageName:(NSString *)selImageName {

    YCSquareButton *btn = [[YCSquareButton alloc] init];
    
    [btn setTitle:title forState:UIControlStateNormal];
    
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    [btn setImage:[UIImage imageNamed:selImageName] forState:UIControlStateSelected];
    
    return btn;
}


+ (YCSquareButton *)squareButtonWithCircleModel:(YCCircleModel *)model {
    
    YCSquareButton *btn = [[YCSquareButton alloc] init];
    btn.circleM = model;
    [btn setTitle:model.circlename forState:UIControlStateNormal];
//    btn.imageView.backgroundColor = [WWTolls colorWithHexString:@"#efefef"];

    [btn sd_setImageWithURL:[NSURL URLWithString:model.imageurlNormal] forState:UIControlStateNormal placeholderImage:nil];
 
    btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    
    [btn sd_setImageWithURL:[NSURL URLWithString:model.imageurlSelect] forState:UIControlStateSelected placeholderImage:nil];
    
    btn.imageView.clipsToBounds = NO;
    
    return btn;
}


@end
