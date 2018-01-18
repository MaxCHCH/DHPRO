//
//  GroupTeamCollectionViewCell.m
//  zhidoushi
//
//  Created by nick on 15/6/16.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "GroupTeamCollectionViewCell.h"
#import "UIView+ViewController.h"
#import "MeViewController.h"

@implementation GroupTeamCollectionViewCell

- (void)awakeFromNib {
    self.headerImage.layer.cornerRadius = 32.5;
    self.headerImage.clipsToBounds = YES;
    self.headerImage.userInteractionEnabled = YES;
    self.headerImage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.headerImage.layer.borderWidth = 2;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHeader)];
    [self.headerImage addGestureRecognizer:tap];
}

-(void)setModel:(intrestUserModel *)model{
    _model = model;
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:model.imageurl] placeholderImage:[UIImage imageNamed:@"mrtx_98_98"]];
    self.nameLbl.text = model.username;
    if ([model.flwstatus isEqualToString:@"0"]) {
        [self.guanzhuBtn setBackgroundImage:[UIImage imageNamed:@"team_yiguanzhu"]    forState:UIControlStateNormal];
    }else{
        [self.guanzhuBtn setBackgroundImage:[UIImage imageNamed:@"team_guanzhu"] forState:UIControlStateNormal];
    }
    if([model.userid isEqualToString:[NSUSER_Defaults objectForKey:ZDS_USERID]]){
        self.guanzhuBtn.hidden = YES;
    }else self.guanzhuBtn.hidden = NO;

}

-(void)clickHeader{
    MeViewController *me = [[MeViewController alloc] init];
    me.otherOrMe = 1;
    me.userID = self.model.userid;
    [self.viewController.navigationController pushViewController:me animated:YES];
}

- (IBAction)clickAttentionSender:(id)sender {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:4];
    [dictionary setObject:self.model.userid forKey:@"rcvuserid"];
    [dictionary setObject:[self.model.flwstatus isEqualToString:@"0"]?@"1":@"0" forKey:@"flwstatus"];
    NSLog(@"——————————————%@",dictionary);
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:[NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_INERACTUPFLWSTS] parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (!dic[ERRCODE]) {
            if ([self.model.flwstatus isEqualToString:@"1"]) {
                [self.guanzhuBtn setBackgroundImage:[UIImage imageNamed:@"team_yiguanzhu.png"] forState:UIControlStateNormal];
                self.model.flwstatus = @"0";//已关注
                [self.viewController showAlertMsg:@"已关注" andFrame:CGRectMake(70,100,200,60)];
            }else{
                [self.guanzhuBtn setBackgroundImage:[UIImage imageNamed:@"team_guanzhu.png"] forState:UIControlStateNormal];
                self.model.flwstatus = @"1";//未关注
                [self.viewController showAlertMsg:@"取消关注" andFrame:CGRectMake(70,100,200,60)];
            }
        }
    }];
    
}
@end
