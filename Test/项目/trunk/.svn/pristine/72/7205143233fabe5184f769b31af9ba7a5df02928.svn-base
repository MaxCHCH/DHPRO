//
//  DisReplyTableViewCell.m
//  zhidoushi
//
//  Created by nick on 15/4/27.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "DisReplyWithImageTableViewCell.h"
#import "MeViewController.h"
#import "XimageView.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface DisReplyWithImageTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end
@implementation DisReplyWithImageTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.headImage.clipsToBounds = YES;
    self.headImage.layer.cornerRadius = 22;
    _buildingLabel.textColor = [WWTolls colorWithHexString:@"#959595"];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.headImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHead)];
    [self.headImage addGestureRecognizer:tap];
    self.separatorInset = UIEdgeInsetsMake(0, 11, 0, 11);
    
    //插入9张图片
    for (int i = 1; i<=9; i++) {
        UIImageView *image = [[UIImageView alloc] init];
        image.userInteractionEnabled = YES;
        image.clipsToBounds = YES;
        image.contentMode = UIViewContentModeScaleAspectFill;
        [image addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
        image.backgroundColor = [WWTolls colorWithHexString:@"#eaeaea"];
        image.tag = i;
        [self.contentView addSubview:image];
    }
    
}

-(void)clickHead{
    MeViewController *single = [[MeViewController alloc]init];
    single.userID = self.model.userid;
    single.otherOrMe = 1;
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            [((UIViewController*)nextResponder).view endEditing:YES];
            [((UIViewController*)nextResponder).navigationController pushViewController:single animated:YES];
            return;
        }
    }
}

