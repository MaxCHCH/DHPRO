//
//  NSObject+Log.m
//  HighCourt
//
//  Created by ludawei on 13-9-24.
//  Copyright (c) 2013年 ludawei. All rights reserved.
//

#import "NSObject+Log.h"
#import <objc/runtime.h>

@implementation NSObject (Log)

-(NSString *)logClassData
{
    NSArray *keys = [self allKeys];
    
    NSMutableString *logString = [NSMutableString string];
    for (NSString *propertyName in keys)
    {
        [logString appendFormat:@"\n%@ : %@", propertyName, [self valueForKey:propertyName]];
    }
    
//    NSLog(@"logData---%@  %@", self.class, logString);
    return logString;
}

// 得到所有的keys
-(NSArray *)allKeys
{   
    unsigned int outCount, i;
    
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity:outCount];
    
    for (i = 0; i < outCount; i++) {
        
        objc_property_t property = properties[i];
                
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        
        [keys addObject:propertyName];
        
    }
    
    if (self.superclass != [NSObject class])
    {
        [keys addObjectsFromArray:[objc_getClass([NSStringFromClass(self.superclass) UTF8String]) allKeys]];
    }
    
    free(properties);
    
    return keys;
}
@end
