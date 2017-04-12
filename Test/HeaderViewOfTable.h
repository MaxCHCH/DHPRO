//
//  HeaderViewOfTable.h
//  Rent
//
//  Created by 2016mini_03 on 16/7/7.
//  Copyright © 2016年 2016mini_03. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderViewOfTable : UIView

// 截止时间
@property (nonatomic, strong) UILabel *deadlineL;
// 租金单价
@property (nonatomic, strong) UILabel *rentL;
// 物业费单价
@property (nonatomic, strong) UILabel *propertyCostsL;
// 收费周期
@property (nonatomic, strong) UILabel *chargeL;
// 计费方式
@property (nonatomic, strong) UILabel *billingL;
// 保证金
@property (nonatomic, strong) UILabel *marginL;
// 租金总价
@property (nonatomic, strong) UILabel *rentTotalL;





@property (nonatomic, strong) NSArray *dataArray;















@end
