//
//  ImageButton.h
//  zhidoushi
//
//  Created by xinglei on 14-11-4.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

typedef enum {
    peoplePicture = 0,
    teamPicture = 1,
    weightPicture = 2
} pictureStatus;

#import <UIKit/UIKit.h>

typedef void(^imageButtonBlock_1) (NSString *key);
typedef void(^imageButtonBlock_2) (NSString *key);

@interface ImageButton : UIButton

@property(nonatomic,assign)BOOL allowEditing;//是否可被编辑
@property(nonatomic,assign)pictureStatus picStatus;//照片的状态
@property(nonatomic,strong)NSString * myPictureFrame;//获取的照片尺寸
@property(nonatomic,strong)NSString * typeString;
@property(nonatomic,strong)NSString * imageTitle;
@property(nonatomic,copy)imageButtonBlock_1 imageBlock_1;
@property(nonatomic,copy)imageButtonBlock_2 imageBlock_2;

@end
