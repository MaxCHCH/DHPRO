//
//  HeaderViewOfTable.m
//  Rent
//
//  Created by 2016mini_03 on 16/7/7.
//  Copyright © 2016年 2016mini_03. All rights reserved.
//

#import "HeaderViewOfTable.h"

@implementation HeaderViewOfTable
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        __weak typeof(self)weakSelf = self;
        NSArray *arr = @[@"合同号:",@"客户名称:",@"计算面积:",@"开始时间:",
                         @"截止时间:",@"租金单价:",@"物业费单价:",@"收费周期:",
                         @"计费方式:",@"保证金:",@"租金总价:"];
        for (int i = 0; i<11; i++) {
            UILabel *nameLabel = [[UILabel alloc]init];
            nameLabel.frame = CGRectMake(0, 5+20*i, 100, 18);
            nameLabel.font = [UIFont systemFontOfSize:14];
            nameLabel.text = arr[i];
            [self addSubview:nameLabel];

        }
        
        for (int i = 0; i<11; i++) {
            UILabel *detailLabel = [[UILabel alloc]init];
            
            [self addSubview:detailLabel];
            
        }
//      截止时间
        
        self.deadlineL = [[UILabel alloc]init];
        self.deadlineL.font = [UIFont systemFontOfSize:14];
        self.deadlineL.text = @"截止时间:2017-12-30";
        self.deadlineL.textColor = [UIColor lightGrayColor];
        self.deadlineL.numberOfLines = 0;
//        self.deadlineL.frame = CGRectMake(0, 0, 100, 20);
        [self addSubview:self.deadlineL];
//        [self.deadlineL mas_makeConstraints:^(MASConstraintMaker *make) {
//           
//            make.left.mas_equalTo(10);
//            make.right.mas_equalTo(-10);
//            make.top.mas_equalTo(10);
//            make.height.equalTo(@(20));
//    
//        
//           }];
//  
//  租金单价
        
        self.rentL = [UILabel new];
        self.rentL.font = [UIFont systemFontOfSize:14];
        self.rentL.textColor = [UIColor lightGrayColor];
        self.rentL.numberOfLines = 0;
        self.rentL.text = @"租金单价:5.0";
//        self.rentL.frame = CGRectMake(0, self.deadlineL.frame.size.height, 100, 20);
        [self addSubview:self.rentL];
        
//        [self.rentL mas_makeConstraints:^(MASConstraintMaker *make) {
//           
//            make.left.right.mas_equalTo(weakSelf.deadlineL);
//            make.top.mas_equalTo(weakSelf.deadlineL.mas_bottom).offset(10);
//            make.height.equalTo(@(20));
//            
//        }];
        
//  物业费单价
        
        self.propertyCostsL = [UILabel new];
        
        self.propertyCostsL.textColor = [UIColor lightGrayColor];
        self.propertyCostsL.font = [UIFont systemFontOfSize:14];
        self.propertyCostsL.numberOfLines = 0;
        self.propertyCostsL.text = @"物业费单价:3.0";
        
        [self addSubview:self.propertyCostsL];
        
//        [self.propertyCostsL mas_makeConstraints:^(MASConstraintMaker *make) {
//           
//            make.left.right.mas_equalTo(weakSelf.rentL);
//            make.top.mas_equalTo(weakSelf.rentL.mas_bottom).offset(10);
//            make.height.mas_equalTo(weakSelf.rentL);
//            
//        }];
        
//  收费周期
        
        self.chargeL = [UILabel new];
        self.chargeL.text = @"收费周期:年";
        
        self.chargeL.textColor = [UIColor lightGrayColor];
        self.chargeL.font = [UIFont systemFontOfSize:14];
        self.chargeL.numberOfLines = 0;
        
        [self addSubview:self.chargeL];
        
//        [self.chargeL mas_makeConstraints:^(MASConstraintMaker *make) {
//           
//            make.left.right.mas_equalTo(weakSelf.propertyCostsL);
//            
//            make.top.mas_equalTo(weakSelf.propertyCostsL.mas_bottom).offset(10);
//            make.height.mas_equalTo(weakSelf.propertyCostsL);
//        
//        }];
        
//   计费方式
        
        self.billingL = [UILabel new];
        self.billingL.textColor = [UIColor lightGrayColor];
        self.billingL.text = @"计费方式:单价";
        self.billingL.font = [UIFont systemFontOfSize:14];
        self.billingL.numberOfLines = 0;
        
        [self addSubview:self.billingL];
        
//        [self.billingL mas_makeConstraints:^(MASConstraintMaker *make) {
//           
//            make.left.right.mas_equalTo(weakSelf.chargeL);
//            make.top.mas_equalTo(weakSelf.chargeL.mas_bottom).offset(10);
//            make.height.mas_equalTo(weakSelf.chargeL);
//            
//            
//            
//        }];
        
//    保证金
        self.marginL = [UILabel new];
        self.marginL.font = [UIFont systemFontOfSize:14];
        self.marginL.text = @"保证金:4.0";
        self.marginL.textColor = [UIColor lightGrayColor];
        self.marginL.numberOfLines = 0;
        [self addSubview:self.marginL];
        
        
//        [self.marginL mas_makeConstraints:^(MASConstraintMaker *make) {
//           
//            make.left.right.mas_equalTo(weakSelf.billingL);
//            make.top.mas_equalTo(weakSelf.billingL.mas_bottom).offset(10);
//            make.height.mas_equalTo(weakSelf.billingL);
//            
//            
//            
//        }];
      
//     租金总价
        
        self.rentTotalL = [UILabel new];
        self.rentTotalL.textColor = [UIColor lightGrayColor];
        self.rentTotalL.font = [UIFont systemFontOfSize:14];
        self.rentTotalL.numberOfLines = 0;
        self.rentTotalL.text = @"租金总价:15.02";
        [self addSubview:self.rentTotalL];
        
//        [self.rentTotalL mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.mas_equalTo(weakSelf.marginL);
//            make.top.mas_equalTo(weakSelf.marginL.mas_bottom).offset(10);
//            make.height.equalTo(@(20));
//            
//        }];
        
    }
    
    self.backgroundColor = [UIColor whiteColor];
    
    
    
    return self;
    
}





@end
