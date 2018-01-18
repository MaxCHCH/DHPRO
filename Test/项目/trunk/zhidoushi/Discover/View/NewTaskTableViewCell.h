//
//  NewTaskTableViewCell.h
//  zhidoushi
//
//  Created by nick on 15/11/16.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyGroupDynModel.h"

@interface NewTaskTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property(nonatomic,strong)MyGroupDynModel *model;//<#强引用#>
@end
