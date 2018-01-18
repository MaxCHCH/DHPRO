//
//  ZYCTagsView.m
//  zhidoushi
//
//  Created by Sunshine on 15/11/11.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import "ZYCTagsView.h"

#import "YCTagButton.h"

/** 类扩展 */
@interface ZYCTagsView()

/** 添加按钮 */
@property (weak, nonatomic) UIButton *addButton;

/** 存放所有的标签label */
@property (nonatomic, strong) NSMutableArray *tagLabels;

@property(nonatomic,strong)UIView *hotTagView;//热门标签视图
@end


@implementation ZYCTagsView

/**
 *  标签的间距
 */
//CGFloat tagMarginX = 2;

- (NSMutableArray *)tagLabels
{
    if (!_tagLabels) {
        _tagLabels = [NSMutableArray array];
    }
    return _tagLabels;
}


/**
 *  布局子控件(标签)
 */
- (void)layoutSubviews
{
    
    [super layoutSubviews];
    self.tagsCol = 1;
    for (int i = 0; i<self.tagLabels.count; i++) {
        UILabel *tagLabel = self.tagLabels[i];
        
        // 设置位置
        if (i == 0) { // 最前面的标签
            tagLabel.x = 0;
            tagLabel.y = 0;
        } else { // 其他标签
            YCTagButton *lastTagLabel = self.tagLabels[i - 1];
            // 计算当前行左边的宽度
            CGFloat leftWidth = CGRectGetMaxX(lastTagLabel.frame) + self.tagMargin;
            // 计算当前行右边的宽度
            CGFloat rightWidth = self.width - leftWidth;
            if (rightWidth >= tagLabel.width) { // 按钮显示在当前行
                tagLabel.y = lastTagLabel.y;
                tagLabel.x = leftWidth;
            } else { // 按钮显示在下一行
                tagLabel.x = 0;
                tagLabel.y = CGRectGetMaxY(lastTagLabel.frame) + self.tagMargin;
                self.tagsCol ++;
            }
            
            // 第2行
            if (tagLabel.y >= tagLabel.height + self.tagMargin) {
                
                [tagLabel removeFromSuperview];
            }
        }
    }
}

/**
 *  创建标签
 *
 *  @param tags      标签的文字数组
 *  @param tagColor  标签的文字颜色
 *  @param tagFont   标签的文字大小
 *  @param completed 创建完成后的操作
 */
- (void)createTagLables:(NSArray *)tags withTagColor:(UIColor *)tagColor tagFont:(CGFloat)tagFont completed:(YCTagsViewCompletionBlock)completed {

    [self.tagLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.tagLabels removeAllObjects];
    
    self.tagsCol = 1;
    
    for (int i = 0; i<tags.count; i++) {
        
        if (![tags[i]  isEqual: @""]) {
            
            YCTagButton *tagBtn = [[YCTagButton alloc] init];
            
            tagBtn.titleLabel.font = MyFont(tagFont);
            
            [tagBtn setTitleColor:tagColor forState:UIControlStateNormal];
            [tagBtn setTitleColor:tagColor forState:UIControlStateSelected];
            tagBtn.userInteractionEnabled = NO;
            [self.tagLabels addObject:tagBtn];
            tagBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            
            NSString *tagStr = [NSString stringWithFormat:@"#%@", tags[i]];
            
            // 应该要先设置文字和字体后，再进行计算x
            tagBtn.height = 16;
            tagBtn.width = [WWTolls WidthForString:tagStr fontSize:tagFont];

            tagBtn.tagStr = tagStr;
            
            [self addSubview:tagBtn];
            
        }
        
        [self layoutIfNeeded];
        
        if (completed != Nil) {
            
            // 完成后更新布局
            completed();
        }
    }
    
}

@end
