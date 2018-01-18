//
//  homeHotCell.m
//  zhidoushi
//
//  Created by nick on 15/4/21.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "homeHotCell.h"
#import "TagImageView.h"

@interface homeHotCell()
//@property (weak, nonatomic) IBOutlet UILabel *bottomLbl;
//@property (weak, nonatomic) IBOutlet UILabel *topLbl;
//@property (weak, nonatomic) IBOutlet UIImageView *topBkView;
//@property (weak, nonatomic) IBOutlet UIImageView *bottomBkView;
@property (weak, nonatomic) IBOutlet TagImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *GroupName;
@property (weak, nonatomic) IBOutlet UILabel *PersonSum;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UIView *bkview;
@property (weak, nonatomic) IBOutlet UIButton *joinBtn;
@end

@implementation homeHotCell

- (void)awakeFromNib {
    // Initialization code
    self.GroupName.textColor = [WWTolls colorWithHexString:@"#626262"];
    self.PersonSum.textColor = [WWTolls colorWithHexString:@"#959595"];
    self.timeLbl.textColor = [WWTolls colorWithHexString:@"#959595"];
    self.GroupName.font = MyFont(14);
    self.PersonSum.font = MyFont(14);
    self.timeLbl.font = MyFont(14);
//    self.clipsToBounds = YES;
//    self.layer.cornerRadius = 5;
    self.bkview.layer.cornerRadius = 3;
    self.bkview.clipsToBounds = YES;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"homeHotCell" owner:self options:nil];
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
        self.headImageView.backgroundColor = [UIColor whiteColor];
    }
    return self;

}
-(void)setModel:(HomeGroupModel *)model{
    _model = model;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.imageurl]];
    self.GroupName.text = model.gamename;
    self.PersonSum.text = model.totalnumpeo;
//    self.joinBtn.hidden = [model.isjoin isEqualToString:@"1"];
    if ([model.gamemode isEqualToString:@"1"]) {
        [self.joinBtn setBackgroundImage:[UIImage imageNamed:@"home_chuangguan_tip"] forState:UIControlStateNormal];
    }else if ([model.gamemode isEqualToString:@"2"]){
        [self.joinBtn setBackgroundImage:[UIImage imageNamed:@"home_happy_tip"] forState:UIControlStateNormal];
    }

    NSString * myString = [NSString stringWithFormat:@"%@-%@",[WWTolls configureTimeString:model.gmbegintime andStringType:@"M.d"],[WWTolls configureTimeString:model.gmendtime andStringType:@"M.d"]];
    self.timeLbl.text = myString;
    self.headImageView.tags = model.gametags;
//    NSArray *tags = [model.gametags componentsSeparatedByString:@","];
//    //隐藏标签
//    self.bottomLbl.hidden = YES;
//    self.bottomBkView.hidden = YES;
//    self.topLbl.hidden = YES;
//    self.topBkView.hidden = YES;
//    NSString *sn = (NSString*)tags[0];
//    if(sn.length>0){//瘦哪里标签
//        self.topLbl.hidden = NO;
//        self.topBkView.hidden = NO;
//        self.topLbl.text = [sn componentsSeparatedByString:@"|"][0];
//
//    }
//    NSString *zms = (NSString*)tags[1];
//    if(zms.length>0){//怎么瘦标签
//        self.bottomLbl.hidden = NO;
//        self.bottomBkView.hidden = NO;
//        self.bottomLbl.text = [zms componentsSeparatedByString:@"|"][0];
//    }
}

@end
