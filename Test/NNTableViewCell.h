//
//  NNTableViewCell.h
//  Test
//
//  Created by Rillakkuma on 2016/12/2.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NNTableViewCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UIButton *normalBtn;
@property (weak, nonatomic) IBOutlet UIButton *disnormarBtn;

@end
