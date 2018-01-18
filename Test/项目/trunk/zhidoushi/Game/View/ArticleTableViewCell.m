//
//  ArticleTableViewCell.m
//  zhidoushi
//
//  Created by nick on 15/9/9.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "ArticleTableViewCell.h"
#import "GroupTalkDetailViewController.h"
#import "GroupViewController.h"
#import "UITableViewCell+SSLSelect.h"
#import "DiscoverTypeViewController.h"
#import "UIView+ViewController.h"
#import "ZDStagLabel.h"

@interface ArticleTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *lookSumLbl;
@property (weak, nonatomic) IBOutlet UILabel *goodSumLbl;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet ZDStagLabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTitleLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consContentLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consLineHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consGroupCome;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consContentHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conslookImageTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conslookNumTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consNumTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consNumImageTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consImageWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consImageLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consContentTop;


@property (weak, nonatomic) IBOutlet UIView *topLine;

@property (weak, nonatomic) IBOutlet UILabel *comelabel;
@property(nonatomic,copy)NSString *groupId;//团组id
//12 动态  6广场
@property(nonatomic,copy)NSString *cellFather;
@end

@implementation ArticleTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self setSelectBackgroundColor:[WWTolls colorWithHexString:@"#eaeaea"] andNormalBackgroundColor:nil];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.showImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.showImageView.clipsToBounds = YES;
    self.showImageView.backgroundColor = [WWTolls colorWithHexString:@"eaeaea"];
    self.topLine.layer.borderWidth = 0.5;
    self.topLine.layer.borderColor = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;
}

