//
//  HTCopyableButton.h
//  zhidoushi
//
//  Created by nick on 15/5/28.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HTCopyableButton;

@protocol HTCopyableLabelDelegate <NSObject>

@optional
- (NSString *)stringToCopyForCopyableLabel:(HTCopyableButton *)copyableLabel;
- (CGRect)copyMenuTargetRectInCopyableLabelCoordinates:(HTCopyableButton *)copyableLabel;

@end
@interface HTCopyableButton : UIButton
@property (nonatomic, assign) BOOL copyingEnabled; // Defaults to YES

@property (nonatomic, weak) id<HTCopyableLabelDelegate> copyableLabelDelegate;

@property (nonatomic, assign) UIMenuControllerArrowDirection copyMenuArrowDirection; // Defaults to UIMenuControllerArrowDefault

// You may want to add longPressGestureRecognizer to a container view
@property (nonatomic, strong, readonly) UILongPressGestureRecognizer *longPressGestureRecognizer;
@end
