//
//  CreatQuanViewController.h
//  zhidoushi
//
//  Created by glaivelee on 15/11/14.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import "BaseViewController.h"
#import "CreatQuanButton.h"

@interface CreatQuanViewController : BaseViewController

@property (nonatomic,strong)NSMutableDictionary *tempDic;
@property (weak, nonatomic) IBOutlet CreatQuanButton *buttonOne;
@property (weak, nonatomic) IBOutlet CreatQuanButton *buttonTwo;
@property (weak, nonatomic) IBOutlet CreatQuanButton *buttonThree;
@property (weak, nonatomic) IBOutlet CreatQuanButton *buttonFour;
@property (weak, nonatomic) IBOutlet CreatQuanButton *buttonFive;
@property (weak, nonatomic) IBOutlet CreatQuanButton *buttonSix;
@property (weak, nonatomic) IBOutlet CreatQuanButton *buttonSeven;
@property (weak, nonatomic) IBOutlet CreatQuanButton *buttonEight;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

- (IBAction)touchHealthWithTag:(id)sender;

@end
