//
//  DisReplyTableViewCell.m
//  zhidoushi
//
//  Created by nick on 15/4/27.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "DisReplyTableViewCell.h"
#import "MeViewController.h"
@interface DisReplyTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end
@implementation DisReplyTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.headImage.clipsToBounds = YES;
    self.headImage.layer.cornerRadius = 22;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.headImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHead)];
    [self.headImage addGestureRecognizer:tap];
//    self.separatorInset = UIEdgeInsetsMake(0, 11, 0, 11);
}

-(void)clickHead{
    MeViewController *single = [[MeViewController alloc]init];
    single.userID = self.model.userid;
    single.otherOrMe = 1;
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            [((UIViewController*)nextResponder).view endEditing:YES];
            [((UIViewController*)nextResponder).navigationController pushViewController:single animated:YES];
            return;
        }
    }
}

-(void)setModel:(DiscoverReplyModel *)model{
    _model = model;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.userimage] placeholderImage:[UIImage imageNamed:@"mrtx_98_98"]];
    self.name.text = model.username;
    self.time.text = [WWTolls date:model.createtime];
    if ([model.commentlevel isEqualToString:@"1"]) {
        self.content.text = model.content;
    }else{
        self.content.text = [NSString stringWithFormat:@"回复%@:%@",model.byusername,model.content];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setHighlighted:(BOOL)highlighted{
    if (highlighted) {
        self.contentView.backgroundColor = [WWTolls colorWithHexString:@"#eaeaea"];
    }else{
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    [self setHighlighted:highlighted];
    [self setNeedsDisplay];
}   

#pragma mark UITableViewCell 左滑删除时，修改删除按钮背景颜色

- (void)layoutSubviews {
    [super layoutSubviews];
    for (UIView *subView in self.subviews) {
        if ([NSStringFromClass([subView class]) isEqualToString:@"UITableViewCellDeleteConfirmationView"]) {
            ((UIView *)[subView.subviews firstObject]).backgroundColor = [WWTolls colorWithHexString:@"#ff4d48"];
        }
    }
}

@end
