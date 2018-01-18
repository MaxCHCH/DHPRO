//
//  HorizontalScrollCell.h
//  MoviePicker
//
//  Created by nick on 28.01.2015.
//  Copyright (c) 2015 nick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "customMyImageButton.h"

@class HorizontalScrollCellAction;
@protocol HorizontalScrollCellDelegate <NSObject>
-(void)cellSelected:(NSString *)tpid;
@end

@interface HorizontalScrollCell : UICollectionViewCell <UIScrollViewDelegate>
{
    CGFloat supW;
    CGFloat off;
    CGFloat diff;
    
}

@property(nonatomic,copy)NSString *typeId;//id
@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
-(void)setUpCellWithArray:(NSArray *)array andTitle:(NSString*)title andTypeId:(NSString *)typeId;
@property (weak, nonatomic) IBOutlet customMyImageButton *titleBtn;

@property (nonatomic,strong) id<HorizontalScrollCellDelegate> cellDelegate;

@end