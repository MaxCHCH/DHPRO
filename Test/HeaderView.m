//
//  HeaderView.m
//  Test
//
//  Created by Rillakkuma on 16/7/4.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor colorWithRed:0.212 green:0.178 blue:0.667 alpha:1.000];

        for (int i = 0; i<_arrayData.count; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10+i*30, 100, 30)];
            //            label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            label.textColor = [UIColor blackColor];
            label.text = _arrayData[i];
            label.font = [UIFont systemFontOfSize:14];
            [self.contentView addSubview:label];
            self.label = label;
            
        }

    }
        return self;
}
+(instancetype)headerViewWithtableView:(UITableView *)tableView{
    static NSString *ID = @"header";
    HeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header != nil) {
        header = [[HeaderView alloc]initWithReuseIdentifier:ID];
    }
    return header;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
