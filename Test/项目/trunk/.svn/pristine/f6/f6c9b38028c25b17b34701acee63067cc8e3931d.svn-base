//
//  DataService.m
//  zhidoushi
//
//  Created by xinglei on 14-9-22.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "DataService.h"

#import "NSURL+MyImageURL.h"

@implementation DataService

+(void)requestWithURL:(NSString *)urlString
          finishBlock:(FinishLoadHandle)successBlock
       failLoadHandle:(FailLoadHandle)failBlock

{
    
    NSURL *url = [NSURL URLWithImageString:urlString Size:0];
    
    __block NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    
    request.timeoutInterval = 5;
    
//    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
//    AFJSONRequestOperation * operation = [[AFJSONRequestOperation alloc]init];
//    operation =
//    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
//                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
//                                                        //                                                        NSDictionary *allDic  = (NSDictionary *)JSON;
//                                                        
//                                                        if (successBlock) {
//                                                            successBlock(JSON);
//                                                        }
//                                                    }
//                                                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
//                                                        NSString *errorAll = [NSString stringWithFormat:@"%@",error];
//                                                        NSString *errorkey = [NSString stringWithFormat:@"Code=-1009"];
//                                                        NSString *errorkey2 = [NSString stringWithFormat:@"Code=-1016"];
//                                                        NSLog(@"请求全部活动失败..请检查网络.");
//                                                        
//                                                        if (failBlock) {
//                                                            failBlock(error);
//                                                        }
//                                                        if ([errorAll rangeOfString:errorkey].location != NSNotFound ) {
//                                                            
//                                                        }else if ([errorAll rangeOfString:errorkey2].location != NSNotFound ) {
//                                                            
//                                                        }
//                                                    }];
//    
//    [operation start];
    
}

@end
