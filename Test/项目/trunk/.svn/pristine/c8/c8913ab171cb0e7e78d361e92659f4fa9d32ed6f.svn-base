//
//  NSObject+NARSerializationCategory.h
//  zhidoushi
//
//  Created by xinglei on 14/11/21.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (NARSerializationCategory)

-(BOOL)supportYRSerialization;

-(NSArray*)propertyKeys;
-(NSDictionary*)savePropertiesToDictionary;//This dictionary can purely be saved to the NSUserDefaults or to a json.
-(BOOL)restorePropertiesFromDictionary:(NSDictionary*)dictionary;//This method make to obj back from the dictionary you previous saved by the savePropertiesToDictionary method.

-(id)saveObjectToSafeStore;
-(id)restoreObjectFromSafeSave:(id)savedObj;

@end

@interface NSArray (YRSerializationCategory)
-(NSArray*)saveObjectsToArray;//This array can purely be saved to the NSUserDefaults or to a json.
-(NSArray*)restoreObjectsFromArray;//This method make to obj back from the array you previous saved by the saveObjectsToArray method.
@end

@interface NSDictionary (YRSerializationCategory)
-(NSDictionary*)saveObjectsToDictionary;//This dictionary can purely be saved to the NSUserDefaults or to a json.
-(NSDictionary*)restoreObjectsFromDictionary;//This method make to obj back from the dictionary you previous saved by the saveObjectsToDictionary method.
@end
