//
//  ZdsTagButton.m
//  zhidoushi
//
//  Created by nick on 15/9/29.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import "ZdsTagButton.h"

@implementation ZdsTagButton

-(void)setTagStr:(NSString *)tagStr{
    _tagStr = tagStr;
    self.layer.cornerRadius = self.bounds.size.height*0.5;
    self.clipsToBounds = YES;
    self.titleLabel.font = MyFont(13);
    [self setTitle:tagStr forState:UIControlStateNormal];
    UIColor *tagColor = ContentColor;
    [self setTitleColor:tagColor forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
//    int lengths = (int)[tagStr lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
//    int leng = (lengths+2)/3;
//    switch (leng) {
//        case 1:
//            tagColor = [WWTolls colorWithHexString:@"#ff4f4e"];
//            break;
//        case 2:
//            tagColor = [WWTolls colorWithHexString:@"#eb5b9f"];
//            break;
//        case 3:
//            tagColor = [WWTolls colorWithHexString:@"#ffb65e"];
//            break;
//        case 4:
//            tagColor = [WWTolls colorWithHexString:@"#896afb"];
//            break;
//        case 5:
//            tagColor = [WWTolls colorWithHexString:@"#36bef8"];
//            break;
//        default:
//            break;
//    }
    self.layer.borderColor = tagColor.CGColor;
    self.layer.borderWidth = 0.5;
    [self setTitleColor:tagColor forState:UIControlStateNormal];
    [self setBackgroundImage:[WWTolls imageWithColor:OrangeColor size:self.bounds.size] forState:UIControlStateSelected];
    [self setBackgroundImage:[WWTolls imageWithColor:[UIColor whiteColor] size:self.bounds.size] forState:UIControlStateNormal];
}
-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        self.layer.borderWidth = 0;
    }else self.layer.borderWidth = 0.5;
}
@end
