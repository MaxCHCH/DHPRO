//
//  TagImageView.m
//  zhidoushi
//
//  Created by nick on 15/4/21.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "TagImageView.h"


@interface TagImageView()
@property (strong, nonatomic) UILabel *bottomLbl;
@property (strong, nonatomic) UILabel *topLbl;
@property (strong, nonatomic) UIImageView *topBkView;
@property (strong, nonatomic) UIImageView *bottomBkView;
@end
@implementation TagImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    [super awakeFromNib];
    [self setUp];
}

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setUp];
    }
    return self;
}

-(void)setUp{
    //下标签
    self.bottomLbl = [[UILabel alloc] init];
    self.bottomLbl.font = MyFont(13);
    self.bottomLbl.textColor = [UIColor whiteColor];
    self.bottomLbl.frame = CGRectMake(7, self.height-20, 100, 20);
    //下标签背景
    self.bottomBkView = [[UIImageView alloc] init];
    self.bottomBkView.frame = CGRectMake(0, self.height-20, 100, 20);
    self.bottomBkView.image = [UIImage imageNamed:@"tagleft"];
    
    [self addSubview:self.bottomBkView];
    [self addSubview:self.bottomLbl];
    
    //上标签
    self.topLbl = [[UILabel alloc] init];
    self.topLbl.font = MyFont(13);
    self.topLbl.textColor = [UIColor whiteColor];
    self.topLbl.frame = CGRectMake(self.width-100, 0, 93, 20);
    self.topLbl.textAlignment = NSTextAlignmentRight;
    //上标签背景
    self.topBkView = [[UIImageView alloc] init];
    self.topBkView.frame = CGRectMake(self.width-100, 0, 100, 20);
    self.topBkView.image = [UIImage imageNamed:@"tagright"];
    
    [self addSubview:self.topBkView];
    [self addSubview:self.topLbl];

}

-(void)layoutSubviews{
    [super layoutSubviews];
    //重新布局
    self.bottomLbl.frame = CGRectMake(7, self.height-20, 100, 20);
    self.bottomBkView.frame = CGRectMake(0, self.height-20, 100, 20);
    self.topLbl.frame = CGRectMake(self.width-100, 0, 93, 20);
    self.topBkView.frame = CGRectMake(self.width-100, 0, 100, 20);
}

-(void)setTags:(NSString *)tags{
    if ([tags rangeOfString:@","].length==0) {
        self.bottomLbl.hidden = YES;
        self.bottomBkView.hidden = YES;
        self.topLbl.hidden = YES;
        self.topBkView.hidden = YES;
        if (tags.length>0&&![tags isEqualToString:@"null"]) {
            self.topLbl.text = tags;
            self.topLbl.hidden = NO;
            self.topBkView.hidden = NO;
        }
        return;
    }
    _tags = tags;
    if (self.topLbl!=nil) {
        NSArray *tags = [self.tags componentsSeparatedByString:@","];
        //隐藏标签
        self.bottomLbl.hidden = YES;
        self.bottomBkView.hidden = YES;
        self.topLbl.hidden = YES;
        self.topBkView.hidden = YES;
        if (self.tags.length == 0 || self.tags == nil || [self.tags isEqualToString:@"null"]) {
            return;
        }
        
        NSString *sn = (NSString*)tags[0];
        if(sn.length>0){//瘦哪里标签
            self.topLbl.hidden = NO;
            self.topBkView.hidden = NO;
            self.topLbl.text = [sn componentsSeparatedByString:@"|"][0];
            
        }
        NSString *zms = (NSString*)tags[1];
        if(zms.length>0){//怎么瘦标签
            self.bottomLbl.hidden = NO;
            self.bottomBkView.hidden = NO;
            self.bottomLbl.text = [zms componentsSeparatedByString:@"|"][0];
        }
    }
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    //重新布局
    self.bottomLbl.frame = CGRectMake(7, self.height-20, 100, 20);
    self.bottomBkView.frame = CGRectMake(0, self.height-20, 100, 20);
    self.topLbl.frame = CGRectMake(self.width-100, 0, 93, 20);
    self.topBkView.frame = CGRectMake(self.width-100, 0, 100, 20);
    
    NSArray *tags = [self.tags componentsSeparatedByString:@","];
    //隐藏标签
//    self.bottomLbl.hidden = YES;
//    self.bottomBkView.hidden = YES;
//    self.topLbl.hidden = YES;
//    self.topBkView.hidden = YES;
    NSString *sn = (NSString*)tags[0];
    if(sn.length>0){//瘦哪里标签
        self.topLbl.hidden = NO;
        self.topBkView.hidden = NO;
        self.topLbl.text = [sn componentsSeparatedByString:@"|"][0];
        
    }
    NSString *zms = (NSString*)tags[1];
    if(zms.length>0){//怎么瘦标签
        self.bottomLbl.hidden = NO;
        self.bottomBkView.hidden = NO;
        self.bottomLbl.text = [zms componentsSeparatedByString:@"|"][0];
    }
}

@end
