//
//  YCGroupCollectionViewCell.m
//  zhidoushi
//
//  Created by Sunshine on 15/11/9.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import "YCGroupCollectionViewCell.h"

#import "UIImageView+WebCache.h"

#import "HomeGroupModel.h"

#import "ZYCTagsView.h"

#import "WWTolls.h"


/** 类扩展 */
@interface YCGroupCollectionViewCell()

/**
 *  团组图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *groupImgView;


/**
 *  团组名称
 */
@property (weak, nonatomic) IBOutlet UILabel *groupName;

/**
 *  团组人数
 */
@property (weak, nonatomic) IBOutlet UILabel *groupRenshu;

/**
 *   团组标签
 */
@property (weak, nonatomic) IBOutlet ZYCTagsView *tagsView;

/**
 *  团组表示
 */
@property (weak, nonatomic) IBOutlet UIImageView *tagImgView;

@end
@implementation YCGroupCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.tagsView.tagMargin = 2;
    
}


-(void)setModel:(HomeGroupModel *)model{
    _model = model;

    [self.groupImgView sd_setImageWithURL:[NSURL URLWithString:model.imageurl]];
    
    self.groupName.text = model.gamename;
    
    self.groupRenshu.text = model.totalnumpeo;

//    NSArray *tagLabels = @[@"跑步", @"游泳", @"足球"];
    
    NSArray *tagLabels = [model.taglist componentsSeparatedByString:@","];
    
    /// 标签
    [self.tagsView createTagLables:tagLabels withTagColor:[WWTolls colorWithHexString:@"ffffff"] tagFont:12 completed:nil];
    
    
    if (model.desctag.length != 0) {
        
        NSString *tagStr = [model.desctag componentsSeparatedByString:@","][0];
        if([tagStr isEqualToString:@"1"]){ // 官方
            self.tagImgView.hidden = NO;
            self.tagImgView.image = [UIImage imageNamed:@"gf-90"];
            
        }else if([tagStr isEqualToString:@"2"]){ // 热门
            self.tagImgView.hidden = NO;
            self.tagImgView.image = [UIImage imageNamed:@"rm-90"];
            
        }else if([tagStr isEqualToString:@"3"]){ // 爆满
            self.tagImgView.hidden = NO;
            self.tagImgView.image = [UIImage imageNamed:@"bm-90"];
            
        }else if([tagStr isEqualToString:@"4"]){ // 新团
            self.tagImgView.hidden = NO;
            self.tagImgView.image = [UIImage imageNamed:@"xin-90"];
        }

    } else {
    
        self.tagImgView.hidden = YES;
    }

}

@end
