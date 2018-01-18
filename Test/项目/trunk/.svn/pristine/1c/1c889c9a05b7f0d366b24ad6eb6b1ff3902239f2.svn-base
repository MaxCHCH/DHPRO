//
//  NARTextField.m
//  zhidoushi
//
//  Created by xinglei on 14-11-5.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "NARTextField.h"

@implementation NARTextField

-(instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
        _placeholderColor = self.textColor;
    }
    return self;
}

-(void)drawPlaceholderInRect:(CGRect)rect{
    [_placeholderColor setFill];
    if ([[[UIDevice currentDevice]systemVersion]compare:@"7.0"]==NSOrderedAscending) {
        [self.placeholder drawInRect:rect withFont:self.font];
    }else{
        CGRect placeholderRect = CGRectMake(rect.origin.x, (rect.size.height- self.font.pointSize)/2-2, rect.size.width, self.font.pointSize+4);//设置距离
        NSMutableDictionary *dictionary=[NSMutableDictionary dictionaryWithCapacity:3];
        [dictionary setObject:self.font forKey:NSFontAttributeName];
        [dictionary setObject:_placeholderColor forKey:NSForegroundColorAttributeName];
        NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
        [paragraphStyle setAlignment:self.textAlignment];
        [dictionary setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        [self.placeholder drawInRect:placeholderRect withAttributes:dictionary];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
