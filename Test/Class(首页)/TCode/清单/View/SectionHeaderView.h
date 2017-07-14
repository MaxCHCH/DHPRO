//
//  SectionHeaderView.h
//  ContractDetailDemo
//
//  Created by 思 彭 on 2017/4/7.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^expandButtonBlock)(BOOL selected);

@interface SectionHeaderView : UITableViewHeaderFooterView
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, copy) expandButtonBlock block;/**<展开,折叠block */

@end
