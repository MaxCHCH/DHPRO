//
//  TableViewCell.m
//  ContractDetailDemo
//
//  Created by 思 彭 on 2017/4/7.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "TableViewCell.h"
#import "CellModel.h"
#import "Macros_Font.h"
@interface TableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = FONT_14;
    self.titleLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.titleLabel];
    self.contentLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.contentLabel];
    self.contentLabel.font = FONT_14;
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.textColor = [UIColor lightGrayColor];
    [self layout];
}

- (void)layout {
    
    self.titleLabel.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .widthIs(100);
    [self.titleLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    self.contentLabel.sd_layout
    .leftSpaceToView(self.titleLabel, 20)
    .topEqualToView(self.titleLabel)
    .rightSpaceToView(self.contentView, 10)
    .bottomEqualToView(self.contentView);
//    .autoHeightRatio(0);
}

- (void)setModel:(CellModel *)model {
    
    _model = model;
    self.titleLabel.text = self.model.titleStr;
    self.contentLabel.text = self.model.contentStr;
}

@end
