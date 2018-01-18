//
//  GroupTagView.m
//  zhidoushi
//
//  Created by nick on 15/10/8.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import "GroupTagView.h"
#import "ZdsTagButton.h"

@implementation GroupTagView

-(void)setTags:(NSArray *)tags{
    _tags = tags;
    if (tags.count == 0 && !self.isShowEditor) {
        self.height = 0;
        return;
    }
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.bounces = NO;
    
    //移除之前视图
    for (UIView *chirldView in self.subviews) {
        [chirldView removeFromSuperview];
    }
    CGFloat WidthSumTemp = 10;
    CGFloat margin = 8;
    int rowIndex = 0;
    for (int i =0; i<tags.count; i++) {
        NSString *tagStr = tags[i];
        if(tagStr.length < 1) break;
        WidthSumTemp += margin;
        
        UILabel *tagBtn = [[UILabel alloc] init];
        tagBtn.userInteractionEnabled = NO;
        CGFloat fontWidth = [WWTolls WidthForString:tagStr fontSize:13] + 30;
        
//        WidthSumTemp += fontWidth;
        if (WidthSumTemp + fontWidth > SCREEN_WIDTH - 18) {
                rowIndex ++ ;
                WidthSumTemp = 18;
        }
        
        tagBtn.frame = CGRectMake(WidthSumTemp, rowIndex*38, fontWidth, 30);
        WidthSumTemp += fontWidth;
        tagBtn.textAlignment = NSTextAlignmentCenter;
        tagBtn.font = MyFont(13);
        tagBtn.text = tagStr;
        tagBtn.layer.cornerRadius = 15;
        tagBtn.clipsToBounds = YES;
        tagBtn.textColor = [WWTolls colorWithHexString:@"#FB6C6A"];
        tagBtn.layer.borderColor = [WWTolls colorWithHexString:@"#FCB4B3"].CGColor;
        tagBtn.layer.borderWidth = 1;
//        tagBtn.backgroundColor = ;
        [self addSubview:tagBtn];
        
    }
    if (self.isShowEditor) {
//        WidthSumTemp += 86;
        if (WidthSumTemp + 103 > SCREEN_WIDTH - 18) {
            rowIndex ++ ;
            WidthSumTemp = 18;
        }
        UIButton *editor = [[UIButton alloc] initWithFrame:CGRectMake(WidthSumTemp + margin,rowIndex*38, 103, 30)];
        [editor setBackgroundImage:[UIImage imageNamed:@"tjtzbq-172-50"] forState:UIControlStateNormal];
        [editor addTarget:self action:@selector(editorTagClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:editor];
    }
//    self.contentSize = CGSizeMake(maxWidth + margin, 0);
//    if(maxWidth > SCREEN_WIDTH) self.contentOffset = CGPointMake((maxWidth - SCREEN_WIDTH + margin)/2, 0);
//    if (SCREEN_WIDTH > maxWidth) {
//        self.left = (SCREEN_WIDTH - maxWidth-margin)/2;
//        //            self.bounds = CGRectMake((SCREEN_WIDTH - maxWidth)/2, 0, self.width, self.height);
//    }
    self.height = rowIndex*38 + 30;
    /*
    //计算标签总长
    CGFloat sumWidth = 0;
    for (NSString *tag in tags) {
        sumWidth += [WWTolls WidthForString:tag fontSize:11] + 8*3;
    }
    if (self.isShowEditor) {
        sumWidth += 94;
    }
    //根据总长计算单排还是双排
    if(sumWidth > SCREEN_WIDTH - 20){//双排
        CGFloat WidthSumTemp = 0;
        CGFloat margin = 7;
        CGFloat maxWidth = 0;
        int rowIndex = 0;
        for (int i =0; i<tags.count; i++) {
            NSString *tagStr = tags[i];
            if(tagStr.length < 1) break;
            WidthSumTemp += margin;
            
            ZdsTagButton *tagBtn = [[ZdsTagButton alloc] init];
            tagBtn.userInteractionEnabled = NO;
            CGFloat fontWidth = [WWTolls WidthForString:tagStr fontSize:11] + 16;
            tagBtn.frame = CGRectMake(WidthSumTemp, 15 + rowIndex*33, fontWidth, 25);
            tagBtn.tagStr = tagStr;
            [self addSubview:tagBtn];
            WidthSumTemp += fontWidth;
            if (WidthSumTemp > sumWidth*17/30) {
                if (rowIndex == 0) {
                    rowIndex = 1;
                    maxWidth = WidthSumTemp;
                    WidthSumTemp = (maxWidth - (sumWidth - WidthSumTemp))/2;
                }
            }
        }
        if (self.isShowEditor) {
            UIButton *editor = [[UIButton alloc] initWithFrame:CGRectMake(WidthSumTemp + margin, 48, 86, 25)];
            [editor setBackgroundImage:[UIImage imageNamed:@"tjtzbq-172-50"] forState:UIControlStateNormal];
            [editor addTarget:self action:@selector(editorTagClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:editor];
        }
        self.contentSize = CGSizeMake(maxWidth + margin, 0);
        if(maxWidth > SCREEN_WIDTH) self.contentOffset = CGPointMake((maxWidth - SCREEN_WIDTH + margin)/2, 0);
        if (SCREEN_WIDTH > maxWidth) {
            self.left = (SCREEN_WIDTH - maxWidth-margin)/2;
//            self.bounds = CGRectMake((SCREEN_WIDTH - maxWidth)/2, 0, self.width, self.height);
        }
        self.height = 88;
    }else{//单排
        CGFloat WidthSumTemp = (SCREEN_WIDTH - sumWidth)/2 - 4;
        CGFloat margin = 8;
        for (int i =0; i<tags.count; i++) {
            WidthSumTemp += margin;
            NSString *tagStr = tags[i];
            ZdsTagButton *tagBtn = [[ZdsTagButton alloc] init];
            tagBtn.userInteractionEnabled = NO;
            CGFloat fontWidth = [WWTolls WidthForString:tagStr fontSize:11] + 16;
            tagBtn.frame = CGRectMake(WidthSumTemp, 15, fontWidth, 25);
            tagBtn.tagStr = tagStr;
            [self addSubview:tagBtn];
            WidthSumTemp += fontWidth;
        }
        if (self.isShowEditor) {
            UIButton *editor = [[UIButton alloc] initWithFrame:CGRectMake(WidthSumTemp + (tags.count>0?margin:margin), 15, 86, 25)];
            [editor setBackgroundImage:[UIImage imageNamed:@"tjtzbq-172-50"] forState:UIControlStateNormal];
            [editor addTarget:self action:@selector(editorTagClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:editor];
        }
        self.contentSize = CGSizeMake(SCREEN_WIDTH, 55);
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 55);
        self.height = 55;
    }
    */
}

- (void)editorTagClick:(UIButton *)btn{
    if (self.EditorClick) {
        self.EditorClick();
    }
}

@end
