//
//  EditorLoseWayAlertView.h
//  zhidoushi
//
//  Created by nick on 15/10/14.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  EditorLoseWayDelegate<NSObject>

@required

- (void)commitLoseWay:(NSString *)text;

@end

@interface EditorLoseWayAlertView : UIView
- (instancetype)initWithFrame:(CGRect)frame delegate:(id <EditorLoseWayDelegate>)delegate;

@property (nonatomic,weak) id <EditorLoseWayDelegate> delegate;
//创建UI 并传入tags
- (void)createViewWithLoseWay:(NSString*)loseway;
@end
