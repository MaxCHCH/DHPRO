//
//  NSObject+NARSerializationCategory.m
//  zhidoushi
//
//  Created by xinglei on 14/11/21.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "NSObject+NARSerializationCategory.h"
#import <objc/runtime.h>

#if ! __has_feature(objc_arc)
#define YRRelease(__v) ([__v release]);
#else
#define YRRelease(__v)
#endif

#define DLog  NSLog

@implementation NSObject (NARSerializationCategory)

-(BOOL)supportYRSerialization{
    return true;
}

-(NSArray*)propertyKeys{
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    NSMutableArray *propertyKeys = [NSMutableArray arrayWithCapacity:outCount];
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [propertyKeys addObject:propertyName];
        YRRelease(propertyName);
    }
    free(properties);
    Class superClass=class_getSuperclass([self class]);
    if (superClass != [NSObject class]) {
        NSArray *superPropertyKeys=[superClass propertyKeys];
        if (superPropertyKeys&&[superPropertyKeys count]>0) {
            [propertyKeys addObjectsFromArray:superPropertyKeys];
        }
    }
    return propertyKeys;
}
-(NSDictionary*)savePropertiesToDictionary{
    if ([self isKindOfClass:[NSDictionary class]]||[self isKindOfClass:[NSArray class]]||[self isKindOfClass:[NSValue class]]||[self isKindOfClass:[NSString class]]||[self isKindOfClass:[NSSet class]]) {
        DLog(@"warning : the class %@ can not use this method !please check and use your custom class",[self class]);
        return nil;
    }
    return [self objectToSafeSave:self];
}
-(BOOL)restorePropertiesFromDictionary:(NSDictionary*)dictionary{
    if (!dictionary||![dictionary isKindOfClass:[NSDictionary class]]) {
        return false;
    }
    return [self restorePropertiesFromDictionary:dictionary class:[self class]];
}



-(id)objectToSafeSave:(id)object{
    id resultObj=nil;
    if ([object isKindOfClass:[NSArray class]]) {
        resultObj=[self saveObjectsFromArray:object];
    }else if ([object isKindOfClass:[NSDictionary class]]){
        resultObj=[self saveObjectsFromDictionary:object];
    }else if ([object isKindOfClass:[NSSet class]]){
        resultObj=[self saveObjectsFromSet:object];
    }else if ([object isKindOfClass:[NSString class]]){
        resultObj=object;
    }else if ([object isKindOfClass:[NSValue class]]){
        resultObj=object;
    }else if ([object isKindOfClass:[NSNull class]]){
        resultObj=object;
    }else{
        resultObj=[object saveObjectPropertiesToDictionary];
    }
    return resultObj;
}

-(id)objectToSafeRestore:(id)object{
    id resultObj=nil;
    if ([object isKindOfClass:[NSArray class]]) {
        resultObj=[self restoreObjectsFromArray:object];
    }else if ([object isKindOfClass:[NSDictionary class]]){
        resultObj=[self restoreObjectsFromDictionary:object];
    }else if ([object isKindOfClass:[NSSet class]]){
        resultObj=[self restoreObjectsFromFromSet:object];
    }else if ([object isKindOfClass:[NSString class]]){
        resultObj=object;
    }else if ([object isKindOfClass:[NSValue class]]){
        resultObj=object;
    }else if ([object isKindOfClass:[NSNull class]]){
        resultObj=object;
    }else{
        resultObj=object;
    }
    return resultObj;
}

-(id)saveObjectToSafeStore{
    return [self objectToSafeSave:self];
}

-(id)restoreObjectFromSafeSave:(id)savedObj{
    return [self objectToSafeRestore:savedObj];
}

-(NSArray*)saveObjectsFromArray:(NSArray*)array{
    if (array&&[array isKindOfClass:[NSArray class]]) {
        NSMutableArray *resultArray=[NSMutableArray arrayWithCapacity:[array count]];
        for (id obj in array) {
            id safeObj=[self objectToSafeSave:obj];
            if (safeObj) {
                [resultArray addObject:safeObj];
            }
        }
        return resultArray;
    }
    return nil;
}

