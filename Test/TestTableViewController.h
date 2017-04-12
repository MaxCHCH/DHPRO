//
//  TestTableViewController.h
//  Test
//
//  Created by Rillakkuma on 16/6/15.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYJNegotiateView.h"

@interface TestTableViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,HYJNegotiateViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableViewMy;
@property (strong, nonatomic) HYJNegotiateView *negotiate;

@end
