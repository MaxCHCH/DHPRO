//
//  ZDStagLabel.m
//  zhidoushi
//
//  Created by nick on 15/8/28.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "ZDStagLabel.h"
#import "WPAttributedStyleAction.h"
#import "NSString+WPAttributedMarkup.h"


@implementation ZDStagLabel
-(void)setContent:(NSString *)content WithTagClick:(tagClick)tag AndOtherClick:(otherClick)other{
    self.tagClick = tag;
    self.otherClick = other;
    self.content = content;
}

-(void)setContent:(NSString *)content{
    if (!content || content.length == 0) {
        self.userInteractionEnabled = NO;
        self.text = content;
        return;
    }
    //三个标签
    NSError *error;
    NSString *regulaStr = @"(#([^#＃\n]+?)#)";
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:content options:0 range:NSMakeRange(0, [content length])];
    WEAKSELF_SS
    self.selectionHandler = ^(NSRange range, NSString *string){
        NSError *error;
        NSString *regulaStr = @"^#([^#＃\n]+?)#$";
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr options:NSRegularExpressionCaseInsensitive error:&error];
        if([regex matchesInString:content options:0 range:range].count > 0){
            weakSelf.tagClick(string);
        }else weakSelf.otherClick();
        
    };
    if (arrayOfAllMatches.count>0) {
        NSMutableArray *tags = [NSMutableArray arrayWithObjects:@"",@"",@"", nil];
        NSMutableString *sb = [NSMutableString stringWithString:content];
        [self.selectableRanges removeAllObjects];
        for (int i = 0; i<arrayOfAllMatches.count; i++) {
            if (i>2) {
                break;
            }
            NSTextCheckingResult *match = arrayOfAllMatches[i];
            NSRange tmRange = NSMakeRange(match.range.location+30*i, match.range.length);
            
            [self setSelectableRange:match.range hightlightedBackgroundColor:[WWTolls colorWithHexString:@"#eaeaea"]];
            NSString *tag = [content substringWithRange:match.range];
            [tags replaceObjectAtIndex:i withObject:tag];
            [sb replaceCharactersInRange:tmRange withString:[NSString stringWithFormat:@"</other><help%d>%@</help%d><other>",i,tag,i]];
        }
        self.userInteractionEnabled = YES;
        
        
        NSDictionary* style3 = @{@"body":@[[UIFont fontWithName:@"HelveticaNeue" size:15.0],self.fontColor?self.fontColor:ContentColor],
                                 
                                 @"help0":@[OrangeColor,[WPAttributedStyleAction styledActionWithAction:^{
                                     if (self.tagClick) {
                                         self.tagClick(tags[0]);
                                     }
                                 }]],
                                 @"help1":@[OrangeColor,[WPAttributedStyleAction styledActionWithAction:^{
                                     if (self.tagClick) {
                                         self.tagClick(tags[1]);
                                     }
                                 }]],
                                 @"help2":@[OrangeColor,[WPAttributedStyleAction styledActionWithAction:^{
                                     if (self.tagClick) {
                                         self.tagClick(tags[2]);
                                     }
                                 }]],@"other":[WPAttributedStyleAction styledActionWithAction:^{
                                     if (self.otherClick) {
                                         self.otherClick();
                                     }
                                 }]
                                 };
        
        NSString *attr = [NSString stringWithFormat:@"<other>%@</other>",sb];
        self.attributedText = [attr attributedStringWithStyleBook:style3];
    }else{
        self.userInteractionEnabled = NO;
        self.text = content;
        
        //         NSMutableAttributedString *as = [[NSMutableAttributedString alloc] initWithString:content attributes:nil];
        //         //调整行间距
        //         NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        //         [paragraphStyle setLineSpacing:12];
        //         [as setAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, [as length])];
        //         self.attributedText = as;
    }
    
    /********一个标签
     
     NSRange range = [content rangeOfString:@"(^#([^#]+?)#)" options:NSRegularExpressionSearch];
     if (range.location != NSNotFound&&content.length>0) {
     self.userInteractionEnabled = YES;
     NSString *tagString = [content substringWithRange:range];
     NSString *afterStirng = [content substringWithRange:NSMakeRange(range.location + range.length,content.length - range.length)];
     NSDictionary* style3 = @{@"body":@[[UIFont fontWithName:@"HelveticaNeue" size:15.0],[WWTolls colorWithHexString:@"#535353"]],
     @"help":@[[WWTolls colorWithHexString:@"#ff8a01"],[WPAttributedStyleAction styledActionWithAction:^{
     if (weakSelf.tagClick) {
     weakSelf.tagClick(tagString);
     }
     }]],@"other":[WPAttributedStyleAction styledActionWithAction:^{
     if (weakSelf.otherClick) {
     weakSelf.otherClick();
     }
     }]};
     self.attributedText = [[NSString stringWithFormat:@"<help>%@</help><other>%@</other>",tagString,afterStirng] attributedStringWithStyleBook:style3];
     [self.selectableRanges removeAllObjects];
     [self setSelectableRange:range hightlightedBackgroundColor:[WWTolls colorWithHexString:@"#eaeaea"]];
     
     
     } else {
     self.userInteractionEnabled = NO;
     self.text = content;
     }
     
     ********/
}

@end
