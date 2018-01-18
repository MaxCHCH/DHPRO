//
//  NSArray+NARSafeArray.m
//  zhidoushi
//
//  Created by xinglei on 14-11-5.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "NSArray+NARSafeArray.h"

@implementation NSArray (NARSafeArray)

+(id)arrayWithObjectSafe:(id)anObject{
    if (!anObject) {
        NSLog(@"NSArray arrayWithObjectSafe add nil into array");
        return NARReturnAutoreleased([self copy]);
    }
    return [self arrayWithObject:anObject];
}

-(id)objectAtIndexSafe:(NSUInteger)uindex{
    int index=(int)uindex;
    if (index<0||index>=self.count) {
        NSLog(@"NSArray objectAtIndexSafe out of bounds for array , %d out of (0,%lu),array=%@",index,(unsigned long)self.count,self);
        return nil;
    }
    return [self objectAtIndex:index];
}
-(NSArray *)arrayByAddingObjectSafe:(id)anObject{
    if (!anObject) {
        NSLog(@"NSArray arrayByAddingObjectSafe add nil into array,array=%@",self);
        return NARReturnAutoreleased([self copy]);
    }
    return [self arrayByAddingObject:anObject];
}   

@end

@implementation NSMutableArray (YRSafeCategory)


-(void)addObjectSafe:(id)anObject{
    if (!anObject) {
        NSLog(@"NSMutableArray addObjectSafe add nil into array,array=%@",self);
        return;
    }
    [self addObject:anObject];
}
-(void)insertObjectSafe:(id)anObject atIndex:(NSUInteger)index{
    if (!anObject) {
        NSLog(@"NSMutableArray insertObjectSafe insert nil into array,array=%@",self);
        return;
    }
    if (index>=self.count) {
        NSLog(@"NSMutableArray insertObjectSafe insert index out of bounds , do addObject,array=%@",self);
        [self addObjectSafe:anObject];
        return;
    }
    [self insertObject:anObject atIndex:index];
}
-(void)replaceObjectAtIndexSafe:(NSUInteger)uindex withObject:(id)anObject{
    if (!anObject) {
        NSLog(@"NSMutableArray replaceObjectAtIndexSafe relpace nil into array,array=%@",self);
        return;
    }
    int index=(int)uindex;
    if (index<0||index>=self.count) {
        NSLog(@"NSMutableArray replaceObjectAtIndexSafe relpace index out of bounds,%d out of %lu,array=%@",index,(unsigned long)self.count,self);
        return;
    }
    [self replaceObjectAtIndex:index withObject:anObject];
}
-(void)removeObjectAtIndexSafe:(NSUInteger)uindex{
    int index=(int)uindex;
    if (index<0||index>=self.count) {
        NSLog(@"NSMutableArray removeObjectAtIndexSafe index out of bounds ,%d out of %lu,array=%@",index,(unsigned long)self.count,self);
        return;
    }
    [self removeObjectAtIndex:index];
}

@end
