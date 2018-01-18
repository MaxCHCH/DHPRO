//
//  HotTagView.m
//  zhidoushi
//
//  Created by licy on 15/7/24.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "HotTagView.h"

@interface HotTagView ()

@property (nonatomic,strong) NSMutableArray *buttonArray;

@end

@implementation HotTagView

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame tagArray:(NSMutableArray *)tagArray {
    if (self = [super initWithFrame:frame]) {
        
        [self createViewWithTagArray:tagArray];
    }
    return self;
}

#pragma mark - UI
- (void)createViewWithTagArray:(NSMutableArray *)tagArray {
    
    //    [self makeCorner:1.0];
    self.backgroundColor = [UIColor whiteColor];
    
    CGFloat margin = 15;
    CGFloat btnHeight = 40;
    CGFloat btnWidth = (SCREEN_WIDTH-3*margin)/2;
    for (int i = 0; i < tagArray.count; i++){
        UIButton *cButton = [[UIButton alloc] initWithFrame:CGRectMake(margin + i%2*(SCREEN_WIDTH/2 - margin/2), i/2*(btnHeight+margin), btnWidth, btnHeight)];
        //        cButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
        [cButton setImage:nil forState:UIControlStateHighlighted];
        [self addSubview:cButton];
        cButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [cButton makeCorner:btnHeight / 2];
        cButton.clipsToBounds = YES;
        cButton.layer.cornerRadius = btnHeight/2;
        //        cButton.layer.borderWidth = 0.5;
        //        cButton.layer.borderColor = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;
        [cButton setTitle:tagArray[i] forState:UIControlStateNormal];
        [cButton setTitleColor:ContentColor forState:UIControlStateNormal];
        cButton.titleLabel.font = MyFont(15.0);
        
        [cButton setBackgroundImage:[self imageWithColor:[WWTolls colorWithHexString:@"#F0EAEA"] size:CGSizeMake(btnWidth, btnHeight)] forState:UIControlStateNormal];
        
        [cButton addTarget:self action:@selector(cButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        self.height = cButton.bottom + margin;
        
    }
    
    
    //    CGFloat edgeSpace = 10;
    //    CGFloat edgeVeSpace = 15;
    //    CGFloat hoSpace = 10;
    //    CGFloat veSpace = 10;
    //    
    //    for (int i = 0; i < tagArray.count; i++) {
    //        
    //        //上一个button  初始化
    //        UIButton *lastButton = nil;
    //        
    //        //如果button数组不为空  取出上一个button
    //        if (self.buttonArray.count > 0) {
    //            lastButton = [self.buttonArray lastObject];
    //        }
    //        
    //        NSString *title = tagArray[i];
    //        CGFloat totalWidth = self.width - edgeSpace * 2;
    //        
    //        NSLog(@"totalWidth:%f",totalWidth);
    //        
    //        CGFloat height = [WWTolls heightForString:title fontSize:14 andWidth:totalWidth];
    //        CGFloat width = [WWTolls WidthForString:title fontSize:14 andHeight:14];
    //        
    //        height = 30;
    //        
    //        width += 17.7;
    //        
    //        if (width > (SCREEN_WIDTH - 20)) {
    //            width = SCREEN_WIDTH - 20;
    //        }
    //                
    //        CGFloat tX = 0;
    //        CGFloat ty = 0;
    //        
    //        //不是第一个button
    //        if (lastButton != nil) {
    //            
    //            NSLog(@"lastButton.maxX:%f hoSpace:%f width:%f",lastButton.maxX,hoSpace,width);
    //            //在此行不够放的时候
    //            if ((totalWidth - lastButton.maxX - hoSpace) < width) {
    //                ty = lastButton.maxY;
    //                tX = 0;
    //                ty += veSpace;
    //                //能放在此行
    //            } else {
    //                ty = lastButton.y;
    //                tX = lastButton.maxX;
    //            }
    //        } else {
    //            ty += edgeVeSpace;
    //        }   
    //        
    //        if (tX == 0) {
    //            tX = edgeSpace;
    //        } else {
    //            tX += hoSpace;
    //        }
    //        
    //        UIButton *cButton = [[UIButton alloc] initWithFrame:CGRectMake(tX, ty, width, height)];
    ////        cButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    //        [cButton setImage:nil forState:UIControlStateHighlighted];
    //        [self addSubview:cButton];
    //         cButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    //        [cButton makeCorner:height / 2];
    //        cButton.clipsToBounds = YES;
    //        cButton.layer.cornerRadius = height/2;
    //        cButton.layer.borderWidth = 0.5;
    //        cButton.layer.borderColor = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;
    //        [cButton setTitle:tagArray[i] forState:UIControlStateNormal];
    //        [cButton setTitleColor:[WWTolls colorWithHexString:@"#ff8a01"] forState:UIControlStateNormal];
    //        cButton.titleLabel.font = MyFont(14.0);
    //        
    //        [cButton setBackgroundImage:[self imageWithColor:[WWTolls colorWithHexString:@"#eaeaea"] size:CGSizeMake(width, height)] forState:UIControlStateHighlighted];
    //        
    //        [cButton addTarget:self action:@selector(cButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //        
    //        [self.buttonArray addObject:cButton];
    //        
    //        //如果是最后一个
    //        if (i == (tagArray.count - 1)) {
    //            self.height = cButton.maxY + 1 + edgeVeSpace;
    //        }
    //    }
}

#pragma mark - Event Responses

#pragma mark 选择某个热门标签
- (void)cButtonClick:(UIButton *)button {
    
    if ([self.delegate respondsToSelector:@selector(hotTagView:selectButtonWithTitle:)]) {
        [self.delegate hotTagView:self selectButtonWithTitle:button.titleLabel.text];
    }
}

#pragma mark - Private Methods
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - Getters And Setters
- (NSMutableArray *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}



@end
