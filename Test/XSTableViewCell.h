//
//  XSTableViewCell.h
//  LeBangProject
//
//  Created by Rillakkuma on 16/8/10.
//  Copyright © 2016年 zhongkehuabo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XSTableViewCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UIButton *chooseButton;
@property (weak, nonatomic) IBOutlet UIButton *chooseSubButton;
@property (weak, nonatomic) IBOutlet UITextField *textFieldTxt;
@property (weak, nonatomic) IBOutlet UILabel *nameLabeltxt;

@end
