//
//  ZYCTagsView.h
//  zhidoushi
//
//  Created by Sunshine on 15/11/11.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YCTagsViewCompletionBlock)();


@interface ZYCTagsView : UIView

/**
 *  标签的行数
 */
@property (nonatomic, assign)NSInteger tagsCol;

@property (nonatomic, assign)CGFloat tagMargin;


/**
 *  创建标签
 *
 *  @param tags      标签的文字数组
 *  @param tagColor  标签的文字颜色
 *  @param tagFont   标签的文字大小
 *  @param completed 创建完成后的操作
 */
- (void)createTagLables:(NSArray *)tags withTagColor:(UIColor *)tagColor tagFont:(CGFloat)tagFont completed:(YCTagsViewCompletionBlock)completed;
@end
