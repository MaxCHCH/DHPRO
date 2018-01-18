//
//  NARCollectionViewCell.m
//  自定义Layout
//
//  Created by xinglei on 14/11/27.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "NARCollectionViewCell.h"

#import "UIViewExt.h"
#import "UIImageView+WebCache.h"
#import "NSURL+MyImageURL.h"
#import "WWTolls.h"

#define MyFont(A) [UIFont systemFontOfSize:A]

@interface NARCollectionViewCell ()
{
    UIImageView *peopleImage;
    UIImageView *discussImage;
}
@end
@implementation NARCollectionViewCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //        self.contentView.layer.cornerRadius = 5.0;
        //        self.contentView.layer.borderWidth = 1.0f;
        //        self.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
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
    self.imageView.backgroundColor = [WWTolls colorWithHexString:@"#eaeaea"];
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 5;
//    self.imageView.layer.borderColor = [UIColor brownColor].CGColor;
//    self.imageView.layer.borderWidth = 2;
//    self.imageView.backgroundColor = [UIColor whiteColor];
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

-(void)setBeginModel:(WillBeginCollectionModel *)beginModel{

    NSURL* imageUrl = [NSURL URLWithImageString: beginModel.imageurl Size:168];

    if (beginModel.imageurl.length != 0) {
        [self.imageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"tztx_168_168"]];
    }else self.imageView.image = [UIImage imageNamed:nil];
    


    //游戏名
    if (beginModel.gamename==nil) {
        self.gameNameLabel.hidden = YES;
    }else{
        self.gameNameLabel.hidden = NO;
        self.gameNameLabel.text = [NSString stringWithFormat:@"%@",beginModel.gamename];
    }
    //人数
    if (beginModel.totalnumdis==nil) {
        self.peopleNumberLabel.hidden = YES;
        peopleImage.hidden = YES;
    }else{
        self.peopleNumberLabel.hidden = NO;
        peopleImage.hidden = NO;
        self.peopleNumberLabel.text = [NSString stringWithFormat:@"%@",beginModel.totalnumpeo];
    }
    //讨论
    if (beginModel.totalnumpeo==nil) {
        self.discussionLabel.hidden = YES;
        discussImage.hidden = YES;
    }else{
        discussImage.hidden = NO;
        self.discussionLabel.hidden = NO;
        self.discussionLabel.text =[NSString stringWithFormat:@"%@",beginModel.totalnumdis];
    }
}

@end
