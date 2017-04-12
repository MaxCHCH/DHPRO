//
//  HYBSectionModel.h
//  Test
//
//  Created by Rillakkuma on 16/6/12.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYBSectionModel : NSObject
@property (nonatomic, copy) NSString *sectionTitle;
// 是否是展开的
@property (nonatomic, assign) BOOL isExpanded;
// 分区下面可以有很多个cell对应的模型
@property (nonatomic, strong) NSMutableArray *cellModels;
@end

// 每个cell对应一个这样的model
@interface HYBCellModel : NSObject

@property (nonatomic, copy) NSString *title;

@end
