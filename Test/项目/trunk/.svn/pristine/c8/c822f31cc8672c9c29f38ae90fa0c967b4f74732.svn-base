//
//  AppDelegate.h
//  zhidoushi
//
//  Created by xinglei on 14-9-10.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GexinSdk.h"

@class ViewController;

typedef enum {
    SdkStatusStoped,
    SdkStatusStarting,
    SdkStatusStarted
} SdkStatus;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSString *_deviceToken;
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) NSMutableArray* faceArray;//表情数组
@property (nonatomic,retain) NSDictionary* faceDict;//表情数组

@property (strong, nonatomic) GexinSdk *gexinPusher;

@property (retain, nonatomic) NSString *appKey;
@property (retain, nonatomic) NSString *appSecret;
@property (retain, nonatomic) NSString *appID;
@property (retain, nonatomic) NSString *clientId;
@property (assign, nonatomic) SdkStatus sdkStatus;

@property (assign, nonatomic) int lastPayloadIndex;

@property (retain, nonatomic) NSString *payloadId;
@property (nonatomic,assign) NSInteger appStoreNum;//苹果推送消息个数

//新浪微博
@property (strong, nonatomic) NSString *wbtoken;
@property (strong, nonatomic) NSString *wbCurrentUserID;

- (void)startSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret;
- (void)stopSdk;

- (void)setDeviceToken:(NSString *)aToken;
- (BOOL)setTags:(NSArray *)aTag error:(NSError **)error;
- (NSString *)sendMessage:(NSData *)body error:(NSError **)error;

- (void)testSdkFunction;
- (void)testSendMessage;

@end