-(void)setUpWithTalkModel:(GroupTalkModel*)model{
    self.talkModel = model;
    //配图
    self.consGroupCome.constant = 0;
    self.consLineHeight.constant = 0;
    self.goodSumLbl.text = model.praisecount;
    self.lookSumLbl.text = model.pageview;
    //标题
    self.titleLabel.text = model.title;
    //时间
    self.timeLbl.text = [WWTolls timeString22:model.createtime];
    //来自
    self.comelabel.hidden = YES;
    //置顶标示
    if ([model.istop isEqualToString:@"1"]) {//置顶
        self.topTag.hidden = NO;
        self.comelabel.text = @"";
        self.consGroupCome.constant = 30;
    }else{
        self.topTag.hidden = YES;
    }
    //内容
    NSString *content = [[model.talkcontent stringByReplacingOccurrencesOfString:@"\r" withString:@" "] stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    WEAKSELF_SS;
    [self.contentLabel setContent:content WithTagClick:^(NSString *tag) {
        DiscoverTypeViewController *type = [[DiscoverTypeViewController alloc] init];
        type.showtag = tag;
        [weakSelf.viewController.navigationController pushViewController:type animated:YES];
    } AndOtherClick:^{
        GroupTalkDetailViewController *talk = [[GroupTalkDetailViewController alloc] init];
        talk.talkid = model.talkid;
        talk.talktype = GroupTitleTalkType;
        talk.clickevent = 4;
        [weakSelf.viewController.navigationController pushViewController:talk animated:YES];
    }];
    //    NSAttributedString *as = self.contentLabel.attributedText;
    //    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //    NSMutableAttributedString *aas = [[NSMutableAttributedString alloc] initWithAttributedString:as];
    //    [paragraphStyle setLineSpacing:1.25];//调整行间距
    //    [aas addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, [content length])];
    //    self.contentLabel.attributedText = aas;
    if (model.imageurl && model.imageurl.length>0) {
        self.consImageLeft.constant = 15;
        self.consImageWidth.constant = 75;
        self.consContentTop.constant = 14;
        self.showImageView.hidden = NO;
        self.consTitleLeft.constant = 10;
        self.consContentLeft.constant = 10;
        self.consContentHeight.constant = 60;
        self.consNumTop.constant = 20;
        self.consNumImageTop.constant = 18;
        self.conslookNumTop.constant = 20;
        self.conslookImageTop.constant = 18;
        NSString *firstImageUrl = [[model.imageurl componentsSeparatedByString:@"|"] firstObject];
        [self.showImageView sd_setImageWithURL:[NSURL URLWithString:firstImageUrl]];
    }else{
        self.consImageLeft.constant = 5;
//        self.consContentTop.constant = 0;
        self.consImageWidth.constant = 0;
        self.showImageView.hidden = YES;
        self.consTitleLeft.constant = -84;
        self.consContentLeft.constant = -84;
        self.consNumTop.constant = 10;
        self.consNumImageTop.constant = 8;
        self.conslookNumTop.constant = 10;
        self.conslookImageTop.constant = 8;
        
        CGFloat heigh = [WWTolls heightForString:content fontSize:13 andWidth:SCREEN_WIDTH - 30];
        if (heigh<=50) {
            self.consContentHeight.constant = heigh+14;
        }else self.consContentHeight.constant = 60;
    }
}

-(void)setUpWithDiscoverModel:(DiscoverModel*)model{
    self.groupId = model.gameid;
    self.lookSumLbl.text = model.pageview;
    self.goodSumLbl.text = model.praisecount;
    self.cellFather = @"6";
    self.consLineHeight.constant = 10;
    self.separLine.hidden = YES;
    CGFloat Namewidth = [WWTolls WidthForString:model.title fontSize:15];
    CGFloat comewidth = [WWTolls WidthForString:[NSString stringWithFormat:@"来自%@",model.gamename] fontSize:10];
    CGFloat maxWidth = SCREEN_WIDTH - 40;
    if (Namewidth + comewidth > maxWidth) {
        self.consGroupCome.constant = comewidth;
        if (self.consGroupCome.constant<70) {
            self.consGroupCome.constant = 70;
        }
    }else{
        self.consGroupCome.constant = comewidth;
    }
    
    //标题
    self.titleLabel.text = model.title;
    //时间
    self.timeLbl.text = [WWTolls timeString22:model.createtime];
    //置顶标示
    self.topTag.hidden = YES;
    //内容
    NSString *content = [[model.content stringByReplacingOccurrencesOfString:@"\r" withString:@" "] stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    WEAKSELF_SS;
    [self.contentLabel setContent:content WithTagClick:^(NSString *tag) {
        DiscoverTypeViewController *type = [[DiscoverTypeViewController alloc] init];
        type.showtag = tag;
        [weakSelf.viewController.navigationController pushViewController:type animated:YES];
    } AndOtherClick:^{
        GroupTalkDetailViewController *talk = [[GroupTalkDetailViewController alloc] init];
        talk.talkid = model.showid;
        talk.talktype = GroupTitleTalkType;
        talk.gamename = model.gamename;
        talk.clickevent = model.type?3:1;
        [weakSelf.viewController.navigationController pushViewController:talk animated:YES];
    }];
    //    NSAttributedString *as = self.contentLabel.attributedText;
    //    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //    NSMutableAttributedString *aas = [[NSMutableAttributedString alloc] initWithAttributedString:as];
    //    [paragraphStyle setLineSpacing:1.25];//调整行间距
    //    [aas addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, [content length])];
    //    self.contentLabel.attributedText = aas;
    //    NSAttributedString *as = self.contentLabel.attributedText;
    //    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //    NSMutableAttributedString *aas = [[NSMutableAttributedString alloc] initWithAttributedString:as];
    //    [paragraphStyle setLineSpacing:8];//调整行间距
    //    [aas addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, [content length])];
    //    self.contentLabel.attributedText = aas;
    //    [self.contentLabel sizeToFit];
    //来自
    self.comelabel.hidden = NO;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"来自%@",model.gamename]];
    [str addAttribute:NSForegroundColorAttributeName value:OrangeColor range:NSMakeRange(2,model.gamename.length)];
    self.comelabel.attributedText = str;
    UITapGestureRecognizer *grouptap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickGroup)];
    self.comelabel.userInteractionEnabled = YES;
    [self.comelabel addGestureRecognizer:grouptap];
    //配图
    if ((model.showimage && model.showimage.length>0)||(model.talkimage && model.talkimage.length>0)) {
        self.consContentTop.constant = 14;
        self.consImageLeft.constant = 15;
        self.consImageWidth.constant = 75;
        self.showImageView.hidden = NO;
        self.consTitleLeft.constant = 10;
        self.consContentLeft.constant = 10;
        self.consContentHeight.constant = 60;
        self.consNumTop.constant = 20;
        self.consNumImageTop.constant = 18;
        self.conslookNumTop.constant = 20;
        self.conslookImageTop.constant = 18;
        
        NSString *firstImageUrl = [[model.talkimage.length>0?model.talkimage:model.showimage componentsSeparatedByString:@"|"] firstObject];
        [self.showImageView sd_setImageWithURL:[NSURL URLWithString:firstImageUrl]];
    }else{
//        self.consContentTop.constant = 0;
        self.consImageLeft.constant = 5;
        self.consImageWidth.constant = 0;
        //        self.showImageView.hidden = YES;
        self.consTitleLeft.constant = -84;
        self.consContentLeft.constant = -84;
        self.consNumTop.constant = 10;
        self.consNumImageTop.constant = 8;
        self.conslookNumTop.constant = 10;
        self.conslookImageTop.constant = 8;
        CGFloat heigh = [WWTolls heightForString:content fontSize:13 andWidth:SCREEN_WIDTH - 30];
        if (heigh<=50) {
            self.consContentHeight.constant = heigh + 14;
        }else self.consContentHeight.constant = 60;
    }
}

