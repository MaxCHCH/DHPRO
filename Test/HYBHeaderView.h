//
//  HYBHeaderView.h
//  Test
//
//  Created by Rillakkuma on 16/6/12.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYBHeaderView.h"
#import "HYBSectionModel.h"

//@class HYBSectionModel;
typedef void(^HYBHeaderViewExpandCallback)(BOOL isExpanded);

@interface HYBHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) HYBSectionModel *model;
@property (nonatomic, copy) HYBHeaderViewExpandCallback expandCallback;

@end
