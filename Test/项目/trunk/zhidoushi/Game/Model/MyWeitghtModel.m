//
//  MyWeitghtModel.m
//  zhidoushi
//
//  Created by xinglei on 14/12/23.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "MyWeitghtModel.h"
#import "WWTolls.h"

@implementation MyWeitghtModel
-(CGFloat)height{
    if (self.logtype) {
        
        if (self.logtype.intValue<6||self.logtype.intValue == 8) {//游戏状态
            CGFloat h = 46;
            if(self.logcontent.length<16) h=46;
            else h = 60;
            return h;
//            self.backView.hidden = YES;
//            self.awardBackGroundView.hidden = YES;
//            self.awardImageView.hidden = YES;
//            self.stageImage.hidden = YES;
//            self.discussImage.frame = CGRectMake(self.discussImage.left, self.stageImage.top, self.discussImage.width, self.discussImage.height);
//            self.discussBackGroundView.frame = CGRectMake(self.discussBackGroundView.left, self.backView.top, self.discussBackGroundView.width, self.discussBackGroundView.height);
//            cellHeight = self.discussBackGroundView.height + 15;
//            self.lineView.height = cellHeight;
//            if (model.logcontent) {
//                
//                NSLog(@"logcontent############%@",model.logcontent);
//                self.discussContentLabel.text = [NSString stringWithFormat:@"%@",self.logcontent];
//            }
            
        }
        else if (self.logtype.intValue==6){//每日提示
            CGFloat h = [WWTolls heightForString:self.logcontent fontSize:12 andWidth:186];
            return 75+h;
            
        }
        else if (self.logtype.intValue==7){//上传记录
            return 120;
            
        }
        else{
            return 0;
        }
    }
    return 0;
}
@end
