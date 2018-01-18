//
//  NSDictionary+NARSafeDictionary.h
//  zhidoushi
//
//  Created by xinglei on 14/12/13.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NARSafeDictionary)

+(instancetype)dictionaryWithObjectSafe:(id)object forKey:(id<NSCopying>)key;
-(id)objectForKeySafe:(id)akey;

@end

@interface NSMutableDictionary (NARSafeDictionary)
-(NSMutableDictionary*)safeMutableDictionary;
-(void)setObjectSafe:(id)anObject forKey:(id<NSCopying>)aKey;
@end