////
////  TTCacheUtil.m
////  EBCCard
////
////  Created by guligei on 2/17/13.
////  Copyright (c) 2013 totemtec.com. All rights reserved.
////
//
//#import "ZSTCacheUtil.h"
////#import "Preferences.h"
//#import "NSString+MD5.h"
//
//@implementation ZSTCacheUtil
//
//+ (NSString*)documentDirectory
//{
//    
//    static NSString *documentPath = nil;
//    
//    if (documentPath == nil)
//    {
//        NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,   NSUserDomainMask, YES);
//        documentPath = [paths objectAtIndex:0];
//    }
//    
//    return documentPath;
//}
//
//+ (BOOL)writeObject:(id)object toFile:(NSString*)fileName;
//{
//    NSString *filePath = [[ZSTCacheUtil documentDirectory] stringByAppendingPathComponent:fileName];
//    
//    NSData *data = nil;
//    if ([fileName hasSuffix:@".json"])
//    {
//        NSError *error;
//        data = [NSJSONSerialization dataWithJSONObject:object options:kNilOptions error:&error];
//        if (error)
//        {
//            NSLog(@"write cache json error: %@", error.localizedDescription);
//        }
//    }
//    else if([fileName hasSuffix:@".plist"])
//    {
//        data = [NSKeyedArchiver archivedDataWithRootObject:object];
//	}
//    BOOL success = [data writeToFile:filePath atomically:YES];
//    return success;
//}
//
//+ (id)objectFromFile:(NSString *)fileName
//{
//    NSString *filePath = [[ZSTCacheUtil documentDirectory] stringByAppendingPathComponent:fileName];
//    
//    NSData *data = [NSData dataWithContentsOfFile:filePath];
//    if (data == nil)
//    {
//        return nil;
//    }
//    
//    id object = nil;
//    
//    if ([fileName hasSuffix:@".json"])
//    {
//        NSError *error;
//        object = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//        if (error)
//        {
//            NSLog(@"read cache json error: %@", error.localizedDescription);
//        }
//    }
//    else if([fileName hasSuffix:@".plist"])
//    {   
//        object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//	}
//    
//    return object;
//}
//
//
//+ (BOOL)removeObjectForName:(NSString*)aName
//{
//    BOOL isok = NO;
//    NSString *filePath = [[ZSTCacheUtil documentDirectory] stringByAppendingPathComponent:aName];
//    if ([aName isEqualToString:CACHE_MESSAGES_INFO]) {
//        filePath = [[ZSTCacheUtil documentDirectory] stringByAppendingPathComponent:@"caches"];
//    }
//   
//    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
//    {
//        isok = [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
//    }else{
//        return YES;
//    }
//    return isok;
//}
//
//+ (BOOL)cacheObject:(id)object toFile:(NSString*)fileName
//{
//    NSString *MD5Path = [[Preferences shared].phoneNumber MD5String];
//    NSString *filePath = [[[ZSTCacheUtil documentDirectory] stringByAppendingPathComponent:@"caches"] stringByAppendingPathComponent:fileName];
//
//    if (MD5Path) {
//        filePath = [[[ZSTCacheUtil documentDirectory] stringByAppendingPathComponent:@"caches"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",MD5Path,fileName]];
//    }
//    
//    NSFileManager *fm = [NSFileManager defaultManager];
//    NSString *docPath = [[ZSTCacheUtil documentDirectory] stringByAppendingPathComponent:@"caches"];
//    
//    if (![fm fileExistsAtPath:docPath]) {
//        NSDictionary *attributes = [NSDictionary dictionaryWithObject: [NSNumber numberWithUnsignedLong: 0777] forKey: NSFilePosixPermissions];
//        [fm createDirectoryAtPath:docPath withIntermediateDirectories: YES attributes: attributes error: nil];
//    }
//    
//    NSData *data = nil;
//     id object2 = nil;
//    if ([fileName hasSuffix:@".json"])
//    {
//        NSError *error;
//        data = [NSJSONSerialization dataWithJSONObject:object options:kNilOptions error:&error];
//        object2 = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//
//        if (error)
//        {
//            NSLog(@"write cache json error: %@", error.localizedDescription);
//        }
//    }
//    else if([fileName hasSuffix:@".plist"])
//    {
//        data = [NSKeyedArchiver archivedDataWithRootObject:object];
//        object2 = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//	}
//    NSMutableArray *addArr = [NSMutableArray arrayWithArray:[object2 safeObjectForKey:@"info"]];
//    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
//    NSMutableArray *preArray = [mutableDic safeObjectForKey:@"info"];
//    if (preArray) {
//        [addArr addObjectsFromArray:preArray];
//        mutableDic = [NSMutableDictionary dictionaryWithObject:addArr forKey:@"info"];
//    }else{
//        mutableDic = [NSMutableDictionary dictionaryWithObject:addArr forKey:@"info"];
//    }
//
//    BOOL success = [mutableDic writeToFile:filePath atomically:YES];
//    return success;
//}
//
//+ (id)objectsFromFile:(NSString *)fileName
//{
//    NSString *filePath = [[[ZSTCacheUtil documentDirectory] stringByAppendingPathComponent:@"caches"] stringByAppendingPathComponent:fileName];
//    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
//    return mutableDic;
//}
//
//+ (id)objectsFromUserFile:(NSString *)fileName
//{
//    NSString *MD5Path = [[Preferences shared].phoneNumber MD5String];
//    NSString *filePath = [[[ZSTCacheUtil documentDirectory] stringByAppendingPathComponent:@"caches"] stringByAppendingPathComponent:fileName];
//    
//    if (MD5Path) {
//        filePath = [[[ZSTCacheUtil documentDirectory] stringByAppendingPathComponent:@"caches"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",MD5Path,fileName]];
//    }
//    
//    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
//    return mutableDic;
//}
//
//@end
