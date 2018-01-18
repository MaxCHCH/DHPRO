//
//  XimageView.h
//  JTSImageVC
//
//  Created by xiang on 15-1-30.
//  Copyright (c) 2015年 Nice Boy, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XimageView : UIImageView
@property(nonatomic,strong)UIView *highliView;
@property(copy,nonatomic) NSURL* bigImageURL;//大图URL地址
@end