-(void)setModel:(DiscoverReplyModel *)model{
    _model = model;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.userimage] placeholderImage:[UIImage imageNamed:@"mrtx_98_98"]];
    self.name.text = model.username;
    self.time.text = [WWTolls date:model.createtime];
    if ([model.commentlevel isEqualToString:@"1"]) {
        self.content.text = model.content;
    }else{
        self.content.text = [NSString stringWithFormat:@"回复%@:%@",model.byusername,model.content];
    }
    if (model.floorcount && model.floorcount.length > 0) {
        _buildingLabel.hidden = NO;
        
        _buildingLabel.text = [NSString stringWithFormat:@"%@楼",model.floorcount];//;
        
    }
    else {
        _buildingLabel.hidden = YES;
        
    }
    if(model.showimage && model.showimage.length > 0){
        NSArray *imageUrls = [model.showimage componentsSeparatedByString:@"|"];
        CGFloat beforeH = [WWTolls heightForString:self.content.text fontSize:15 andWidth:SCREEN_WIDTH-30] + 83 + 15;
        
        int imageCount = (int)imageUrls.count;
        switch (imageCount) {
            case 1:
            {
                for (int i = 1; i<=9; i++) {
                    for (UIImageView *imgView in self.contentView.subviews) {
                        if (imgView.tag == i) {
                            imgView.frame = CGRectZero;
                            if (i == 1) {
                                [imgView sd_setImageWithURL:[NSURL URLWithString:imageUrls[0]]];
                                imgView.backgroundColor = [WWTolls colorWithHexString:@"#efefef"];
                                CGSize imgsize = [WWTolls sizeForQNURLStr:imageUrls[i-1]];
                                imgView.frame = CGRectMake(15, beforeH,SCREEN_WIDTH-30, imgsize.height*(SCREEN_WIDTH-30)/imgsize.width);
                                beforeH += imgsize.height*(SCREEN_WIDTH-30)/imgsize.width;
                            }
                            break;
                        }
                    }
                }
            }
                break;
                //3、4张 以上 为九宫格
            case 4:
            case 2:
            {
                CGFloat width = (SCREEN_WIDTH - 30 - 3)/2;
                for (int i = 1; i<=9; i++) {
                    for (UIImageView *imgView in self.contentView.subviews) {
                        if (imgView.tag == i) {
                            imgView.frame = CGRectZero;
                            if (i <= imageCount) {
                                [imgView sd_setImageWithURL:[NSURL URLWithString:imageUrls[i-1]]];
                                imgView.backgroundColor = [WWTolls colorWithHexString:@"#efefef"];
                                imgView.frame = CGRectMake(15 + (width + 3)*(i%2), beforeH + (width+3)*((i-1)/2) - 3, width, width);
                            }
                            break;
                        }
                    }
                }
                beforeH += (imageCount/2 - 1)*(width+3) + width;
            }
                break;
                
            case 5:
            case 6:
            case 7:
            case 8:
            case 9:
            case 3:
            {
                
                CGFloat width = (SCREEN_WIDTH - 30 - 6)/3;
                for (int i = 1; i<=9; i++) {
                    for (UIImageView *imgView in self.contentView.subviews) {
                        if (imgView.tag == i) {
                            imgView.frame = CGRectZero;
                            if (i <= imageCount) {
                                [imgView sd_setImageWithURL:[NSURL URLWithString:imageUrls[i-1]]];
                                imgView.backgroundColor = [WWTolls colorWithHexString:@"#efefef"];
                                
                                imgView.frame = CGRectMake(15 + (width + 3)*(i%3), beforeH + (i-1)/3*(width+3), width, width);
                            }
                            break;
                        }
                    }
                }
                beforeH += (imageCount/3 - 1)*(width+3) + width;;
                
            }
                break;
                
            default:
            {
                for (int i = 1; i<=9; i++) {
                    for (UIImageView *imgView in self.contentView.subviews) {
                        if (imgView.tag == i) {
                            imgView.frame = CGRectZero;
                            break;
                        }
                    }
                }
            }
                break;
        }
        
//        
//        //循环设置图片
//        for (int i = 1; i<=9; i++) {
//            if(i<=imageUrls.count){//有图片
//                for (UIImageView *imgView in self.contentView.subviews) {
//                    if (imgView.tag == i) {
//                        [imgView sd_setImageWithURL:[NSURL URLWithString:imageUrls[i-1]]];
//                        CGSize imgsize = [WWTolls sizeForQNURLStr:imageUrls[i-1]];
//                        imgView.frame = CGRectMake(65, beforeH, imgsize.width*105/195, imgsize.height*105/195);
//                        beforeH += imgsize.height*105/195 + 7;
//                    }
//                }
//            }else{//没图片
//                for (UIImageView *imgView in self.contentView.subviews) {
//                    if (imgView.tag == i) {
//                        imgView.frame = CGRectZero;
//                    }
//                }
//            }
//        }
    }else{
        for (int i = 1; i<=9; i++) {
            for (UIImageView *imgView in self.contentView.subviews) {
                if (imgView.tag == i) {
                    imgView.frame = CGRectZero;
                }
            }
        }
//
    }
}

- (void)tapImage:(UITapGestureRecognizer *)tap
{
    int count = [self.model.showimage componentsSeparatedByString:@"|"].count;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        // 替换为中等尺寸图片
        NSString *url = [self.model.showimage componentsSeparatedByString:@"|"][i];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径
        for (UIImageView *imgView in self.contentView.subviews) {
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

    // Configure the view for the selected state
}
-(void)setHighlighted:(BOOL)highlighted{
    if (highlighted) {
        self.contentView.backgroundColor = [WWTolls colorWithHexString:@"#eaeaea"];
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

#pragma mark UITableViewCell 左滑删除时，修改删除按钮背景颜色

- (void)layoutSubviews {
    [super layoutSubviews];
    for (UIView *subView in self.subviews) {
        if ([NSStringFromClass([subView class]) isEqualToString:@"UITableViewCellDeleteConfirmationView"]) {
            ((UIView *)[subView.subviews firstObject]).backgroundColor = [WWTolls colorWithHexString:@"#ff4d48"];
        }
    }
}

@end
