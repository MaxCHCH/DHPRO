//
//  UserListTableViewCell.m
//  zhidoushi
//
//  Created by nick on 15/4/28.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "UserListTableViewCell.h"
#import "UIView+ViewController.h"

#import "MeViewController.h"
#import "UIButton+WebCache.h"

@interface UserListTableViewCell ()

//头像到左边界距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerButtonLeading;

@end

@implementation UserListTableViewCell

#pragma mark Life Cycle
- (void)awakeFromNib {
    
    [self setSelectBackgroundColor:[WWTolls colorWithHexString:@"#eaeaea"] andNormalBackgroundColor:[UIColor whiteColor]];
    
    //    self.lineHeight.constant = 0.5;
    
    [self.headerButton makeCorner:22.0];
    self.headerButton.layer.cornerRadius = 22;
    [self.headerButton setBackgroundImage:nil forState:UIControlStateHighlighted];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark Public Methods

-(void)setModel:(intrestUserModel *)model {
    
    _model = model;
    
    self.tuanzhangImage.hidden = YES;
    
    //头像
    [self.headerButton sd_setImageWithURL:[NSURL URLWithString:model.imageurl] forState:UIControlStateNormal placeholderImage:[WWTolls imageWithColor:[WWTolls colorWithHexString:@"#efefef"] size:self.headerButton.bounds.size]];
    
    //用户名
    self.nameLbl.text = model.username;
    
    //性别
    if ([model.usersex isEqualToString:@"1"]) {
//        self.sexIcon.image = [UIImage imageNamed:@"man-28-28"];
        self.sexIcon.image = [UIImage imageNamed:@"nan-26"];
    } else {
//        self.sexIcon.image = [UIImage imageNamed:@"woman-28-28"];
        self.sexIcon.image = [UIImage imageNamed:@"nv-26"];
    }
    
//    //个性签名
//    self.msgLbl.text = model.usersign;
    
    self.msgLbl.text = model.fanscount;
    
    //关注
    if ([model.flwstatus isEqualToString:@"0"]) {
        [self.guanzhuBtn setBackgroundImage:[UIImage imageNamed:@"ygz-32"]    forState:UIControlStateNormal];
        [self.guanzhuBtn setBackgroundImage:[UIImage imageNamed:@"ygz-32"] forState:UIControlStateHighlighted];
    }else{
        [self.guanzhuBtn setBackgroundImage:[UIImage imageNamed:@"jgz-32"] forState:UIControlStateNormal];
        [self.guanzhuBtn setBackgroundImage:[UIImage imageNamed:@"jgz-32"] forState:UIControlStateHighlighted];
    }
    
    if([model.userid isEqualToString:[NSUSER_Defaults objectForKey:ZDS_USERID]]) {
        self.guanzhuBtn.hidden = YES;
    } else {
        self.guanzhuBtn.hidden = NO;
    }
}

#pragma mark - Event Responses
#pragma mark 头像点击
- (IBAction)headerButtonClick:(id)sender {
    
    if (self.selectButton.hidden) {
        
        MeViewController *me = [[MeViewController alloc] init];
        me.otherOrMe = 1;
        me.userID = self.model.userid;
        [self.viewController.navigationController pushViewController:me animated:YES];
    } else {
        [self selectButtonClick:nil];
    }
    
}   

#pragma mark 选择按钮点击
- (IBAction)selectButtonClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(userListTableViewCell:isSelectWithIndexPath:)]) {
        if ([self.delegate userListTableViewCell:self isSelectWithIndexPath:self.indexPath]) {
            
            self.selectButton.selected = !self.selectButton.selected;
            self.model.isSelect = self.selectButton.selected;
        }
    }
}

#pragma mark 关注点击
- (IBAction)clickAttentionSender:(id)sender {
    [self requestWithUpflwsts];
}   

#pragma mark - Public Methods
#pragma mark 减脂伙伴设置
- (void)groupTeamSetWithShowSelectButton:(BOOL)showSelectButton {
    
    if (showSelectButton && ![self.model.userid isEqualToString:[NSUSER_Defaults objectForKey:ZDS_USERID]]) {
        self.selectButton.hidden = NO;
        self.headerButtonLeading.constant = 53;
        self.selectButton.selected = self.model.isSelect;
    } else {
        self.selectButton.hidden = YES;
        self.headerButtonLeading.constant = 15;
    }
    
}

#pragma mark - Private Methods
#pragma mark 关注请求

- (void)requestWithUpflwsts {
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:4];
    [dictionary setObject:self.model.userid forKey:@"rcvuserid"];
    [dictionary setObject:[self.model.flwstatus isEqualToString:@"0"]?@"1":@"0" forKey:@"flwstatus"];
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_INERACTUPFLWSTS parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (!dic[ERRCODE]) {
            if ([weakSelf.model.flwstatus isEqualToString:@"1"]) {
                [weakSelf.guanzhuBtn setBackgroundImage:[UIImage imageNamed:@"ygz-32"] forState:UIControlStateNormal];
                [weakSelf.guanzhuBtn setBackgroundImage:[UIImage imageNamed:@"ygz-32"] forState:UIControlStateHighlighted];
                weakSelf.model.flwstatus = @"0";//已关注
                [weakSelf.viewController showAlertMsg:@"已关注" andFrame:CGRectMake(70,100,200,60)];
            }else{
                [weakSelf.guanzhuBtn setBackgroundImage:[UIImage imageNamed:@"jgz-32"]    forState:UIControlStateNormal];
                [weakSelf.guanzhuBtn setBackgroundImage:[UIImage imageNamed:@"jgz-32"] forState:UIControlStateHighlighted];
                weakSelf.model.flwstatus = @"1";//未关注
                [weakSelf.viewController showAlertMsg:@"取消关注" andFrame:CGRectMake(70,100,200,60)];
            }
        }
    }];
}



@end








