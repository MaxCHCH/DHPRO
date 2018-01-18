//
//  HomeGroupCollectionViewCell.m
//  zhidoushi
//
//  Created by nick on 15/4/20.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "HomeGroupCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "WWTolls.h"
#import "TagImageView.h"

@interface HomeGroupCollectionViewCell()
@property (weak, nonatomic) IBOutlet TagImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *GroupName;
@property (weak, nonatomic) IBOutlet UILabel *PersonSum;
@property (weak, nonatomic) IBOutlet UIView *outCorner;
@property (weak, nonatomic) IBOutlet UIView *innerCorner;
@property (weak, nonatomic) IBOutlet UIImageView *shibai;

@end

@implementation HomeGroupCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.outCorner.backgroundColor = [UIColor whiteColor];
    self.innerCorner.backgroundColor = [UIColor whiteColor];
    self.innerCorner.layer.cornerRadius = 2.5;
    self.innerCorner.clipsToBounds = YES;
    self.GroupName.textColor = [WWTolls colorWithHexString:@"#626262"];
    self.PersonSum.textColor = [WWTolls colorWithHexString:@"#959595"];
    self.timeLbl.textColor = [WWTolls colorWithHexString:@"#959595"];
    self.GroupName.font = MyFont(13);
    self.PersonSum.font = MyFont(12);
    self.timeLbl.font = MyFont(12);

    [self setuplayout];
}
- (void)setuplayout {
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.contentView.layer.mask = maskLayer;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    self.contentView.frame = CGRectInset(self.bounds, 5, 5);
    //由于改了contentView.frame。所以这句话要在这里执行
    self.contentView.clipsToBounds = YES;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"HomeGroupCollectionViewCell" owner:self options:nil];
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
//        [self.joinBtn setBackgroundColor:RGBCOLOR(179, 225, 87)];
//        self.joinBtn.titleLabel.font = MyFont(12);
//        self.joinBtn.layer.cornerRadius = 2;
//        [self.joinBtn setTitle:@"加入" forState:UIControlStateNormal];
//        [self.joinBtn setTitle:@"查看" forState:UIControlStateDisabled];
//        [self.joinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.GroupName.textColor = RGBCOLOR(98, 98, 98);
        self.timeLbl.textColor = RGBCOLOR(181, 181, 181);
        self.PersonSum.textColor = RGBCOLOR(181, 181, 181);
        self.headImageView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)setModel:(HomeGroupModel *)model{
    _model = model;
    self.timeLbl.hidden = NO;
    self.joinBtn.hidden = NO;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.imageurl]];
    self.GroupName.text = model.gamename;
    if ([model.isfull isEqualToString:@"0"]) self.PersonSum.text = [NSString stringWithFormat:@"%@（满）",model.totalnumpeo];
    else self.PersonSum.text = model.totalnumpeo;
    self.pwdGroupTag.hidden = ![model.ispwd isEqualToString:@"0"];
//    self.joinBtn.hidden = [model.isjoin isEqualToString:@"1"];
    
    if ([model.gamemode isEqualToString:@"1"]) {
        [self.joinBtn setBackgroundImage:[UIImage imageNamed:@"tag_days_28"] forState:UIControlStateNormal];
    }else if ([model.gamemode isEqualToString:@"2"]){
        [self.joinBtn setBackgroundImage:[UIImage imageNamed:@"tag_days_28"] forState:UIControlStateNormal];
    }else if ([model.gamemode isEqualToString:@"3"]){
        self.timeLbl.hidden = YES;
        self.joinBtn.hidden = YES;
    }

    if([model.isjoinfail isEqualToString:@"0"]){//加入失败
        self.shibai.hidden = NO;
    }else{
        self.shibai.hidden = YES;
    }
    
    
    NSString * myString = [NSString stringWithFormat:@"%@-%@",[WWTolls configureTimeString:model.gmbegintime andStringType:@"M.d"],[WWTolls configureTimeString:model.gmendtime andStringType:@"M.d"]];
    self.timeLbl.text = myString;
    self.headImageView.tags = model.gametags;
}
@end
