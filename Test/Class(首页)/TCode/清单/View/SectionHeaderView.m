//
//  SectionHeaderView.m
//  ContractDetailDemo
//
//  Created by 思 彭 on 2017/4/7.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "SectionHeaderView.h"
#import "Macros_Font.h"
@interface SectionHeaderView ()

@property (nonatomic, strong) UIButton *expandButton;

@end

@implementation SectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textColor = [UIColor lightGrayColor];
    self.titleLabel.font = FONT_14;
//    self.titleLabel.text = @"付款计划明细(数量:2条)";
    [self.contentView addSubview:self.titleLabel];
    
    self.expandButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.expandButton setImage:[UIImage imageNamed:@"f_down_icon"] forState:UIControlStateNormal];
    [self.expandButton addTarget:self action:@selector(expandButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.expandButton];
    [self layout];
}

- (void)layout {
    
    self.titleLabel.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topEqualToView(self.contentView)
    .bottomEqualToView(self.contentView);
//    .centerYIs(self.contentView.centerY);
    [self.titleLabel setSingleLineAutoResizeWithMaxWidth:200];
    self.expandButton.sd_layout
    .rightSpaceToView(self.contentView, 10)
    .widthIs(20)
    .heightIs(20)
    .centerYEqualToView(self.contentView);
}

- (void)expandButtonDidClick: (UIButton *)button {
    button.selected = !button.selected;
    if (self.block) {
        self.block(button.selected);
    }
}
@end
