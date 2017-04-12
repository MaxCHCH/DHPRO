//
//  HeaderView.h
//  Test
//
//  Created by Rillakkuma on 16/7/4.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderView : UITableViewHeaderFooterView
@property (nonatomic, strong)NSArray *arrayData;
@property (nonatomic, strong) UILabel *label;
+ (instancetype)headerViewWithtableView:(UITableView *)tableView;
@end
