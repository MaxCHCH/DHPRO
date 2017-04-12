//
//  SystermSetting.h
//  Test
//
//  Created by Rillakkuma on 2016/11/18.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystermSetting : NSObject
+ (SystermSetting *)ba_systermSettingManage;
/*!
 *  跳到WIFI界面
 */
- (void)ba_gotoSystermWIFISettings;
@end