-(void)setUpWithGroupDynModel:(MyGroupDynModel*)model{
    self.groupId = model.gameid;
    self.cellFather = @"12";
    self.goodSumLbl.text = model.praisecount;
    self.lookSumLbl.text = model.pageview;
    self.consLineHeight.constant = 10;
    self.separLine.hidden = YES;
    CGFloat Namewidth = [WWTolls WidthForString:model.title fontSize:15];
    CGFloat comewidth = [WWTolls WidthForString:[NSString stringWithFormat:@"来自%@",model.gamename] fontSize:10];
    CGFloat maxWidth = SCREEN_WIDTH - 40;
    if (Namewidth + comewidth > maxWidth) {
        self.consGroupCome.constant = comewidth;
        if (self.consGroupCome.constant<70) {
            self.consGroupCome.constant = 70;
        }
    }else{
        self.consGroupCome.constant = comewidth;
    }
    
    //标题
    self.titleLabel.text = model.title;
    //时间
    self.timeLbl.text = [WWTolls timeString22:model.createtime];
    //置顶标示
    self.topTag.hidden = YES;
    //内容
    NSString *content = [[model.content stringByReplacingOccurrencesOfString:@"\r" withString:@" "] stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    WEAKSELF_SS;
    [self.contentLabel setContent:content WithTagClick:^(NSString *tag) {
        DiscoverTypeViewController *type = [[DiscoverTypeViewController alloc] init];
        type.showtag = tag;
        [weakSelf.viewController.navigationController pushViewController:type animated:YES];
    } AndOtherClick:^{
        GroupTalkDetailViewController *talk = [[GroupTalkDetailViewController alloc] init];
        talk.talkid = model.dynid;
        talk.talktype = GroupTitleTalkType;
        talk.gamename = model.gamename;
        talk.clickevent = 2;
        [weakSelf.viewController.navigationController pushViewController:talk animated:YES];
    }];
    //    NSAttributedString *as = self.contentLabel.attributedText;
    //    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //    NSMutableAttributedString *aas = [[NSMutableAttributedString alloc] initWithAttributedString:as];
    //    [paragraphStyle setLineSpacing:1.25];//调整行间距
    //    [aas addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, [content length])];
    //    self.contentLabel.attributedText = aas;
    //来自
    self.comelabel.hidden = NO;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"来自%@",model.gamename]];
    [str addAttribute:NSForegroundColorAttributeName value:OrangeColor range:NSMakeRange(2,model.gamename.length)];
    self.comelabel.attributedText = str;
    UITapGestureRecognizer *grouptap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickGroup)];
    self.comelabel.userInteractionEnabled = YES;
    [self.comelabel addGestureRecognizer:grouptap];
    //配图
    if (model.talkimage && model.talkimage.length>0) {
        self.consContentTop.constant = 14;
        self.consImageLeft.constant = 15;
        self.consImageWidth.constant = 75;
        self.showImageView.hidden = NO;
        self.consContentTop.constant = 14;
        self.consTitleLeft.constant = 10;
        self.consContentLeft.constant = 10;
        self.consContentHeight.constant = 60;
        self.consNumTop.constant = 20;
        self.consNumImageTop.constant = 18;
        self.conslookNumTop.constant = 20;
        self.conslookImageTop.constant = 18;
        NSString *firstImageUrl = [[model.talkimage componentsSeparatedByString:@"|"] firstObject];
        [self.showImageView sd_setImageWithURL:[NSURL URLWithString:firstImageUrl]];
    }else{
//        self.consContentTop.constant = 0;
        self.consImageLeft.constant = 5;
        self.consImageWidth.constant = 0;
        self.showImageView.hidden = YES;
//        self.consContentTop.constant = 0;
        self.consTitleLeft.constant = -84;
        self.consContentLeft.constant = -84;
        self.consNumTop.constant = 10;
        self.consNumImageTop.constant = 8;
        self.conslookNumTop.constant = 10;
        self.conslookImageTop.constant = 8;
        CGFloat heigh = [WWTolls heightForString:content fontSize:13 andWidth:SCREEN_WIDTH - 30];
        if (heigh<50) {
            self.consContentHeight.constant = heigh+14;
        }else self.consContentHeight.constant = 60;
    }
}

- (void)clickGroup{
    GroupViewController *group = [[GroupViewController alloc] init];
    group.groupId = self.groupId;
    group.clickevent = self.cellFather;
    group.joinClickevent = self.cellFather;
    [self.viewController.navigationController pushViewController:group animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
