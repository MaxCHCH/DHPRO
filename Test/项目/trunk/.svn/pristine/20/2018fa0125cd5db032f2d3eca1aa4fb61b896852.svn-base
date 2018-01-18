//
//  ZDSTagsView.m
//  zhidoushi
//
//  Created by Sunshine on 15/10/30.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import "ZDSTagsView.h"

#import "ZdsTagButton.h"

#import "WWTolls.h"

/** 类扩展 */
@interface ZDSTagsView()

/** 添加按钮 */
@property (weak, nonatomic) UIButton *addButton;

/** 存放所有的标签label */
@property (nonatomic, strong) NSMutableArray *tagLabels;

@property(nonatomic,strong)UIView *hotTagView;//热门标签视图

@end

@implementation ZDSTagsView

/**
 *  标签的间距
 */
CGFloat tagMargin = 6;

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
            ZdsTagButton *lastTagLabel = self.tagLabels[i - 1];
            // 计算当前行左边的宽度
            CGFloat leftWidth = CGRectGetMaxX(lastTagLabel.frame) + tagMargin;
            // 计算当前行右边的宽度
            CGFloat rightWidth = self.width - leftWidth;
            if (rightWidth >= tagLabel.width) { // 按钮显示在当前行
                tagLabel.y = lastTagLabel.y;
                tagLabel.x = leftWidth;
            } else { // 按钮显示在下一行
                tagLabel.x = 0;
                tagLabel.y = CGRectGetMaxY(lastTagLabel.frame) + tagMargin;
                self.tagsCol ++;
            }
            
            // 第2行
            if (tagLabel.y >= tagLabel.height + tagMargin) {
                
                [tagLabel removeFromSuperview];
            }
        }
    }
}

/**
 * 创建标签
 */
- (void)createTagLabels:(NSArray *)tags completed:(TagsViewCompletionBlock)completed
{
 
    [self.tagLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];

    [self.tagLabels removeAllObjects];
    
    self.tagsCol = 1;
    
    for (int i = 0; i<tags.count; i++) {
        
        if (![tags[i]  isEqual: @""]) {
            
            ZdsTagButton *tagBtn = [[ZdsTagButton alloc] init];
            tagBtn.userInteractionEnabled = NO;
            [self.tagLabels addObject:tagBtn];
            tagBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            
            // 应该要先设置文字和字体后，再进行计算x
            tagBtn.height = 16;
            tagBtn.width = [WWTolls WidthForString:tags[i] fontSize:12] + 16;

            tagBtn.tagStr = tags[i];
            
            [self addSubview:tagBtn];

        }
        
        [self layoutIfNeeded];
        
        // 完成后更新布局
        completed();
    }
}

@end


