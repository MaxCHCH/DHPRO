//
//  CommentOneReplyTableViewCell.m
//  zhidoushi
//
//  Created by nick on 15/7/20.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "CommentOneReplyTableViewCell.h"
#import "ReplyViewController.h"
#import "UIView+ViewController.h"
#import "UIButton+WebCache.h"
#import "MeViewController.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface CommentOneReplyTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *headerBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UIView *comentBackView;
@property (weak, nonatomic) IBOutlet UILabel *comentLbl;
@property (weak, nonatomic) IBOutlet UIImageView *commentImage;
@property (weak, nonatomic) IBOutlet UILabel *commentName;
@property (weak, nonatomic) IBOutlet UILabel *commentconent;
@property (weak, nonatomic) IBOutlet UIImageView *goodImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLeft;
@property (weak, nonatomic) IBOutlet UIButton *replyBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *imageBackScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consScrollHeight;

@end
@implementation CommentOneReplyTableViewCell

- (void)awakeFromNib {
//    self.lineView.layer.borderColor = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;
//    self.lineView.layer.borderWidth = 0.5;
    self.headerBtn.layer.cornerRadius = 22;
    self.headerBtn.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.commentImage.contentMode = UIViewContentModeScaleAspectFill;
    self.commentImage.clipsToBounds = YES;
    self.imageBackScrollView.showsHorizontalScrollIndicator = NO;
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

-(void)setModel:(CommentModel *)model{
    _model = model;
    [self.headerBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.userimage] forState:UIControlStateNormal];
    self.nameLbl.text = model.username;
    self.timeLbl.text = [WWTolls configureTimeString:model.pushtime andStringType:@"M-d HH:mm"];
    if ([model.valuetype isEqualToString:@"3"]) {//赞
        self.goodImage.hidden = NO;
//        self.contentLeft.constant = 37;
        self.comentLbl.text = @"给你加油！";
        self.comentLbl.font = MyFont(17);
        self.replyBtn.hidden = YES;
    }else{
        self.goodImage.hidden = YES;
        self.contentLeft.constant = 15;
        self.comentLbl.text = model.content;
        self.comentLbl.font = MyFont(13);
        self.replyBtn.hidden = NO;
    }
    if(![model.valuetype isEqualToString:@"3"] && model.imageurl && model.imageurl.length > 0){
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
    if (model.parentimageurl.length > 0) [self.commentImage sd_setImageWithURL:[NSURL URLWithString:[[model.parentimageurl componentsSeparatedByString:@"|"] firstObject]]];
    else [self.commentImage sd_setImageWithURL:[NSURL URLWithString:model.parentuserimage]];
    self.commentName.text = model.title&&model.title.length>0?model.title:model.parentusername;
    self.commentconent.text = model.parentcontent;
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
