//
//  ZDSActDetailCell.m
//  zhidoushi
//
//  Created by nick on 15/4/27.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "ZDSActDetailCell.h"
#import "MeViewController.h"
#import "HTCopyableLabel.h"
@interface ZDSActDetailCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet HTCopyableLabel *content;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIView *grayLine;

@end
@implementation ZDSActDetailCell

- (void)awakeFromNib {
    // Initialization code
    self.grayLine.height = 0.5;
    self.headImage.clipsToBounds = YES;
    self.headImage.layer.cornerRadius = 20;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.headImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHead)];
    [self.headImage addGestureRecognizer:tap];
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

-(void)setModel:(ZDSActCommentModel *)model{
    
    _model = model;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.userimage] placeholderImage:[UIImage imageNamed:@"mrtx_98_98"]];
    self.name.text = model.username;
    self.time.text = [WWTolls timeString22:model.createtime];
    
    self.content.text = model.content;
    
    if ([model.commentlevel isEqualToString:@"1"]) {
        self.content.text = model.content;
    }else{
        self.content.text = [NSString stringWithFormat:@"回复%@:%@",model.byusername,model.content];
    }   
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat h = [WWTolls heightForString:self.content.text fontSize:14 andWidth:self.content.width];
        if (!iPhone4) {
            h += 6;
        }
        self.content.height = h;
        h += 45;
        
        self.grayLine.top = h-1;
    });
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
