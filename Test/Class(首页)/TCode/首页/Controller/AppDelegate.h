//
//  AppDelegate.h
//  Test
//
//  Created by Rillakkuma on 16/6/1.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kUseScreenShotGesture 1

#if kUseScreenShotGesture
#import "ScreenShotView.h"
#endif
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

#if kUseScreenShotGesture
@property (strong, nonatomic) ScreenShotView *screenshotView;
#endif

+ (AppDelegate* )shareAppDelegate;


@end

