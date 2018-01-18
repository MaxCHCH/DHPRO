//
//  YCImageView.m
//  zhidoushi
//
//  Created by Sunshine on 15/11/16.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import "YCImageView.h"
#import "WWTolls.h"

@implementation YCImageView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    if (!self.clipsToBounds && !self.hidden && self.alpha > 0.0) {
        
        for (UIView *member in self.subviews) {
            CGPoint subPoint = [member convertPoint:point fromView:self];
            UIView *result = [member hitTest:subPoint withEvent:event];
            
            if (result != nil) {
                return result;
            }
        }
    }
    
    return nil;
}
@end
