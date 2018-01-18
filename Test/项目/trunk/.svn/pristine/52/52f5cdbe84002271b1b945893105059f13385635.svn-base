//
//  StoreCollectionViewCell.m
//  zhidoushi
//
//  Created by xinglei on 15/1/16.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "StoreCollectionViewCell.h"

#import "UIImageView+AFNetworking.h"
#import "NSURL+MyImageURL.h"
#import "WWTolls.h"
#import "UIImageView+WebCache.h"

@implementation StoreCollectionViewCell

-(void)setStoreModel:(StoreModel *)model
{
    NSURL *imageUrlleft = [NSURL URLWithImageString:model.imageurlleft Size:0];
    NSLog(@"model.imageurlleft**************%@",model.imageurlleft);
    self.leftName.textColor = [WWTolls colorWithHexString:@"#535353"];
    self.leftOverLabel.textColor = [WWTolls colorWithHexString:@"#959595"];
    self.leftMoneyLabel.textColor = [WWTolls colorWithHexString:@"#ea5b57"];
    [self.leftImageView sd_setImageWithURL:imageUrlleft];
    self.leftMoneyLabel.text = [NSString stringWithFormat:@"%@",model.exchscoreleft];
    self.leftName.text = [NSString stringWithFormat:@"%@",model.gsnameleft];
    self.leftOverLabel.hidden = NO;
    if (model.gsstatusleft) {
        switch (model.gsstatusleft.intValue) {
            case 0:
                self.leftOverLabel.text =@"已结束";
                break;
            case 1:
                self.leftOverLabel.hidden = YES;
                break;
            case 2:
                self.leftOverLabel.text =@"已结束";
                break;
            case 3:
                self.leftOverLabel.text =@"已结束";
                break;
            default:
                self.leftOverLabel.hidden = YES;
                break;
        }
    }

}

@end
