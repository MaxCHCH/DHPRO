//
//  InitShareButton.h
//  zhidoushi
//
//  Created by xinglei on 14-11-5.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    shareViewType_loadPhotoView=10,
    shareViewType_sharView
}shareViewType;

@interface InitShareButton : UIButton

@property(nonatomic,assign)shareViewType viewType;

-(void)initShareView;

@end
