//
//  UIViewController+Photo.h
//  zhidoushi
//
//  Created by xinglei on 14-9-16.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Photo)<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

-(void)takePhoto;
-(void)LocalPhoto;

@end
