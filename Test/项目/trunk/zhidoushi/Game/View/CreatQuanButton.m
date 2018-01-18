//
//  CreatQuanButton.m
//  zhidoushi
//
//  Created by glaivelee on 15/11/18.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import "CreatQuanButton.h"

@implementation CreatQuanButton
-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

-(void)awakeFromNib{
    [self setUp];
}

- (void)setUp{
    UILabel *backgroundLabel = [UILabel new];
    backgroundLabel.backgroundColor = [UIColor blackColor];
    backgroundLabel.alpha = 0.3;
    backgroundLabel.frame = self.bounds;
    self.back = backgroundLabel;
//    [self addSubview:backgroundLabel];
    [self insertSubview:backgroundLabel aboveSubview:self.imageView];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.back.frame = self.bounds;
}
-(void)setIsPressdWithTitle:(NSString *)titleStr backgroundImage:(UIImage *)btnImage forState:(UIControlState)state{
    
//    UIImageView *imageBack = [[UIImageView alloc]initWithFrame:self.frame];
//    [imageBack setImage:btnImage];
//    [self addSubview:imageBack];
//    
//    UILabel *backgroundLabel = [UILabel new];
//    backgroundLabel.backgroundColor = [UIColor blackColor];
//    backgroundLabel.alpha = 0.3;
//    [self addSubview:backgroundLabel];
//    
//    UILabel *titleBLabel = [UILabel new];
//    titleBLabel.frame = self.frame;
//    titleBLabel.text = titleStr;
//    [self addSubview:titleBLabel];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
