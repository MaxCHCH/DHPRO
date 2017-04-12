//
//  CCTableViewCell.h
//  Test
//
//  Created by Rillakkuma on 2016/12/2.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCTableViewCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@end
