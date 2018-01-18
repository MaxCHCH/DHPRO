//
//  SearchResultTableViewCell.m
//  zhidoushi
//
//  Created by xinglei on 14/12/12.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "SearchResultTableViewCell.h"

#import "UIImageView+WebCache.h"
#import "NSURL+MyImageURL.h"
#import "WWTolls.h"
#import "UITableViewCell+SSLSelect.h"
#import "UIButton+WebCache.h"

#import "ZYCTagsView.h"

@interface SearchResultTableViewCell ()


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeight;

@property (weak, nonatomic) IBOutlet ZYCTagsView *tagsView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagsViewMarginY;

@end

@implementation SearchResultTableViewCell

- (void)awakeFromNib {
    
    self.teamLeaderLabel.textColor = [WWTolls colorWithHexString:@"#959595"];
    self.peopleNumberLabel.textColor = [WWTolls colorWithHexString:@"#959595"];

//    [self.showImage makeCorner:5.0];
    
    [self.wheretag makeCorner:8.0];
    self.wheretag.layer.borderColor = [WWTolls colorWithHexString:@"#805efb"].CGColor;
    self.wheretag.layer.borderWidth = 0.5;
    self.lineHeight.constant = 0.5;
    
    
    self.tagsView.tagMargin = 10;
    
    
    self.showImage.layer.borderWidth = 1.0;
    self.showImage.layer.borderColor = [WWTolls colorWithHexString:@"#e2e2e2"].CGColor;
    
    
    
}

-(void)setSearchModel:(HomeGroupModel *)searchModel{

    _searchModel = searchModel;

    NSArray *tagLabels = [searchModel.taglist componentsSeparatedByString:@","];
    /// 标签
//    [self.tagsView createTagLabels:tagLabels completed:^{
//       
//        if (self.tagsView.tagsCol == 1) {
//            self.tagsViewMarginY.constant = 7.5;
//        } else{
//            self.tagsViewMarginY.constant = 10;
//        }
//    }];
    
    [self.tagsView createTagLables:tagLabels withTagColor:[WWTolls colorWithHexString:@"ff5340"] tagFont:12 completed:^{
        
        if (self.tagsView.tagsCol == 1) {
            self.tagsViewMarginY.constant = 7.5;
        } else{
            self.tagsViewMarginY.constant = 10;
        }
    }];
    
    
    
    
    NSURL *imageUrl = [NSURL URLWithImageString:searchModel.imageurl Size:168];
    
    [self.showImage sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"tztx_168_168"]];
    
    self.wheretag.text = [searchModel.gametags componentsSeparatedByString:@","][0];
    self.wheretag.hidden = self.wheretag.text.length<1;
    self.pwdGroupTag.hidden = ![searchModel.ispwd isEqualToString:@"0"];
    self.consPwdGroupTagLeft.constant = self.wheretag.hidden?-34:4;
    self.teamNameLabel.text = [NSString stringWithFormat:@"%@",searchModel.gamename];
    self.teamLeaderLabel.text =[NSString stringWithFormat:@"减脂方法：%@",searchModel.loseway];
    NSString * myString = [NSString stringWithFormat:@"%@-%@",[WWTolls configureTimeString:searchModel.gmbegintime andStringType:@"M.d"],[WWTolls configureTimeString:searchModel.gmendtime andStringType:@"M.d"]];
    self.timeLabel.text = myString;
    self.peopleNumberLabel.text = [NSString stringWithFormat:@"%@",searchModel.totalnumpeo];
    if ([searchModel.gamemode isEqualToString:@"3"]) {///1 28天%4,2 欢乐,3 普通
        self.tipchuangguan.hidden = YES;
        self.tipchuangguanlbl.hidden = YES;
        self.teamLeaderLabel.hidden = YES;
        self.timeImage.hidden = YES;
        self.timeLabel.hidden = YES;
        self.tagsView.hidden = NO;
        
    }else{  
        self.tipchuangguan.hidden = NO;
        self.tipchuangguanlbl.hidden = NO;
        self.teamLeaderLabel.hidden = YES;
        self.timeImage.hidden = NO;
        self.timeLabel.hidden = NO;
        self.tagsView.hidden = YES;
    }
    
    if([searchModel.desctag isEqualToString:@"1"]){
        self.Tag.hidden = NO;
        self.Tag.image = [UIImage imageNamed:@"gft-90-36"];
    }else if([searchModel.desctag isEqualToString:@"2"]){
        self.Tag.hidden = NO;
        self.Tag.image = [UIImage imageNamed:@"ybm-90-36"];
    }else if([searchModel.desctag isEqualToString:@"3"]){
        self.Tag.hidden = NO;
        self.Tag.image = [UIImage imageNamed:@"hot-90-36"];
    }else if([searchModel.desctag isEqualToString:@"4"]){
        self.Tag.hidden = NO;
        self.Tag.image = [UIImage imageNamed:@"new-90-36"];
    }else if([searchModel.isfull isEqualToString:@"0"]){
        self.Tag.hidden = NO;
        self.Tag.image = [UIImage imageNamed:@"ybm-90-36"];
    }else{
        self.Tag.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setHighlighted:(BOOL)highlighted{
    if (highlighted) {
        self.contentView.backgroundColor = [WWTolls colorWithHexString:@"#eaeaea"];
//        self.wheretag.backgroundColor = [WWTolls colorWithHexString:@"#FEC94B"];
    }else{
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    [self setHighlighted:highlighted];
    [self setNeedsDisplay];
}

@end
