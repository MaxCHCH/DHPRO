//
//  EmployeeDetail.m
//  LeBangProject
//
//  Created by Rillakkuma on 16/7/19.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
	
}
- (void)setNilValueForKey:(NSString *)key{
	
}
-  (void)setValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues{
	[keyedValues enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
		
		if ([obj isKindOfClass:[NSNull class]]) {
			obj = @"";
		}
		
	}];
	[super setValuesForKeysWithDictionary:keyedValues];
}

@end
