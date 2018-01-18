//
//  WWViewController.h
//  zhidoushi
//
//  Created by xinglei on 14-11-5.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "NSString+Utilities.h"

@implementation NSString (Utilities)

- (BOOL)containsString:(NSString *)aString
{
	NSRange range = [[self lowercaseString] rangeOfString:[aString lowercaseString]];
	return range.location != NSNotFound;
}

- (NSString*)telephoneWithReformat
{
    if ([self containsString:@"-"])
    {
        [self stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    
    if ([self containsString:@" "])
    {
        [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    
    if ([self containsString:@"("])
    {
        [self stringByReplacingOccurrencesOfString:@"(" withString:@""];
    }
    
    if ([self containsString:@")"])
    {
        [self stringByReplacingOccurrencesOfString:@")" withString:@""];
    }
    
    return self;
}
@end
