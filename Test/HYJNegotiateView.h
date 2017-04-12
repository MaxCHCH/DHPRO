//
//  HYJNegotiateView.h
//  HeYiJia
//
//  Created by Jabraknight on 15/3/31.
//  Copyright (c) 2015年 pang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HYJNegotiateViewDelegate<NSObject>

-(void)HYJxxiangqingSizevviewGouwuChe :(NSString *)sender indexPathS:(NSIndexPath *)indexPaths;

@end
@interface HYJNegotiateView : UIView<UITableViewDataSource,UITableViewDelegate>
/**
 *  显示选项
 */
@property (weak, nonatomic) IBOutlet UITableView *tableViewMy;
/**
 *  背景
 */
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;
@property (weak, nonatomic) IBOutlet UIView *viewBackGround;
@property (strong, nonatomic)  NSArray *arrayData;
@property(nonatomic,weak)id<HYJNegotiateViewDelegate>delegate;

+(HYJNegotiateView *)instanceSizeTextView;
@end
