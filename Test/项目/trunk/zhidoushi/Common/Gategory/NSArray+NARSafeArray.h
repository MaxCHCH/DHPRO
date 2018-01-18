//
//  NSArray+NARSafeArray.h
//  zhidoushi
//
//  Created by xinglei on 14-11-5.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (NARSafeArray)

+(id)arrayWithObjectSafe:(id)anObject;
-(id)objectAtIndexSafe:(NSUInteger)uindex;
-(NSArray *)arrayByAddingObjectSafe:(id)anObject;

@end

@interface NSMutableArray (NARSafeArray)

-(void)addObjectSafe:(id)anObject;
-(void)insertObjectSafe:(id)anObject atIndex:(NSUInteger)index;
-(void)replaceObjectAtIndexSafe:(NSUInteger)index withObject:(id)anObject;
-(void)removeObjectAtIndexSafe:(NSUInteger)index;

@end