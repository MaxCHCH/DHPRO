//
//  CommentTwoReplyTableViewCell.m
//  zhidoushi
//
//  Created by nick on 15/7/20.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "CommentTwoReplyTableViewCell.h"
#import "WPAttributedStyleAction.h"
#import "UIButton+WebCache.h"
#import "WPHotspotLabel.h"
#import "UIView+ViewController.h"
#import "MeViewController.h"
#import "NSString+WPAttributedMarkup.h"
#import "MeViewController.h"
#import "GroupTalkDetailViewController.h"
#import "DiscoverDetailViewController.h"
#import "ReplyViewController.h"
#import <CoreText/CoreText.h>
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"


@interface CommentTwoReplyTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *headerBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UIView *comentBackView;
@property (weak, nonatomic) IBOutlet UIImageView *commentImage;
@property (weak, nonatomic) IBOutlet UILabel *commentcontent;
@property (weak, nonatomic) IBOutlet UILabel *commentname;
@property (weak, nonatomic) IBOutlet WPHotspotLabel *twocontent;
@property (weak, nonatomic) IBOutlet UIButton *replyBtn;
@property (weak, nonatomic) IBOutlet WPHotspotLabel *onecontent;
@property (weak, nonatomic) IBOutlet UIScrollView *byImageScrollBack;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consByimageBackHeight;
@property (weak, nonatomic) IBOutlet UIScrollView *imageBackScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consScrollHeight;
@end
@implementation CommentTwoReplyTableViewCell

- (void)awakeFromNib {
//    self.lineView.layer.borderColor = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;
//    self.lineView.layer.borderWidth = 0.5;
    self.headerBtn.layer.cornerRadius = 22;
    self.headerBtn.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.commentImage.contentMode = UIViewContentModeScaleAspectFill;
    self.commentImage.clipsToBounds = YES;
}


