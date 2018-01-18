//
//  DiscoverReplyModel.m
//  zhidoushi
//
//  Created by nick on 15/4/27.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "DiscoverReplyModel.h"

@implementation DiscoverReplyModel
+(instancetype)modelWithDic:(NSDictionary*)dic{
    return [[self alloc] initWithDic:dic];
}

-(instancetype)initWithDic:(NSDictionary*)dic{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
-(CGFloat)getCellHeight{
    NSString *s;
    if ([self.commentlevel isEqualToString:@"1"]) {
        s = self.content;
    }else{
        s = [NSString stringWithFormat:@"回复%@:%@",self.byusername,self.content];
    }
    CGFloat h = 100;
    h += [WWTolls heightForString:s fontSize:15 andWidth:SCREEN_WIDTH-30];
    if(self.showimage && self.showimage.length > 0){
        NSArray *images = [self.showimage componentsSeparatedByString:@"|"];
        h += 15;
        //循环图片计算高度
        int imageCount = (int)images.count;
        switch (imageCount) {
            case 1:
            {
                CGSize imagesize = [WWTolls sizeForQNURLStr:images[0]];
                h += (SCREEN_WIDTH - 30)*imagesize.height/imagesize.width +15;
            }
                break;
                //3、4张 以上 为九宫格
            case 4:
            case 2:
            {
                CGFloat width = (SCREEN_WIDTH - 30 - 3)/2;
                h += (imageCount/2 - 1)*(width+3) + width;
            }
                break;
                
            case 5:
            case 6:
            case 7:
            case 8:
            case 9:
            case 3:
            {
                CGFloat width = (SCREEN_WIDTH - 30 - 6)/3;
                h += (imageCount/3 - 1)*(width+3) + width;
            }
                break;
                
            default:
                break;
        }
    }
    return h;
}
@end
