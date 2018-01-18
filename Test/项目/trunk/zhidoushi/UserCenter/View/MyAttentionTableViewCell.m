//
//  MyAttentionTableViewCell.m
//  zhidoushi
//
//  Created by xinglei on 15/1/5.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "MyAttentionTableViewCell.h"
#import "WWTolls.h"
#import "UIView+ViewController.h"

@interface MyAttentionTableViewCell ()

@property(nonatomic,assign)BOOL buttonStage;//是否已被关注

@end

@implementation MyAttentionTableViewCell

-(void)initWithCellAtIndex:(NSMutableSet*)indexArray{

    [self.attentionButton_1 setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];

    if ([self.flwstatus isEqualToString:@"1"]) {//未被关注的情况下按钮显示红色,在未关注组里面

        [self.attentionButton_1 setBackgroundImage:[UIImage imageNamed:@"guanzhu-96-68"] forState:UIControlStateNormal];
    }

    else{//否则显示白色

        [self.attentionButton_1 setBackgroundImage:[UIImage imageNamed:@"yiguanzhu-96-68"] forState:UIControlStateNormal];
    }
}

- (void)awakeFromNib {
    self.headImage.clipsToBounds = YES;
    self.headImage.layer.cornerRadius = 20;
    self.backgroundColor = RGBCOLOR(239, 239, 239);
    self.descripeLabel.textColor = [WWTolls colorWithHexString:@"#313131"];
    self.moreLabel.textColor = [WWTolls colorWithHexString:@"#313131"];
}

- (IBAction)clickAttentionSender:(id)sender {

    if ([self.flwstatus isEqualToString:@"1"]) {
        [self.attentionButton_1 setBackgroundImage:[UIImage imageNamed:@"yiguanzhu-96-68"] forState:UIControlStateNormal];
        _buttonStage = YES;
        self.flwstatus = @"0";//已关注
        [self.viewController showAlertMsg:@"已关注" andFrame:CGRectMake(70,100,200,60)];
    }else{
        [self.attentionButton_1 setBackgroundImage:[UIImage imageNamed:@"guanzhu-96-68"] forState:UIControlStateNormal];
        _buttonStage = NO;
        self.flwstatus = @"1";//未关注
        [self.viewController showAlertMsg:@"取消关注" andFrame:CGRectMake(70,100,200,60)];
    }
    NSString * indexString = [NSString stringWithFormat:@"%ld",self.cellIndex];
    if ([self.atttionDelegate respondsToSelector:@selector(clickAttentionButton)]) {
        [self.atttionDelegate rcvuseridValue:self.rcvuserid flwstatus: self.flwstatus cellIndexString:indexString];
        [self.atttionDelegate clickAttentionButton];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
