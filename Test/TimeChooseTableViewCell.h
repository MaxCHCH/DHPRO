//
//  TimeChooseTableViewCell.h
//  LeBangProject
//
//  Created by Rillakkuma on 16/7/25.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeChooseTableViewCell : UITableViewCell{
    UIView *dataTimeView;
}
@property (strong, nonatomic)UIButton *disMissBtn;

/**
 *  开始时间
 */
@property (weak, nonatomic) IBOutlet UILabel *labelTimetop;
@property (weak, nonatomic) IBOutlet UILabel *labelTimebottom;
@property (weak, nonatomic) IBOutlet UIButton *buttonLeft;
/**
 *  结束时间
 */
@property (weak, nonatomic) IBOutlet UILabel *labelTimeEndtop;
@property (weak, nonatomic) IBOutlet UILabel *labelTimeEndbottom;
@property (weak, nonatomic) IBOutlet UIButton *buttonRight;
+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
