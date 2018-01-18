//
//  DiscoverModel.m
//  zhidoushi
//
//  Created by nick on 15/4/20.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "DiscoverModel.h"

@implementation DiscoverModel
+(instancetype)modelWithDic:(NSDictionary*)dic{
    return [[self alloc] initWithDic:dic];
}

-(instancetype)initWithDic:(NSDictionary*)dic{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
-(NSString *)content{
    if (_content.length<1) {
        return @"";
    }
    return [_content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
-(CGFloat)getDiscoverHeight{
    if ([self.showkind isEqualToString:@"1"]) {
        return 197 + 2;
    }
    
    CGFloat h = 156;
    h += [WWTolls heightForString:self.content fontSize:15 andWidth:SCREEN_WIDTH-30];
    if (![WWTolls isNull:self.showimage]) {
        h += SCREEN_WIDTH-30;
        //        h += [WWTolls sizeForQNURLStr:self.showimage].height+13+2;
    }else h-= 15;
    if (self.content.length<1) {
        h -=15;
    }
    return h;
}
//- (NSString *)content {
//    if ([WWTolls isNull:_content]) {
//        _content = @" ";
//    }
//    return _content;
//}

@end