-(NSDictionary *)saveObjectsFromDictionary:(NSDictionary*)dictionary{
    if (dictionary&&[dictionary isKindOfClass:[NSDictionary class]]) {
        __block NSMutableDictionary *resultDictionary=[NSMutableDictionary dictionaryWithCapacity:[dictionary count]];
        [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [resultDictionary setObject:[self objectToSafeSave:obj] forKey:key];
        }];
        return resultDictionary;
    }
    return nil;
}
-(NSSet *)saveObjectsFromSet:(NSSet*)set{
    if (set&&[set isKindOfClass:[NSSet class]]) {
        NSMutableSet *resultSet=[NSMutableSet setWithCapacity:[set count]];
        for (id obj in set) {
            id safeObj=[self objectToSafeSave:obj];
            if (safeObj) {
                [resultSet addObject:safeObj];
            }
        }
        return resultSet;
    }
    return nil;
}
-(NSDictionary*)saveObjectPropertiesToDictionary{
    if ([self isKindOfClass:[NSDictionary class]]||[self isKindOfClass:[NSArray class]]||[self isKindOfClass:[NSValue class]]||[self isKindOfClass:[NSString class]]||[self isKindOfClass:[NSSet class]]) {
        DLog(@"warning : the class %@ can not use this method !please check and use your custom class",[self class]);
        return nil;
    }
    NSArray *propertyKeys=[self propertyKeys];
    if ([propertyKeys count]==0) {
        return nil;
    }
    NSMutableDictionary *dictionary=[NSMutableDictionary dictionaryWithCapacity:[propertyKeys count]];
    [dictionary setObject:NSStringFromClass([self class]) forKey:@"__yrname"];
    for (NSString *key in propertyKeys) {
        id propertyValue = [self valueForKey:key];
        if (propertyValue) {
            [dictionary setObject:[self objectToSafeSave:propertyValue] forKey:key];
        }
    }
    return dictionary;
}


-(NSArray*)restoreObjectsFromArray:(NSArray*)array{
    NSMutableArray *resultArray=[NSMutableArray arrayWithCapacity:[array count]];
    for (id obj in array) {
        id safeObj=[self objectToSafeRestore:obj];
        if (safeObj) {
            [resultArray addObject:safeObj];
        }
    }
    return resultArray;
}
-(NSSet*)restoreObjectsFromFromSet:(NSSet*)set{
    NSMutableSet *resultSet=[NSMutableSet setWithCapacity:[set count]];
    for (id obj in set) {
        id safeObj=[self objectToSafeRestore:obj];
        if (safeObj) {
            [resultSet addObject:safeObj];
        }
    }
    return resultSet;
}


