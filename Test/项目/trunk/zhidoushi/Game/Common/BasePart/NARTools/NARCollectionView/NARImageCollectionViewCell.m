//
//  NARImageCollectionViewCell.m
//  zhidoushi
//
//  Created by xinglei on 14/12/1.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "NARImageCollectionViewCell.h"


#import "UIViewExt.h"
#import "NSURL+MyImageURL.h"
#import "WWTolls.h"

#import "UIImageView+WebCache.h"

@interface NARImageCollectionViewCell()
{
    UIImageView *peopleImage;
    UIImageView *discussImage;
}
@end

@implementation NARImageCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}
#pragma mark - Setup
- (void)setup
{
    [self setupView];
    [self setupBottomView];
}

- (void)setupView
{
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,0,0)];
    self.imageView.layer.cornerRadius = 5;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.backgroundColor = [WWTolls colorWithHexString:@"#eaeaea"];

    //    self.imageView.layer.borderColor = [UIColor brownColor].CGColor;
    //    self.imageView.layer.borderWidth = 2;
//    self.imageView.backgroundColor = [UIColor whiteColor];
    self.imageView.userInteractionEnabled = YES;
    [self addSubview:self.imageView];
}

- (void)setupBottomView
{
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self addSubview:self.bottomView];
    //人物图片
    peopleImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 16, 16)];
    peopleImage.image = [UIImage imageNamed:@"renshu2_32_32"];
    [self.bottomView addSubview:peopleImage];
    //人数
    _peopleNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(peopleImage.right+3, peopleImage.top, 70, 20)];
    self.peopleNumberLabel.text = @"123";
    self.peopleNumberLabel.font = MyFont(12);
    //    self.peopleNumberLabel.backgroundColor = [UIColor redColor];
    self.peopleNumberLabel.textColor = [WWTolls colorWithHexString:@"#a0a0a0"];
    [self.bottomView addSubview:self.peopleNumberLabel];
    //讨论图片
    discussImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.peopleNumberLabel.right-44, peopleImage.top, peopleImage.width, peopleImage.height)];
    discussImage.image = [UIImage imageNamed:@"pinglun_32_32"];
    [self.bottomView addSubview:discussImage];
    //讨论数
    _discussionLabel = [[UILabel alloc]initWithFrame:CGRectMake(discussImage.right+2, self.peopleNumberLabel.top, self.peopleNumberLabel.width,self.peopleNumberLabel.height)];
    self.discussionLabel.text = @"123";
    self.discussionLabel.font = MyFont(12);
    //    self.discussionLabel.backgroundColor = [UIColor redColor];
    self.discussionLabel.textColor = [WWTolls colorWithHexString:@"#a0a0a0"];
    [self.bottomView addSubview:self.discussionLabel];
    //游戏组名称
    _gameNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, peopleImage.bottom
                                                              , 80, 20)];
    self.gameNameLabel.text = @"减肥明星游戏";
    self.gameNameLabel.font = MyFont(12);
    self.gameNameLabel.textColor = [WWTolls colorWithHexString:@"#535353"];
    self.gameNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.bottomView addSubview:self.gameNameLabel];
}

-(void)setHotModel:(hotGameModel *)hotModel{

    NSURL* imageUrl = [NSURL URLWithImageString: hotModel.imageurl Size:168];
    [self.imageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"tztx_168_168"]];
    self.gameNameLabel.text = [NSString stringWithFormat:@"%@",hotModel.gamename];
    self.discussionLabel.text =[NSString stringWithFormat:@"%@",hotModel.totalnumdis];
    self.peopleNumberLabel.text = [NSString stringWithFormat:@"%@",hotModel.totalnumpeo];
    NSLog(@"self.gameNameLabel.text%@,%@",self.discussionLabel.text,self.peopleNumberLabel.text);

}

@end

