//
//  UITableViewCell+SSLSelect.m
//  zhidoushi
//
//  Created by licy on 15/7/27.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "UITableViewCell+SSLSelect.h"

@implementation UITableViewCell (SSLSelect)

+ (CGFloat)cellHeight {
    return 0;
}

//让按钮点击效果生效
- (void) setButtonClickEffectWithTableView:(UITableView *)tableView {
    tableView.delaysContentTouches = NO;
    for (id obj in self.subviews) {
        if ([NSStringFromClass([obj class])isEqualToString:@"UITableViewCellScrollView"]) {
            UIScrollView *scroll = (UIScrollView *) obj;
            scroll.delaysContentTouches = NO;
            break;
        }
    }   
}

//设置点击和普通状态的背景图片
- (void)setSelectBackgroundImage:(NSString *)selectImage andNormalBackgroundImage:(NSString *)normalImage {
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    
    if (normalImage) {
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:normalImage]];
    }
    
    if (selectImage) {
        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:selectImage]];
    }
}

//设置点击和普通状态的背景图片
- (void)setSelectBackgroundColor:(UIColor *)selectColor andNormalBackgroundColor:(UIColor *)normalColor {
    //    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    
    if (normalColor) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = normalColor;
        self.backgroundView = view;
    }
    
    if (selectColor) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = selectColor;
        self.selectedBackgroundView = view;
    }
}

@end
