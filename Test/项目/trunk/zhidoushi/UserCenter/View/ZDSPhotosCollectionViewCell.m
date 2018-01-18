//
//  ZDSPhotosCollectionViewCell.m
//  zhidoushi
//
//  Created by System Administrator on 15/10/23.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import "ZDSPhotosCollectionViewCell.h"

@implementation ZDSPhotosCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.photosImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.photosImageView.clipsToBounds = YES;
}

@end
