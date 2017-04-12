//
//  BLEViewController.h
//  Test
//
//  Created by Rillakkuma on 16/6/6.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "DHBle.h"

@interface BLEViewController : UIViewController
@property (nonatomic, retain) NSMutableArray *peripheralViewControllerArray;

@property (weak, nonatomic) IBOutlet UITableView *tableV;
@end
