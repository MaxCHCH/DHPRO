//
//  StoreViewController.h
//  zhidoushi
//
//  Created by xinglei on 14/11/22.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"

@interface StoreViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITableView *storeTableView;
@property(weak,nonatomic) UILabel* lblNum;
- (void)doneLoadingTableViewData;
- (void)loadMoreData;
-(void)uploadAdvertisementData:(NSInteger)page pageSizeFor:(NSString*)pageSize;
-(void)getNum;
@end
