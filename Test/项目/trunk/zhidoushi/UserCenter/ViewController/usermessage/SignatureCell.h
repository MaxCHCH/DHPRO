//
//  SignatureCell.h
//  zhidoushi
//
//  Created by ji on 15/11/13.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignatureCell : UITableViewCell

@property (nonatomic,strong) UILabel *signalName;
@property (nonatomic,strong) UILabel *contentLabel;

- (void)setsignalNameText:(NSString *)signalName
           contentLabelText:(NSString *)contentLabel;

@end
