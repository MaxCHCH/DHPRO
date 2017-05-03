//
//  CeModel.h
//  Test
//
//  Created by Rillakkuma on 2017/5/2.
//  Copyright © 2017年 Rillakkuma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CrModel.h"
@interface CeModel : NSObject
@property (nonatomic,copy)NSString *gc_id;
@property (nonatomic,copy)NSString *gc_name;
@property (nonatomic,retain)NSArray<CrModel *>*child_list;

@end
