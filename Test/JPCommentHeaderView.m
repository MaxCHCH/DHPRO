//
//  JPCommentHeaderView.m
//  Test
//
//  Created by Rillakkuma on 16/6/29.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import "JPCommentHeaderView.h"

@implementation JPCommentHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor redColor];
        // label
//        UILabel *label = [[UILabel alloc] init];
//        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        label.textColor = [UIColor grayColor];
//        label.font = [UIFont systemFontOfSize:14];
//        [self.contentView addSubview:label];
        
        UIView *viewP = [[UIView alloc]init];
        viewP.backgroundColor = [UIColor grayColor];
        viewP.frame = CGRectMake(10, 10, 100, 100);
        [self.contentView addSubview:viewP];
        self.vieL = viewP;
    }
    return self;
}
- (void)setText:(NSString *)text
{
    _text = [text copy];
    self.label.text = text;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
