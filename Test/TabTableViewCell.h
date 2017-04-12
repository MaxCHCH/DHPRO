//
//  TabTableViewCell.h
//  Test
//
//  Created by Rillakkuma on 2016/10/20.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *chooseButton;
@property (weak, nonatomic) IBOutlet UIButton *chooseSubButton;

+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
