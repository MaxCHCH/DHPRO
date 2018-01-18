//
//  ZDSWeekCollectionViewCell.m
//  CollectionView
//
//  Created by System Administrator on 15/10/22.
//  Copyright © 2015年 System Administrator. All rights reserved.
//

#import "ZDSWeekCollectionViewCell.h"

@implementation ZDSWeekCollectionViewCell

- (void)awakeFromNib {
    // Initialization code

    
    self.layer.shadowColor = [UIColor colorWithWhite:0.529 alpha:1.000].CGColor;//shadowColor阴影颜色
    self.layer.shadowOffset = CGSizeMake(8,8);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    self.layer.shadowOpacity = 1;//阴影透明度，默认0
    self.layer.shadowRadius = 8;//阴影半径，默认3
    self.layer.masksToBounds = YES;
    
    self.backgroundImageVIew.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundImageVIew.clipsToBounds = YES;
//    self.layer.shadowColor = [UIColor yellowColor].CGColor;//shadowColor阴影颜色
//    self.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
//    self.layer.shadowOpacity = 1;//阴影透明度，默认0
//    self.layer.shadowRadius = 3;//阴影半径，默认3
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"ZDSWeekCollectionViewCell" owner:self options:nil];
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]])
        {
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}

@end
