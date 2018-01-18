//
//  NARCollectionViewController.h
//  自定义Layout
//
//  Created by xinglei on 14/11/27.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NARCollectionViewController : UICollectionViewController

@property (nonatomic,strong) NSArray* imagesArr;//存储图片数组

@property (nonatomic) NSInteger imagewidth;
-(void)loadWillBeginGameData;

@end
