//
//  CustomActionSheet.h
//  iSport2
//
//  Created by xinglei on 13-5-27.
//  Copyright (c) 2013年 xinglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomActionSheet;
@protocol CustomActionSheetDelegate <NSObject>

@optional
- (void)customActionSheet:(CustomActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface CustomActionSheet : UIView

@property (nonatomic, retain) UIImageView* bottomImageView;
@property (nonatomic, assign) id<CustomActionSheetDelegate> delegate;


-(id)initWithTitle:(NSString*)title delegate:(id<CustomActionSheetDelegate>)aDelegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles;

-(void)show;

@end
