//
//  DiscoverAddViewController.h
//  zhidoushi
//
//  Created by nick on 15/4/20.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "BaseViewController.h"
#import <TuSDKGeeV1/TuSDKGeeV1.h>
#import "DemoSimpleBase.h"
@interface DiscoverAddViewController : BaseViewController<TuSDKFilterManagerDelegate>
{
    TuSDKCPPhotoEditMultipleComponent *_photoEditMultipleComponent;
    TuSDKCPAlbumComponent *_albumComponent;


}
@property(nonatomic,copy)NSString *Photohash;//图片hash
@property(nonatomic,copy)NSString *Photokey;//图片key
@property(nonatomic,assign)CGSize PhotoSize;//尺寸
@property(nonatomic,assign)long long PhotoBig;//大小
@property(nonatomic,strong) NSMutableArray *assets;//图片集合

@property (nonatomic, retain) DemoSimpleGroup *group;


@property(nonatomic,strong)UIImage *image;//图片
@property(nonatomic,copy)NSString *type;//发现类型

@property (nonatomic,strong) NSString *tagName;//标签名字
/**
 1 撒欢广场
 2 撒欢动态
 **/
@property(nonatomic,copy)NSString *clickevent;//来源

@end

