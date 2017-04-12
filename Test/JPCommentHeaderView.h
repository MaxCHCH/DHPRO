//
//  JPCommentHeaderView.h
//  Test
//
//  Created by Rillakkuma on 16/6/29.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPCommentHeaderView : UITableViewHeaderFooterView
/** 文字属性 */
@property (nonatomic, copy) NSString *text;
/** 内部的label */
@property (nonatomic, weak) UILabel *label;

@property (nonatomic, weak) UIView *vieL;

@end