-(id)restoreObjectsFromDictionary:(NSDictionary *)dictionary{
    if (!dictionary||![dictionary isKindOfClass:[NSDictionary class]]) {
        return false;
    }
    NSString *subClassName=[dictionary objectForKey:@"__yrname"];
    if (subClassName) {
        Class className=NSClassFromString(subClassName);
        id classObj=[[className alloc]init];
        [classObj restorePropertiesFromDictionary:dictionary class:className];
        return classObj;
    }else{
        __block NSMutableDictionary *resultDictionary=[NSMutableDictionary dictionaryWithCapacity:[dictionary count]];
        [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [resultDictionary setObject:[self objectToSafeRestore:obj] forKey:key];
        }];
        return resultDictionary;
    }
    return nil;
}
-(BOOL)restorePropertiesFromDictionary:(NSDictionary*)dictionary class:(Class)class{
    if (!dictionary||![dictionary isKindOfClass:[NSDictionary class]]) {
        return false;
    }
    BOOL ret = false;
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList(class, &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        if ([dictionary isKindOfClass:[NSDictionary class]]) {
            ret = ([dictionary valueForKey:propertyName]==nil)?false:true;
        }else{
            ret = [dictionary respondsToSelector:NSSelectorFromString(propertyName)];
        }
        if (ret) {
            id propertyValue = [dictionary valueForKey:propertyName];
            if (propertyValue) {
                id safeObj=[self objectToSafeRestore:propertyValue];
                if (safeObj) {
                    [self setValue:safeObj forKey:propertyName];
                }
            }
        }
        YRRelease(propertyName);
    }
    free(properties);
    
    Class superClass=class_getSuperclass(class);
    if (superClass != [NSObject class]) {
        [self restorePropertiesFromDictionary:dictionary class:superClass];
    }
    return ret;
}
//-(BOOL)restorePropertiesFromDictionary:(NSDictionary*)dictionary class:(Class)class{
//    BOOL ret = false;
//    unsigned int outCount;
//    objc_property_t *properties = class_copyPropertyList(class, &outCount);
//    for (int i = 0; i < outCount; i++) {
//        objc_property_t property = properties[i];
//        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
//        if ([dictionary isKindOfClass:[NSDictionary class]]) {
//            ret = ([dictionary valueForKey:propertyName]==nil)?false:true;
//        }else{
//            ret = [dictionary respondsToSelector:NSSelectorFromString(propertyName)];
//        }
//        if (ret) {
//            id propertyValue = [dictionary valueForKey:propertyName];
//            if (propertyValue&&![propertyValue isKindOfClass:[NSNull class]]) {
//                BOOL isSetDone=false;
//                if ([propertyValue isKindOfClass:[NSDictionary class]]) {
//                    NSString *propertyAttributes=[NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
//                    NSArray *tempArray=[propertyAttributes componentsSeparatedByString:@"\""];
//                    if ([tempArray count]>1) {
//                        NSString *className=[tempArray objectAtIndex:1];
//                        if ([propertyAttributes rangeOfString:@"ictionary"].length==0) {//not a dictionary
//                            id subPropertyObj=[[NSClassFromString(className) alloc]init];
//                            [subPropertyObj restorePropertiesFromDictionary:propertyValue];
//                            [self setValue:subPropertyObj forKey:propertyName];
//                            YRRelease(subPropertyObj);
//                            isSetDone=true;
//                        }
//                    }
//                }else if([propertyValue isKindOfClass:[NSArray class]]){
//                    NSArray *subPropertyArray=[self restoreObjectsFromArray:propertyValue];
//                    [self setValue:subPropertyArray forKey:propertyName];
//                    isSetDone=true;
//                }
//                if (!isSetDone) {
//                    [self setValue:propertyValue forKey:propertyName];
//                }
//            }
//        }
//        YRRelease(propertyName);
//    }
//    free(properties);
//
//    Class superClass=class_getSuperclass(class);
//    if (superClass != [NSObject class]) {
//        [self restorePropertiesFromDictionary:dictionary class:superClass];
//    }
//    return ret;
//}


-(id)valueForUndefinedKey:(NSString *)key{
    DLog(@"-->>try to get undefinekey %@ from %@",key,self);
    return nil;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    DLog(@"-->>try to set undefinekey %@ value %@ to %@",key,value,self);
}

@end


@implementation NSArray (YRSerializationCategory)
-(NSArray*)saveObjectsToArray{
    if (self&&[self isKindOfClass:[NSArray class]]) {
        return [super saveObjectsFromArray:self];
    }
    return nil;
}
-(NSArray*)restoreObjectsFromArray{
    if (self&&[self isKindOfClass:[NSArray class]]) {
        return [super restoreObjectsFromArray:self];
    }
    return nil;
}
@end

@implementation NSDictionary (YRSerializationCategory)
-(NSDictionary*)saveObjectsToDictionary{
    if (self&&[self isKindOfClass:[NSDictionary class]]) {
        return [super saveObjectsFromDictionary:self];
    }
    return nil;
}
-(NSDictionary*)restoreObjectsFromDictionary{
    if (self&&[self isKindOfClass:[NSDictionary class]]) {
        return [super restoreObjectsFromDictionary:self];
    }
    return nil;
}

@end
