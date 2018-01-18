//
//  GroupEditeViewController.h
//  zhidoushi
//
//  Created by glaivelee on 15/11/17.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditGroupDelegate <NSObject>

@optional
-(void)editSuccessWithTags:(NSString*)tags AndContent:(NSString*)content;

@end

@interface GroupEditeViewController : BaseViewController
@property(nonatomic,copy)NSString *groupId;//团组宣言
@property(nonatomic,copy)NSString *groupTags;//团组标签
@property(nonatomic,copy)NSString *groupXuanyan;//团组宣言
@property(nonatomic,strong)NSArray *grouphottags;//热门标签
@property(nonatomic,assign)id<EditGroupDelegate> delegate;//daili
/**
 * 团组标签
 */
@property (weak, nonatomic) IBOutlet UIScrollView *grouptagScrollView;
/**
 * 添加更多标签
 */
@property (weak, nonatomic) IBOutlet UIView *moretagView;
/**
 * 减肥宣言
 */
@property (weak, nonatomic) IBOutlet UITextView *dietdeclarationView;

@end