-(void)setModel:(CommentModel *)model{
    _model = model;
    [self.headerBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.userimage] forState:UIControlStateNormal];
    self.nameLbl.text = model.username;
    self.timeLbl.text = [WWTolls configureTimeString:model.pushtime andStringType:@"M-d HH:mm"];
    if (model.parentimageurl.length > 0) [self.commentImage sd_setImageWithURL:[NSURL URLWithString:model.parentimageurl]];
    else [self.commentImage sd_setImageWithURL:[NSURL URLWithString:[[model.parentuserimage  componentsSeparatedByString:@"|"] firstObject]]];
    self.commentname.text = model.title&&model.title.length>0?model.title:model.parentusername;
    self.commentcontent.text = model.parentcontent;
    
    self.onecontent.userInteractionEnabled = YES;
    WEAKSELF_SS
    NSDictionary* style3 = @{@"body":@[MyFont(13),[WWTolls colorWithHexString:@"#4E777F"]],
                             @"help":[WPAttributedStyleAction styledActionWithAction:^{
                                 [weakSelf gotoByUser];
                             }],
                             @"helpp":[WPAttributedStyleAction styledActionWithAction:^{
                                 [weakSelf gotoUser];
                             }],
                             @"other":[WPAttributedStyleAction styledActionWithAction:^{
                                 [weakSelf gotoGroup];
                             }],
                             @"ll": [WWTolls colorWithHexString:@"#FF723E"],
                             @"lll": [WWTolls colorWithHexString:@"#a7a7a7"],
                             @"l": [WWTolls colorWithHexString:@"#FF723E"]
                             };
    self.onecontent.attributedText = [[NSString stringWithFormat:@"<help>  <ll>%@</ll></help> <lll>回复</lll> <helpp><l>%@</l>  </helpp><other>%@</other>",model.byusername,model.username,model.bycontent] attributedStringWithStyleBook:style3];
    [self.onecontent.selectableRanges removeAllObjects];
    [self.onecontent setSelectableRange:NSMakeRange(2, model.byusername.length) hightlightedBackgroundColor:[WWTolls colorWithHexString:@"#eaeaea"]];
    [self.onecontent setSelectableRange:NSMakeRange(model.byusername.length+6, model.username.length) hightlightedBackgroundColor:[WWTolls colorWithHexString:@"#eaeaea"]];
    
    self.twocontent.userInteractionEnabled = YES;
    NSDictionary* style = @{@"body":@[MyFont(13),[WWTolls colorWithHexString:@"#4E777F"]],
                             @"helpp":[WPAttributedStyleAction styledActionWithAction:^{
                                 [weakSelf gotoByUser];
                             }],
                             @"other":[WPAttributedStyleAction styledActionWithAction:^{
                                 [weakSelf gotoGroup];
                             }],
                             @"l": [WWTolls colorWithHexString:@"#FF723E"],
                            @"ll": [WWTolls colorWithHexString:@"#a7a7a7"],
                             };
    self.twocontent.attributedText = [[NSString stringWithFormat:@"<ll>回复 </ll><helpp><l>%@</l>  </helpp><other>%@</other>",model.byusername,model.content] attributedStringWithStyleBook:style];
    [self.twocontent.selectableRanges removeAllObjects];
    [self.twocontent setSelectableRange:NSMakeRange(3, model.byusername.length) hightlightedBackgroundColor:[WWTolls colorWithHexString:@"#eaeaea"]];
    //回复图片
    if(model.imageurl && model.imageurl.length > 0){
        self.consScrollHeight.constant = 95;
        for (UIView *chirldView in self.imageBackScrollView.subviews) {
            [chirldView removeFromSuperview];
        }
        //添加图片
        NSArray *images = [model.imageurl componentsSeparatedByString:@"|"];
        for (int i = 0; i < images.count ; i++) {
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(i*90, 0, 85, 85)];
            image.contentMode = UIViewContentModeScaleAspectFill;
            image.clipsToBounds = YES;
            image.userInteractionEnabled = YES;
            image.tag = i+ 1;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
            [image addGestureRecognizer:tap];
            [image sd_setImageWithURL:[NSURL URLWithString:images[i]]];
            [self.imageBackScrollView addSubview:image];
        }
        self.imageBackScrollView.contentSize = CGSizeMake(90*images.count, 85);
    }else{
        self.consScrollHeight.constant = 0;
    }
    //被回复图片
    if(model.byimageurl && model.byimageurl.length > 0){
        self.consByimageBackHeight.constant = 45;
        for (UIView *chirldView in self.byImageScrollBack.subviews) {
            [chirldView removeFromSuperview];
        }
        //添加图片
        NSArray *images = [model.byimageurl componentsSeparatedByString:@"|"];
        for (int i = 0; i < images.count ; i++) {
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(i*43, 0, 40, 40)];
            image.contentMode = UIViewContentModeScaleAspectFill;
            image.clipsToBounds = YES;
            image.userInteractionEnabled = YES;
            image.tag = i+ 1;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapByImage:)];
            [image addGestureRecognizer:tap];
            [image sd_setImageWithURL:[NSURL URLWithString:images[i]]];
            [self.byImageScrollBack addSubview:image];
        }
        self.byImageScrollBack.contentSize = CGSizeMake(43*images.count, 45);
    }else{
        self.consByimageBackHeight.constant = 0;
    }
}
- (void)tapImage:(UITapGestureRecognizer *)tap
{
    int count = [self.model.imageurl componentsSeparatedByString:@"|"].count;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        // 替换为中等尺寸图片
        NSString *url = [self.model.imageurl componentsSeparatedByString:@"|"][i];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径
        for (UIImageView *imgView in self.imageBackScrollView.subviews) {
            if (imgView.tag == i+1) {
                photo.srcImageView = imgView;
            }
        }
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = tap.view.tag - 1; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}
- (void)tapByImage:(UITapGestureRecognizer *)tap
{
    int count = [self.model.byimageurl componentsSeparatedByString:@"|"].count;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        // 替换为中等尺寸图片
        NSString *url = [self.model.byimageurl componentsSeparatedByString:@"|"][i];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径
        for (UIImageView *imgView in self.byImageScrollBack.subviews) {
            if (imgView.tag == i+1) {
                photo.srcImageView = imgView;
            }
        }
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = tap.view.tag - 1; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}
#pragma mark - 头像点击事件
-(IBAction)clickHeader{
    if (self.model.userid.length>0) {
        MeViewController *me = [[MeViewController alloc] init];
        me.userID = self.model.userid;
        me.otherOrMe = 1;
        [self.viewController.navigationController pushViewController:me animated:YES];
    }
}
#pragma mark - 回复点击
- (IBAction)replyClick:(id)sender {
    if([self.model.status isEqualToString:@"1"]){//无效
        [self.viewController showAlertMsg:@"该信息已删除╮(╯▽╰)╭" yOffset:0];
    }else{
        ReplyViewController *rp = [[ReplyViewController alloc] init];
        rp.parentId = self.model.parentid;
        rp.ReplyId = self.model.valueid;
        rp.ReplyType = self.model.valuetype;
        rp.byuserName = self.model.username;
        [self.viewController.navigationController pushViewController:rp animated:YES];
    }
}

#pragma mark 标签列表触发事件
- (void)gotoUser {
    MeViewController *me = [[MeViewController alloc] init];
    me.userID = self.model.userid;
    me.otherOrMe = 1;
    [self.viewController.navigationController pushViewController:me animated:YES];
}
- (void)gotoByUser {
    MeViewController *me = [[MeViewController alloc] init];
    me.userID = self.model.byuserid;
    me.otherOrMe = 1;
    [self.viewController.navigationController pushViewController:me animated:YES];
}

-(void)gotoGroup{
    if ([self.model.valuetype isEqualToString:@"1"]) {//团聊回复
        GroupTalkDetailViewController *gt = [[GroupTalkDetailViewController alloc] init];
        gt.talkid = self.model.parentid;
        [self.viewController.navigationController pushViewController:gt animated:YES];
    }else if([self.model.valuetype isEqualToString:@"2"]){//撒欢回复
        DiscoverDetailViewController *gt = [[DiscoverDetailViewController alloc] init];
        gt.discoverId = self.model.parentid;
        [self.viewController.navigationController pushViewController:gt animated:YES];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)setHighlighted:(BOOL)highlighted{
    if (highlighted) {
        self.contentView.backgroundColor = [WWTolls colorWithHexString:@"#eaeaea"];
        self.replyBtn.highlighted = YES;
    }else{
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.replyBtn.highlighted = NO;
    }
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    [self setHighlighted:highlighted];
    [self setNeedsDisplay];
}

@end
