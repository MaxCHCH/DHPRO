//
//  MyAttentionModel.m
//  zhidoushi
//
//  Created by xinglei on 15/1/5.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "MyAttentionModel.h"

#import "CoachModel.h"
#import "UIImageView+WebCache.h"
#import "NSURL+MyImageURL.h"

@interface MyAttentionModel ()

@end

@implementation MyAttentionModel

+(void)initWithCoachCell:(MyAttentionTableViewCell *)cell index:(NSInteger)index dataArray:(NSMutableArray*)array judgeIndexArray:(NSMutableSet*)indexJudgeSet;
{
    CoachModel *coach = [array objectAtIndex:index];
    if (coach.usersign == nil) {
        cell.moreLabel.text = @"";
    }else cell.moreLabel.text = [NSString stringWithFormat:@"%@",coach.usersign];
    cell.descripeLabel.text = [NSString stringWithFormat:@"%@",coach.username];
    NSURL *url = [NSURL URLWithImageString:coach.imageurl Size:98];
    [cell.headImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"mrtx_98_98"]];
    cell.rcvuserid = coach.userid;
    cell.flwstatus = coach.flwstatus;
    cell.cellIndex = index;
    if ([coach.usersex isEqualToString:@"1"]) {
        cell.sexIcon.image = [UIImage imageNamed:@"man-28-28"];
    } else {
        cell.sexIcon.image = [UIImage imageNamed:@"woman-28-28"];
    }
    [cell initWithCellAtIndex:indexJudgeSet];
}

+(NSMutableArray*)changesThisCoachModel:(NSMutableArray*)myModelArray andIndex:(NSInteger)index adnSet:(NSMutableSet*)myset andFlwstatus:(NSString*)flwstatus
{
    CoachModel *coach = [myModelArray objectAtIndex:index];
    for (NSString *numberString in myset) {
        if (index==numberString.integerValue) {
            coach.flwstatus = flwstatus;
            [myModelArray replaceObjectAtIndex:numberString.integerValue withObject:coach];
        }
    }
    return myModelArray;
}


@end
@implementation MePhotoModel

@end
@implementation MeWeightModel


@end