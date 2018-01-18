//
//  DataService.h
//  zhidoushi
//
//  Created by xinglei on 14-9-22.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^FinishLoadHandle)(id result);
typedef void (^FailLoadHandle)(id result);

@interface DataService : NSObject

+(void)requestWithURL:(NSString *)urlString
          finishBlock:(FinishLoadHandle)successBlock
       failLoadHandle:(FailLoadHandle)failBlock;

@end
