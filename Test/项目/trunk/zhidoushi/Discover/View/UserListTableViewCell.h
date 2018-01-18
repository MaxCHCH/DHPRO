//
//  UserListTableViewCell.h
//  zhidoushi
//
//  Created by nick on 15/4/28.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "intrestUserModel.h"
#import "UITableViewCell+SSLSelect.h"
#import "UIButton+SSLPointBigger.h"

@class UserListTableViewCell;

@protocol UserListTableViewCellDelegate <NSObject>

/**
 *  点击某个选择按钮  并在controller中判断选择个数是否达到最大值 并返回
 *
 *  @param userListTableViewCell UserListTableViewCell本身
 *  @param indexPath             每个cell的 NSIndexPath
 *
 *  @return 选择个数是否达到最大值
 */
- (BOOL)userListTableViewCell:(UserListTableViewCell *)userListTableViewCell isSelectWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface UserListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *sexIcon;
@property (weak, nonatomic) IBOutlet UILabel *msgLbl;
@property (weak, nonatomic) IBOutlet UIButton *guanzhuBtn;
@property (weak, nonatomic) IBOutlet UIButton *headerButton;

@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@property (weak, nonatomic) IBOutlet UIImageView *tuanzhangImage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeight;

@property(nonatomic,strong)intrestUserModel *model;//模型

@property (nonatomic,weak) id <UserListTableViewCellDelegate> delegate;

@property (nonatomic,strong) NSIndexPath *indexPath;


/**
 *  减脂伙伴设置
 *
 *  @param hidden yes:显示electButton no:隐藏selectButton
 */
- (void)groupTeamSetWithShowSelectButton:(BOOL)showSelectButton;

- (IBAction)headerButtonClick:(id)sender;

@end
