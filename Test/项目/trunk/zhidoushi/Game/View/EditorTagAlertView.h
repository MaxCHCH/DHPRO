//
//  EditorTagAlertView.h
//  zhidoushi
//
//  Created by nick on 15/9/29.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKKTagWriteView.h"

@class EditorTagAlertView;

@protocol  EditorTagDelegate<NSObject>

@required

- (void)commitEditor:(EditorTagAlertView *)discussAlert;

@end

@interface EditorTagAlertView : UIView
- (instancetype)initWithFrame:(CGRect)frame delegate:(id <EditorTagDelegate>)delegate;
@property(nonatomic,copy)NSString *clickEvent;//来源
@property (nonatomic,weak) id <EditorTagDelegate> delegate;
@property(nonatomic,strong)HKKTagWriteView *tagWriteView;
//创建UI 并传入tags
- (void)createViewWithSelectTags:(NSArray*)selectTags AndHotTags:(NSArray*)hotTags;
@end
