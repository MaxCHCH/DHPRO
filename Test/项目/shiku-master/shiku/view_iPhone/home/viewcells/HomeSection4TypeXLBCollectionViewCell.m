//
//  HomSection4CollectionViewCell.m
//  shiku
//
//  Created by txj on 15/4/2.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "HomeSection4TypeXLBCollectionViewCell.h"

@implementation HomeSection4TypeXLBCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.lb_title.textColor=TEXT_COLOR_DARK;
    self.lb_price.textColor=MAIN_COLOR;
    [self.btn_cart setTintColor:MAIN_COLOR];
    [self.btn_fav setTintColor:MAIN_COLOR];
    
    
}
- (void)bind
{
    @weakify(self)
    [RACObserve(self, aditem)
     subscribeNext:^(id x) {
         @strongify(self);
         [self render];
     }];
}

- (void)unbind
{
}
- (void)render
{
    [self.coverImage sd_setImageWithURL:url(self.aditem.url) placeholderImage:img_placehold];
    ;
    self.lb_price.text=[NSString stringWithFormat:@"￥%@",self.aditem.price];
    self.lb_title.text=self.aditem.title;
    self.lb_count.text=self.aditem.desc;
}

@end
