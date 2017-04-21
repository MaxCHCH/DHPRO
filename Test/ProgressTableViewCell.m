//
//  ProgressTableViewCell.m
//  ProgressViewDemo
//
//  Created by 思 彭 on 2017/4/21.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "ProgressTableViewCell.h"
#import "Masonry.h"
#import "ProgressView.h"

@interface ProgressTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) ProgressView *progressView;
@property (nonatomic, strong) UILabel *numberLabel;

@end

@implementation ProgressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSubViews];
        [self layOut];
    }
    return self;
}

- (void)createSubViews {
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.text = @"西单大悦城";
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.titleLabel];
    self.progressView = [[ProgressView alloc]init];
    self.progressView.backgroundColor = [UIColor whiteColor];
    self.progressView.progress = arc4random_uniform(100) + 40;
    [self.contentView addSubview:self.progressView];
    self.numberLabel = [[UILabel alloc]init];
    self.numberLabel.font = [UIFont systemFontOfSize:16];
    self.numberLabel.text = @"2000";
    self.numberLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.numberLabel];
}

- (void)layOut {
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(10);
        make.centerY.mas_equalTo(self.contentView);
//        make.width.greaterThanOrEqualTo(@(70));
        make.width.mas_equalTo(self.contentView.frame.size.width * 0.3);
    }];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(10);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
        make.width.mas_equalTo(self.contentView.frame.size.width * 0.4);
    }];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.progressView.mas_right).offset(10);
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView).offset(-10);
    }];
}

@end
