//
//  SignatureCell.m
//  zhidoushi
//
//  Created by ji on 15/11/13.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import "SignatureCell.h"

@implementation SignatureCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.signalName = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, SCREEN_WIDTH, 20)];
        [self.contentView addSubview:self.signalName];
        
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, SCREEN_WIDTH, self.frame.size.height)];
        [self.contentView addSubview:self.contentLabel];
        
    }
    return self;
}

- (void)setsignalNameText:(NSString *)signalName
         contentLabelText:(NSString *)contentLabel
{
    self.signalName.text = signalName;
    self.contentLabel.text = contentLabel;
}

- (void)drawRect:(CGRect)rect{
    
}

@end
