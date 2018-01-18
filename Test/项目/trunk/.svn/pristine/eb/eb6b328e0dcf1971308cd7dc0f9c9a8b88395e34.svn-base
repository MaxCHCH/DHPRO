//
//  NSDictionary+NARSafeDictionary.m
//  zhidoushi
//
//  Created by xinglei on 14/12/13.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "NSDictionary+NARSafeDictionary.h"

@implementation NSDictionary (NARSafeDictionary)

+(instancetype)dictionaryWithObjectSafe:(id)object forKey:(id<NSCopying>)key
{
    if (!key || !object) {
        return nil;
    }
    return [self dictionaryWithObjectSafe:object forKey:key];
}

-(instancetype)objectForKeySafe:(id)akey
{
    if (!akey) {
        return nil;
    }
    if (![self objectForKey:akey]){
        return nil;
    }
    return [self objectForKey:akey];
}

@end

@implementation NSMutableDictionary (NARSafeDictionary)

-(NSMutableDictionary*)safeMutableDictionary
{
    return [self copy];
}

-(void)setObjectSafe:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (!anObject || !aKey) {
        return;
    }
    return [self setObjectSafe:anObject forKey:aKey];
}

@end