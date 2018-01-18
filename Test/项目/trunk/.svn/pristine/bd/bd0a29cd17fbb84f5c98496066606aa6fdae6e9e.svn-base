//
//  LoseWeightTableViewCell.m
//  zhidoushi
//
//  Created by licy on 15/6/19.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "LoseWeightTableViewCell.h"

@interface LoseWeightTableViewCell ()

@property (nonatomic,strong) UIImageView *headImageView;

@property (nonatomic,strong) UILabel *originLabel;
@property (nonatomic,strong) UILabel *currentLabel;
@property (nonatomic,strong) UILabel *losedLabel;

@property (nonatomic,strong) UILabel *nickNameLabel;

@property (nonatomic,strong) UIButton *taskButton;

@end

@implementation LoseWeightTableViewCell


#pragma mark - Life Cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    
    return self;
}

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - UI
- (void)createView {
    
    self.width = 305;
    
    self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(28, 10, 40, 40)];
    [self.contentView addSubview:self.headImageView];
    self.headImageView.backgroundColor = ZDS_BACK_COLOR;
    
    UILabel *memberLable = [[UILabel alloc] initWithFrame:CGRectMake(0, self.headImageView.maxY + 6, 96, 10)];
    [self.contentView addSubview:memberLable];
    memberLable.font = MyFont(10);
    memberLable.textAlignment = NSTextAlignmentCenter;
    memberLable.textColor = [WWTolls colorWithHexString:@"#6b6b6b"];
    memberLable.text = @"";
    self.nickNameLabel = memberLable;
    
    for (int i = 0; i < 4; i++) {
        CGFloat x = memberLable.maxX + i * 52;
        UILabel *tLbl = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, 0.5, 76)];
        [self.contentView addSubview:tLbl];
        tLbl.backgroundColor = [WWTolls colorWithHexString:@"#f6f6f6"];
    }
    
    for (int i = 0; i < 4; i++) {
        CGFloat x = memberLable.maxX + 1 + 12 + (52) * i;
        
        if (i == 3) {
            x += 6;
            self.taskButton = [[UIButton alloc] initWithFrame:CGRectMake(x, (76 - 16) / 2, 16, 16)];
            [self.contentView addSubview:self.taskButton];
            self.taskButton.userInteractionEnabled = NO;
            [self.taskButton setImage:[UIImage imageNamed:@"wwc-32"] forState:UIControlStateNormal];
//            [self.taskButton addTarget:self action:@selector(taskButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, (76 - 27) / 2, 27, 27)];
            [self.contentView addSubview:label];
            label.text = @"170";
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 2;
            
            label.textColor = [WWTolls colorWithHexString:@"#959595"];
            label.font = MyFont(11);
            
            switch (i) {
                case 0:
                    self.originLabel = label;
                    break;
                case 1:
                    self.currentLabel = label;
                    break;
                case 2:
                    self.losedLabel = label;
                    break;
            }
        }
        
    }
    
    UILabel *boLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 75.5, self.width, 0.5)];
    [self.contentView addSubview:boLine];
    boLine.backgroundColor = [WWTolls colorWithHexString:@"#f6f6f6"];
}   

#pragma mark - Public Methods
- (void)setModel:(LoseDetailModel *)model {
    _model = model;
    
    self.nickNameLabel.text = model.username;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.imageurl]];
    self.originLabel.text = [NSString stringWithFormat:@"%@",model.initialweg];
    self.currentLabel.text = [NSString stringWithFormat:@"%@",model.latestweg];
    self.losedLabel.text = [NSString stringWithFormat:@"%@",model.ploseweg];
    
    //已完成
    if ([model.tasksts isEqualToString:@"0"]) {
        [self.taskButton setImage:[UIImage imageNamed:@"ywc-32"] forState:UIControlStateNormal];
        
        //未完成或者没有
    } else {
        [self.taskButton setImage:[UIImage imageNamed:@"wwc-32"] forState:UIControlStateNormal];
    }
}

@end









